Return-Path: <linux-kernel-owner+w=401wt.eu-S965425AbZLHCn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbZLHCn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 21:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965409AbZLHCnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 21:43:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34162 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965390AbZLHCnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 21:43:25 -0500
Date: Tue, 8 Dec 2009 02:43:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: liqin.chen@sunplusct.com
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 13/19] Unify sys_mmap*
Message-ID: <20091208024330.GL14381@ZenIV.linux.org.uk>
References: <E1NHUfg-0007xZ-R1@ZenIV.linux.org.uk> <OFB4F0BC92.C5E0A391-ON48257686.000CDDCF-48257686.000E5459@sunplusct.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFB4F0BC92.C5E0A391-ON48257686.000CDDCF-48257686.000E5459@sunplusct.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 10:36:29AM +0800, liqin.chen@sunplusct.com wrote:
> > --- a/arch/score/kernel/sys_score.c
> > +++ b/arch/score/kernel/sys_score.c
> > @@ -36,33 +36,18 @@ asmlinkage long
> >  sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
> >       unsigned long flags, unsigned long fd, unsigned long pgoff)
> >  {
> > -   int error = -EBADF;
> > -   struct file *file = NULL;
> > -
> >     if (pgoff & (~PAGE_MASK >> 12))
> >        return -EINVAL;
> > 
> > -   flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
> > -   if (!(flags & MAP_ANONYMOUS)) {
> > -      file = fget(fd);
> > -      if (!file)
> > -         return error;
> > -   }
> > -
> > -   down_write(&current->mm->mmap_sem);
> > -   error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
> > -   up_write(&current->mm->mmap_sem);
> > -
> > -   if (file)
> > -      fput(file);
> > -
> > -   return error;
> > +   return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
> > +   /* sic - almost certainly should shift pgoff as well */
> >  }
> > 
> >  asmlinkage long
> >  sys_mmap(unsigned long addr, unsigned long len, unsigned long prot,
> >     unsigned long flags, unsigned long fd, off_t pgoff)
> >  {
> > +   /* where's the alignment check? */
> >     return sys_mmap2(addr, len, prot, flags, fd, pgoff >> PAGE_SHIFT);
> >  }
> > 
> 
> It's ok for your update, even 
>      if (pgoff & (~PAGE_MASK >> 12))
>         return -EINVAL;
> code haven't use anymore, you could remove it.

The sys_mmap2() simply disappears - it's exactly the same as sys_mmap_pgoff().
Good.

> In addition, the sys_mmap should like this.
> 
> asmlinkage long
> sys_mmap(unsigned long addr, unsigned long len, unsigned long prot,
>     unsigned long flags, unsigned long fd, off_t pgoff)
> {
>         unsigned long result;
> 
>         result = -EINVAL;
>         if (pgoff & ~PAGE_MASK)
>                 goto out;
> 
>         result = sys_mmap2(addr, len, prot, flags, fd, pgoff >> 
> PAGE_SHIFT);
> out:
>         return result;
> } 

s/sys_mmap2/sys_mmap_pgoff/ and for pity sake, s/\<pgoff\>/offset/ ;-)

> Thanks
>                 liqin

OK, will fold sys_mmap2 replacement with sys_mmap_pgoff into that patch,
adding a missing chech on top of it - I'd rather keep that one an
equivalent transformation.
