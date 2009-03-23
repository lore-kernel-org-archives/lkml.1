Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZCWBoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZCWBoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 21:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbZCWBnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 21:43:42 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48216 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZCWBni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 21:43:38 -0400
Date: Mon, 23 Mar 2009 01:41:27 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Eric Biederman <ebiederm@aristanetworks.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] sysfs: fix some bin_vm_ops errors
In-Reply-To: <aca0ce8b0903221356w487dbbbdie6d5cb9a1862af57@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0903230130200.10796@blonde.anvils>
References: <Pine.LNX.4.64.0903221826520.17976@blonde.anvils>
 <aca0ce8b0903221356w487dbbbdie6d5cb9a1862af57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-471640453-1237772487=:10796"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-471640453-1237772487=:10796
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 22 Mar 2009, Eric Biederman wrote:
> On Sun, Mar 22, 2009 at 11:33 AM, Hugh Dickins <hugh@veritas.com> wrote:
>=20
> > If the file being mmap'ed is a shmem/tmpfs file, don't fail the mmap
> > on CONFIG_NUMA=3Dy, just because that has a set_policy and get_policy.
> > They probably won't be called, and it's not a disaster if they don't
> > work on sysfs. =C2=A0vm_ops->migrate? =C2=A0I couldn't find any example=
=2E =C2=A0Just
> > delete CONFIG_NUMA tests, easy enough to add stubs later if required.
>=20
> I agree about it being easy enough to add stubs later if required.  In my=
 case
> I deliberately added an error check instead so that the code would fail f=
ast
> instead of failing subtlely if anyone ever did that.  And that check appe=
ars
> to have worked in your case so I would like to retain that check.

No, I didn't really hit that case (I didn't even have CONFIG_NUMA=3Dy),
it was just one of the several misguesses I made before hitting on the
right answer.

I can understand you preferring to keep a check on this, but I don't
believe you really want to retain _that_ check: it just causes some
mmaps to fail on CONFIG_NUMA=3Dy configurations, which succeed on
non-NUMA configurations, and work fine on non-NUMA configurations,
so long as you don't try set_policy, get_policy or migrate.

Here's a replacement version of the patch which adds those methods,
and adds a comment on the substituted vm_file as Ben suggests.


[PATCH next] sysfs: fix some bin_vm_ops errors

Commit 86c9508eb1c0ce5aa07b5cf1d36b60c54efc3d7a
"sysfs: don't block indefinitely for unmapped files" in linux-next
crashes the PowerMac G5 when X starts up.  It's caught out by the way
powerpc's pci_mmap of legacy_mem uses shmem_zero_setup(), substituting
a new vma->vm_file whose private_data no longer points to the bin_buffer
(substitution done because some versions of X crash if that mmap fails).

The fix to this is straightforward: the original vm_file is fput() in
that case, so this mmap won't block sysfs at all, so just don't switch
over to bin_vm_ops if vm_file has changed.

But more fixes made before realizing that was the problem:-

It should not be an error if bin_page_mkwrite() finds no underlying
page_mkwrite().

Check that a file already mmap'ed has the same underlying vm_ops
_before_ pointing vma->vm_ops at bin_vm_ops.

If the file being mmap'ed is a shmem/tmpfs file, don't fail the mmap
on CONFIG_NUMA=3Dy, just because that has a set_policy and get_policy:
provide bin_set_policy, bin_get_policy and bin_migrate.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I have only tested that X now starts up fine on the G5: I don't think
I've messed up the intent of your patch, but not tested it still works.

 fs/sysfs/bin.c |   89 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 79 insertions(+), 10 deletions(-)

--- 2.6.29-rc8-next/fs/sysfs/bin.c=092009-03-20 12:41:45.000000000 +0000
+++ linux/fs/sysfs/bin.c=092009-03-23 01:24:48.000000000 +0000
@@ -241,9 +241,12 @@ static int bin_page_mkwrite(struct vm_ar
 =09struct sysfs_dirent *attr_sd =3D file->f_path.dentry->d_fsdata;
 =09int ret;
=20
-=09if (!bb->vm_ops || !bb->vm_ops->page_mkwrite)
+=09if (!bb->vm_ops)
 =09=09return -EINVAL;
=20
+=09if (!bb->vm_ops->page_mkwrite)
+=09=09return 0;
+
 =09if (!sysfs_get_active_two(attr_sd))
 =09=09return -EINVAL;
=20
@@ -273,12 +276,78 @@ static int bin_access(struct vm_area_str
 =09return ret;
 }
=20
+#ifdef CONFIG_NUMA
+static int bin_set_policy(struct vm_area_struct *vma, struct mempolicy *ne=
w)
+{
+=09struct file *file =3D vma->vm_file;
+=09struct bin_buffer *bb =3D file->private_data;
+=09struct sysfs_dirent *attr_sd =3D file->f_path.dentry->d_fsdata;
+=09int ret;
+
+=09if (!bb->vm_ops || !bb->vm_ops->set_policy)
+=09=09return 0;
+
+=09if (!sysfs_get_active_two(attr_sd))
+=09=09return -EINVAL;
+
+=09ret =3D bb->vm_ops->set_policy(vma, new);
+
+=09sysfs_put_active_two(attr_sd);
+=09return ret;
+}
+
+static struct mempolicy *bin_get_policy(struct vm_area_struct *vma,
+=09=09=09=09=09unsigned long addr)
+{
+=09struct file *file =3D vma->vm_file;
+=09struct bin_buffer *bb =3D file->private_data;
+=09struct sysfs_dirent *attr_sd =3D file->f_path.dentry->d_fsdata;
+=09struct mempolicy *pol;
+
+=09if (!bb->vm_ops || !bb->vm_ops->get_policy)
+=09=09return vma->vm_policy;
+
+=09if (!sysfs_get_active_two(attr_sd))
+=09=09return vma->vm_policy;
+
+=09pol =3D bb->vm_ops->get_policy(vma, addr);
+
+=09sysfs_put_active_two(attr_sd);
+=09return pol;
+}
+
+static int bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
+=09=09=09const nodemask_t *to, unsigned long flags)
+{
+=09struct file *file =3D vma->vm_file;
+=09struct bin_buffer *bb =3D file->private_data;
+=09struct sysfs_dirent *attr_sd =3D file->f_path.dentry->d_fsdata;
+=09int ret;
+
+=09if (!bb->vm_ops || !bb->vm_ops->migrate)
+=09=09return 0;
+
+=09if (!sysfs_get_active_two(attr_sd))
+=09=09return 0;
+
+=09ret =3D bb->vm_ops->migrate(vma, from, to, flags);
+
+=09sysfs_put_active_two(attr_sd);
+=09return ret;
+}
+#endif
+
 static struct vm_operations_struct bin_vm_ops =3D {
 =09.open=09=09=3D bin_vma_open,
 =09.close=09=09=3D bin_vma_close,
 =09.fault=09=09=3D bin_fault,
 =09.page_mkwrite=09=3D bin_page_mkwrite,
 =09.access=09=09=3D bin_access,
+#ifdef CONFIG_NUMA
+=09.set_policy=09=3D bin_set_policy,
+=09.get_policy=09=3D bin_get_policy,
+=09.migrate=09=3D bin_migrate,
+#endif
 };
=20
 static int mmap(struct file *file, struct vm_area_struct *vma)
@@ -287,7 +356,6 @@ static int mmap(struct file *file, struc
 =09struct sysfs_dirent *attr_sd =3D file->f_path.dentry->d_fsdata;
 =09struct bin_attribute *attr =3D attr_sd->s_bin_attr.bin_attr;
 =09struct kobject *kobj =3D attr_sd->s_parent->s_dir.kobj;
-=09struct vm_operations_struct *vm_ops;
 =09int rc;
=20
 =09mutex_lock(&bb->mutex);
@@ -302,24 +370,25 @@ static int mmap(struct file *file, struc
 =09=09goto out_put;
=20
 =09rc =3D attr->mmap(kobj, attr, vma);
-=09vm_ops =3D vma->vm_ops;
-=09vma->vm_ops =3D &bin_vm_ops;
 =09if (rc)
 =09=09goto out_put;
=20
-=09rc =3D -EINVAL;
-=09if (bb->mmapped && bb->vm_ops !=3D vma->vm_ops)
+=09/*
+=09 * PowerPC's pci_mmap of legacy_mem uses shmem_zero_setup()
+=09 * to satisfy versions of X which crash if the mmap fails: that
+=09 * substitutes a new vm_file, and we don't then want bin_vm_ops.
+=09 */
+=09if (vma->vm_file !=3D file)
 =09=09goto out_put;
=20
-#ifdef CONFIG_NUMA
 =09rc =3D -EINVAL;
-=09if (vm_ops && ((vm_ops->set_policy || vm_ops->get_policy || vm_ops->mig=
rate)))
+=09if (bb->mmapped && bb->vm_ops !=3D vma->vm_ops)
 =09=09goto out_put;
-#endif
=20
 =09rc =3D 0;
 =09bb->mmapped =3D 1;
-=09bb->vm_ops =3D vm_ops;
+=09bb->vm_ops =3D vma->vm_ops;
+=09vma->vm_ops =3D &bin_vm_ops;
 out_put:
 =09sysfs_put_active_two(attr_sd);
 out_unlock:
--8323584-471640453-1237772487=:10796--
