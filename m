Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbZJUTVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbZJUTVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZJUTVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:21:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbZJUTVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:41 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 38/41] union-mount: Make pivot_root work with union mounts
Date: Wed, 21 Oct 2009 12:19:36 -0700
Message-Id: <1256152779-10054-39-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-38-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
 <1256152779-10054-28-git-send-email-vaurora@redhat.com>
 <1256152779-10054-29-git-send-email-vaurora@redhat.com>
 <1256152779-10054-30-git-send-email-vaurora@redhat.com>
 <1256152779-10054-31-git-send-email-vaurora@redhat.com>
 <1256152779-10054-32-git-send-email-vaurora@redhat.com>
 <1256152779-10054-33-git-send-email-vaurora@redhat.com>
 <1256152779-10054-34-git-send-email-vaurora@redhat.com>
 <1256152779-10054-35-git-send-email-vaurora@redhat.com>
 <1256152779-10054-36-git-send-email-vaurora@redhat.com>
 <1256152779-10054-37-git-send-email-vaurora@redhat.com>
 <1256152779-10054-38-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When moving a union mount, follow it down to the bottom layer and move
that instead of just the top layer.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9b71743..6ac5fc1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2282,6 +2282,15 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	if (d_unlinked(old.dentry))
 		goto out2;
 	error = -EBUSY;
+	/*
+	 * follow_union_down() only goes one layer down.  We want the
+	 * bottom-most layer here - if we move that around, all the
+	 * layers on top move with it.  But if we ever allow more than
+	 * two layers, the below two will both need to be in while()
+	 * loops.
+	 */
+	follow_union_down(&new.mnt, &new.dentry);
+	follow_union_down(&root.mnt, &root.dentry);
 	if (new.mnt == root.mnt ||
 	    old.mnt == root.mnt)
 		goto out2; /* loop, on the same file system  */
-- 
1.6.3.3

