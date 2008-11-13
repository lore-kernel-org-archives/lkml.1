Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYKMEuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYKMEuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 23:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYKMEtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 23:49:52 -0500
Received: from ozlabs.org ([203.10.76.45]:58805 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYKMEtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 23:49:52 -0500
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Greg Kroah-Hartman <greg@kroah.com>,
       <viro@zeniv.linux.org.uk>
Message-Id: <b0f1032863818f2834094e2ca9ce4b1c13122748.1226551772.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Store the relevant miscdevice in file->private_data in misc_open()
Date: Thu, 13 Nov 2008 15:49:50 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it's not easy to share file_operations between multiple
instances of a miscdevice. In order to do this, the device code needs to
store a list of all it's miscdevice instances, and when fops->open() is
called, search the list and find the right device based on the minor
number.

However the generic miscdevice code already has a list of miscdevices,
and uses this to find the right device in misc_open(). If misc_open()
would store the miscdevice it found in file->private_data, then the
device code wouldn't need to worry about storing it's own separate list
and searching that as well.

The rest of the miscdevice code does not use file->private_data, so the
device code is still free to use file->private_data for something else
if it wants to.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

---
I'm not all that across VFS or driver core stuff, but this looks safe to
me, lots of other devices use file->private_data and this should be no
different AFAICT.


 drivers/char/misc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index a5e0db9..bb91d68 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -147,11 +147,13 @@ static int misc_open(struct inode * inode, struct file * file)
 	err = 0;
 	old_fops = file->f_op;
 	file->f_op = new_fops;
+	file->private_data = c;
 	if (file->f_op->open) {
 		err=file->f_op->open(inode,file);
 		if (err) {
 			fops_put(file->f_op);
 			file->f_op = fops_get(old_fops);
+			file->private_data = NULL;
 		}
 	}
 	fops_put(old_fops);
-- 
1.5.5

