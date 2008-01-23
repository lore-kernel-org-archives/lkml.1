Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYAWTmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYAWTmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYAWTl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:41:57 -0500
Received: from styx.suse.cz ([82.119.242.94]:42938 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751615AbYAWTl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:41:57 -0500
Date: Wed, 23 Jan 2008 20:41:55 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH RESEND] Handle i_size > s_maxbytes correctly
Message-ID: <20080123194155.GI10144@duck.suse.cz>
References: <20080123175440.GF10144@duck.suse.cz> <20080123191306.GA17118@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123191306.GA17118@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-01-08 19:13:06, Christoph Hellwig wrote:
> On Wed, Jan 23, 2008 at 06:54:41PM +0100, Jan Kara wrote:
> >   A different solution (even with smaller impact) would be to not allow
> > files with i_size > s_maxbytes in VFS at all. For local filesystems we can
> > just check this on open and everything is fine
> 
> Which we should do.
  I'm fine with that ;).

> > but with remote filesystems
> > such as OCFS2 (or NFS) filesize can be changed on the fly from a different
> > machine. So to avoid problems we can either introduce some locking to
> > prevent changes of i_size from other machines while we are in critical
> > sections (awww, I really don't think this is better) or truncate i_size to
> > s_maxbytes when we update i_size from what we've received via network /
> > shared storage (but then we'd have to track whether user truncated file to
> > some size or whether fs truncated it just for safety and apps could be
> > confused too). So I don't think this is really feasible.
> 
> The right fix for cluster filesystem is to have a coherent maximum file
> size for the whole cluster.  If that can't be done due to protocol
> reason we need to lock around i_size update and revoke access to the
> inode on the client that doesn't support it.  Which of course would
> require a working revoke to start with..
  But with which lock you'd like to lock-around i_size update? Note that
you have to make sure you won't race even with read path which currently
doesn't take any locks at all (except for page lock) if I'm right... So,
e.g. NFS, would have to wrap generic_file_aio_read() in some lock to
prevent inode updates while generic_file_aio_read() runs. That doesn't
sound too appealing to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
