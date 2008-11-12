Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYKLA1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYKLA1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYKLA0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:05 -0500
Received: from kroah.org ([198.145.64.141]:42083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752408AbYKLA0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:03 -0500
Date: Tue, 11 Nov 2008 16:22:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 04/49] x86: add X86_RESERVE_LOW_64K
Message-ID: <20081112002259.GE10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-add-x86_reserve_low_64k.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Molnar <mingo@elte.hu>

commit fc38151947477596aa27df6c4306ad6008dc6711 upstream.

This bugzilla:

  http://bugzilla.kernel.org/show_bug.cgi?id=11237

Documents a wide range of systems where the BIOS utilizes the first
64K of physical memory during suspend/resume and other hardware events.

Currently we reserve this memory on all AMI and Phoenix BIOS systems.
Life is too short to hunt subtle memory corruption problems like this,
so we try to be robust by default.

Still, allow this to be overriden: allow users who want that first 64K
of memory to be available to the kernel disable the quirk, via
CONFIG_X86_RESERVE_LOW_64K=n.

Also, allow the early reservation to overlap with other
early reservations.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig        |   20 ++++++++++++++++++++
 arch/x86/kernel/setup.c |    4 +++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1059,6 +1059,26 @@ config HIGHPTE
 	  low memory.  Setting this option will put user-space page table
 	  entries in high memory.
 
+config X86_RESERVE_LOW_64K
+        bool "Reserve low 64K of RAM on AMI/Phoenix BIOSen"
+	default y
+	help
+	 Reserve the first 64K of physical RAM on BIOSes that are known
+	 to potentially corrupt that memory range. A numbers of BIOSes are
+	 known to utilize this area during suspend/resume, so it must not
+	 be used by the kernel.
+
+	 Set this to N if you are absolutely sure that you trust the BIOS
+	 to get all its memory reservations and usages right.
+
+	 If you have doubts about the BIOS (e.g. suspend/resume does not
+	 work or there's kernel crashes after certain hardware hotplug
+	 events) and it's not AMI or Phoenix, then you might want to enable
+	 X86_CHECK_BIOS_CORRUPTION=y to allow the kernel to check typical
+	 corruption patterns.
+
+	 Say Y if unsure.
+
 config MATH_EMULATION
 	bool
 	prompt "Math emulation" if X86_32
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -584,13 +584,14 @@ static int __init dmi_low_memory_corrupt
 		"%s detected: BIOS may corrupt low RAM, working it around.\n",
 		d->ident);
 
-	reserve_early(0x0, 0x10000, "BIOS quirk");
+	reserve_early_overlap_ok(0x0, 0x10000, "BIOS quirk");
 
 	return 0;
 }
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 	{
 		.callback = dmi_low_memory_corruption,
 		.ident = "AMI BIOS",
@@ -606,6 +607,7 @@ static struct dmi_system_id __initdata b
 		},
 	},
 	{}
+#endif
 };
 
 /*

-- 
