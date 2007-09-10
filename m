Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbXIJWNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbXIJWNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760869AbXIJWNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:13:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:60297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbXIJWN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:13:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:to:subject:cc:message-id:date:from;
	b=mNkyUotLp5Ku1zttnj8g3z73IwEP4qiE0s4rRakcYp4phn0qAJCvadYzEabzJ8dS6
	T4lKHGe3Qq6ALKYanmleQ==
To: viro@zeniv.linux.org.uk
Subject: [PATCH] Add a refcount check in dput()
Cc: linux-kernel@vger.kernel.org
Message-Id: <20070910221319.302473D66CF@localhost>
Date: Mon, 10 Sep 2007 15:13:19 -0700 (PDT)
From: menage@google.com (Paul Menage)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a BUG_ON() to check for passing an unreferenced dentry to dput().

This is analogous to the similar check in dget(), and will make
reference-counting bugs in filesystems more immediately obvious. (I
just spent a while debugging an oops that turned out to be due to
broken fs reference counting.)

Signed-off-by: Paul Menage <menage@google.com>

---
 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

Index: container-2.6.23-rc3-mm1/fs/dcache.c
===================================================================
--- container-2.6.23-rc3-mm1.orig/fs/dcache.c
+++ container-2.6.23-rc3-mm1/fs/dcache.c
@@ -176,6 +176,7 @@ void dput(struct dentry *dentry)
 	if (!dentry)
 		return;
 
+	BUG_ON(!atomic_read(&dentry->d_count));
 repeat:
 	if (atomic_read(&dentry->d_count) == 1)
 		might_sleep();
