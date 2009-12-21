Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZLUNuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZLUNuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbZLUNuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:50:12 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:39923 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZLUNuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:50:11 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Sam Ravnborg <sam@ravnborg.org>,
       Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86 boot
References: <20091219233457.GA4288@trillian.comsick.at>
	<20091220084656.GA485@merkur.ravnborg.org>
	<20091220091138.GA1793@trillian.comsick.at>
	<20091220100344.GA6614@merkur.ravnborg.org>
	<4B2E084D.6080105@msgid.tls.msk.ru> <m2y6kxetu8.fsf@igel.home>
	<4B2F68AA.2020102@suse.cz>
X-Yow: Hello...  IRON CURTAIN?  Send over a SAUSAGE PIZZA!
 World War III?  No thanks!
Date: Mon, 21 Dec 2009 14:50:06 +0100
In-Reply-To: <4B2F68AA.2020102@suse.cz> (Michal Marek's message of "Mon, 21
	Dec 2009 13:23:06 +0100")
Message-ID: <m2pr68e8s1.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> writes:

> Andreas Schwab napsal(a):
>> Does dash's printf support %b?  Then this should work.
>
> Good idea. %b is specified by posix, so there is hope :).

Actually you don't need it anyway.  (Still untested though.)

Andreas.

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cd815ac..7173c0c 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -213,14 +213,16 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 
 # Bzip2 and LZMA do not include size in file... so we have to fake that;
 # append the size as a 32-bit littleendian number as gzip does.
-size_append = printf $(shell						\
+size_append = printf $$(						\
 dec_size=0;								\
 for F in $1; do								\
 	fsize=$$(stat -c "%s" $$F);					\
 	dec_size=$$(expr $$dec_size + $$fsize);				\
 done;									\
-printf "%08x" $$dec_size |						\
-	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
+for i in 1 2 3 4; do							\
+	printf '\\%03o' $$(expr $$dec_size % 256);			\
+  	dec_size=$$(expr $$dec_size / 256);				\
+done									\
 )
 
 quiet_cmd_bzip2 = BZIP2   $@

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
