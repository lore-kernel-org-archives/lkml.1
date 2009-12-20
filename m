Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZLTMDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZLTMDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZLTMDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:03:01 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:41942 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbZLTMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:03:00 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
       Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86 boot
References: <20091219233457.GA4288@trillian.comsick.at>
	<20091220084656.GA485@merkur.ravnborg.org>
	<20091220091138.GA1793@trillian.comsick.at>
	<20091220100344.GA6614@merkur.ravnborg.org>
	<4B2E084D.6080105@msgid.tls.msk.ru>
X-Yow: I put aside my copy of ``BOWLING WORLD'' and think
 about GUN CONTROL legislation..
Date: Sun, 20 Dec 2009 13:02:55 +0100
In-Reply-To: <4B2E084D.6080105@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Sun, 20 Dec 2009 14:19:41 +0300")
Message-ID: <m2y6kxetu8.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> Sam Ravnborg wrote:
>> We use ... printf \x ... when calculating the size of the
>> compressed kernel.
>> Unfortunately dash built-in printf does not support this notation
>> resulting in a non-bootable kernel.
>> 
>> Fix this by always using the external version of printf.

That changed the wrong printf. :-)

>> The commit that introduced this bug was:
>> 4a2ff67c88211026afcbdbc190c13f705dae1b59: "kbuild: fix bzImage
>> build for x86"
>
> It's not that simple Sam.  This commit is a part of the game.
> It works neither with printf as after my commit above, nor with
> original fix with `/bin/echo -ne'.  In neither case the fix is
> complete or robust.  Because there are two places in the few lines,
> around this, both affected and both are non-POSIX-conformant.

Does dash's printf support %b?  Then this should work.

Andreas.

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cd815ac..340813d 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -213,14 +213,16 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 
 # Bzip2 and LZMA do not include size in file... so we have to fake that;
 # append the size as a 32-bit littleendian number as gzip does.
-size_append = printf $(shell						\
+size_append = printf %b $$(						\
 dec_size=0;								\
 for F in $1; do								\
 	fsize=$$(stat -c "%s" $$F);					\
 	dec_size=$$(expr $$dec_size + $$fsize);				\
 done;									\
-printf "%08x" $$dec_size |						\
-	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
+for i in 1 2 3 4; do							\
+	printf '\\%04o' $$(expr $$dec_size % 256);			\
+  	dec_size=$$(expr $$dec_size / 256);				\
+done									\
 )
 
 quiet_cmd_bzip2 = BZIP2   $@

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
