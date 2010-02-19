Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0BSVlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:41:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:59613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab0BSVle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:41:34 -0500
Date: Fri, 19 Feb 2010 21:41:10 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: Don't skip mode setting for the standard VGA modes
Message-ID: <tip-8e92dc767abb58357e696a48fc3d8ce615a9c01a@git.kernel.org>
Git-Commit-ID: 8e92dc767abb58357e696a48fc3d8ce615a9c01a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Feb 2010 21:41:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e92dc767abb58357e696a48fc3d8ce615a9c01a
Gitweb:     http://git.kernel.org/tip/8e92dc767abb58357e696a48fc3d8ce615a9c01a
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 19 Feb 2010 13:21:38 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Feb 2010 13:21:38 -0800

x86, setup: Don't skip mode setting for the standard VGA modes

The code for setting standard VGA modes probes for the current mode,
and skips the mode setting if the mode is 3 (color text 80x25) or 7
(mono text 80x25).  Unfortunately, there are BIOSes, including the
VMware BIOS, which report the previous mode if function 0F is queried
while the screen is in a VESA mode, and of course, nothing can help a
mode poked directly into the hardware.

As such, the safe option is to set the mode anyway, and only query to
see if we should be using mode 7 rather than mode 3.  People who don't
want any mode setting at all should probably use vga=0x0f04
(VIDEO_CURRENT_MODE).  It's possible that should be the kernel
default.

Reported-by Rene Arends <R.R.Arends@hro.nl>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/boot/video-vga.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index 819caa1..ed7aeff 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -42,22 +42,15 @@ static u8 vga_set_basic_mode(void)
 {
 	struct biosregs ireg, oreg;
 	u16 ax;
-	u8 rows;
 	u8 mode;
 
 	initregs(&ireg);
 
+	/* Query current mode */
 	ax = 0x0f00;
 	intcall(0x10, &ireg, &oreg);
 	mode = oreg.al;
 
-	set_fs(0);
-	rows = rdfs8(0x484);	/* rows minus one */
-
-	if ((oreg.ax == 0x5003 || oreg.ax == 0x5007) &&
-	    (rows == 0 || rows == 24))
-		return mode;
-
 	if (mode != 3 && mode != 7)
 		mode = 3;
 
