Return-Path: <linux-kernel-owner+w=401wt.eu-S934347AbXGMIiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbXGMIiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbXGMIir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:38:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:15515 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbXGMIiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GuzE3N4WZp6bTjzUD6fHoXr0ex2L1w8jFb+IztEzlryFyUx9mtAj2YbqYkNAy56tK8zsZo+vbL/Q/NWmd40zouTNTkskJo6iuZvlJjW5GqnIKNJsXlN97EIaOb5aTIdhrT2R1EnkyoKbdFDlqCnEQWIh/+gsmnJpkqD7DW54pWA=
Message-ID: <91b13c310707130138p6cffd0b4va34eec320d66ab44@mail.gmail.com>
Date: Fri, 13 Jul 2007 16:38:44 +0800
From: "rae l" <crquan@gmail.com>
To: "Kirill Korotaev" <dev@sw.ru>
Subject: Re: [PATCH] replace kmem_cache_alloc with kmem_cache_zalloc to remove some following zero initializations.
Cc: trivial@kernel.org, Denis <cr_quan@163.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4697357A.10605@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184290905.5475.5.camel@tux.homenetwork> <4697357A.10605@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/07, Kirill Korotaev <dev@sw.ru> wrote:
> This doesn't look worth zeroing half of the struct
> when it is initialized to non-zeros then.
But why?

My reason to think it's better and faster is that:
1. the code will be shorter if it calls zalloc and then removes the
NULL and zero initilization;
2. in the assembly code objdumped, many mov operations reduced, such as:
    movl $0,0x40(%ebp)
    ...
    this style of zero initialization occupies 7 bytes per line
(i386), and then multiply 7 lines,

3. the only change is that calls to kmem_cache_zalloc other than
kmem_cache_alloc, it's just an extra memset is called, as we all know
the memset implimentation is string operation, that's rather fast.

>
> Denis Cheng wrote:
> >>From 4d87e14b67890f06885a76b5792ca034de2e9d06 Mon Sep 17 00:00:00 2001
> > From: Denis Cheng <crquan@gmail.com>
> > Date: Thu, 12 Jul 2007 11:53:58 +0800
> > Subject: [PATCH] replace kmem_cache_alloc with kmem_cache_zalloc to
> > remove some following zero initializations.
> >
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
> > ---
> >  fs/dcache.c |   12 ++----------
> >  1 files changed, 2 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 0e73aa0..8c559b2 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -898,7 +898,7 @@ struct dentry *d_alloc(struct dentry * parent, const
> > struct qstr *name)
> >       struct dentry *dentry;
> >       char *dname;
> >
> > -     dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
> > +     dentry = kmem_cache_zalloc(dentry_cache, GFP_KERNEL);
> >       if (!dentry)
> >               return NULL;
> >
> > @@ -921,15 +921,7 @@ struct dentry *d_alloc(struct dentry * parent,
> > const struct qstr *name)
> >       atomic_set(&dentry->d_count, 1);
> >       dentry->d_flags = DCACHE_UNHASHED;
> >       spin_lock_init(&dentry->d_lock);
> > -     dentry->d_inode = NULL;
> > -     dentry->d_parent = NULL;
> > -     dentry->d_sb = NULL;
> > -     dentry->d_op = NULL;
> > -     dentry->d_fsdata = NULL;
> > -     dentry->d_mounted = 0;
> > -#ifdef CONFIG_PROFILING
> > -     dentry->d_cookie = NULL;
> > -#endif
> > +
> >       INIT_HLIST_NODE(&dentry->d_hash);
> >       INIT_LIST_HEAD(&dentry->d_lru);
> >       INIT_LIST_HEAD(&dentry->d_subdirs);
>
>


-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
