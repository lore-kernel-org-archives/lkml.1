Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbZDOBaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbZDOBaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZDOBaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:30:08 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:38223 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754415AbZDOBaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:30:06 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 21:30:05 EDT
Message-ID: <439758577.02046@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: xcf@ustc.edu.cn
Date: Wed, 15 Apr 2009 09:22:01 +0800
From: Chenfeng Xu <xcf@ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       fengguang.wu@intel.com
Subject: Re: [RFC][PATCH] vfs: check inode size on no_cached_page
Message-ID: <20090415012027.GA4731@ThinkPad>
References: <20090412071605.GA14058@localhost> <20090414171114.04a47932.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414171114.04a47932.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 05:11:14PM -0700, Andrew Morton wrote:
> On Sun, 12 Apr 2009 15:16:05 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > [This patch may not necessarily be merged, but at least we should
> >  be aware of the problem.]
> > 
> > When user space requests past-EOF data, do_generic_file_read() will
> > issue a bonus readpage call, which may be unfavorable.
> > 
> > do_generic_file_read:
> >         -> find_page:
> >         -> find_get_page()             = NULL
> >         -> page_cache_sync_readahead()
> >         -> find_get_page()             = NULL
> >         -> no_cached_page:
> >         -> readpage:
> >                 -> nfs_readpage()      = error
> >         -> readpage_error:
> > 
> > Reported-by: Xu Chenfeng <xcf@ustc.edu.cn>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  mm/filemap.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- mm.orig/mm/filemap.c
> > +++ mm/mm/filemap.c
> > @@ -1269,6 +1269,11 @@ readpage_error:
> >  		goto out;
> >  
> >  no_cached_page:
> > +		isize = i_size_read(inode);
> > +		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
> > +		if (unlikely(!isize || index > end_index))
> > +			goto out;
> > +
> >  		/*
> >  		 * Ok, it wasn't cached, so we need to create a new
> >  		 * page..
> 
> Is this a problem which needs to be solved?  userspace does something
> silly and the kernel behaves a bit suboptimally?
> 
> If thats the only problem here then it's not worth adding fastpath
> cycles to fix it?
> 

Currently, it is the only problem I have found. It is caused by 'dd' which tries to access
the page > end_index. However, as linux-based operating systems have
many zero-size configure files, 'isize == 0' could be a more general
case. Without this fastpath, 'no_cached_page' will create many unusable
pages.


I add the following lines and boot a small system in kvm. 

        if (unlikely(!isize || index > end_index))
+       {
+                printk(KERN_DEBUG "over read: %s %lu/%lu\n",
+                filp->f_path.dentry->d_name.name, index, end_index);
                goto out;
+        }

The 'over read' message in boot time:
Apr  6 23:57:43 kvm kernel: [    4.334520] over read: locale 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    4.350895] over read: locale 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    4.365575] over read: locale 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    4.695195] over read: mtab 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    5.326886] over read: ifstate 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    5.326912] over read: ifstate 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    5.396599] over read: portmap_mapping 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    6.076429] over read: random-seed 1/0
Apr  6 23:57:43 kvm kernel: [    6.152477] over read: utmp 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    6.152492] over read: utmp 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    6.367410] over read: etab 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    6.426226] over read: xtab.tmp 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    6.426229] over read: xtab 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    6.533658] over read: locale 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    6.550716] over read: locale 0/18446744073709551615
Apr  6 23:57:43 kvm kernel: [    6.565761] over read: locale 0/18446744073709551615
Apr  6 23:57:47 kvm kernel: [   10.122621] over read: environment 0/18446744073709551615
Apr  6 23:57:47 kvm kernel: [   10.122751] over read: locale 0/18446744073709551615
Apr  6 23:58:49 kvm kernel: [   72.388823] over read: etab.tmp 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [    6.184260] over read: locale 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [    6.221483] over read: locale 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [    6.260493] over read: locale 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [    7.185390] over read: mtab 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [    8.960259] over read: ifstate 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [    8.960322] over read: ifstate 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [    9.155492] over read: portmap_mapping 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [   10.922985] over read: random-seed 1/0
Apr  6 23:59:17 kvm kernel: [   11.151462] over read: utmp 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [   11.151497] over read: utmp 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [   11.708856] over read: etab 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [   11.810557] over read: xtab.tmp 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [   11.810561] over read: xtab 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [   11.954552] over read: locale 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [   11.975360] over read: locale 0/18446744073709551615
Apr  6 23:59:17 kvm kernel: [   11.994969] over read: locale 0/18446744073709551615
Apr  6 23:59:22 kvm kernel: [   16.132338] over read: environment 0/18446744073709551615
Apr  6 23:59:22 kvm kernel: [   16.132471] over read: locale 0/18446744073709551615
