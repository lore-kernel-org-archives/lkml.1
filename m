Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYB2EJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYB2EJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYB2EJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:09:33 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:37614 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbYB2EJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:09:32 -0500
Date: Fri, 29 Feb 2008 05:09:02 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/3] fix recursive dependencies
In-Reply-To: <20080226194058.GA31438@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802290443440.2723@scrub.home>
References: <200802210258.45011.yinghai.lu@sun.com> <200802241832.37850.yinghai.lu@sun.com>
 <200802242136.28744.yinghai.lu@sun.com> <200802242243.49576.yinghai.lu@sun.com>
 <20080226194058.GA31438@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 26 Feb 2008, Sam Ravnborg wrote:

> We discovered a situation where we could set a
> choice value in menuconfig but later when we either was
> running menuconfig or oldconfig the value were changed.

The patch fixes these dependency problems.

bye, Roman


The proper dependency check uncovered a few dependency problems,
the subarchitecture used a mixture of selects and depends on SMP
and PCI dependency was messed up.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 arch/x86/Kconfig |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -243,8 +243,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
-	depends on X86_32
-	select SMP if !BROKEN
+	depends on X86_32 && (SMP || BROKEN)
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
 	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
@@ -256,9 +255,8 @@ config X86_VOYAGER
 
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
-	select SMP
+	depends on SMP && X86_32
 	select NUMA
-	depends on X86_32
 	help
 	  This option is used for getting Linux to run on a (IBM/Sequent) NUMA
 	  multiquad box. This changes the way that processors are bootstrapped,
@@ -329,7 +327,7 @@ config X86_RDC321X
 
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
-	depends on X86_64 && PCI
+	depends on X86_64
 	 help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
@@ -1381,7 +1379,7 @@ endmenu
 menu "Bus options (PCI etc.)"
 
 config PCI
-	bool "PCI support" if !X86_VISWS
+	bool "PCI support" if !X86_VISWS && !X86_VSMP
 	depends on !X86_VOYAGER
 	default y
 	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
