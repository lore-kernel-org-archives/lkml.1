Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYJPRQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYJPRQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYJPROD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:03 -0400
Received: from kroah.org ([198.145.64.141]:46914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756046AbYJPROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/46] modules: fix module "notes" kobject leak
Date: Thu, 16 Oct 2008 10:10:02 -0700
Message-Id: <1224177047-11859-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

Fix "notes" kobject leak

It happens every rmmod if KALLSYMS=y and SYSFS=y.

	# modprobe foo

kobject: 'foo' (ffffffffa00743d0): kobject_add_internal: parent: 'module', set: 'module'
kobject: 'holders' (ffff88017e7c5770): kobject_add_internal: parent: 'foo', set: '<NULL>'
kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
kobject: 'notes' (ffff88017fa9b668): kobject_add_internal: parent: 'foo', set: '<NULL>'
	  ^^^^^

	# rmmod foo

kobject: 'holders' (ffff88017e7c5770): kobject_cleanup
kobject: 'holders' (ffff88017e7c5770): auto cleanup kobject_del
kobject: 'holders' (ffff88017e7c5770): calling ktype release
kobject: (ffff88017e7c5770): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'foo' (ffffffffa00743d0): kobject_cleanup
kobject: 'foo' (ffffffffa00743d0): does not have a release() function, it is broken and must be fixed.
kobject: 'foo' (ffffffffa00743d0): auto cleanup 'remove' event
kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
kobject: 'foo' (ffffffffa00743d0): auto cleanup kobject_del
kobject: 'foo': free name

	[whooops]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 9db1191..d5fcd24 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1173,7 +1173,7 @@ static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
 		while (i-- > 0)
 			sysfs_remove_bin_file(notes_attrs->dir,
 					      &notes_attrs->attrs[i]);
-		kobject_del(notes_attrs->dir);
+		kobject_put(notes_attrs->dir);
 	}
 	kfree(notes_attrs);
 }
-- 
1.6.0.2

