Return-Path: <linux-kernel-owner+w=401wt.eu-S2993237AbXEBO2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993237AbXEBO2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993238AbXEBO2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:28:31 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45046 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2993237AbXEBO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:28:29 -0400
Date: Wed, 2 May 2007 16:28:27 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Dave Jones <davej@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
In-Reply-To: <20070428030805.GA13331@redhat.com>
Message-ID: <Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org>
 <20070425112133.4ae86399.randy.dunlap@oracle.com>
 <20070425143011.57247c1d.akpm@linux-foundation.org>
 <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com>
 <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org>
 <20070428030805.GA13331@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Dave Jones wrote:
> On Wed, Apr 25, 2007 at 08:02:07PM -0700, Andrew Morton wrote:
>  > > Yep, I was going to mention your scripts but you beat me to it.
>  > > 
>  > > I'll be glad to help maintain such animals if wanted.
>  > > 
>  > wanted ;)
>  > 
>  > At least, it would be interesting to investigate the usefulness.  I suspect
>  > it will prove to be very useful for the little things.
> 
> Randy and I got together and hashed out a first cut at this.
> (Randy actually gutted quite a lot of what I originally wrote, so deserves
>  much kudos for improving this beyond my initial crappy version).
> You can find the script at http://www.codemonkey.org.uk/projects/checkpatch/
> There's also a git clonable tree there (only http right now).
> 
> http://www.codemonkey.org.uk/projects/checkpatch/example.log shows
> what fell out of running it on my mbox of lkml from the past month.
> Some of them are kinda noisy, and perhaps should be moved under --pedantic
> 
> I'm all ears for additional regexps, bug reports or other suggestions.

Nice!

Here are a few more:
  - Check for all of (u)int{8,16,32,64}_t
  - Check for GNU extension __FUNCTION__
  - Don't use space before tab
  - Don't use trailing white space

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/checkpatch.pl b/checkpatch.pl
index cbda29a..b44a3f3 100755
--- a/checkpatch.pl
+++ b/checkpatch.pl
@@ -143,10 +143,26 @@ sub process {
 			"Bad variable name: tmp. Please use something more descriptive.\n");
 		$warnings += search(qr/temp(,|;)/,
 			"Bad variable name: temp. Please use something more descriptive.\n");
+		$warnings += search(qr/uint8_t/,
+			"Incorrect type usage for kernel code. Use __u8/u8\n");
+		$warnings += search(qr/uint16_t/,
+			"Incorrect type usage for kernel code. Use __u16/u16\n");
 		$warnings += search(qr/uint32_t/,
-			"Incorrect type usage for kernel code. Use __u32 etc.\n");
+			"Incorrect type usage for kernel code. Use __u32/u32\n");
+		$warnings += search(qr/uint64_t/,
+			"Incorrect type usage for kernel code. Use __u64/u64\n");
+		$warnings += search(qr/int8_t/,
+			"Incorrect type usage for kernel code. Use __s8/s8\n");
+		$warnings += search(qr/int16_t/,
+			"Incorrect type usage for kernel code. Use __s16/s16\n");
+		$warnings += search(qr/int32_t/,
+			"Incorrect type usage for kernel code. Use __s32/s32\n");
+		$warnings += search(qr/int64_t/,
+			"Incorrect type usage for kernel code. Use __s64/s64\n");
 		$warnings += search(qr/\b(BUG|BUG_ON)\b/,
 			"Try to use WARN_ON & Recovery code rather than BUG() or BUG_ON()\n");
+		$warnings += search(qr/__FUNCION__/,
+			"Should use C99 __func__ instead of GNU __FUNCTION__\n");
 	}
 
 	# coding style:
@@ -154,6 +170,8 @@ sub process {
 		$warnings += search(qr/,[^[:space:]]/, "Need space after comma:\n");
 		$warnings += search(qr/\([[:space:]]/, "Don't use space after '(':\n");
 		$warnings += search(qr/[[:space:]]\)/, "Don't use space before ')':\n");
+		$warnings += search(qr/ \t/, "Don't use space before tab:\n");
+		$warnings += search(qr/[[:space:]]$/, "Don't use trailing white space:\n");
 		$warnings += search(qr/if\(|for\(|while\(|switch\(/,
 				"Need space after if/for/while/switch:\n");
 		$warnings += search(qr/sizeof[[:space:]]/,

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
