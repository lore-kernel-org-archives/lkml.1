Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbXEaKya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbXEaKya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbXEaKyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:54:23 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9344 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691AbXEaKyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:54:23 -0400
Date: Thu, 31 May 2007 12:53:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070531105321.GQ32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531124753.a99f713c.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, Eric Dumazet wrote:
> On Thu, 31 May 2007 12:33:16 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Hi,
> > 
> > This patch removes the ->sendfile() hook from the file_operations
> > structure, and replaces the sys_sendfile() mechanism to be based on
> > ->splice_read() instead. There should be no functional changes.
> > 
>   
> > -	retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
> > +	fl = 0;
> > +	if (in_file->f_flags & O_NONBLOCK)
> > +		fl = SPLICE_F_NONBLOCK;
> > +
> > +	retval = do_splice_direct(in_file, ppos, out_file, count, fl);
> 
> I like this, but are you sure it wont break user land ?
> 
> Some applications might react badly if sendfile() returns EAGAIN ?

Yeah, I didn't actually intend for that to sneak in. I'd think that
userspace should handle it if they opened the file O_NONBLOCK (or used
fcntl()), but it's a change in behaviour none the less and probably not
a good idea.

Encourage those people to use splice() instead :-)

-- 
Jens Axboe

