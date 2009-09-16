Return-Path: <linux-kernel-owner+w=401wt.eu-S1751296AbZIPEOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbZIPEOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbZIPEOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:14:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbZIPEOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:14:18 -0400
Date: Tue, 15 Sep 2009 21:14:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: 2.6.32 -mm merge plans
Message-Id: <20090915211408.bb614be5.akpm@linux-foundation.org>
In-Reply-To: <20090916034650.GD2756@core.coreip.homeip.net>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
	<20090916034650.GD2756@core.coreip.homeip.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 20:46:50 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Andrew,
> 
> On Tue, Sep 15, 2009 at 04:15:35PM -0700, Andrew Morton wrote:
> > 
> > input-touchpad-not-detected-on-asus-g1s.patch
> 
> This one has been in mainline for a while now, please drop.

Thanks.

> > input-add-a-shutdown-method-to-pnp-drivers.patch
> 
> This should go through PNP tree (do we have one?).

Not really.  Bjorn heeps an eye on pnp.  Sometimes merges through acpi,
sometimes through -mm.

I'll merge it I guess, but where is the corresponding change to the
winbond driver?




From: David H_rdeman <david@hardeman.nu>

The shutdown method is used by the winbond cir driver to setup the
hardware for wake-from-S5.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: David H_rdeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/driver.c |   10 ++++++++++
 include/linux/pnp.h  |    1 +
 2 files changed, 11 insertions(+)

diff -puN drivers/pnp/driver.c~input-add-a-shutdown-method-to-pnp-drivers drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~input-add-a-shutdown-method-to-pnp-drivers
+++ a/drivers/pnp/driver.c
@@ -135,6 +135,15 @@ static int pnp_device_remove(struct devi
 	return 0;
 }
 
+static void pnp_device_shutdown(struct device *dev)
+{
+	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
+	struct pnp_driver *drv = pnp_dev->driver;
+
+	if (drv && drv->shutdown)
+		drv->shutdown(pnp_dev);
+}
+
 static int pnp_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
@@ -203,6 +212,7 @@ struct bus_type pnp_bus_type = {
 	.match   = pnp_bus_match,
 	.probe   = pnp_device_probe,
 	.remove  = pnp_device_remove,
+	.shutdown = pnp_device_shutdown,
 	.suspend = pnp_bus_suspend,
 	.resume  = pnp_bus_resume,
 	.dev_attrs = pnp_interface_attrs,
diff -puN include/linux/pnp.h~input-add-a-shutdown-method-to-pnp-drivers include/linux/pnp.h
--- a/include/linux/pnp.h~input-add-a-shutdown-method-to-pnp-drivers
+++ a/include/linux/pnp.h
@@ -360,6 +360,7 @@ struct pnp_driver {
 	unsigned int flags;
 	int (*probe) (struct pnp_dev *dev, const struct pnp_device_id *dev_id);
 	void (*remove) (struct pnp_dev *dev);
+	void (*shutdown) (struct pnp_dev *dev);
 	int (*suspend) (struct pnp_dev *dev, pm_message_t state);
 	int (*resume) (struct pnp_dev *dev);
 	struct device_driver driver;
_

