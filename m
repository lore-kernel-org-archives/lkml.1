Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbZFQXKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbZFQXKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761204AbZFQXKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:10:07 -0400
Received: from outbound-mail-314.bluehost.com ([67.222.54.7]:41958 "HELO
	outbound-mail-314.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762677AbZFQXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:10:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SR8b/5oqigecX2Ajd9af7UgubsQhK6rdlIOtS7h7AeaQDy9xSNHYytYa1+dhfYTpM7GURzL2F8sGe6PwBfzZGwCN5EmQHgCzQLNI58u/8FANKZy1SahZz46+f3wSIFIx;
Date: Wed, 17 Jun 2009 16:10:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: linux-next: Tree for June 17 (pci/slot)
Message-ID: <20090617161001.734321be@jbarnes-g45>
In-Reply-To: <4A392B48.7060206@oracle.com>
References: <20090617155354.075c60ae.sfr@canb.auug.org.au>
	<4A39194B.2060200@oracle.com>
	<20090617163604.GT19977@parisc-linux.org>
	<20090617102901.6e39aac2@jbarnes-g45>
	<4A392B48.7060206@oracle.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 10:43:36 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Jesse Barnes wrote:
> > On Wed, 17 Jun 2009 10:36:04 -0600
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > 
> >> On Wed, Jun 17, 2009 at 09:26:51AM -0700, Randy Dunlap wrote:
> >>> Stephen Rothwell wrote:
> >>>> Hi all,
> >>>>
> >>>> Changes since 20090616:
> >>>
> >>> When CONFIG_SYSFS=n:
> >>>
> >>> drivers/pci/slot.c:327: error: 'module_kset' undeclared (first use
> >>> in this function)
> >> Is there any point to pci_slot existing without CONFIG_SYSFS?
> >> I don't see how you can interact with it in any meaningful way.
> >> Perhaps CONFIG_PCI_SLOT should depend on CONFIG_SYSFS?
> > 
> > I've got a code fix queued up, but maybe a Kconfig dependency is the
> > way to go...
> 
> What is the code fix like?
> The Kconfig fix makes sense to me.
> 
> 
Here's the patch I have (sorry cut & paste):

Fix this build error when CONFIG_SYSFS is not set:
drivers/pci/slot.c: In function 'pci_hp_create_module_link':
drivers/pci/slot.c:327: error: 'module_kset' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/pci/slot.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index eddb074..dd6c097 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -308,6 +308,7 @@ void pci_destroy_slot(struct pci_slot *slot)
 EXPORT_SYMBOL_GPL(pci_destroy_slot);
 
 #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
+#ifdef CONFIG_SYSFS
 #include <linux/pci_hotplug.h>
 /**
  * pci_hp_create_link - create symbolic link to the hotplug driver
module. @@ -344,6 +345,14 @@ void pci_hp_remove_module_link(struct
pci_slot *pci_slot) sysfs_remove_link(&pci_slot->kobj, "module");
 }
 EXPORT_SYMBOL_GPL(pci_hp_remove_module_link);
+#else /* CONFIG_SYSFS */
+
+inline void pci_hp_create_module_link(struct pci_slot *pci_slot) {}
+EXPORT_SYMBOL_GPL(pci_hp_create_module_link);
+
+inline void pci_hp_remove_module_link(struct pci_slot *pci_slot) {}
+EXPORT_SYMBOL_GPL(pci_hp_remove_module_link);
+#endif /* CONFIG_SYSFS */
 #endif
 
 static int pci_slot_init(void)


-- 
Jesse Barnes, Intel Open Source Technology Center
