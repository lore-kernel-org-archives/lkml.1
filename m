Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYCVTAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYCVTAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 15:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYCVTAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 15:00:06 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:57614 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYCVTAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 15:00:04 -0400
Date: Sat, 22 Mar 2008 11:59:48 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, shai@scalex86.org
Subject: Re: [patch 4/4] x86: apic_is_clustered_box to indicate unsynched TSC's on multiboard vSMP systems
Message-ID: <20080322185948.GD23139@localdomain>
References: <20080320073740.GA9414@localdomain> <20080320074508.GE9414@localdomain> <86802c440803200053m1b0928a9q6567d8c619fa7a2f@mail.gmail.com> <20080320190240.GB6085@localdomain> <20080321091542.GE20420@elte.hu> <20080321185225.GA23139@localdomain> <20080321185821.GE6571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321185821.GE6571@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 07:58:21PM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> As for the observation about probing the pci space early during the 
>> bootup, we call vsmp_init() much earlier during the bootup, which 
>> calls is_vsmp_box(), does the pci probing and caches the result in the 
>> flag, as you suggest. So the call in the above diff context does not 
>> access the pci config space as is.
>
>ah, i see - indeed - the trick with -1 :-)
>
>my point remains though: if you initialize VSMP in a separate function 
>anyway then please move this PCI config space access from is_vsmp_box() 
>into vsmp_init() and keep a pure flag return is_vsmp_box(). That way 
>there can be no question at all whether there are (or can be) any 
>side-effects of that function.
>

OK. Something like this?

vSMP detection: Access pci config space early in boot to detect if the
system is a vSMPowered box, and cache the result in a flag, so that
is_vsmp_box() retrieves the value of the flag always.

Signed-off-by; Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux.git.trees/arch/x86/kernel/vsmp_64.c
===================================================================
--- linux.git.trees.orig/arch/x86/kernel/vsmp_64.c	2008-03-21 13:15:17.000000000 -0700
+++ linux.git.trees/arch/x86/kernel/vsmp_64.c	2008-03-22 11:58:42.313580356 -0700
@@ -108,25 +108,34 @@ static void __init set_vsmp_pv_ops(void)
 #endif
 
 #ifdef CONFIG_PCI
-static int vsmp = -1;
+static int is_vsmp = -1;
 
-int is_vsmp_box(void)
+static void __init detect_vsmp_box(void)
 {
-	if (vsmp != -1)
-		return vsmp;
+	is_vsmp = 0;
 
-	vsmp = 0;
 	if (!early_pci_allowed())
-		return vsmp;
+		return;
 
-	/* Check if we are running on a ScaleMP vSMP box */
+	/* Check if we are running on a ScaleMP vSMPowered box */
 	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
 	     (PCI_VENDOR_ID_SCALEMP | (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
-		vsmp = 1;
+		is_vsmp = 1;
+}
 
-	return vsmp;
+int is_vsmp_box(void)
+{
+	if (is_vsmp != -1)
+		return is_vsmp;
+	else {
+		printk("ScaleMP vSMPowered system detection called too early!\n");
+		return 0;
+	}
 }
 #else
+static int __init detect_vsmp_box(void)
+{
+}
 int is_vsmp_box(void)
 {
 	return 0;
@@ -135,6 +144,7 @@ int is_vsmp_box(void)
 
 void __init vsmp_init(void)
 {
+	detect_vsmp_box();
 	if (!is_vsmp_box())
 		return;
 
