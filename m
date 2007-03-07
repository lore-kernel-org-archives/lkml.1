Return-Path: <linux-kernel-owner+w=401wt.eu-S1161340AbXCGI4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161340AbXCGI4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161344AbXCGI4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:56:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42452 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161335AbXCGI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:56:38 -0500
Date: Wed, 7 Mar 2007 08:56:20 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
Message-ID: <20070307085620.GB5469@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Davide Libenzi <davidel@xmailserver.org>,
	Avi Kivity <avi@argo.co.il>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
References: <45ED1A3C.6030707@argo.co.il> <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org> <45EE6125.3010702@cosmosbay.com> <45EE66BE.8020003@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EE66BE.8020003@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:16:14AM +0100, Eric Dumazet wrote:
> Crazy ideas : (some readers are going to kill me)
> 
> 1) Use the low order bit of f_path.dentry to say : this pointer is not a 
> pointer to a dentry but the inode pointer (with the low order bit set to 1)
> 
> OR
> 
> 2) file->f_path.dentry set to NULL for this special files (so that we dont 
> need to dput() and cache line ping pong the common dentry each time we 
> __fput() a pipe/socket.

No way on either one.  f_path.dentry always beeing there is an assumption
we make all over the place, and changing that would be a big regression
for code qualityand reliability all over the place.

Face it folks, memory is generally cheap, and we're not going to uglify
huge amounts of code to shave of a little bit.

[and that is only in reply to this one, the single dentry optimizations
 for epoll and friends are perfecltly fine from the high level view]

> Same trick could be used for file->f_path.mnt, because there is a big SMP 
> cache line ping/pong to maintain a mnt_count on pipe/sockets mountpoint 
> while these file systems cannot be un-mounted)

Same thing as above.  We might do a hack to not refcount these vfsmounts,
but we definitively want to keep the invariant of f_path.mnt never
beeing NULL.

