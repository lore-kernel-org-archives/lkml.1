Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0BBNta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:49:30 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50821 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0BBNt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gzCltNzr+y5dUnR7EjzwmIrhL5vevS1Z9SNGVY1SBAig4LGm3Sju/hOEpsCtMHS94E
         nJlSRKqibj0E9r1X4qAy+km9kwG8Eq0lyohWBzZYxE4H3gBcXpPeaIfFDTRncmIfBpX3
         a2GUM5VVVL0UaYFLSqWBNbgSeoG+CkUSNhH44=
MIME-Version: 1.0
In-Reply-To: <1265115344.25140.805.camel@Joe-Laptop.home>
References: <cover.1264967493.git.joe@perches.com>
	 <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
	 <20100201144745.GC26011@rakim.wolfsonmicro.main>
	 <1265044080.25140.266.camel@Joe-Laptop.home>
	 <8bd0f97a1002012013t5c4a3951ra559a8965d67a672@mail.gmail.com>
	 <20100202110824.GF6566@rakim.wolfsonmicro.main>
	 <1265115344.25140.805.camel@Joe-Laptop.home>
Date: Tue, 2 Feb 2010 14:49:25 +0100
X-Google-Sender-Auth: 977c862e6109329d
Message-ID: <520f0cf11002020549td6bb27fp9301d3385dc6a0e3@mail.gmail.com>
Subject: Re: [RFC PATCH] checkpatch.pl: Add warning on non #define 
	continuation lines
From: John Kacur <jkacur@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 1:55 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2010-02-02 at 11:08 +0000, Mark Brown wrote:
>> it'd be good to also check for just regular use of
>> continuations in code other than macro definitions.  These are just a
>> style nit but if there's a script that filters out false positives from
>> the macros that'd be handy...
>
>> Running "grep ' \\$' sound/soc/blackfin/*.[ch]" suggests that there's
>> still some of the continuations I mentioned above in there (plus a lot
>> of false positives from macros).
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 3257d3d..a174501 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1234,6 +1234,7 @@ sub process {
>
>        $realcnt = 0;
>        $linenr = 0;
> +       my $in_define = 0;
>        foreach my $line (@lines) {
>                $linenr++;
>
> @@ -1388,6 +1389,16 @@ sub process {
>                        WARN("adding a line without newline at end of file\n" . $herecurr);
>                }
>
> +               if ($rawline =~ /\\$/) {
> +                   if ($rawline =~ /\s*\#\s*define\s+/) {
> +                       $in_define = 1;
> +                   } elsif (!$in_define) {
> +                       WARN("Continuations outside of macros should be avoided\n" . $herecurr);
> +                   }
> +               } else {
> +                   $in_define = 0;
> +               }
> +
>  # Blackfin: use hi/lo macros
>                if ($realfile =~ m@arch/blackfin/.*\.S$@) {
>                        if ($line =~ /\.[lL][[:space:]]*=.*&[[:space:]]*0x[fF][fF][fF][fF]/) {
>
>find ./ -name "*.[ch]" | xargs ./scripts/checkpatch.pl -f | grep -a3 Continuations

Checkpatch is already kind of loud, so I'm not sure I like the idea -
you even say yourself that it's just a style nit.
But just in-case there are a lot of people who do like this, then you
have to do some work to get rid of false positives. Try something like
the following.

1. apply your patch.
2. run something like
find ./ -name "*.[ch]" | xargs ./scripts/checkpatch.pl -f | grep -a3
Continuations

and then go through the results looking for false positives.

One that I see right away, is with #if
For example,

#39: FILE: arch/arm/mach-lh7a40x/lcd-panel.h:39:
+#if defined (MACH_LPD79520)\

WARNING: Continuations outside of macros should be avoided
#40: FILE: arch/arm/mach-lh7a40x/lcd-panel.h:40:
+ || defined (MACH_LPD79524)\
