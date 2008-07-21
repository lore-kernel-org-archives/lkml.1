Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYGUNUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYGUNUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYGUNU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:20:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50323 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYGUNU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:20:29 -0400
Date: Mon, 21 Jul 2008 14:20:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tej Parkash <bewith.tej@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PANIC with linux-next-2.6.26-next-20080718
Message-ID: <20080721132027.GD28946@ZenIV.linux.org.uk>
References: <f1c9d250807210348w58aa132che5543cb30a33ee60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1c9d250807210348w58aa132che5543cb30a33ee60@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 04:18:35PM +0530, Tej Parkash wrote:
> while testing linux-next with commit
> "commit 43a2c1df777e18dfb0ba48d03b4f8b8ff80f1b57"
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Fri Jul 18 19:27:47 2008 +1000
> 
> machine hang with the following panic. config/cpuinfo/lspci are attached.
> trying git-bisect.

Apply the patch below or try the current linux-next where vfs-next is
rebased on top of net-next with that sucker folded in.

diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index b91a5de..2240a9e 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -44,13 +44,6 @@ static struct ctl_table_root net_sysctl_root = {
 	.lookup = net_ctl_header_lookup,
 };
 
-static LIST_HEAD(net_sysctl_ro_tables);
-static struct list_head *net_ctl_ro_header_lookup(struct ctl_table_root *root,
-		struct nsproxy *namespaces)
-{
-	return &net_sysctl_ro_tables;
-}
-
 static int net_ctl_ro_header_perms(struct ctl_table_root *root,
 		struct nsproxy *namespaces, struct ctl_table *table)
 {
@@ -61,7 +54,6 @@ static int net_ctl_ro_header_perms(struct ctl_table_root *root,
 }
 
 static struct ctl_table_root net_sysctl_ro_root = {
-	.lookup = net_ctl_ro_header_lookup,
 	.permissions = net_ctl_ro_header_perms,
 };
 
@@ -89,6 +81,7 @@ static __init int sysctl_init(void)
 	if (ret)
 		goto out;
 	register_sysctl_root(&net_sysctl_root);
+	setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL, NULL);
 	register_sysctl_root(&net_sysctl_ro_root);
 out:
 	return ret;

