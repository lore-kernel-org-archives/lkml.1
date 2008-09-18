Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYIRLNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYIRLNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYIRLNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:13:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50200 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbYIRLNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:13:02 -0400
Date: Thu, 18 Sep 2008 13:12:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, mpm@selenic.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Message-ID: <20080918111226.GD29968@elte.hu>
References: <20080910121217.GA16013@elte.hu> <20080910144812.GB18644@wotan.suse.de> <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917131419.e6b7622e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 15 Sep 2008 00:12:31 +0200
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > tiny-shmem calls do_truncate in shmem_file_setup. do_truncate takes i_mutex,
> > and shmem_file_setup is called with mmap_sem held. However i_mutex nests
> > outside mmap_sem.
> > 
> > Copy the code in shmem.c to avoid this problem.
> > 
> 
> It's a bit unfortunate (as in: arse-about) that we end up creating new
> files deep within the mmap code, but I guess we won't be changing that
> in a hurry.
> 
> 
> > ---
> > Index: linux-2.6/mm/tiny-shmem.c
> > ===================================================================
> > --- linux-2.6.orig/mm/tiny-shmem.c
> > +++ linux-2.6/mm/tiny-shmem.c
> > @@ -65,31 +65,25 @@ struct file *shmem_file_setup(char *name
> >  	if (!dentry)
> >  		goto put_memory;
> >  
> > +        error = -ENFILE;
> > +        file = get_empty_filp();
> > +        if (!file)
> > +                goto put_dentry;
> > +
> >  	error = -ENOSPC;
> >  	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
> >  	if (!inode)
> > -		goto put_dentry;
> > -
> > -	d_instantiate(dentry, inode);
> > -	error = -ENFILE;
> > -	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> > -			&ramfs_file_operations);
> > -	if (!file)
> > -		goto put_dentry;
> > -
> > -	inode->i_nlink = 0;	/* It is unlinked */
> > -
> > -	/* notify everyone as to the change of file size */
> > -	error = do_truncate(dentry, size, 0, file);
> > -	if (error < 0)
> >  		goto close_file;
> >  
> > +        d_instantiate(dentry, inode);
> > +        inode->i_size = size;
> > +        inode->i_nlink = 0;     /* It is unlinked */
> > +        init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> > +                        &ramfs_file_operations);
> >  	return file;
> >  
> >  close_file:
> >  	put_filp(file);
> > -	return ERR_PTR(error);
> > -
> >  put_dentry:
> >  	dput(dentry);
> >  put_memory:
> 
> That's a fairly substantial change.  Was it runtime tested?

yes, -tip testing. I queued it up in tip/out-of-tree a week ago:

 commit 20e27c7b26792dbd9af0543c4bc86b5de5653a89
 Author:     Nick Piggin <npiggin@suse.de>
 AuthorDate: Wed Sep 10 17:12:45 2008 +0200
 Commit:     Ingo Molnar <mingo@elte.hu>
 CommitDate: Thu Sep 11 09:13:36 2008 +0200

    mm: fix tiny-shmem circular locking

in 7 days that's about 7000 random bootups, 20% of which had TINY_SHMEM 
enabled, half 32-bit, half 64-bit x86. It did not blow up in any way 
that would have prevented the kernel from building its next random 
version from within itself and it did not produce any kernel messages 
with various random kernel debug, compile and boot options.

So i think it's a candidate for v2.6.27.

	Ingo
