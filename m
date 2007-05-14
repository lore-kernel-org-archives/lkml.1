Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbXENU7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbXENU7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXENU70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:59:26 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60921 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbXENU7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:59:25 -0400
Date: Mon, 14 May 2007 22:57:52 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  6/14] Union-mount dentry reference counting
In-Reply-To: <20070514094114.GH4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705142252510.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094114.GH4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:11, Bharata B Rao wrote:
>+void __union_check(struct dentry *dentry)
>+{
>+	if (likely(!(dentry->d_topmost || dentry->d_overlaid))) {

This could be simplified to

   if (likely(!dentry->d_topmost && !dentry->d_overlaid))

(I prefer x==NULL over !x for pointers, though)
And then again, do not assume everything is (un)likely [also elsewhere].

>+		if (unlikely(dentry->d_union)) {
>+			printk(KERN_ERR "%s: \"%s\" stale union reference\n" \
>+			       "\tdentry=%p, inode=%p, count=%d, u_count=%d\n",
>+			       __FUNCTION__,
>+			       dentry->d_name.name,
>+			       dentry,
>+			       dentry->d_inode,
>+			       atomic_read(&dentry->d_count),
>+			       atomic_read(&dentry->d_union->u_count));
>+			dump_stack();
>+		}
>+		return;
>+	}
>+
>--- a/net/unix/af_unix.c
>+++ b/net/unix/af_unix.c
>@@ -1082,8 +1082,11 @@ restart:
> 		newu->addr = otheru->addr;
> 	}
> 	if (otheru->dentry) {
>-		newu->dentry	= dget(otheru->dentry);
>+		/* Is this safe here? I don't know ... */

Figure it out :)


	Jan
-- 
