Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbXE2Twm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbXE2Twm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXE2Twf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:52:35 -0400
Received: from mail.fieldses.org ([66.93.2.214]:46618 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbXE2Twe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:52:34 -0400
Date: Tue, 29 May 2007 15:52:27 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
       nfs@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NFS] [PATCH] NFSD: fix uninitialized variable
Message-ID: <20070529195227.GG6815@fieldses.org>
References: <20070527103442.GA10594@havoc.gtf.org> <20070529030050.GB20631@fieldses.org> <465B9BB9.7060300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465B9BB9.7060300@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 11:19:21PM -0400, Jeff Garzik wrote:
> J. Bruce Fields wrote:
> >But I don't want anyone else wasting their time on this.  Should we cave
> >in and add the initialization here just to shut up gcc?  Or would a
> >comment here help?
> 
> Given what you said above, I don't see gcc, on its best day, will ever 
> know enough to validate that that variable is indeed always initialized. 

I recall there being arguments before about when to add initializations.
Unfortunately I can't remember the content of those arguments.  But I
thought that on the gcc-haters side the complaint was exactly that gcc
was emitting warnings in cases where it could never hope to determine
whether an initialization is required.  Am I misremembering?

>  So I would vote for silencing it on those grounds.

That said, I'm OK with the extra initialization.  Might be worth a
comment, though, just to avoid giving the wrong impression about the
assumptions here; something like:

--b.

diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index cc3b7ba..4adb5ee 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -183,8 +183,13 @@ static void
 summarize_posix_acl(struct posix_acl *acl, struct posix_acl_summary *pas)
 {
 	struct posix_acl_entry *pa, *pe;
-	pas->users = 0;
-	pas->groups = 0;
+
+	/*
+	 * Only pas.users and pas.groups need initialization; previous
+	 * posix_acl_valid() calls ensure that the other fields will be
+	 * initialized in the following loop.  But, just to placate gcc:
+	 */
+	memset(pas, 0, sizeof(*pas));
 	pas->mask = 07;
 
 	pe = acl->a_entries + acl->a_count;
