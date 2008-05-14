Return-Path: <linux-kernel-owner+w=401wt.eu-S1761770AbYENMpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770AbYENMpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbYENMpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:45:23 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:41729 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYENMpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:45:23 -0400
Message-ID: <482ADF34.2010004@keyaccess.nl>
Date: Wed, 14 May 2008 14:46:44 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl> <20080513180107.1a3893f1@core> <4829D0E5.8050905@keyaccess.nl> <200805131718.40138.bjorn.helgaas@hp.com>
In-Reply-To: <200805131718.40138.bjorn.helgaas@hp.com>
Content-Type: multipart/mixed;
 boundary="------------030300000008080707000900"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030300000008080707000900
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 14-05-08 01:18, Bjorn Helgaas wrote:

> On Tuesday 13 May 2008 11:33:25 am Rene Herman wrote:

>> No, isa_device is its own thing, on its own isa_bus (*). It has a struct 
>> device * readily available though...
>>
>> (*) drivers/base/isa.c, and explanatory changelog at:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a5117ba7da37deb09df5eb802dace229b3fb1e9f
> 
> Thanks for the nice changelog.
> 
> isa_register_driver() currently doesn't set a DMA mask.  Should it?

If it's going to be useful, definitely. The attached does not just set

   dev->dma_mask = &dev->coherent_dma_mask

as in the fallback_dev when dma_alloc_coherent() is passed a NULL device 
only due to the mask juggling in snd_dma_hack_alloc_coherent() (which 
wouldn't break, but...) but introduces its own copy in struct isa_dev 
same as struct pnp_dev. As far as I'm aware, there's no actual reason 
for keeping it other than that and if the hack could go I'd rather lose 
the private mask copy again also.

(the device model still uses a plain u64 by the way but I guess the 
clean type would be a dma64_addr_t)

Inlining is whitespace-failing here. Patch itself is trivial...

> I only see about 35 dma_alloc_coherent() calls that pass NULL.  I 
> guess even those would be a fair amount of work to change, and I 
> suppose there would be more that I missed.

At least the ALSA one isn't passing a literal NULL it seems. But yes, 
current NULL-hack reinstatement (it's been merged by Linus already) is 
definitely the correct fix for now.

Would like a comment on the snd_dma_hack_alloc_coherent thing first (no 
signoff...) but other than that I'll submit this in preparation for it 
being useful, I guess?

Rene.

--------------030300000008080707000900
Content-Type: text/plain;
 name="isa_dev_dma_mask.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="isa_dev_dma_mask.diff"

From: Rene Herman <rene.herman@gmail.com>

ISA: set 24-bit dma_mask for ISA devices

Set the ISA device dma_mask in preparation for using the actual device
with the DMA API.
---
 drivers/base/isa.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/base/isa.c b/drivers/base/isa.c
index d222239..842ca08 100644
--- a/drivers/base/isa.c
+++ b/drivers/base/isa.c
@@ -7,6 +7,8 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
 #include <linux/isa.h>
 
 static struct device isa_bus = {
@@ -17,6 +19,7 @@ struct isa_dev {
 	struct device dev;
 	struct device *next;
 	unsigned int id;
+	u64 dma_mask;
 };
 
 #define to_isa_dev(x) container_of((x), struct isa_dev, dev)
@@ -131,6 +134,9 @@ int isa_register_driver(struct isa_driver *isa_driver, unsigned int ndev)
 			break;
 		}
 
+		isa_dev->id		= id;
+		isa_dev->dma_mask	= DMA_24BIT_MASK;
+
 		isa_dev->dev.parent	= &isa_bus;
 		isa_dev->dev.bus	= &isa_bus_type;
 
@@ -138,8 +144,9 @@ int isa_register_driver(struct isa_driver *isa_driver, unsigned int ndev)
 				isa_driver->driver.name, id);
 
 		isa_dev->dev.platform_data	= isa_driver;
+		isa_dev->dev.dma_mask		= &isa_dev->dma_mask;
+		isa_dev->dev.coherent_dma_mask  = isa_dev->dma_mask;
 		isa_dev->dev.release		= isa_dev_release;
-		isa_dev->id			= id;
 
 		error = device_register(&isa_dev->dev);
 		if (error) {
-- 
1.5.2.2


--------------030300000008080707000900--
