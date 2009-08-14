Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZHNIdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZHNIdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 04:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbZHNIdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 04:33:49 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:34988 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZHNIds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 04:33:48 -0400
X-SourceIP: 213.93.53.227
Subject: Re: Does perf_counter need to make mmap pages uptodate?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <19076.64899.915246.955189@drongo.ozlabs.ibm.com>
References: <19076.64899.915246.955189@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 10:33:19 +0200
Message-Id: <1250238799.5241.1167.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 16:00 +1000, Paul Mackerras wrote:
> At a colleague's request, I did a backport of the perf_counter code to
> 2.6.30.3.  When I tried "perf record ls" I hit the WARN_ON_ONCE in
> __set_page_dirty (fs/buffer.c line 669):
> 
>                 WARN_ON_ONCE(warn && !PageUptodate(page));
> 
> and indeed we never mark the pages that we let userspace mmap as being
> uptodate.  To get around the problem I added
> 
> 	SetPageUptodate(vmf->page);
> 
> after the get_page call in perf_mmap_fault, but I can't see any
> relevant changes between 2.6.30 and current upstream that would cause
> this to be necessary for 2.6.30 but not for current upstream.
> 
> Should we in fact be marking the pages uptodate, or is there some
> reason why we should never get to that WARN_ON_ONCE?

commit d3a9262e59f7fb83c6d44df3b2b1460ed57d3ea1
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Jun 18 12:54:00 2009 +0200

    fs: Provide empty .set_page_dirty() aop for anon inodes
    
    .set_page_dirty() is one of those a_ops that defaults to the
    buffer implementation when not set. Therefore provide a dummy
    function to make it do nothing.
    
    (Uncovered by perfcounters fd's which can now be writable-mmap-ed.)
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Davide Libenzi <davidel@xmailserver.org>
    LKML-Reference: <new-submission>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 1dd96d4..47d4a01 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -52,6 +52,19 @@ static const struct dentry_operations anon_inodefs_dentry_operations = {
 	.d_delete	= anon_inodefs_delete_dentry,
 };
 
+/*
+ * nop .set_page_dirty method so that people can use .page_mkwrite on
+ * anon inodes.
+ */
+static int anon_set_page_dirty(struct page *page)
+{
+	return 0;
+};
+
+static const struct address_space_operations anon_aops = {
+	.set_page_dirty = anon_set_page_dirty,
+};
+
 /**
  * anon_inode_getfd - creates a new file instance by hooking it up to an
  *                    anonymous inode, and a dentry that describe the "class"
@@ -151,6 +164,8 @@ static struct inode *anon_inode_mkinode(void)
 
 	inode->i_fop = &anon_inode_fops;
 
+	inode->i_mapping->a_ops = &anon_aops;
+
 	/*
 	 * Mark the inode dirty from the very beginning,
 	 * that way it will never be moved to the dirty


