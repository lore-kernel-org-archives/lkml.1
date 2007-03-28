Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbXC1PcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbXC1PcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbXC1PcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:32:17 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49249 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXC1PcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:32:16 -0400
Date: Wed, 28 Mar 2007 11:28:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Blaisorblade <blaisorblade@yahoo.it>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/4] UML - Replace one-element array with zero-element array
Message-ID: <20070328152848.GA6345@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
  
To look at users I did:
$ find arch/um/ include/asm-um -name '*.[ch]'|xargs grep -r 'net_kern\.h'
+-l|xargs grep '\<user\>'

Most users just cast user to the appropriate pointer, the remaining ones are
fixed here. In net_kern.c, I'm almost sure that save trick is not needed
anymore, but I've not verified it.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/net_kern.c |   14 +++-----------
 arch/um/include/net_kern.h |    2 +-
 2 files changed, 4 insertions(+), 12 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/net_kern.c	2007-03-21 13:43:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/net_kern.c	2007-03-21 13:43:48.000000000 -0400
@@ -347,10 +347,9 @@ static void eth_configure(int n, void *i
 	struct uml_net *device;
 	struct net_device *dev;
 	struct uml_net_private *lp;
-	int save, err, size;
+	int err, size;
 
-	size = transport->private_size + sizeof(struct uml_net_private) +
-		sizeof(((struct uml_net_private *) 0)->user);
+	size = transport->private_size + sizeof(struct uml_net_private);
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (device == NULL) {
@@ -409,12 +408,6 @@ static void eth_configure(int n, void *i
 	 */
 	(*transport->kern->init)(dev, init);
 
-	/* lp.user is the first four bytes of the transport data, which
-	 * has already been initialized.  This structure assignment will
-	 * overwrite that, so we make sure that .user gets overwritten with
-	 * what it already has.
-	 */
-	save = lp->user[0];
 	*lp = ((struct uml_net_private)
 		{ .list  		= LIST_HEAD_INIT(lp->list),
 		  .dev 			= dev,
@@ -428,8 +421,7 @@ static void eth_configure(int n, void *i
 		  .write 		= transport->kern->write,
 		  .add_address 		= transport->user->add_address,
 		  .delete_address  	= transport->user->delete_address,
-		  .set_mtu 		= transport->user->set_mtu,
-		  .user  		= { save } });
+		  .set_mtu 		= transport->user->set_mtu });
 
 	init_timer(&lp->tl);
 	spin_lock_init(&lp->lock);
Index: linux-2.6.21-mm/arch/um/include/net_kern.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/net_kern.h	2007-03-20 15:41:35.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/net_kern.h	2007-03-21 13:43:48.000000000 -0400
@@ -40,7 +40,7 @@ struct uml_net_private {
 	void (*add_address)(unsigned char *, unsigned char *, void *);
 	void (*delete_address)(unsigned char *, unsigned char *, void *);
 	int (*set_mtu)(int mtu, void *);
-	int user[1];
+	char user[0];
 };
 
 struct net_kern_info {
