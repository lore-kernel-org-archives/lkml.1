Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZFFVv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZFFVv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZFFVvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:51:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47256 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZFFVvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:51:20 -0400
Date: Sat, 6 Jun 2009 22:51:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] headers_check fixes
Message-ID: <20090606215107.GA23695@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam> <1244292857.2473.4.camel@ht.satnam> <20090606130210.GA9343@flint.arm.linux.org.uk> <1244299177.2473.21.camel@ht.satnam> <20090606214711.GA4813@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090606214711.GA4813@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 10:47:11PM +0100, Russell King wrote:
> What follows this email is the diff of what effect it has on the
> headers copied over - as can be seen, all resulting changes are of
> net benefit.

And here is the patch illustrating the overall change on the installed
header files.  As can be seen, all instances of:

#if defined(__KERNEL__) && ...
...
#endif

are removed, and:

#if !defined(__KERNEL__) || ...
...
#endif

have the conditionals also correctly removed, leaving the code between
properly exposed.

Clearly from the number of differences below, I'm not the only one who
is "ignorant" of this magic new rule about __KERNEL__, and I suggest
that no such rule actually ever existed.

diff -ur include.old/asm/hwcap.h include/asm/hwcap.h
--- include.old/asm/hwcap.h	2009-06-06 19:29:31.000000000 +0100
+++ include/asm/hwcap.h	2009-06-06 22:40:58.000000000 +0100
@@ -20,13 +20,5 @@
 #define HWCAP_VFPv3	8192
 #define HWCAP_VFPv3D16	16384
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
-/*
- * This yields a mask that user programs can use to figure out what
- * instruction set this cpu supports.
- */
-#define ELF_HWCAP	(elf_hwcap)
-extern unsigned int elf_hwcap;
-#endif
 
 #endif
diff -ur include.old/linux/acct.h include/linux/acct.h
--- include.old/linux/acct.h	2009-06-06 19:29:27.000000000 +0100
+++ include/linux/acct.h	2009-06-06 22:40:55.000000000 +0100
@@ -59,9 +59,7 @@
 	comp_t		ac_majflt;		/* Major Pagefaults */
 	comp_t		ac_swaps;		/* Number of Swaps */
 /* m68k had no padding here. */
-#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
 	__u16		ac_ahz;			/* AHZ */
-#endif
 	__u32		ac_exitcode;		/* Exitcode */
 	char		ac_comm[ACCT_COMM + 1];	/* Command Name */
 	__u8		ac_etime_hi;		/* Elapsed Time MSB */
diff -ur include.old/linux/soundcard.h include/linux/soundcard.h
--- include.old/linux/soundcard.h	2009-06-06 19:29:30.000000000 +0100
+++ include/linux/soundcard.h	2009-06-06 22:40:57.000000000 +0100
@@ -1033,7 +1033,6 @@
  */
 #define LOCL_STARTAUDIO		1
 
-#if !defined(__KERNEL__) || defined(USE_SEQ_MACROS)
 /*
  *	Some convenience macros to simplify programming of the
  *	/dev/sequencer interface
@@ -1275,4 +1274,3 @@
 		(SEQ_DUMPBUF(), write(seqfd, (char*)(patchx), len))
 
 #endif
-#endif
diff -ur include.old/linux/videodev.h include/linux/videodev.h
--- include.old/linux/videodev.h	2009-06-06 19:29:30.000000000 +0100
+++ include/linux/videodev.h	2009-06-06 22:40:58.000000000 +0100
@@ -16,24 +16,6 @@
 #include <linux/ioctl.h>
 #include <linux/videodev2.h>
 
-#if defined(__MIN_V4L1) && defined (__KERNEL__)
-
-/*
- * Used by those V4L2 core functions that need a minimum V4L1 support,
- * in order to allow V4L1 Compatibilty code compilation.
- */
-
-struct video_mbuf
-{
-	int	size;		/* Total memory to map */
-	int	frames;		/* Frames */
-	int	offsets[VIDEO_MAX_FRAME];
-};
-
-#define VIDIOCGMBUF		_IOR('v',20, struct video_mbuf)		/* Memory map buffer info */
-
-#else
-#if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
 
 #define VID_TYPE_CAPTURE	1	/* Can capture */
 #define VID_TYPE_TUNER		2	/* Can tune */
@@ -328,8 +310,6 @@
 #define VID_PLAY_RESET			13
 #define VID_PLAY_END_MARK		14
 
-#endif /* CONFIG_VIDEO_V4L1_COMPAT */
-#endif /* __MIN_V4L1 */
 
 #endif /* __LINUX_VIDEODEV_H */
 
diff -ur include.old/video/edid.h include/video/edid.h
--- include.old/video/edid.h	2009-06-06 19:29:31.000000000 +0100
+++ include/video/edid.h	2009-06-06 22:40:58.000000000 +0100
@@ -1,13 +1,11 @@
 #ifndef __linux_video_edid_h__
 #define __linux_video_edid_h__
 
-#if !defined(__KERNEL__) || defined(CONFIG_X86)
 
 struct edid_info {
 	unsigned char dummy[128];
 };
 
 
-#endif
 
 #endif /* __linux_video_edid_h__ */


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
