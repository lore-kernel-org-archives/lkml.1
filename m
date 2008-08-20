Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYHTS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYHTS6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYHTS6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:58:05 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:43599 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYHTS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:58:04 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Kel Modderman <kel@otaku42.de>,
       Markus Armbruster <armbru@redhat.com>
In-Reply-To: <20080820013736.ec64baae.akpm@linux-foundation.org>
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	 <20080818233824.5d219105.akpm@linux-foundation.org>
	 <1219220003.3996.29.camel@localhost.localdomain>
	 <20080820013736.ec64baae.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HxIQ85CZL77e76fq4EKB"
Date: Wed, 20 Aug 2008 19:57:53 +0100
Message-Id: <1219258673.3996.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HxIQ85CZL77e76fq4EKB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[correcting stable@]

On Wed, 2008-08-20 at 01:37 -0700, Andrew Morton wrote:
> On Wed, 20 Aug 2008 09:13:23 +0100 Ian Campbell <ijc@hellion.org.uk> wrot=
e:
>=20
> > Perhaps applying the band-aid at open time instead would be preferred?
>=20
> That would be less racy, I expect.
[...]
> <tries to write a patch>
>=20
> OK, seems that fb_ops.fb_open() has no way of getting at the `struct
> file *' which is being opened (wtf?).  Screwed.  Need to change
> fb_ops.fb_open(), or add a new fb_ops.fb_open_sane().

Ah yes, I remember why I did it in mmap() now...

How about this version? Not as clean as overriding fb_open() but
involves less frobbing with unrelated drivers.

=46rom ae2f7f118518fbfd4006c985b136a5d3d1a314af Mon Sep 17 00:00:00 2001
From: Ian Campbell <ijc@hellion.org.uk>
Date: Wed, 20 Aug 2008 19:54:50 +0100
Subject: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB

Fixes kernel BUG at lib/radix-tree.c:473.

Previously the handler was incidentally provided by tmpfs but this was
removed with:

  commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
  Author: Hugh Dickins <hugh@veritas.com>
  Date:   Mon Jul 28 15:46:19 2008 -0700

    tmpfs: fix kernel BUG in shmem_delete_inode

relying on this behaviour was incorrect in any case and the BUG
also appeared when the device node was on an ext3 filesystem.

v2: override a_ops at open() time rather than mmap() time to minimise
races per AKPM's concerns.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kel Modderman <kel@otaku42.de>
Cc: Markus Armbruster <armbru@redhat.com>
Cc: stable@kernel.org [14fcc23fd is in 2.6.25.14 and 2.6.26.1]
---
 drivers/video/fb_defio.c |   19 +++++++++++++++++++
 drivers/video/fbmem.c    |    4 ++++
 include/linux/fb.h       |    3 +++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index 59df132..4835bdc 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -114,6 +114,17 @@ static struct vm_operations_struct fb_deferred_io_vm_o=
ps =3D {
 	.page_mkwrite	=3D fb_deferred_io_mkwrite,
 };
=20
+static int fb_deferred_io_set_page_dirty(struct page *page)
+{
+	if (!PageDirty(page))
+		SetPageDirty(page);
+	return 0;
+}
+
+static const struct address_space_operations fb_deferred_io_aops =3D {
+	.set_page_dirty =3D fb_deferred_io_set_page_dirty,
+};
+
 static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct=
 *vma)
 {
 	vma->vm_ops =3D &fb_deferred_io_vm_ops;
@@ -163,6 +174,14 @@ void fb_deferred_io_init(struct fb_info *info)
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_init);
=20
+void fb_deferred_io_open(struct fb_info *info,
+			 struct inode *inode,
+			 struct file *file)
+{
+	file->f_mapping->a_ops =3D &fb_deferred_io_aops;
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_open);
+
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	void *screen_base =3D (void __force *) info->screen_base;
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 6b48780..98843c2 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1344,6 +1344,10 @@ fb_open(struct inode *inode, struct file *file)
 		if (res)
 			module_put(info->fbops->owner);
 	}
+#ifdef CONFIG_FB_DEFERRED_IO
+	if (info->fbdefio)
+		fb_deferred_io_open(info, inode, file);
+#endif
 out:
 	unlock_kernel();
 	return res;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 3b8870e..531ccd5 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -976,6 +976,9 @@ static inline void __fb_pad_aligned_buffer(u8 *dst, u32=
 d_pitch,
=20
 /* drivers/video/fb_defio.c */
 extern void fb_deferred_io_init(struct fb_info *info);
+extern void fb_deferred_io_open(struct fb_info *info,
+				struct inode *inode,
+				struct file *file);
 extern void fb_deferred_io_cleanup(struct fb_info *info);
 extern int fb_deferred_io_fsync(struct file *file, struct dentry *dentry,
 				int datasync);
--=20
1.5.6.3




--=20
Ian Campbell

Hope that the day after you die is a nice day.

--=-HxIQ85CZL77e76fq4EKB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkisaTAACgkQM0+0qS9rzVmWEQCgsya+jPMH9kERCHGZczRsJxjS
KO4AoKiSf1ugeh+x55QjKysJicopWEjM
=4l8B
-----END PGP SIGNATURE-----

--=-HxIQ85CZL77e76fq4EKB--

