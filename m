Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbXEPFBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbXEPFBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759657AbXEPFBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:01:34 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44719 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbXEPFBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:01:33 -0400
Date: Wed, 16 May 2007 10:38:51 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  8/14] Union-mount lookup
Message-ID: <20070516050851.GB4403@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094218.GJ4139@in.ibm.com> <Pine.LNX.4.61.0705150937590.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705150937590.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 09:57:24AM +0200, Jan Engelhardt wrote:
> 
> On May 14 2007 15:12, Bharata B Rao wrote:
> > 
> >+struct dentry * d_lookup_single(struct dentry *parent, struct qstr *name)
> >+{
> >+	struct dentry *dentry;
> >+	unsigned long seq;
> >+
> >+        do {
> >+                seq = read_seqbegin(&rename_lock);
> >+                dentry = __d_lookup_single(parent, name);
> >+                if (dentry)
> >+			break;
> >+	} while (read_seqretry(&rename_lock, seq));
> >+	return dentry;
> >+}
> 
> Replace with tabs.

This is copied from fs/dcache.c:d_lookup() and the whitespaces came from there.
But that is not an excuse, will fix.

> 
> >+lookup_union:
> >+	do {
> >+		struct vfsmount *mnt = find_mnt(topmost);
> >+		UM_DEBUG_DCACHE("name=\"%s\", inode=%p, device=%s\n",
> >+				topmost->d_name.name, topmost->d_inode,
> >+				mnt->mnt_devname);
> >+		mntput(mnt);
> >+	} while (0);
> 
> Why the extra do{}while? [elsewhere too]

Not sure, may be to get a scope to define 'mnt' here. Jan ?

> 
> >+	if (topmost->d_union) {
> >+		union_lock_spinlock(topmost, &topmost->d_lock);
> >+	}
> 
> Extra {} could go [elsewhere too].
> 
> >+		if (last->d_overlaid
> >+		    && (last->d_overlaid != dentry)) {
> 
> As can these extra () [elsewhere too].
>

Sure, will fix all these.
 
> >+static inline struct dentry * __lookup_hash_single(struct qstr *name, struct dentry *base, struct nameidata *nd)
> >+{
> >+	struct dentry *dentry;
> >+	struct inode *inode;
> >+	int err;
> >+
> >+	inode = base->d_inode;
> >+
> >+	err = permission(inode, MAY_EXEC, nd);
> >+	dentry = ERR_PTR(err);
> >+	if (err)
> >+		goto out;
> >+
> >+	dentry = __lookup_hash_kern_single(name, base, nd);
> >+out:
> >+	return dentry;
> >+}
> 
> This looks a little big for being inline.

ok.

Regards,
Bharata.
