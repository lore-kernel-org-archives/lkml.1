Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYBJTAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYBJTAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYBJTAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:00:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:21962 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbYBJS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nkhKBrTcq+lFjtstVDpkYoZoW7KQujcORA+kiEblipz+CMdbLz0rhvvRJNBncz7DJmwjrfttSbT3mEc6IYBW2pNArXIIAwK7ny1q5oTjDxoQphIalpOhDX6YwYPq7T2tgs19pniauN/bmFJlvBBfdcwVSzwclzPPIxIafRbe6f8=
Message-ID: <2c0942db0802101059y6384a35fh2a0dc8d65bc73dbc@mail.gmail.com>
Date: Sun, 10 Feb 2008 10:59:58 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Jan Kiszka" <jan.kiszka@web.de>
Subject: Re: [git pull] kgdb light, v5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Sam Ravnborg" <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jason Wessel" <jason.wessel@windriver.com>
In-Reply-To: <47AF36D6.7050507@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080210071304.GA3788@elte.hu>
	 <20080210104709.GB10790@uranus.ravnborg.org>
	 <20080210163603.GB28201@elte.hu>
	 <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com>
	 <47AF36D6.7050507@web.de>
X-Google-Sender-Auth: 8c8d146eab5057d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 9:39 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
> Ray Lee wrote:
> > unsigned int void u64_to_hex(u64 val, unsigned char *buf)
> > {
> >          int i;
> >          for (i=15; i>=0; i--) {
> >                   buf[i] = hexchars[ val & 0x0f ];
> >                   val >>= 4;
> >          }
> >          return 16;
> > }
> > ...
> >          buf += u64_to_hex(cpu_to_be64(tmp_ll), buf);
> >
> > be clearer both visually, and code-as-intent? (And equivalent helpers
> > for u32, u16 -- though they could all be rolled into one.)
>
> Yes, will come, I just produced some ETOOMANYCHANGESATONCE issue while
> improving this. The code goes down by more than 150 lines!

Thanks for responding. I'd mentioned it twice already and gotten no
response, so wasn't sure if my microphone was on :-).

If you're feeling energetic, the same sort of cleanup can be done against:

+#ifdef __BIG_ENDIAN
+               tmp_s |= hex(*buf++) << 12;
+               tmp_s |= hex(*buf++) << 8;
+               tmp_s |= hex(*buf++) << 4;
+               tmp_s |= hex(*buf++);
+#else
+               tmp_s |= hex(*buf++) << 4;
+               tmp_s |= hex(*buf++);
+               tmp_s |= hex(*buf++) << 12;
+               tmp_s |= hex(*buf++) << 8;
+#endif
+               if (probe_kernel_write(mem, tmp_s))
+                       return ERR_PTR(-EINVAL);
+
+               mem += 2;
+       } else if ((count == 4) && (((long)mem & 3) == 0)) {
+               u32 tmp_l = 0;
+
+#ifdef __BIG_ENDIAN
+               tmp_l |= hex(*buf++) << 28;
+               tmp_l |= hex(*buf++) << 24;
+               tmp_l |= hex(*buf++) << 20;
+               tmp_l |= hex(*buf++) << 16;
+               tmp_l |= hex(*buf++) << 12;
+               tmp_l |= hex(*buf++) << 8;
+               tmp_l |= hex(*buf++) << 4;
+               tmp_l |= hex(*buf++);
+#else
+               tmp_l |= hex(*buf++) << 4;
+               tmp_l |= hex(*buf++);
+               tmp_l |= hex(*buf++) << 12;
+               tmp_l |= hex(*buf++) << 8;
+               tmp_l |= hex(*buf++) << 20;
+               tmp_l |= hex(*buf++) << 16;
+               tmp_l |= hex(*buf++) << 28;
+               tmp_l |= hex(*buf++) << 24;
+#endif
+               if (probe_kernel_write(mem, tmp_l))
+                       return ERR_PTR(-EINVAL);
+               mem += 4;

As in, write a helper to parse a hex16, hex32, hex64, then do a
be[16|32|64]_to_cpu, and probe_kernel_write the result.

u64 hex_to_u64(unsigned char *buf)
{
        int i;
        u64 val = 0;

        for (i=0; i<16; i++)
                val = val<<4 | hex(buf[i]);   /* or *buf++, take your pick */
        return val;
}

...

        if (probe_kernel_write(mem, be64_to_cpu(hex_to_u64(unsigned char *buf)))
                return ERR_PTR(-EINVAL));
        mem += 4;
        buf += 16;

Or, you know, something like that.
