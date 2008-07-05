Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYGENuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYGENuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYGENuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:50:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:14770 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYGENuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XQ1Q4MSzOVj9BevW3M3lQ9bdh4RsvbnI7rY+I68/AafQBDpACBVnk469d9qeeBgRlx
         BCoUHC+cC6AXJSoTmwiqDUmmjn5rNA/KRoBYOfAI5ieRItdgS04lXUCrIwY2t1HsVKMg
         XlXXs8C/bruwQkQ/zDuk8MKyX5vF5qe6eAxDI=
Message-ID: <19f34abd0807050650y327ca434pfca324fcccc14f06@mail.gmail.com>
Date: Sat, 5 Jul 2008 15:50:08 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: the printk problem
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0807051518500.28765@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705125230.GA20166@damson.getinternet.no>
	 <alpine.LNX.1.10.0807051518500.28765@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2008 at 3:24 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Saturday 2008-07-05 14:52, Vegard Nossum wrote:
>>> On Saturday 2008-07-05 00:01, Andrew Morton wrote:
>>>>
>>>>We don't know how much interest there would be in churning NIPQUAD from
>>>>the net guys.  Interestingly, there's also %C (wint_t) which is a
>>>>32-bit quantity.  So we could just go and say "%C prints an ipv4
>>>>address" and be done with it.  But there's no way of doing that for
>>>>ipv6 addresses so things would become asymmetrical there.
>>>
>>>        struct in6_addr src;
>>>        printk("Source address: %p{ipv6}\n", &src);
>>>
>>> How about %p{feature}?
>>
>>Something like this?
>>
>>+static char *custom_format(char *buf, char *end,
>>+      const char *fmt, unsigned int fmtlen, void *arg)
>
> I'd use const void *arg here, so nobody gets the idea
> that you could modify the argument while printing :)
>

Oops, of course. Thanks.

>>+{
>>+      if (!strncmp(fmt, "sym", fmtlen)) {
...
>>+      }
>
> And I assume it's then as simple as
>
>        } else if (strncmp(fmt, "nip6", fmtlen) == 0) {
>                snprintf(buf, end - buf (+1?), NIP6_FMT in expanded form,
>                         NIP6 in expanded form(arg));
>        }
>
> Hm, that's going to get a big function when everyone adds their
> fmttypes.
>

Yes. Luckily, the entry point is then fixed in a single place and it's
easy to convert it into something more dynamic :-)

A static array wouldn't help much because it still concentrates all
the names. But we could at least do a binary search on that and get
some speed improvements if it grows large.

I think the most elegant solution would be a macro similar to the
initcall macros, that adds the custom extensions to a table which is
defined by a special linker section. This allows complete
decentralization, but I don't think it's possible to do binary search
on the names anymore.

Dynamic registering/unregistering could be done too. Maybe this is a
good thing for modules...

Thoughts?

>>+
>>+      return buf;
>>+}
>>+
>> static char *number(char *buf, char *end, unsigned long long num, int base, int size, int precision, int type)
>> {
>>       /* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
>>@@ -648,6 +673,25 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>>                               continue;
>>
>>                       case 'p':
>>+                              if (fmt[1] == '{') {
>>+                                      const char *cfmt;
>>+
>>+                                      /* Skip the '%{' */
>>+                                      ++fmt;
>>+                                      ++fmt;
>>+
>
> Not this?
>
>        /* Skip the '%p{' */
>        fmt += 3;
>

Oops, the comment is wrong. It should say: "Skip the p{". But fmt += 3
is wrong. Since fmt[0] is at this point 'p', and fmt[1] is '{'. The %
and flags, etc. have already been skipped by the common code. So it
should be fmt += 2 :-)

Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
