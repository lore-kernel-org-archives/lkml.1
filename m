Return-Path: <linux-kernel-owner+w=401wt.eu-S1763893AbYEFBIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763893AbYEFBIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbYEFBHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:07:31 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59574 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbYEFBHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:07:30 -0400
Message-ID: <481FAF83.5090305@keyaccess.nl>
Date: Tue, 06 May 2008 03:08:19 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] PNP: add AD1815 and AD1816 quirks
References: <481FAC37.6090703@keyaccess.nl> <481FAD12.3030409@keyaccess.nl>
In-Reply-To: <481FAD12.3030409@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------080706020706090304000002"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080706020706090304000002
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Bjorn.

The AD181x chip doesn't support an IRQ-less MPU401 option but works
fine without one. This adds (priority: functional) IRQ-less options
for each port option to help systems with few available IRQs.

The AD1815 quirk can't use pnp_register_irq_resource() due to doubly
penalizing the IRQ. Also, while not a practical issue due to no IRQ
option being present for the dependents, this needs to add in front,
not back.

Doesn't use pnp_register_port_resource() for symetry with above.

This does not delete the AD1815 independent option even though it
should be empty after the IRQ transfer due to AD1816 coming with an
empty but still present independent option by default.

Was tested on AD1815 and AD1816. The ALSA driver also support the
AZT2002 ID for MPU401 but this doesn't as I was unable to test it.

Signed-off-by: Rene Herman <rene.herman@gmail.com>


--------------080706020706090304000002
Content-Type: text/plain;
 name="pnp-add-ad1815-and-ad1816-quirks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp-add-ad1815-and-ad1816-quirks.diff"

commit effa66095a52cecd415c3f34043ed505561a5139
Author: Rene Herman <rene.herman@gmail.com>
Date:   Tue May 6 02:07:59 2008 +0200

    PNP: add AD1815 and AD1816 quirks.
    
    The AD181x chip doesn't support an IRQ-less MPU401 option but works
    fine without one. This adds (priority: functional) IRQ-less options
    for each port option to help systems with few available IRQs.
    
    The AD1815 quirk can't use pnp_register_irq_resource() due to doubly
    penalizing the IRQ. Also, while not a practical issue due to no IRQ
    option being present for the dependents, this needs to add in front,
    not back.
    
    Doesn't use pnp_register_port_resource() for symetry with above.
    
    This does not delete the AD1815 independent option even though it
    should be empty after the IRQ transfer due to AD1816 coming with an
    empty but still present independent option by default.
    
    Was tested on AD1815 and AD1816. The ALSA driver also support the
    AZT2002 ID for MPU401 but this doesn't as I was unable to test it.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 10b1295..e4b049c 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -108,6 +108,114 @@ static void quirk_sb16audio_resources(struct pnp_dev *dev)
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
+static struct pnp_option *quirk_ad181x_mpu_resources(struct pnp_dev *dev)
+{
+	struct pnp_option *head = NULL;
+	struct pnp_option *prev = NULL;
+	struct pnp_option *res;
+
+	/*
+	 * Build a functional IRQ-less variant of each MPU option.
+	 */
+
+	for (res = dev->dependent; res; res = res->next) {
+		struct pnp_option *curr;
+		struct pnp_port *port;
+		struct pnp_port *copy;
+
+		port = res->port;
+		if (!port || !res->irq)
+			continue;
+
+		copy = pnp_alloc(sizeof *copy);
+		if (!copy)
+			break;
+
+		copy->min = port->min;
+		copy->max = port->max;
+		copy->align = port->align;
+		copy->size = port->size;
+		copy->flags = port->flags;
+
+		curr = pnp_build_option(PNP_RES_PRIORITY_FUNCTIONAL);
+		if (!curr) {
+			kfree(copy);
+			break;
+		}
+		curr->port = copy;
+
+		if (prev)
+			prev->next = curr;
+		else
+			head = curr;
+		prev = curr;
+	}
+	return head;
+}
+
+static void quirk_ad1815_mpu_resources(struct pnp_dev *dev)
+{
+	struct pnp_option *res;
+	struct pnp_irq *irq;
+
+	/*
+	 * Distribute the independent IRQ over the dependent options
+	 */
+
+	res = dev->independent;
+	if (!res)
+		return;
+
+	irq = res->irq;
+	if (!irq || irq->next)
+		return;
+
+	res = dev->dependent;
+	if (!res)
+		return;
+
+	while (1) {
+		struct pnp_irq *copy;
+
+		copy = pnp_alloc(sizeof *copy);
+		if (!copy)
+			return;
+
+		memcpy(copy->map, irq->map, sizeof copy->map);
+		copy->flags = irq->flags;
+
+		copy->next = res->irq; /* Yes, this is NULL */
+		res->irq = copy;
+
+		if (!res->next)
+			break;
+		res = res->next;
+	}
+	kfree(irq);
+
+	res->next = quirk_ad181x_mpu_resources(dev);
+
+	res = dev->independent;
+	res->irq = NULL;
+
+	printk(KERN_INFO "pnp: adding IRQ-less AD1815 MPU options\n");
+}
+
+static void quirk_ad1816_mpu_resources(struct pnp_dev *dev)
+{
+	struct pnp_option *res;
+
+	res = dev->dependent;
+	if (!res)
+		return;
+
+	while (res->next)
+		res = res->next;
+
+	res->next = quirk_ad181x_mpu_resources(dev);
+
+	printk(KERN_INFO "pnp: adding IRQ-less AD1816 MPU options\n");
+}
 
 #include <linux/pci.h>
 
@@ -202,6 +310,10 @@ static struct pnp_fixup pnp_fixups[] = {
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
+	/* Add IRQ-less AD1815 MPU options */
+	{"ADS7151", quirk_ad1815_mpu_resources},
+	/* Add IRQ-less AD1816 MPU options */
+	{"ADS7181", quirk_ad1816_mpu_resources},
 	{"PNP0c01", quirk_system_pci_resources},
 	{"PNP0c02", quirk_system_pci_resources},
 	{""}


--------------080706020706090304000002--
