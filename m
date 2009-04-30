Return-Path: <linux-kernel-owner+w=401wt.eu-S933060AbZD3Rb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060AbZD3Rb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764670AbZD3RIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:15 -0400
Received: from kroah.org ([198.145.64.141]:56683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764611AbZD3RIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:46 2009
Message-Id: <20090430165746.385280871@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Christian Borntraeger <borntraeger@de.ibm.com>, mtosatti@redhat.com,
       avi@redhat.com
Subject: [patch 54/88] anon_inodes: use fops->owner for module refcount
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=anon_inodes-use-fops-owner-for-module-refcount.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

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
Signed-off-by: Avi Kivity <avi@redhat.com>
(cherry picked from commit e3a2a0d4e5ace731e60e2eff4fb7056ecb34adc1)
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/anon_inodes.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
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


