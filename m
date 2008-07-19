Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYGSDwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYGSDwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 23:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYGSDwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 23:52:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51573 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYGSDwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 23:52:39 -0400
Date: Sat, 19 Jul 2008 04:52:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: linux-next: Tree for July 17: early crash on x86-64
Message-ID: <20080719035231.GU28946@ZenIV.linux.org.uk>
References: <20080718012842.690b8346.sfr@canb.auug.org.au> <200807180106.08328.rjw@sisk.pl> <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 05:52:23PM +0400, Alexander Beregalov wrote:
> 2008/7/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > This one crashes all of my x86-64 test boxes early during boot.
> The same problem with next-20080718.
> Unfortunatelly I do not have serial console on that host.

vfs-next/net-next conflict; apply the patch below on top of the merge.

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
