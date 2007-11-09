Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbXKICww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbXKICww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 21:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbXKICwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 21:52:42 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55086 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXKICwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 21:52:41 -0500
Date: Thu, 8 Nov 2007 21:47:02 -0500
Message-Id: <200711090247.lA92l2Ct014971@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-reply-to: Your message of "Mon, 05 Nov 2007 08:38:50 PST."
             <1194280730.6271.145.camel@localhost> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1194280730.6271.145.camel@localhost>, Dave Hansen writes:
> On Mon, 2007-11-05 at 15:40 +0000, Hugh Dickins wrote:
[...]
> I have a decent guess what the bug is, too.  In the unionfs code:
> 
> > int init_lower_nd(struct nameidata *nd, unsigned int flags)
> > {
> > ...
> > #ifdef ALLOC_LOWER_ND_FILE
> >                 file = kzalloc(sizeof(struct file), GFP_KERNEL);
> >                 if (unlikely(!file)) {
> >                         err = -ENOMEM;
> >                         break; /* exit switch statement and thus return */
> >                 }
> >                 nd->intent.open.file = file;
> > #endif /* ALLOC_LOWER_ND_FILE */
> 
> The r/o bind mount code will mnt_drop_write() on that file's f_vfsmnt at
> __fput() time.  Since that code never got a write on the mount, we'll
> see an imbalance if the file was opened for a write.  I don't see this
> file's mnt set anywhere, so I'm not completely sure that this is it.  In
> any case, rolling your own 'struct file' without using alloc_file() and
> friends is a no-no.
[...]

This #ifdef'd code in unionfs is actually not enabled.  I left it there as a
reminder of possible future things to come (esp. if nameidata gets split).
There's a related comment earlier in fs/unionfs/lookup.c:init_lower_nd()
that says:

#ifdef ALLOC_LOWER_ND_FILE
	/*
	 * XXX: one day we may need to have the lower return an open file
	 * for us.  It is not needed in 2.6.23-rc1 for nfs2/nfs3, but may
	 * very well be needed for nfs4.
	 */
	struct file *file;
#endif /* ALLOC_LOWER_ND_FILE */

In the interest of keeping unionfs as simple as I can, when I implemented
the whole "pass a lower nd" stuff, I left thos bits of semi-experimental
#ifdef code for this lower file upon open-intent.  It's not enabled and up
until now, it didn't seem to be needed.

Do you think unionfs has to start using this nd->intent.open.file stuff?

Thanks,
Erez.
