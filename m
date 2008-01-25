Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbYAYXkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbYAYXkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYAYXkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:40:37 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:48439 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYAYXkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:40:36 -0500
Date: Fri, 25 Jan 2008 15:39:51 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] Handle i_size > s_maxbytes correctly
Message-ID: <20080125233951.GZ23506@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20080123175440.GF10144@duck.suse.cz> <20080123191306.GA17118@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123191306.GA17118@infradead.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reply comes a bit late, sorry about that.

On Wed, Jan 23, 2008 at 07:13:06PM +0000, Christoph Hellwig wrote:
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
> size for the whole cluster. If that can't be done

Yeah, as you noted, there's problems with that approach. The first is that
we don't control when a 32 bit node mounts the file system. Communicating it
over the network wouldn't help because information communicated over the
network is transient and will be lost when all nodes unmount, whereas
maximun i_size for a volume is the type of thing which needs to be
permanent. Putting a "max i_size" field in the superblock is one way to
ensure that we never get into this situation but that would leave existing
file systems without a fix.


> we need to lock around i_size update and revoke access to the inode on the
> client that doesn't support it. Which of course would require a working
> revoke to start with..

If we had a way to disable access to an inodes data, Ocfs2 could mark the
inode when it takes a cluster lock and discovers that i_size grew past what
the local node can handle.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
