Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbYFFVRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbYFFVRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbYFFVRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:17:23 -0400
Received: from home.keithp.com ([63.227.221.253]:1627 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbYFFVRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:17:22 -0400
Subject: Re: [intel-agp] Rewrite GTT on resume
From: Keith Packard <keithp@keithp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
       Keith Packard <keith@keithp.com>
In-Reply-To: <20080606135015.3f42820d.akpm@linux-foundation.org>
References: <1212550880.4677.5.camel@koto.keithp.com>
	 <20080606135015.3f42820d.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h4q6X7f+CZpXeyqq7eZt"
Date: Fri, 06 Jun 2008 14:17:07 -0700
Message-Id: <1212787027.8384.31.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h4q6X7f+CZpXeyqq7eZt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-06 at 13:50 -0700, Andrew Morton wrote:

> Please send a signed-off-by:?

See below.

> Is it safe to use this without locking?

I don't know. There is a mutex in the agp frontend exposed to user mode,
but that is not used by the internal kernel interfaces used by drm. This
scares me a bit, but the agp code doesn't appear to have any kind of
internal data structures that might be messed up, so it 'should' be OK.

This version adds a spinlock around all of the mapped_list manipulation.

=46rom 26b58f13ecbe95a7eaca7434aeb885def057b835 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Tue, 3 Jun 2008 20:34:54 -0700
Subject: [PATCH] [INTEL-AGP] Re-write GATT on resume

Keep a list of current GATT mappings. At resume time, rewrite them into the
GATT. This is needed on Intel (at least) as the entire GATT is cleared
across suspend/resume. The list is protected by a spinlock.

Signed-off-by: Keith Packard <keithp@keithp.com>

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index c69f795..5fdbbd7 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -148,6 +148,9 @@ struct agp_bridge_data {
 	char minor_version;
 	struct list_head list;
 	u32 apbase_config;
+	/* list of agp_memory mapped to the aperture */
+	struct list_head mapped_list;
+	spinlock_t mapped_lock;
 };
=20
 #define KB(x)	((x) * 1024)
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index b1bdd01..463f04b 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -183,6 +183,8 @@ static int agp_backend_initialize(struct agp_bridge_dat=
a *bridge)
 		rc =3D -EINVAL;
 		goto err_out;
 	}
+	INIT_LIST_HEAD(&bridge->mapped_list);
+	spin_lock_init(&bridge->mapped_lock);
=20
 	return 0;
=20
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 7fc0c99..4741438 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -426,6 +426,10 @@ int agp_bind_memory(struct agp_memory *curr, off_t pg_=
start)
=20
 	curr->is_bound =3D TRUE;
 	curr->pg_start =3D pg_start;
+	spin_lock(&agp_bridge->mapped_lock);
+	list_add (&curr->mapped_list, &agp_bridge->mapped_list);
+	spin_unlock(&agp_bridge->mapped_lock);
+=09
 	return 0;
 }
 EXPORT_SYMBOL(agp_bind_memory);
@@ -458,10 +462,34 @@ int agp_unbind_memory(struct agp_memory *curr)
=20
 	curr->is_bound =3D FALSE;
 	curr->pg_start =3D 0;
+	spin_lock(&curr->bridge->mapped_lock);
+	list_del (&curr->mapped_list);
+	spin_unlock(&curr->bridge->mapped_lock);
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
+	spin_lock(&agp_bridge->mapped_lock);
+	list_for_each_entry(curr, &agp_bridge->mapped_list, mapped_list) {
+		ret_val =3D curr->bridge->driver->insert_memory(curr,
+							      curr->pg_start,
+							      curr->type);
+		if (ret_val !=3D 0)
+			return ret_val;
+	}
+	spin_unlock(&agp_bridge->mapped_lock);
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

--=-h4q6X7f+CZpXeyqq7eZt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBISalTQp8BWwlsTdMRAqGgAKDL+MSj7Hc22C/mcjrjRer4kBMd/ACglXJJ
gI5BnJOgX2A+QPivLoT+uJw=
=p67Q
-----END PGP SIGNATURE-----

--=-h4q6X7f+CZpXeyqq7eZt--

