Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZLGAXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZLGAXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbZLGAXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:23:38 -0500
Received: from kroah.org ([198.145.64.141]:34598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758550AbZLGANf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:35 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:54 2009
Message-Id: <20091207000654.584900701@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [079/119] sparc: Move of_set_property_mutex acquisition outside of devtree_lock grab.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sparc-move-of_set_property_mutex-acquisition-outside-of-devtree_lock-grab.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 1c9d80ddc60f8ac26344ec3db9830e5f8016c16d ]

Otherwise we try to sleep with preemption disabled, etc.

Noticed by Thomas Gleixner.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/prom_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -76,6 +76,7 @@ int of_set_property(struct device_node *
 
 	err = -ENODEV;
 
+	mutex_lock(&of_set_property_mutex);
 	write_lock(&devtree_lock);
 	prevp = &dp->properties;
 	while (*prevp) {
@@ -85,9 +86,7 @@ int of_set_property(struct device_node *
 			void *old_val = prop->value;
 			int ret;
 
-			mutex_lock(&of_set_property_mutex);
 			ret = prom_setprop(dp->node, name, val, len);
-			mutex_unlock(&of_set_property_mutex);
 
 			err = -EINVAL;
 			if (ret >= 0) {
@@ -106,6 +105,7 @@ int of_set_property(struct device_node *
 		prevp = &(*prevp)->next;
 	}
 	write_unlock(&devtree_lock);
+	mutex_unlock(&of_set_property_mutex);
 
 	/* XXX Upate procfs if necessary... */
 


