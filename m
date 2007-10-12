Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbXJLWQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbXJLWQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbXJLWQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:16:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbXJLWQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:16:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [2.6.24 PATCH 02/25] dm io:ctl use constant struct size
Date: Sat, 13 Oct 2007 00:16:29 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
       Guido Guenther <agx@sigxcpu.org>, Kevin Corry <kevcorry@us.ibm.com>,
       stable@kernel.org
References: <20071012170509.GM24157@agk.fab.redhat.com>
In-Reply-To: <20071012170509.GM24157@agk.fab.redhat.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710130016.29937.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+keEXFnrH3xr1o3hWD+zvmYgqYciOMPVgH3M0
 4qgaXtsAd3STbYsloVG5L7t7E6a7Y5+PMNPyw1Unz7oUxu5CIk
 MH093BuogJ9CfD1WM+gaw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007, Alasdair G Kergon wrote:
> Make size of dm_ioctl struct always 312 bytes on all supported
> architectures.
> 
> This change retains compatibility with already-compiled code because
> it uses an embedded offset to locate the payload that follows the
> structure.
> 
> On 64-bit architectures there is no change at all; on 32-bit
> we are increasing the size of dm-ioctl from 308 to 312 bytes.
> 
> Currently with 32-bit userspace / 64-bit kernel on x86_64
> some ioctls (including rename, message) are incorrectly rejected
> by the comparison against 'param + 1'.  This breaks userspace
> lvrename and multipath 'fail_if_no_path' changes, for example.
> 
> (BTW Device-mapper uses its own versioning and ignores the ioctl
> size bits.  Only the generic ioctl compat code on mixed arches
> checks them, and that will continue to accept both sizes for now,
> but we intend to list 308 as deprecated and eventually remove it.)
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> Cc: Guido Guenther <agx@sigxcpu.org>
> Cc: Kevin Corry <kevcorry@us.ibm.com>
> Cc: stable@kernel.org
> 

This change seems rather bogus, you're changing the ABI just to work
around a bug in the compat_ioctl layer. Why not just do the compat
code the right way, like the patch below?

	Arnd <><

---
dm: move compat_ioctl handling to dm-ioctl.c

Device mapper ioctl numbers use a variable size field

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b441d82..a662279 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -700,7 +700,7 @@ static int dev_rename(struct dm_ioctl *param, size_t param_size)
 	int r;
 	char *new_name = (char *) param + param->data_start;
 
-	if (new_name < (char *) (param + 1) ||
+	if (new_name < (char *)param + param->data_size ||
 	    invalid_str(new_name, (void *) param + param_size)) {
 		DMWARN("Invalid new logical volume name supplied.");
 		return -EINVAL;
@@ -726,7 +726,7 @@ static int dev_set_geometry(struct dm_ioctl *param, size_t param_size)
 	if (!md)
 		return -ENXIO;
 
-	if (geostr < (char *) (param + 1) ||
+	if (geostr < (char *)param + param->data_size ||
 	    invalid_str(geostr, (void *) param + param_size)) {
 		DMWARN("Invalid geometry supplied.");
 		goto out;
@@ -1233,7 +1233,7 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
 	if (r)
 		goto out;
 
-	if (tmsg < (struct dm_target_msg *) (param + 1) ||
+	if (tmsg < (struct dm_target_msg *) ((char *)param + param->data_size) ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMWARN("Invalid target message parameters.");
 		r = -EINVAL;
@@ -1348,11 +1348,11 @@ static void free_params(struct dm_ioctl *param)
 	vfree(param);
 }
 
-static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
+static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param, uint ulen)
 {
 	struct dm_ioctl tmp, *dmi;
 
-	if (copy_from_user(&tmp, user, sizeof(tmp)))
+	if (copy_from_user(&tmp, user, ulen))
 		return -EFAULT;
 
 	if (tmp.data_size < sizeof(tmp))
@@ -1399,13 +1399,11 @@ static int validate_params(uint cmd, struct dm_ioctl *param)
 	return 0;
 }
 
-static int ctl_ioctl(struct inode *inode, struct file *file,
-		     uint command, ulong u)
+static int ctl_ioctl(uint command, struct dm_ioctl __user *user, uint ulen)
 {
 	int r = 0;
 	unsigned int cmd;
 	struct dm_ioctl *param;
-	struct dm_ioctl __user *user = (struct dm_ioctl __user *) u;
 	ioctl_fn fn = NULL;
 	size_t param_size;
 
@@ -1447,7 +1445,7 @@ static int ctl_ioctl(struct inode *inode, struct file *file,
 	/*
 	 * Copy the parameters into kernel space.
 	 */
-	r = copy_params(user, &param);
+	r = copy_params(user, &param, ulen);
 
 	current->flags &= ~PF_MEMALLOC;
 
@@ -1459,7 +1457,7 @@ static int ctl_ioctl(struct inode *inode, struct file *file,
 		goto out;
 
 	param_size = param->data_size;
-	param->data_size = sizeof(*param);
+	param->data_size = ulen;
 	r = fn(param, param_size);
 
 	/*
@@ -1473,8 +1471,64 @@ static int ctl_ioctl(struct inode *inode, struct file *file,
 	return r;
 }
 
+static int ctl_ioctl(struct inode *inode, struct file *file,
+		     uint command, ulong u)
+{
+	return ctl_do_ioctl(command, (void __user *)u, sizeof (struct dm_ioctl));
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_dm_ioctl {
+	/*
+	 * The version number is made up of three parts:
+	 * major - no backward or forward compatibility,
+	 * minor - only backwards compatible,
+	 * patch - both backwards and forwards compatible.
+	 *
+	 * All clients of the ioctl interface should fill in the
+	 * version number of the interface that they were
+	 * compiled with.
+	 *
+	 * All recognised ioctl commands (ie. those that don't
+	 * return -ENOTTY) fill out this field, even if the
+	 * command failed.
+	 */
+	uint32_t version[3];	/* in/out */
+	uint32_t data_size;	/* total size of data passed in
+				 * including this struct */
+
+	uint32_t data_start;	/* offset to start of data
+				 * relative to start of this struct */
+
+	uint32_t target_count;	/* in/out */
+	int32_t open_count;	/* out */
+	uint32_t flags;		/* in/out */
+	uint32_t event_nr;	/* in/out */
+	uint32_t padding;
+
+	compat_u64 dev;		/* in/out */
+
+	char name[DM_NAME_LEN];	/* device name */
+	char uuid[DM_UUID_LEN];	/* unique identifier for
+				 * the block device */
+};
+
+static int compat_ctl_ioctl(struct inode *inode, struct file *file,
+		     uint command, ulong u)
+{
+	int ret = 0;
+	lock_kernel();
+	ret = ctl_do_ioctl(command, compat_ptr(u), sizeof(struct compat_dm_ioctl));
+	unlock_kernel();
+	return ret;
+}
+#else
+#define compat_ctl_ioctl NULL
+#endif
+
 static const struct file_operations _ctl_fops = {
 	.ioctl	 = ctl_ioctl,
+	.compat_ioctl = compat_ctl_ioctl,
 	.owner	 = THIS_MODULE,
 };
 
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -76,7 +76,6 @@
 #include <linux/mii.h>
 #include <linux/if_bonding.h>
 #include <linux/watchdog.h>
-#include <linux/dm-ioctl.h>
 
 #include <linux/soundcard.h>
 #include <linux/lp.h>
@@ -1986,39 +1985,6 @@ COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
 COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 ULONG_IOCTL(SET_BITMAP_FILE)
-/* DM */
-COMPATIBLE_IOCTL(DM_VERSION_32)
-COMPATIBLE_IOCTL(DM_REMOVE_ALL_32)
-COMPATIBLE_IOCTL(DM_LIST_DEVICES_32)
-COMPATIBLE_IOCTL(DM_DEV_CREATE_32)
-COMPATIBLE_IOCTL(DM_DEV_REMOVE_32)
-COMPATIBLE_IOCTL(DM_DEV_RENAME_32)
-COMPATIBLE_IOCTL(DM_DEV_SUSPEND_32)
-COMPATIBLE_IOCTL(DM_DEV_STATUS_32)
-COMPATIBLE_IOCTL(DM_DEV_WAIT_32)
-COMPATIBLE_IOCTL(DM_TABLE_LOAD_32)
-COMPATIBLE_IOCTL(DM_TABLE_CLEAR_32)
-COMPATIBLE_IOCTL(DM_TABLE_DEPS_32)
-COMPATIBLE_IOCTL(DM_TABLE_STATUS_32)
-COMPATIBLE_IOCTL(DM_LIST_VERSIONS_32)
-COMPATIBLE_IOCTL(DM_TARGET_MSG_32)
-COMPATIBLE_IOCTL(DM_DEV_SET_GEOMETRY_32)
-COMPATIBLE_IOCTL(DM_VERSION)
-COMPATIBLE_IOCTL(DM_REMOVE_ALL)
-COMPATIBLE_IOCTL(DM_LIST_DEVICES)
-COMPATIBLE_IOCTL(DM_DEV_CREATE)
-COMPATIBLE_IOCTL(DM_DEV_REMOVE)
-COMPATIBLE_IOCTL(DM_DEV_RENAME)
-COMPATIBLE_IOCTL(DM_DEV_SUSPEND)
-COMPATIBLE_IOCTL(DM_DEV_STATUS)
-COMPATIBLE_IOCTL(DM_DEV_WAIT)
-COMPATIBLE_IOCTL(DM_TABLE_LOAD)
-COMPATIBLE_IOCTL(DM_TABLE_CLEAR)
-COMPATIBLE_IOCTL(DM_TABLE_DEPS)
-COMPATIBLE_IOCTL(DM_TABLE_STATUS)
-COMPATIBLE_IOCTL(DM_LIST_VERSIONS)
-COMPATIBLE_IOCTL(DM_TARGET_MSG)
-COMPATIBLE_IOCTL(DM_DEV_SET_GEOMETRY)
 /* Big K */
 COMPATIBLE_IOCTL(PIO_FONT)
 COMPATIBLE_IOCTL(GIO_FONT)
