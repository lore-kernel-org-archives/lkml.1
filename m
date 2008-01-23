Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYAWVvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYAWVvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYAWVvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:51:40 -0500
Received: from 1wt.eu ([62.212.114.60]:1558 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYAWVvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:51:39 -0500
Date: Wed, 23 Jan 2008 22:19:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Jordan Crouse <jordan.crouse@amd.com>, Lars Heete <hel@admin.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] x86: GEODE add the "mfgptfix" boot time option to fix MFGPT timers
Message-ID: <20080123211952.GB3081@1wt.eu>
References: <20080116165606.3ebc06a4@ephemeral> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com> <47965806.6080903@i4.informatik.rwth-aachen.de> <20080122211014.GA27870@elte.hu> <20080123211746.GA2969@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123211746.GA2969@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The new "mfgptfix" boot command line option may be usd to fix MFGPT
timers on AMD Geode platforms when the BIOS has incorrectly applied
a workaround. TinyBIOS version 0.98 is known to be affected, 0.99
fixes the problem by letting the user disable the workaround.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 Documentation/kernel-parameters.txt |    5 +++++
 arch/x86/kernel/mfgpt_32.c          |   15 +++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c417877..83c6704 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1051,6 +1051,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			Multi-Function General Purpose Timers on AMD Geode
 			platforms.
 
+	mfgptfix	[X86-32] Fix MFGPT timers on AMD Geode platforms when
+			the BIOS has incorrectly applied a workaround. TinyBIOS
+			version 0.98 is known to be affected, 0.99 fixes the
+			problem by letting the user disable the workaround.
+
 	mga=		[HW,DRM]
 
 	mousedev.tap_time=
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 5519091..f38d4a9 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -63,6 +63,21 @@ static int __init mfgpt_disable(char *s)
 }
 __setup("nomfgpt", mfgpt_disable);
 
+/* Reset the MFGPT timers. This is required by some broken BIOSes which already
+ * do the same and leave the system in an unstable state. TinyBIOS 0.98 is
+ * affected at least (0.99 is OK with MFGPT workaround left to off).
+ */
+static int __init mfgpt_fix(char *s)
+{
+	u32 val, dummy;
+
+	/* The following udocumented bit resets the MFGPT timers */
+	val = 0xFF; dummy = 0;
+	wrmsr(0x5140002B, val, dummy);
+	return 1;
+}
+__setup("mfgptfix", mfgpt_fix);
+
 /*
  * Check whether any MFGPTs are available for the kernel to use.  In most
  * cases, firmware that uses AMD's VSA code will claim all timers during
-- 
1.5.3.4

