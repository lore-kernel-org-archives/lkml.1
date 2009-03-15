Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZCOShl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZCOShl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZCOSha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:37:30 -0400
Received: from netgear.net.ru ([195.178.208.66]:48288 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbZCOSh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:37:29 -0400
Date: Sun, 15 Mar 2009 21:37:25 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8] exofs: dir_inode and directory operations
Message-ID: <20090315183725.GA18123@ioremap.net>
References: <49902A9E.3070002@panasas.com> <1234185853-7873-1-git-send-email-bharrosh@panasas.com> <20090215170840.GA18115@ioremap.net> <4999328B.8000705@panasas.com> <49BD449C.8090301@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BD449C.8090301@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 08:10:36PM +0200, Boaz Harrosh (bharrosh@panasas.com) wrote:
> >>> +	atomic_inc(&inode->i_count);
> >>> +
> >>> +	ret = exofs_async_op(or, create_done, inode, oi->i_cred);
> >>> +	if (ret) {
> >>> +		atomic_dec(&inode->i_count);
> >> igrab()/iput()?
> >>
> > 
> > Thanks, makes much more sense. Sorry leftovers from 2.6.10
> > 
> 
> It's the same at ext2. I looked at the igrab()/iput() code it does some extra
> locks which I'm afraid of at this stage. I'll postpone this to the next (next)
> merge window, after I ran with it for a while.

It does not allow to work with to be freed inode, getting that it is
fresh inode, things should be ok just to increase the reference counter,
but iput() may highlight problems if inode's reference counter can be
decreased, and apparently it can not since otherwise increment would not
be added around exofs_async_op().

What if exofs_async_op() drops a reference and returns error? inode will
not be freed and will not be placed into to be freed list, which in turn
will break accounting and potentially prevent superblock freeing.

-- 
	Evgeniy Polyakov
