Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbZDPRCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbZDPRCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZDPRB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:01:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZDPRB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:01:58 -0400
Date: Thu, 16 Apr 2009 13:01:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090416170150.GA526@infradead.org>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416143626.GA17683@infradead.org> <20090416164927.GB19281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416164927.GB19281@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 06:49:27PM +0200, Ingo Molnar wrote:
> They dont really protect anything - the patch is wrong and 
> equivalent to a plain removal of the BKL.
> 
> The only case we found to ever matter in practice is NFS: it really 
> wants to get rid of the BKL in nfsd_get_sb(). So pushing down the 
> BKL lock into per filesystems and then removing it from NFS should 
> do the trick.
> 
> Would be nice to have some tentative Ack (or, a tentative 
> non-immediate-NAK) from Al before we go touch a lot of filesystems 
> though. Stupid dont-waste-human-effort considerations and stuff.
> 
> For us, the much simpler solution would be to drop the BKL in 
> nfsd_get_sb() and go on with life without to touch a dozen or so 
> filesystems. Alessio, mind trying that too, is it a solution for 
> your testcase?

What about trying to attack it piece-mail?  ->unmount_begin is really
easy.  The only one that doesn't protect everything properly is
9p, but it doesn't protect the state variable deep down a few levels
of function calls at all.

->remount_fs should be easy enough to, we do have proper per-sb
protection here, but do_remount_sb will need a bit of an audit.
(and of course pushing lock_kernel down into the many instances and
leave the cleanup-work to the fs maintainers).

The actual mount path is more interesting as there are quite a few cases
there.  As a first step you can take lock_kernel from outside do_mount
into the various do_foo calls inside it, and then work on those piece
by piece.
