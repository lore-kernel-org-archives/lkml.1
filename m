Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYBXM2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYBXM2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 07:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYBXM2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 07:28:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYBXM2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 07:28:35 -0500
Date: Sun, 24 Feb 2008 13:29:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Message-ID: <20080224122903.GC13637@one.firstfloor.org>
References: <200802210258.45011.yinghai.lu@sun.com> <200802221102.31019.yinghai.lu@sun.com> <47BF1BD9.4020808@firstfloor.org> <200802232148.43255.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802232148.43255.yinghai.lu@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 09:48:42PM -0800, Yinghai Lu wrote:
> 
> quad core 8 socket system will have apic id lifting.the apic id range could
> be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
> and that is large than 2. So it is treated as clustered_box.

Ok I see you chose the quick hack over doing it properly ...

> 
> and will get
> 
> Marking TSC unstable due to TSCs unsynchronized
> 
> even the CPUs have X86_FEATURE_CONSTANT_TSC set.

I doubt that will do the right thing on AMD based vSMP,
which also required the cluster check on AMD iirc.

Cc'ed Kiran/Shai. damage has already hit x86 tree I believe.

-Andi

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index d8d03e0..7d8ffda 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1180,9 +1180,19 @@ __cpuinit int apic_is_clustered_box(void)
 {
        int i, clusters, zeros;
        unsigned id;
-       u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+       u16 *bios_cpu_apicid;
        DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
+       /*
+        * Some AMD box with quadcore cpu and 8 sockets apicid
+        * will be [4, 0x23] or [8, 0x27] could be thought to
+        * have three apic_clusters. So go out early.
+        */
+       if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+               return 0;

