Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZECX0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZECX0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZECX0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:26:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:29006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZECX0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DQTw1lcGftWXtQKT4ncXeWmHyuBx5QH0en93A9WD+xK/H5QzzbQRWUHlqa2O45YMlH
         OZD7rmaVlWvLa3BANr/lr/fXD046KURmpU4O6lEneV0f9ALgX6Lw2ON59fhSZenzIiZD
         sEyJtYjQ/NlmUe53jO/C6v4Uu2ptCSWbevfNQ=
Date: Mon, 4 May 2009 03:27:00 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       xemul@parallels.com
Subject: [PATCH 1/2] pidns 1/2: make create_pid_namespace() accept parent
	pidns
Message-ID: <20090503232700.GD16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_pid_namespace() creates everything, but caller has to assign parent
pidns by hand, which is unnatural. At the moment of call new ->level has
to be taken from somewhere and parent pidns is already available.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 kernel/pid_namespace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 2d1001b..495d5de 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -67,9 +67,10 @@ err_alloc:
 	return NULL;
 }
 
-static struct pid_namespace *create_pid_namespace(unsigned int level)
+static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
+	unsigned int level = parent_pid_ns->level + 1;
 	int i;
 
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
@@ -86,6 +87,7 @@ static struct pid_namespace *create_pid_namespace(unsigned int level)
 
 	kref_init(&ns->kref);
 	ns->level = level;
+	ns->parent = get_pid_ns(parent_pid_ns);
 
 	set_bit(0, ns->pidmap[0].page);
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
@@ -125,9 +127,7 @@ struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old
 	if (flags & CLONE_THREAD)
 		goto out_put;
 
-	new_ns = create_pid_namespace(old_ns->level + 1);
-	if (!IS_ERR(new_ns))
-		new_ns->parent = get_pid_ns(old_ns);
+	new_ns = create_pid_namespace(old_ns);
 
 out_put:
 	put_pid_ns(old_ns);
