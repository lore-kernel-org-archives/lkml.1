Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZJBBtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZJBBtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbZJBBdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:32 -0400
Received: from kroah.org ([198.145.64.141]:33237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309AbZJBBd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:17 2009
Message-Id: <20091002012416.979819124@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [069/136] ahci: restore pci_intx() handling
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=ahci-restore-pci_intx-handling.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 31b239ad1ba7225435e13f5afc47e48eb674c0cc upstream.

Commit a5bfc4714b3f01365aef89a92673f2ceb1ccf246 dropped explicit
pci_intx() manipulation from ahci because it seemed unnecessary and
ahci doesn't seem to be the right place to be tweaking it if it were.
This was largely okay but there are exceptions.  There was one on an
embedded platform which was fixed via firmware and now bko#14124
reports it on a HP DL320.

  http://bugzilla.kernel.org/show_bug.cgi?id=14124

I still think this isn't something libata drivers should be caring
about (the only ones which are calling pci_intx() explicitly are
libata ones and one other driver) but for now reverting the change
seems to be the right thing to do.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2861,8 +2861,8 @@ static int ahci_init_one(struct pci_dev 
 	if (ahci_asus_m2a_vm_32bit_only(pdev))
 		hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
 
-	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
-		pci_enable_msi(pdev);
+	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
+		pci_intx(pdev, 1);
 
 	/* save initial config */
 	ahci_save_initial_config(pdev, hpriv);


