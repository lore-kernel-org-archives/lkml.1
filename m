Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYICPE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYICPE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbYICPER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:04:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:33430 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753941AbYICPEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:04:16 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+k0DtV6wuk0AndvycMng4DRbeWDLhsNeIsipbkX1
	URQCOH8re/4vLX
Date: Wed, 3 Sep 2008 17:03:43 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Message-ID: <20080903150343.GA23515@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org
Bcc: 
Subject: Re: [Patch] Check hfs_bnode_find return value
Reply-To: 
In-Reply-To: <Pine.LNX.4.64.0808290405480.2507@localhost.localdomain>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc4 (x86_64)
X-Uptime: 16:56:46 up  6:37,  1 user,  load average: 1.90, 0.90, 0.60

* Roman Zippel (zippel@linux-m68k.org) wrote:
> Hi,
> 
> On Tue, 26 Aug 2008, Eric Sesterhenn wrote:
> 
> > --- linux/fs/hfsplus/brec.c.orig	2008-08-26 19:18:56.000000000 +0200
> > +++ linux/fs/hfsplus/brec.c	2008-08-26 19:19:27.000000000 +0200
> > @@ -304,6 +304,8 @@ static struct hfs_bnode *hfs_bnode_split
> >  	/* update next bnode header */
> >  	if (new_node->next) {
> >  		struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
> > +		if (IS_ERR(next_node))
> > +			return next_node;
> >  		next_node->prev = new_node->this;
> >  		hfs_bnode_read(next_node, &node_desc, 0, sizeof(node_desc));
> >  		node_desc.prev = cpu_to_be32(next_node->prev);
> 
> Al Viro already fixed this for HFS in a better way, could you please adopt 
> his solution?

This is the patch from hfs applied to hfsplus (see
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3d10a15d6919488204bdb264050d156ced20d9aa
). Guess Al should sign this off since it is his work?


--- linux/fs/hfsplus/brec.c.orig	2008-09-03 17:00:07.000000000 +0200
+++ linux/fs/hfsplus/brec.c	2008-09-03 17:00:43.000000000 +0200
@@ -216,7 +216,7 @@ skip:
 static struct hfs_bnode *hfs_bnode_split(struct hfs_find_data *fd)
 {
 	struct hfs_btree *tree;
-	struct hfs_bnode *node, *new_node;
+	struct hfs_bnode *node, *new_node, *next_node;
 	struct hfs_bnode_desc node_desc;
 	int num_recs, new_rec_off, new_off, old_rec_off;
 	int data_start, data_end, size;
@@ -235,6 +235,17 @@ static struct hfs_bnode *hfs_bnode_split
 	new_node->type = node->type;
 	new_node->height = node->height;
 
+	if (node->next)
+		next_node = hfs_bnode_find(tree, node->next);
+	else
+		next_node = NULL;
+
+	if (IS_ERR(next_node)) {
+		hfs_bnode_put(node);
+		hfs_bnode_put(new_node);
+		return next_node;
+	}
+
 	size = tree->node_size / 2 - node->num_recs * 2 - 14;
 	old_rec_off = tree->node_size - 4;
 	num_recs = 1;
@@ -248,6 +259,8 @@ static struct hfs_bnode *hfs_bnode_split
 		/* panic? */
 		hfs_bnode_put(node);
 		hfs_bnode_put(new_node);
+		if (next_node)
+			hfs_bnode_put(next_node);
 		return ERR_PTR(-ENOSPC);
 	}
 
@@ -302,8 +315,7 @@ static struct hfs_bnode *hfs_bnode_split
 	hfs_bnode_write(node, &node_desc, 0, sizeof(node_desc));
 
 	/* update next bnode header */
-	if (new_node->next) {
-		struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
+	if (next_node) {
 		next_node->prev = new_node->this;
 		hfs_bnode_read(next_node, &node_desc, 0, sizeof(node_desc));
 		node_desc.prev = cpu_to_be32(next_node->prev);
