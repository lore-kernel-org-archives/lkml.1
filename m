Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYFDDlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYFDDlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYFDDlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:41:31 -0400
Received: from home.keithp.com ([63.227.221.253]:2179 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbYFDDla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:41:30 -0400
Subject: [intel-agp] Rewrite GTT on resume
From: Keith Packard <keithp@keithp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>
Cc: keithp@keithp.com
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0FnBM33fErMYuTEz09KN"
Date: Tue, 03 Jun 2008 20:41:20 -0700
Message-Id: <1212550880.4677.5.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0FnBM33fErMYuTEz09KN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On my Intel chipset (965GM), the GTT is entirely erased across
suspend/resume. This patch simply re-plays the current mapping at resume
time to restore the table.=20

I noticed this once I started relying on persistent GTT mappings across
VT switch in our GEM work -- the old X server and DRM code carefully
unbind all memory from the GTT on VT switch, but GEM does not bother.

I placed the list management and rewrite code in the generic layer on
the assumption that it will be needed on other hardware, but I did not
add the rewrite call to anything other than the Intel resume function.


commit 1233057731935fb5e9fd115d3d2985802ab636c8
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Jun 3 20:34:54 2008 -0700

    [INTEL-AGP] Re-write GATT on resume
   =20
    Keep a list of current GATT mappings. At resume time, rewrite them into=
 the
    GATT. This is needed on Intel (at least) as the entire GATT is cleared
    across suspend/resume.

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index c69f795..253f56f 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -148,6 +148,8 @@ struct agp_bridge_data {
 	char minor_version;
 	struct list_head list;
 	u32 apbase_config;
+	/* list of agp_memory mapped to the aperture */
+	struct list_head mapped_list;
 };
=20
 #define KB(x)	((x) * 1024)
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index b1bdd01..a5f0ce2 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -183,6 +183,7 @@ static int agp_backend_initialize(struct agp_bridge_dat=
a *bridge)
 		rc =3D -EINVAL;
 		goto err_out;
 	}
+	INIT_LIST_HEAD(&bridge->mapped_list);
=20
 	return 0;
=20
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 7fc0c99..cf99078 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -426,6 +426,8 @@ int agp_bind_memory(struct agp_memory *curr, off_t pg_s=
tart)
=20
 	curr->is_bound =3D TRUE;
 	curr->pg_start =3D pg_start;
+	list_add (&curr->mapped_list, &agp_bridge->mapped_list);
+=09
 	return 0;
 }
 EXPORT_SYMBOL(agp_bind_memory);
@@ -458,10 +460,30 @@ int agp_unbind_memory(struct agp_memory *curr)
=20
 	curr->is_bound =3D FALSE;
 	curr->pg_start =3D 0;
+	list_del (&curr->mapped_list);
 	return 0;
 }
 EXPORT_SYMBOL(agp_unbind_memory);
=20
+/**
+ *	agp_rebind_emmory  -  Rewrite the entire GATT, useful on resume
+ */
+int agp_rebind_memory (void)
+{
+	struct agp_memory *curr;
+	int ret_val;
+=09
+	list_for_each_entry(curr, &agp_bridge->mapped_list, mapped_list) {
+		ret_val =3D curr->bridge->driver->insert_memory(curr,
+							      curr->pg_start,
+							      curr->type);
+		if (ret_val !=3D 0)
+			return ret_val;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(agp_rebind_memory);
+
 /* End - Routines for handling swapping of agp_memory into the GATT */
=20
=20
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index eeea50a..7f1a96e 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -2176,6 +2176,7 @@ static void __devexit agp_intel_remove(struct pci_dev=
 *pdev)
 static int agp_intel_resume(struct pci_dev *pdev)
 {
 	struct agp_bridge_data *bridge =3D pci_get_drvdata(pdev);
+	int ret_val;
=20
 	pci_restore_state(pdev);
=20
@@ -2203,6 +2204,10 @@ static int agp_intel_resume(struct pci_dev *pdev)
 	else if (bridge->driver =3D=3D &intel_i965_driver)
 		intel_i915_configure();
=20
+	ret_val =3D agp_rebind_memory();
+	if (ret_val !=3D 0)
+		return ret_val;
+
 	return 0;
 }
 #endif
diff --git a/include/linux/agp_backend.h b/include/linux/agp_backend.h
index 03e3454..2fbfe4d 100644
--- a/include/linux/agp_backend.h
+++ b/include/linux/agp_backend.h
@@ -32,6 +32,8 @@
=20
 #ifdef __KERNEL__
=20
+#include <linux/list.h>
+
 #ifndef TRUE
 #define TRUE 1
 #endif
@@ -88,6 +90,8 @@ struct agp_memory {
 	u8 is_bound;
 	u8 is_flushed;
         u8 vmalloc_flag;
+	/* list of agp_memory mapped to the aperture */
+	struct list_head mapped_list;
 };
=20
 #define AGP_NORMAL_MEMORY 0
@@ -106,6 +110,7 @@ extern struct agp_memory *agp_allocate_memory(struct ag=
p_bridge_data *, size_t,
 extern int agp_copy_info(struct agp_bridge_data *, struct agp_kern_info *)=
;
 extern int agp_bind_memory(struct agp_memory *, off_t);
 extern int agp_unbind_memory(struct agp_memory *);
+extern int agp_rebind_memory (void);
 extern void agp_enable(struct agp_bridge_data *, u32);
 extern struct agp_bridge_data *agp_backend_acquire(struct pci_dev *);
 extern void agp_backend_release(struct agp_bridge_data *);

--=20
keith.packard@intel.com

--=-0FnBM33fErMYuTEz09KN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIRg7gQp8BWwlsTdMRAgqdAKCgp94mzXnBLPcg8wtVjCWhQ5qvfgCfTAs6
7HJK13K8L3OLanApCuQT4VM=
=FAs/
-----END PGP SIGNATURE-----

--=-0FnBM33fErMYuTEz09KN--

