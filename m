Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZHSQdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZHSQdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZHSQdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:33:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZHSQdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:33:14 -0400
Date: Wed, 19 Aug 2009 12:33:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com
Subject: Re: [PATCH 14/17] xfs: Use new syncing helper
Message-ID: <20090819163315.GA19969@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-15-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250697884-22288-15-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:04:41PM +0200, Jan Kara wrote:
> diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
> index 7078974..aeb5a39 100644
> --- a/fs/xfs/linux-2.6/xfs_lrw.c
> +++ b/fs/xfs/linux-2.6/xfs_lrw.c
> @@ -817,7 +817,7 @@ write_retry:
>  		xfs_iunlock(xip, iolock);
>  		if (need_i_mutex)
>  			mutex_unlock(&inode->i_mutex);
> -		error2 = sync_page_range(inode, mapping, pos, ret);
> +		error2 = generic_write_sync(file, pos, ret);

I don't think this is very optimal for XFS.  This first starts an
asynchronous writeout of the range in generic_write_sync,
then calls into ->fsync which waits for all I/O on the file to finish,
then forces the log inside xfs_fsync,  then waits for the range again in
generic_write_sync, and after this code calls into
xfs_write_sync_logforce which forces to log _again_.

We should be fine just doing your new filemap_fdatawrite_range helper
here and let xfs_write_sync_logforce do the work.  Long term we should
just get rid of this stupid submit writes before syncing the iode, then
wait crap which is a pain for all modern filesystems.
