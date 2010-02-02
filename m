Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab0BBPuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:50:15 -0500
Received: from sh.osrg.net ([192.16.179.4]:39839 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0BBPuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:50:12 -0500
Date: Wed, 3 Feb 2010 00:49:20 +0900
To: mitov@issp.bas.bg
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc5 if
 iommu=allowed in kernel command line
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100202202328O.fujita.tomonori@lab.ntt.co.jp>
References: <20100125141006O.fujita.tomonori@lab.ntt.co.jp>
	<201001250937.53518.mitov@issp.bas.bg>
	<20100202202328O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100203004905T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 03 Feb 2010 00:49:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010 20:23:40 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > If CONFIG_AGP_AMD64=m  it works (I have agp)  with no kernel command
> > line parameters. If I boot to no graphics (runlevel 3 in slackware), 
> > lsmod output is:
> > 
> > amd64_agp               7463  1
> > agpgart                   27765  1 amd64_agp
> > 
> > amd64_agp is in use (not known by who), cannot be unloaded and I cannot 
> > test load/unload.
> > 
> > If CONFIG_AGP_AMD64=m and  iommu=allowed is in kernel command line
> > I have no agp.
> > dmesg:
> > [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
> 
> This works with 2.6.32, right?  The following patch works?

Duh, sorry, please this instead:

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 34cf04e..fd50ead 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -767,16 +767,19 @@ int __init agp_amd64_init(void)
 
 static int __init agp_amd64_mod_init(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return agp_bridges_found ? 0 : -ENODEV;
-
+#endif
 	return agp_amd64_init();
 }
 
 static void __exit agp_amd64_cleanup(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return;
+#endif
 	if (aperture_resource)
 		release_resource(aperture_resource);
 	pci_unregister_driver(&agp_amd64_pci_driver);
