Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZHFBR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZHFBR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZHFBR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:17:26 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:54618 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZHFBRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=etR6h7HZ+j+T1HbfiAMybPrkewv/w23eQX0DTevjGDbgw6buC3OMWFR7c+j9bV/fV2
         85b28NR74866PYOQlRLY5bndZQ+3cTVtfWEQJhGntOF+QDaraUY37FpQPKDkk4f/2t/e
         Nd0e1ZRrfT5C2c88s2I46Nq4+xkOpTrJhgSuo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0908051720350.23591@gandalf.stny.rr.com>
References: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com>
	 <alpine.DEB.2.00.0908051525070.23591@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.0908051720350.23591@gandalf.stny.rr.com>
Date: Thu, 6 Aug 2009 11:17:24 +1000
Message-ID: <21d7e9970908051817u2f630d2ai2d4435fb79601bbb@mail.gmail.com>
Subject: Re: Please revert fc4c73554c9d93b3e495f2f7acae1323b0d5db84. Re: 
	[PATCH 1/2] ftrace: Fix the conditional that updates $ref_func
From: Dave Airlie <airlied@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 7:21 AM, Steven Rostedt<rostedt@goodmis.org> wrote:
>
> On Wed, 5 Aug 2009, Steven Rostedt wrote:
>
>>
>> On Wed, 5 Aug 2009, Dave Airlie wrote:
>>
>> > On Fri, Jul 24, 2009 at 2:16 AM, Matt Fleming<matt@console-pimps.org> wrote:
>> > > Fix the conditional that checks if we already have a $ref_func and that
>> > > the new function is weak. The code as previously checking whether either
>> > > condition was false, and we really need to only update $ref_func is both
>> > > cconditions are false.
>> > >
>> >
>> > This breaks the powerpc build on Fedora.
>> >
>> > When building on ppc64 this commit causes the links of drivers/hwmon/lm93.o
>> > to fail.
>> >
>> > It introduces an undefined symbol
>> >                  U .LM93_IN_FROM_REG
>> >
>> > that isn't produced when this patch is reverted
>> >
>> > This was found when the Fedora kernel failed to build when I pulled in
>> > -rc5-git3.
>> >
>> > can be seen at the end of:
>> > http://koji.fedoraproject.org/koji/getfile?taskID=1582002&name=build.log
>> >
>> > So can we revert this (at this stage in -rc5 or maybe fix it).
>> >
>>
>> I was not able to reproduce it, but could you see if this patch fixes the
>> issue?
>>
>
> Forget that one. I was finally able to reproduce it. This patch fixed it
> for me:
>

Doesn't seem to work here, I put the patch in on top of the Fedora
kernel instead of the previous one and got a link failure again in lm93.o

I'll reconfirm it now.

Dave.


> -- Steve
>
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index d29baa2..98e4afb 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -135,6 +135,7 @@ $mv = "mv" if ((length $mv) == 0);
>
>  my %locals;            # List of local (static) functions
>  my %weak;              # List of weak functions
> +my %symbols;           # List of symbols that are not local or weak
>  my %convert;           # List of local functions used that needs conversion
>
>  my $type;
> @@ -318,6 +319,8 @@ while (<IN>) {
>        $locals{$1} = 1;
>     } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
>        $weak{$2} = $1;
> +    } elsif (/^[0-9a-fA-F]+\s+(\S+)\s+(\S+)/) {
> +       $symbols{$2} = $1;
>     }
>  }
>  close(IN);
> @@ -408,13 +411,15 @@ while (<IN>) {
>        # if this is either a local function or a weak function
>        # keep looking for functions that are global that
>        # we can use safely.
> -       if (!defined($locals{$text}) && !defined($weak{$text})) {
> +       if (!defined($locals{$text}) && !defined($weak{$text}) &&
> +           defined($symbols{$text})) {
>            $ref_func = $text;
>            $read_function = 0;
>            $offset = hex $1;
>        } else {
>            # if we already have a function, and this is weak, skip it
> -           if (!defined($ref_func) && !defined($weak{$text})) {
> +           if (!defined($ref_func) && defined($locals{$text}) &&
> +               !defined($weak{$text})) {
>                $ref_func = $text;
>                $offset = hex $1;
>            }
>
