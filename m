Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYJTU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYJTU5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYJTU5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:57:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:65317 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbYJTU5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:57:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,454,1220252400"; 
   d="scan'208";a="62729725"
Date: Mon, 20 Oct 2008 13:57:02 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [saa7133] resource map sanity check conflict
Message-ID: <20081020205702.GI7829@linux-os.sc.intel.com>
References: <1224340447.5325.4.camel@zwerg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224340447.5325.4.camel@zwerg>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 07:34:07AM -0700, Alexey Fisher wrote:
> i get this message after your patch: "IO resources, x86: ioremap sanity
> check to catch mapping requests exceeding"
> 
> so may be saa7133 not clean ;) dmesg is attached.
> 
> resource map sanity check conflict: 0xcfeff800 0xcff007ff 0xcfe00000
> 0xcfefffff PCI Bus 0000:01
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0x2f5/0x33c()
> Modules linked in: saa7134(+) ir_common hid snd_hda_intel compat_ioctl32
> videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core tveeprom
> snd_pcm_oss snd_mixer_oss evdev snd_pcm snd_timer snd_page_alloc
> Pid: 2345, comm: modprobe Not tainted 2.6.27-slub-04260-g6b2ada8 #9
> Call Trace:
>  [<ffffffff80238459>] warn_on_slowpath+0x51/0x7e
>  [<ffffffff8051d3ba>] printk+0x4e/0x5c
>  [<ffffffff80490880>] pci_conf1_read+0xb1/0xdc
>  [<ffffffff8023e135>] iomem_map_sanity_check+0x94/0x9b
>  [<ffffffff80222a52>] __ioremap_caller+0x2f5/0x33c
>  [<ffffffffa00d8f0c>] saa7134_initdev+0x32c/0x9b5 [saa7134]

Alexey, Appended patch should fix this conflict. Can you please test and
ack it?

thanks,
suresh
---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: saa7134: fix the hard coded size argument in ioremap()

Alexey Fisher reported:
> resource map sanity check conflict: 0xcfeff800 0xcff007ff 0xcfe00000
> 0xcfefffff PCI Bus 0000:01

BAR base is located in the middle of the 4K page and the hardcoded
size argument makes the request span two pages causing the conflict.

Fix the hard coded size argument in ioremap()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index b686bfa..cff3b99 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -941,7 +941,8 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 		       dev->name,(unsigned long long)pci_resource_start(pci_dev,0));
 		goto fail1;
 	}
-	dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x1000);
+	dev->lmmio = ioremap(pci_resource_start(pci_dev,0),
+			     pci_resource_len(pci_dev,0));
 	dev->bmmio = (__u8 __iomem *)dev->lmmio;
 	if (NULL == dev->lmmio) {
 		err = -EIO;
