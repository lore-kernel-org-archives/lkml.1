Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbZHDObq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbZHDObq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZHDObq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:31:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbZHDObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:31:45 -0400
Date: Tue, 4 Aug 2009 10:31:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, hch@lst.de,
       linux-kernel@vger.kernel.org, mszeredi@novell.com
Subject: Re: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
	device
Message-ID: <20090804143142.GA6712@infradead.org>
References: <1249329808.7686.26.camel@logos> <20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249351241.7513.18.camel@logos>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 11:00:41PM -0300, Ramon de Carvalho Valle wrote:
> On Mon, 2009-08-03 at 17:49 -0400, Christoph Hellwig wrote:
> > On Mon, Aug 03, 2009 at 05:03:28PM -0300, Ramon de Carvalho Valle wrote:
> > > The __xfs_get_blocks function does not check if the pointer to the target
> > > device is valid before dereferencing it.
> > 
> > It should never be zero.  It's set by xfs_imap_to_bmap to either
> > mp->m_ddev_targp which is always allocated, or to mp->m_rtdev_targp
> > which is always allocated if we have a realtime device, and
> > XFS_IS_REALTIME_INODE should only be true in that case.
> > 
> 
> While testing XFS code with a modified version of fsfuzzer on SLES 10
> SP3 (Kernel 2.6.16.60-0.49.3.ramon-ppc64), I came across the following
> Oops:

So you actually introduced the RT flag in the inode on a filesystem
where it can't happen software-wise.

I'd rather deal with this early on to protect the invariant that's
guaranteed inside the xfs code.

Something like the following untested patch:

Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2009-08-04 16:19:40.778532419 +0200
+++ linux-2.6/fs/xfs/xfs_inode.c	2009-08-04 16:28:06.352533058 +0200
@@ -343,6 +343,16 @@ xfs_iformat(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
+	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
+		     !ip->i_mount->m_rtdev_targp)) {
+		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
+			"corrupt dinode %Lu, has realtime flag set.",
+			ip->i_ino);
+		XFS_CORRUPTION_ERROR("xfs_iformat(realtime)",
+				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
 	switch (ip->i_d.di_mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
