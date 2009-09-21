Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZIUOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZIUOng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbZIUOnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:43:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41420 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbZIUOnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:43:35 -0400
Date: Mon, 21 Sep 2009 15:43:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de,
       hugh.dickins@tiscali.co.uk, matthew@wil.cx
Subject: Re: [PATCH 2/2] vfs: fix d_path() for unreachable paths
Message-ID: <20090921144336.GF14381@ZenIV.linux.org.uk>
References: <E1MpiJo-0005fv-2y@pomaz-ex.szeredi.hu> <E1MpiMo-0005h9-DG@pomaz-ex.szeredi.hu> <20090921140220.GD14381@ZenIV.linux.org.uk> <8bd0f97a0909210710h5bb75bcdwb666b51a9155a70a@mail.gmail.com> <20090921143857.GE14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921143857.GE14381@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 03:38:57PM +0100, Al Viro wrote:
> On Mon, Sep 21, 2009 at 10:10:17AM -0400, Mike Frysinger wrote:
> 
> > it works without having to copy & paste the same exact structures over
> > and over.  a suggestion as how to do it cleanly without bloating the
> > code is certainly welcome.  it doesnt really matter that it's on the
> > stack as the usage is small and d_path() is given the size of the
> > buffer, so it isnt going to overflow.
> 
> Umm...  Surely, you can put a CPU number + one bit into PDE->data?  As in
> 	proc_create_data("icplb", ....., (void *)(cpu * 2))
> 	proc_create_data("dcplb", ....., (void *)(cpu * 2 + 1))
> and
> 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
> 	unsigned long n = (unsigned long) pde->data;
> 	...
> 	cpu = n / 2;
> 	is_D = n & 1;

PS: as to why it is broken...  Consider e.g.
	mount --bind /proc/cplbinfo/cpu0 /mnt
	cat /mnt/icplb
Or, better yet,
	mount -t proc none /mnt/cpu
	cat /mnt/cpu/cplbinfo/cpu0/icplb
