Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZLECYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZLECYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZLECX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:23:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbZLECX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:23:57 -0500
Message-ID: <4B19C493.4030506@gmail.com>
Date: Sat, 05 Dec 2009 03:25:23 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: tony.luck@intel.com, geoffrey.levand@am.sony.com, davem@davemloft.net,
       tglx@linutronix.de, joerg.roedel@amd.com, muli@il.ibm.com,
       jdmason@kudzu.us, jbarnes@virtuousgeek.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] Constify struct dma_map_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>	<4B1989B0.102@gmail.com>	<20091205115936.d3a7a6ec.sfr@canb.auug.org.au>	<20091205122015.c898e234.sfr@canb.auug.org.au>	<4B19BEB9.3000600@gmail.com> <20091205131011.e90d7f1c.sfr@canb.auug.org.au>
In-Reply-To: <20091205131011.e90d7f1c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Emese,
> 
> On Sat, 05 Dec 2009 03:00:25 +0100 Emese Revfy <re.emese@gmail.com> wrote:
>> Ok, I made the changes, I also removed the vio_cmo_set_dma_ops function
>> because I think it is now unnecessary.
> 
> It is necessary because vio_dma_mapping_ops is only defined when
> CONFIG_PPC_SMLPAR is set, but that function was called from unconditional
> code (and there was a trivial version for when CONFIG_PPC_SMLPAR was not
> set) i.e. we only want the dma_ops set if we were built with
> CONFIG_PPC_SMLPAR.

I already took care of these, look at these hunks:

@@ -1033,7 +1026,6 @@ int vio_cmo_entitlement_update(size_t new_entitlement) { return 0; }
 void vio_cmo_set_dev_desired(struct vio_dev *viodev, size_t desired) {}
 static int vio_cmo_bus_probe(struct vio_dev *viodev) { return 0; }
 static void vio_cmo_bus_remove(struct vio_dev *viodev) {}
-static void vio_cmo_set_dma_ops(struct vio_dev *viodev) {}
 static void vio_cmo_bus_init(void) {}
 static void vio_cmo_sysfs_init(void) { }
 #endif /* CONFIG_PPC_SMLPAR */
@@ -1233,7 +1225,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 	viodev->dev.archdata.of_node = of_node_get(of_node);
 
 	if (firmware_has_feature(FW_FEATURE_CMO))
-		vio_cmo_set_dma_ops(viodev);
+		viodev->dev.archdata.dma_ops = &vio_dma_mapping_ops;
 	else
 		viodev->dev.archdata.dma_ops = &dma_iommu_ops;
 	set_iommu_table_base(&viodev->dev, vio_build_iommu_table(viodev));


If you think it's not enough please let me know.
--
Emese
