Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYEJVrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYEJVrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbYEJVrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:47:25 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:44190 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbYEJVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:47:12 -0400
Message-ID: <48261832.70006@keyaccess.nl>
Date: Sat, 10 May 2008 23:48:34 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] PNP: add ISAPnP MPU option quirks
References: <481FAF79.2030407@keyaccess.nl> <200805061115.56737.bjorn.helgaas@hp.com> <482614B3.4000908@gmail.com>
In-Reply-To: <482614B3.4000908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 23:27, Bjorn Helgaas wrote:

> OK, thanks a lot for the explanation. It makes a lot more sense now,
> and I'm happy with your approach now. It shouldn't make anything 
> worse, and it should make the card useful in some cases where it 
> wasn't before.

Or at least allow one less shared PCI interrupt...

With respect to the last posting, this also grew the AZT0002 ID (which
just shares the same code) which the AZT2320 exports for its MPU401 due
to it sharing the same mandatory-IRQ setup as AD1816.

===
PNP: add ISAPnP MPU option quirks.

The AD181x and AZT230 chips don't support an IRQ-less MPU401 option
but work fine without one. This adds (priority functional) IRQ-less
options for each port option to help systems with few available IRQs.

The AD1815 quirk can't use pnp_register_irq_resource() due to doubly
penalizing the IRQ. Also, while not a practical issue due to no IRQ
option being present for the dependents, this needs to add in front,
not back.

Doesn't use pnp_register_port_resource() for symetry with above.

This does not delete the AD1815 independent option even though it
should be empty after the IRQ transfer due to AD1816 coming with an
empty but still present independent option by default.

Was tested on AD1815, AD1816 and AZT230. The ALSA snd-ad1818a driver
also support the AZT2002 ID for MPU401 but this doesn't as I was
unable to test it.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
drivers/pnp/quirks.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++
1 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index a1af2f9..ffdb12a 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -111,6 +111,113 @@ static void quirk_sb16audio_resources(struct pnp_dev *dev)
		dev_info(&dev->dev, "SB audio device quirk - increased port range\n");
}

+static struct pnp_option *quirk_isapnp_mpu_options(struct pnp_dev *dev)
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
+	if (head)
+		dev_info(&dev->dev, "adding IRQ-less MPU options\n");
+
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
+			break;
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
+	res->next = quirk_isapnp_mpu_options(dev);
+
+	res = dev->independent;
+	res->irq = NULL;
+}
+
+static void quirk_isapnp_mpu_resources(struct pnp_dev *dev)
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
+	res->next = quirk_isapnp_mpu_options(dev);
+}

#include <linux/pci.h>

@@ -205,6 +312,11 @@ static struct pnp_fixup pnp_fixups[] = {
	{"CTL0043", quirk_sb16audio_resources},
	{"CTL0044", quirk_sb16audio_resources},
	{"CTL0045", quirk_sb16audio_resources},
+	/* Add IRQ-less MPU options */
+	{"ADS7151", quirk_ad1815_mpu_resources},
+	{"ADS7181", quirk_isapnp_mpu_resources},
+	{"AZT0002", quirk_isapnp_mpu_resources},
+	/* PnP resources that might overlap PCI BARs */
	{"PNP0c01", quirk_system_pci_resources},
	{"PNP0c02", quirk_system_pci_resources},
	{""}
-- 
1.5.2.2


