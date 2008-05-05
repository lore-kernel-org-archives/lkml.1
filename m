Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYEEEDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYEEEDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYEEECs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:02:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbYEEECq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:02:46 -0400
Date: Mon, 5 May 2008 14:02:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, dougthompson@xmission.com,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       bluesmoke-devel@lists.sourceforge.net, tony@bakeyournoodle.com,
       michael@ellerman.id.au
Subject: linux-next: upstream edac build failure
Message-Id: <20080505140234.ac7b8a22.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_May_2008_14_02_34_+1000_b_HT8zrZLZyvea=."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_May_2008_14_02_34_+1000_b_HT8zrZLZyvea=.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (powerpc allyesconfig) fails like this:

drivers/edac/cell_edac.c: In function 'cell_edac_count_ce':
drivers/edac/cell_edac.c:38: error: 'struct device' has no member named 'de=
v_name'
drivers/edac/cell_edac.c: In function 'cell_edac_count_ue':
drivers/edac/cell_edac.c:59: error: 'struct device' has no member named 'de=
v_name'
drivers/edac/cell_edac.c: In function 'cell_edac_init_csrows':
drivers/edac/cell_edac.c:145: error: 'struct device' has no member named 'd=
ev_name'
drivers/edac/cell_edac.c: In function 'cell_edac_probe':
drivers/edac/cell_edac.c:168: error: 'struct device' has no member named 'd=
ev_name'
drivers/edac/cell_edac.c:175: error: 'struct device' has no member named 'd=
ev_name'
drivers/edac/cell_edac.c:179: error: 'struct device' has no member named 'd=
ev_name'
drivers/edac/cell_edac.c:204: error: 'struct device' has no member named 'd=
ev_name'

Commit 06916639e2fed9ee475efef2747a1b7429f8fe76 ("driver-core: add
dev_name() to help transition away from using bus_id") in Linus' tree
added a static inline dev_name() and used it in dev_printk.
Unfortunately, drivers/edac/edac_core.h defines a macro called dev_name().

I have applied the following patch (diagnosis by Tony Breeds and Michael
Ellerman).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

>From 58d998b394ddb1f4bff4fb79feccb8eb102e22c3 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 5 May 2008 13:54:19 +1000
Subject: [PATCH] dev_name introduction fall out fix

Commit 06916639e2fed9ee475efef2747a1b7429f8fe76 ("driver-core:
add dev_name() to help transition away from using bus_id") added a
static inline dev_name() and used it in dev_printk.  Unfortunately,
drivers/edac/edac_core.h defines a macro called dev_name().  Rename the
latter.

Diagnosis by Tony Breeds and Michael Ellerman.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/edac/edac_core.h   |    2 +-
 drivers/edac/edac_device.c |    6 +++---
 drivers/edac/edac_mc.c     |    6 +++---
 drivers/edac/edac_pci.c    |    6 +++---
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index a9aa845..b27b13c 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -97,7 +97,7 @@ extern int edac_debug_level;
 #define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
 	PCI_DEVICE_ID_ ## vend ## _ ## dev
=20
-#define dev_name(dev) (dev)->dev_name
+#define edac_dev_name(dev) (dev)->dev_name
=20
 /* memory devices */
 enum dev_type {
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 63372fa..5fcd3d8 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -333,7 +333,7 @@ static int add_edac_dev_to_global_list(struct edac_devi=
ce_ctl_info *edac_dev)
 fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
 			"%s (%s) %s %s already assigned %d\n",
-			rover->dev->bus_id, dev_name(rover),
+			rover->dev->bus_id, edac_dev_name(rover),
 			rover->mod_name, rover->ctl_name, rover->dev_idx);
 	return 1;
=20
@@ -538,7 +538,7 @@ int edac_device_add_device(struct edac_device_ctl_info =
*edac_dev)
 				"'%s': DEV '%s' (%s)\n",
 				edac_dev->mod_name,
 				edac_dev->ctl_name,
-				dev_name(edac_dev),
+				edac_dev_name(edac_dev),
 				edac_op_state_to_string(edac_dev->op_state));
=20
 	mutex_unlock(&device_ctls_mutex);
@@ -599,7 +599,7 @@ struct edac_device_ctl_info *edac_device_del_device(str=
uct device *dev)
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n",
 		edac_dev->dev_idx,
-		edac_dev->mod_name, edac_dev->ctl_name, dev_name(edac_dev));
+		edac_dev->mod_name, edac_dev->ctl_name, edac_dev_name(edac_dev));
=20
 	return edac_dev;
 }
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index a4cf164..d110392 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -402,7 +402,7 @@ static int add_mc_to_global_list(struct mem_ctl_info *m=
ci)
 fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
 		"%s (%s) %s %s already assigned %d\n", p->dev->bus_id,
-		dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
+		edac_dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
 	return 1;
=20
 fail1:
@@ -517,7 +517,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
=20
 	/* Report action taken */
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to '%s' '%s':"
-		" DEV %s\n", mci->mod_name, mci->ctl_name, dev_name(mci));
+		" DEV %s\n", mci->mod_name, mci->ctl_name, edac_dev_name(mci));
=20
 	mutex_unlock(&mem_ctls_mutex);
 	return 0;
@@ -565,7 +565,7 @@ struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
=20
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
-		mci->mod_name, mci->ctl_name, dev_name(mci));
+		mci->mod_name, mci->ctl_name, edac_dev_name(mci));
=20
 	return mci;
 }
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 9b24340..22ec9d5 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -150,7 +150,7 @@ static int add_edac_pci_to_global_list(struct edac_pci_=
ctl_info *pci)
 fail0:
 	edac_printk(KERN_WARNING, EDAC_PCI,
 		"%s (%s) %s %s already assigned %d\n",
-		rover->dev->bus_id, dev_name(rover),
+		rover->dev->bus_id, edac_dev_name(rover),
 		rover->mod_name, rover->ctl_name, rover->pci_idx);
 	return 1;
=20
@@ -360,7 +360,7 @@ int edac_pci_add_device(struct edac_pci_ctl_info *pci, =
int edac_idx)
 			" DEV '%s' (%s)\n",
 			pci->mod_name,
 			pci->ctl_name,
-			dev_name(pci), edac_op_state_to_string(pci->op_state));
+			edac_dev_name(pci), edac_op_state_to_string(pci->op_state));
=20
 	mutex_unlock(&edac_pci_ctls_mutex);
 	return 0;
@@ -415,7 +415,7 @@ struct edac_pci_ctl_info *edac_pci_del_device(struct de=
vice *dev)
=20
 	edac_printk(KERN_INFO, EDAC_PCI,
 		"Removed device %d for %s %s: DEV %s\n",
-		pci->pci_idx, pci->mod_name, pci->ctl_name, dev_name(pci));
+		pci->pci_idx, pci->mod_name, pci->ctl_name, edac_dev_name(pci));
=20
 	return pci;
 }
--=20
1.5.5.1


--Signature=_Mon__5_May_2008_14_02_34_+1000_b_HT8zrZLZyvea=.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHobgTgG2atn1QN8RAgjUAJsE/rMXzpDnrzZxI0YboU4OaOUdQwCfRIgt
mWUFcdaIz3R3wVCCQvko/oA=
=vBNy
-----END PGP SIGNATURE-----

--Signature=_Mon__5_May_2008_14_02_34_+1000_b_HT8zrZLZyvea=.--
