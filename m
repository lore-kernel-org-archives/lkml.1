Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbXK3KOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbXK3KOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 05:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXK3KOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 05:14:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:58552 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbXK3KOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 05:14:19 -0500
Subject: [PATCH] Set pnp_init_resource_table, pnp_resource_change,
	pnp_manual_config_dev deprecated
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Shaohua Li <shaohua.li@intel.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Dave Young <hidave.darkstar@gmail.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Zhao Yakui <yakui.zhao@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1196389939.7234.1.camel@sli10-desk.sh.intel.com>
References: <a8e1da0711290111m65b071cft90b4361ec0155096@mail.gmail.com>
	 <474F72E3.4040608@keyaccess.nl>
	 <1196389939.7234.1.camel@sli10-desk.sh.intel.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Fri, 30 Nov 2007 11:14:17 +0100
Message-Id: <1196417657.23251.293.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 10:32 +0800, Shaohua Li wrote:
> On Fri, 2007-11-30 at 03:18 +0100, Rene Herman wrote:
> > On 29-11-07 10:11, Dave Young wrote:
> > 
> > > The pnpacpi rsparser.c report warnings of:
> > > exceeded the max number of IO resources: 24
> > > 
> > > dmesg|grep exceeded|wc
> > >     66     594    3564
> > 
> > Heavens... (added CCs of people who just upped it from 8 -- I suppose the 
> > problem is not new then?)
> Properly we should make a bit bigger till Thomas's patch is ready.
> Thomas, your patch isn't 2.6.24 staff, right?

Definitely not.
I also wonder how sever this is..., we now at least register 24, we
didn't reserve more than 8 for at least 2 kernel iterations AFAIK.
Another workaround could be:
AFAIK IO resources below 0x100 are (still?) ignored atm.
If they are ignored earlier, at parse time
({pnpbios,pnpacpi}/rsparser.c) and they are not added to the
pnp_resource_table of the device, we would save another maybe 4-6 IO
ports which are ignored anyway.


I don't know how many externally built drivers, which are making use of
this, could still be out there?
What is the general policy for removing such old, rarely used and "being
more a workaround than an interface" exported symbols?

This should be 2.6.24 material:

Mark pnp_init_resource_table, pnp_resource_change, pnp_manual_config_dev deprecated

Thanks to Rene Herman, the remaining calls to those functions got eliminated
in the sound/isa layer recently.
Those functions are a workaround for wrong BIOS pnp information and give
drivers the possibility to override BIOS exported PNP resources.
This can be done through sysfs since 2.6, therefore these functions should
vanish rather soon, as dynamic allocation for PNP resources is depending
on it.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 include/linux/pnp.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/linux/pnp.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/linux/pnp.h
+++ linux-2.6.24-rc3-mm2/include/linux/pnp.h
@@ -387,8 +387,8 @@ int pnp_register_dma_resource(struct pnp
 int pnp_register_port_resource(struct pnp_option *option,
 			       struct pnp_port *data);
 int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data);
-void pnp_init_resource_table(struct pnp_resource_table *table);
-int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
+void __deprecated pnp_init_resource_table(struct pnp_resource_table *table);
+int __deprecated pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
 			  int mode);
 int pnp_auto_config_dev(struct pnp_dev *dev);
 int pnp_validate_config(struct pnp_dev *dev);
@@ -396,8 +396,8 @@ int pnp_start_dev(struct pnp_dev *dev);
 int pnp_stop_dev(struct pnp_dev *dev);
 int pnp_activate_dev(struct pnp_dev *dev);
 int pnp_disable_dev(struct pnp_dev *dev);
-void pnp_resource_change(struct resource *resource, resource_size_t start,
-			 resource_size_t size);
+void __deprecated pnp_resource_change(struct resource *resource, resource_size_t start,
+				      resource_size_t size);
 
 /* protocol helpers */
 int pnp_is_active(struct pnp_dev *dev);
@@ -436,15 +436,15 @@ static inline int pnp_register_irq_resou
 static inline int pnp_register_dma_resource(struct pnp_option *option, struct pnp_dma *data) { return -ENODEV; }
 static inline int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
 static inline int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
-static inline void pnp_init_resource_table(struct pnp_resource_table *table) { }
-static inline int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode) { return -ENODEV; }
+static inline void __deprecated pnp_init_resource_table(struct pnp_resource_table *table) { }
+static inline int __deprecated pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode) { return -ENODEV; }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_validate_config(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_disable_dev(struct pnp_dev *dev) { return -ENODEV; }
-static inline void pnp_resource_change(struct resource *resource, resource_size_t start, resource_size_t size) { }
+static inline void __deprecated pnp_resource_change(struct resource *resource, resource_size_t start, resource_size_t size) { }
 
 /* protocol helpers */
 static inline int pnp_is_active(struct pnp_dev *dev) { return 0; }


