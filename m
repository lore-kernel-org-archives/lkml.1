Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbZK3BKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbZK3BKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 20:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZK3BKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 20:10:21 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:52107 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZK3BKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 20:10:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gAFcMuYVhtsBnDQFy8Q7I7mf3Mv0Adp04ThRqItqMI+IhvtCe+mVacu5Mxcg8KDFgV
         2aaxhATJQRzCtQcnwD0G3wothQw+9dfCadT7HI8Zd6OffLyrXZrmsL4Pra1zZN+wJ09a
         xgn5rnLDCMKyoX2it3GmvqscIFen2mw3YFAOQ=
Date: Sun, 29 Nov 2009 17:10:22 -0800
From: 640E9920 <640e9920@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
       jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
       peter.p.waskiewicz.jr@intel.com, john.ronciak@intel.com
Subject: [RFC] PM_QOS api update to use handles 3/5 (ethernet driver
 updates)
Message-ID: <20091130011022.GC4732@mgross-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

update to eithernet driver dependencies on pm_qos WRT api change to use
handles instead of name strings.

--mgross

Signed-off-by: mark gross <mgross@linux.intel.com>


---
 drivers/net/e1000e/netdev.c |   13 ++++++-------
 drivers/net/igbvf/netdev.c  |    5 +++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 0687c6a..d703061 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -51,6 +51,7 @@
 #define DRV_VERSION "1.0.2-k2"
 char e1000e_driver_name[] =3D "e1000e";
 const char e1000e_driver_version[] =3D DRV_VERSION;
+struct pm_qos_request_list *e1000e_driver_pm_qos_req;
=20
 static const struct e1000_info *e1000_info_tbl[] =3D {
 	[board_82571]		=3D &e1000_82571_info,
@@ -2516,11 +2517,9 @@ static void e1000_configure_rx(struct e1000_adapter =
*adapter)
 		 * With jumbo frames and early-receive enabled, excessive
 		 * C4->C2 latencies result in dropped transactions.
 		 */
-		pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY,
-					  e1000e_driver_name, 55);
+		pm_qos_update_request(e1000e_driver_pm_qos_req, 55);
 	} else {
-		pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY,
-					  e1000e_driver_name,
+		pm_qos_update_request(e1000e_driver_pm_qos_req,
 					  PM_QOS_DEFAULT_VALUE);
 	}
=20
@@ -5401,8 +5400,8 @@ static int __init e1000_init_module(void)
 	printk(KERN_INFO "%s: Copyright (c) 1999-2008 Intel Corporation.\n",
 	       e1000e_driver_name);
 	ret =3D pci_register_driver(&e1000_driver);
-	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, e1000e_driver_name,
-			       PM_QOS_DEFAULT_VALUE);
+	e1000e_driver_pm_qos_req =3D pm_qos_add_request(
+			PM_QOS_CPU_DMA_LATENCY, PM_QOS_DEFAULT_VALUE);
 			=09
 	return ret;
 }
@@ -5417,7 +5416,7 @@ module_init(e1000_init_module);
 static void __exit e1000_exit_module(void)
 {
 	pci_unregister_driver(&e1000_driver);
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, e1000e_driver_name);
+	pm_qos_remove_request(e1000e_driver_pm_qos_req);
 }
 module_exit(e1000_exit_module);
=20
diff --git a/drivers/net/igbvf/netdev.c b/drivers/net/igbvf/netdev.c
index 91024a3..0ba48d1 100644
--- a/drivers/net/igbvf/netdev.c
+++ b/drivers/net/igbvf/netdev.c
@@ -47,6 +47,7 @@
 #define DRV_VERSION "1.0.0-k0"
 char igbvf_driver_name[] =3D "igbvf";
 const char igbvf_driver_version[] =3D DRV_VERSION;
+struct pm_qos_request_list *igbvf_driver_pm_qos_req;
 static const char igbvf_driver_string[] =3D
 				"Intel(R) Virtual Function Network Driver";
 static const char igbvf_copyright[] =3D "Copyright (c) 2009 Intel Corporat=
ion.";
@@ -2881,7 +2882,7 @@ static int __init igbvf_init_module(void)
 	printk(KERN_INFO "%s\n", igbvf_copyright);
=20
 	ret =3D pci_register_driver(&igbvf_driver);
-	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, igbvf_driver_name,
+	igbvf_driver_pm_qos_req =3D pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
 	                       PM_QOS_DEFAULT_VALUE);
=20
 	return ret;
@@ -2897,7 +2898,7 @@ module_init(igbvf_init_module);
 static void __exit igbvf_exit_module(void)
 {
 	pci_unregister_driver(&igbvf_driver);
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, igbvf_driver_name);
+	pm_qos_remove_request(igbvf_driver_pm_qos_req);
 }
 module_exit(igbvf_exit_module);
=20
--=20
1.6.3.3


--PuGuTyElPB9bOcsM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksTG34ACgkQhK5OsmQOmSCqCACfTXBr72lQCFYuUXsl6R5ATiy6
SjQAn1pcM/yPGVZY01NMKUOrRCdyjn5/
=/8e4
-----END PGP SIGNATURE-----

--PuGuTyElPB9bOcsM--
