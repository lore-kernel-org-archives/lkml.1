Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXBLGqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXBLGqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933048AbXBLGqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:46:00 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53648 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933045AbXBLGp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:45:59 -0500
X-Sasl-enc: crj9XA/onexJFJmLVtHVe9l2bSt/iPYAtLNyWgdU7AaL 1171262756
Subject: Re: [PATCH 2/2] Re: [autofs] Bad race condition in the new autofs
	protocol somewhere
From: Ian Kent <raven@themaw.net>
To: Olivier Galibert <galibert@pobox.com>
Cc: "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
In-Reply-To: <1171262594.18376.13.camel@raven.themaw.net>
References: <20070207173414.GA64492@dspnet.fr.eu.org>
	 <1170871661.3415.36.camel@raven.themaw.net>
	 <20070207181817.GA75717@dspnet.fr.eu.org>
	 <1170901990.3383.18.camel@raven.themaw.net>
	 <1171262594.18376.13.camel@raven.themaw.net>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 15:46:40 +0900
Message-Id: <1171262800.18376.16.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 15:43 +0900, Ian Kent wrote:
> On Thu, 2007-02-08 at 11:33 +0900, Ian Kent wrote:
> > On Wed, 2007-02-07 at 19:18 +0100, Olivier Galibert wrote:
> > > On Thu, Feb 08, 2007 at 03:07:41AM +0900, Ian Kent wrote:
> > > > It may be better to update to a later kernel so I don't have to port the
> > > > patch to several different kernels. Is that possible?
> > > 
> > > Sure, 2.6.20 or -git?
> > 
> > 2.6.20 has all the patches I've proposed so far except for the one we're
> > working on so that would be best for me.
> > 
> > Seems there may still be a problem with the patch so I'll let you know
> > what's happening as soon as I can.
> 
> I think I'm just about done.
> 
> Could you try using the two patches here against 2.6.20 please:
> 
> Ian

---

--- linux-2.6.20/fs/autofs4/root.c.lookup-check-unhased	2007-02-12 13:49:46.000000000 +0900
+++ linux-2.6.20/fs/autofs4/root.c	2007-02-12 13:54:58.000000000 +0900
@@ -655,14 +655,29 @@ static struct dentry *autofs4_lookup(str
 
 	/*
 	 * If this dentry is unhashed, then we shouldn't honour this
-	 * lookup even if the dentry is positive.  Returning ENOENT here
-	 * doesn't do the right thing for all system calls, but it should
-	 * be OK for the operations we permit from an autofs.
+	 * lookup.  Returning ENOENT here doesn't do the right thing
+	 * for all system calls, but it should be OK for the operations
+	 * we permit from an autofs.
 	 */
 	if (dentry->d_inode && d_unhashed(dentry)) {
+		/*
+		 * A user space application can (and has done in the past)
+		 * remove and re-create this directory during the callback.
+		 * This can leave us with an unhashed dentry, but a
+		 * successful mount!  So we need to perform another
+		 * cached lookup in case the dentry now exists.
+		 */
+		struct dentry *parent = dentry->d_parent;
+		struct dentry *new = d_lookup(parent, &dentry->d_name);
+		if (new != NULL)
+			dentry = new;
+		else
+			dentry = ERR_PTR(-ENOENT);
+
 		if (unhashed)
 			dput(unhashed);
-		return ERR_PTR(-ENOENT);
+
+		return dentry;
 	}
 
 	if (unhashed)


