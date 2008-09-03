Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYICOQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYICOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYICOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:16:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:4055 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYICOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QvJlsC82pcXSVYvuyEKYsV5RxmIDbT9+SHmxS/8CQM9oEHgC+Wgb1oCyK/f+sysXen
         IJ+PBOc5y6IdNqN+uNAG8+lV/4PfpStB8dPFoCSxeCKuzsaB/o0Tr4I+UU5ITx4fAMwl
         Itt0/oQu387Eb9TJ60eoTY02X+D+7T6x0EnH8=
Date: Wed, 3 Sep 2008 18:17:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix return value of proc_reg_open() in "too
	late" case
Message-ID: <20080903141755.GA5604@x200.localdomain>
References: <20080830053412.GB25179@x200.localdomain> <20080902162624.cd9f6d7f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902162624.cd9f6d7f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 04:26:24PM -0700, Andrew Morton wrote:
> On Sat, 30 Aug 2008 09:34:12 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > If ->open() wasn't called, returning 0 is misleading and, theoretically,
> > oopsable:
> > 1. remove_proc_entry clears ->proc_fops, drops lock,
> > 2. ->open "succeeds",
> > 3. ->release oopses, because it assumes ->open was called (single_release()).
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  fs/proc/inode.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/fs/proc/inode.c
> > +++ b/fs/proc/inode.c
> > @@ -350,7 +350,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
> >  	if (!pde->proc_fops) {
> >  		spin_unlock(&pde->pde_unload_lock);
> >  		kfree(pdeo);
> > -		return rv;
> > +		return -EINVAL;
> >  	}
> >  	pde->pde_users++;
> >  	open = pde->proc_fops->open;
> 
> Can this code path ever actually be executed?  afacit if ->proc_fops is
> ever NULL, the caller (proc_get_inode) would have already oopsed:
> 
> #ifdef CONFIG_COMPAT
> 				if (!de->proc_fops->compat_ioctl)
> 					inode->i_fop =
> 						&proc_reg_file_ops_no_compat;
> 				else
> #endif
> 					inode->i_fop = &proc_reg_file_ops;

Yes, it can.

remove_proc_entry() clears ->proc_fops to indicate that removal of PDE started.
But somebody could have already open(2) and is currently at the beginning of
proc_reg_open().

Well, that's how bug was noticed in the first place.

