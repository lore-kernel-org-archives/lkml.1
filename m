Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYLBKRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYLBKRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYLBKRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:17:22 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:43201 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYLBKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:17:21 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@redhat.com>
Subject: [PATCH 1/2] anon_inodes: use fops->owner for module refcount
Date: Tue, 2 Dec 2008 11:16:03 +0100
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Davide Libenzi <davidel@xmailserver.org>
References: <200812021114.59050.borntraeger@de.ibm.com>
In-Reply-To: <200812021114.59050.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021116.03143.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is an imbalance for anonymous inodes. If the fops->owner field is set,
the module reference count of owner is decreases on release. 
("filp_close" --> "__fput" ---> "fops_put")

On the other hand, anon_inode_getfd does not increase the module reference 
count of owner. This causes two problems:

- if owner is set, the module refcount goes negative
- if owner is not set, the module can be unloaded while code is running 

This patch changes anon_inode_getfd to be symmetric regarding fops->owner 
handling.

I have checked all existing users of anon_inode_getfd. Noone sets fops->owner, 
thats why nobody has seen the module refcount negative. The refcounting was 
tested with a patched and unpatched KVM module.(see patch 2/2) I also did an
epoll_open/close test.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Davide Libenzi <davidel@xmailserver.org>
---
 fs/anon_inodes.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: kvm/fs/anon_inodes.c
===================================================================
--- kvm.orig/fs/anon_inodes.c
+++ kvm/fs/anon_inodes.c
@@ -79,9 +79,12 @@ int anon_inode_getfd(const char *name, c
 	if (IS_ERR(anon_inode_inode))
 		return -ENODEV;
 
+	if (fops->owner && !try_module_get(fops->owner))
+		return -ENOENT;
+
 	error = get_unused_fd_flags(flags);
 	if (error < 0)
-		return error;
+		goto err_module;
 	fd = error;
 
 	/*
@@ -128,6 +131,8 @@ err_dput:
 	dput(dentry);
 err_put_unused_fd:
 	put_unused_fd(fd);
+err_module:
+	module_put(fops->owner);
 	return error;
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
