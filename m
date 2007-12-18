Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXLROET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXLROET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbXLROEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:04:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52604 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbXLROEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:04:06 -0500
Date: Tue, 18 Dec 2007 15:04:03 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: xfs@oss.sgi.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Do not reset xfsquota flags on quotaless ro mount
Message-ID: <Pine.LNX.4.64.0712181459210.32270@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


In https://bugzilla.novell.com/show_bug.cgi?id=345338 it is claimed that
resetting the quota flags in the mounting sequence rw,ro,rw is a bug, but I
would say this is not the case, as quota is metadata, and the log is replayed
in ro mode even for other filesystems. Yet, it is still not nice, and I have
been trying with this patch, which does not do the right thing yet. (It does a
recovery when mounting for the 3rd time, which probably just says that I did
not know too much of xfs internals to cook up a nicely working patch.)
Opinions?

===

In the following action sequence, quota is unnecessarily recalculated
at the 3rd mount invocation:

	mount -o usrquota,grpquota /dev/mapper/myxfs /mnt
	umount /mnt
	mount -o ro /dev/mapper/myxfs /mnt
	umount /mnt
	mount -o usrquota,grpquota /dev/mapper/myxfs /mnt

This patch skips clearing the quota flags on read-only mounts.

---
 fs/xfs/xfs_qmops.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/xfs/xfs_qmops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_qmops.c
+++ linux-2.6/fs/xfs/xfs_qmops.c
@@ -134,7 +134,14 @@ static struct xfs_qmops xfs_qmcore_stub 
 int
 xfs_qmops_get(struct xfs_mount *mp, struct xfs_mount_args *args)
 {
-	if (args->flags & (XFSMNT_UQUOTA | XFSMNT_PQUOTA | XFSMNT_GQUOTA)) {
+	bool c;
+
+	c = args->flags & (XFSMNT_UQUOTA | XFSMNT_GQUOTA | XFSMNT_PQUOTA);
+#ifdef CONFIG_XFS_QUOTA
+	c |= mp->m_flags & XFS_MOUNT_RDONLY;
+#endif
+
+	if (c) {
 #ifdef CONFIG_XFS_QUOTA
 		mp->m_qm_ops = &xfs_qmcore_xfs;
 #else
