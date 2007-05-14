Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbXENLIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbXENLIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbXENLIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:08:07 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39237 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbXENLIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:08:04 -0400
Date: Mon, 14 May 2007 16:45:21 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Carsten Otte <cotte.de@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 9/14] Union-mount readdir
Message-ID: <20070514111521.GQ4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094249.GK4139@in.ibm.com> <5c77e7070705140343q51208efdk2746b4d80db353ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c77e7070705140343q51208efdk2746b4d80db353ba@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 12:43:43PM +0200, Carsten Otte wrote:
> On 5/14/07, Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> >+/* This is a copy from fs/readdir.c */
> >+struct getdents_callback {
> >+       struct linux_dirent __user *current_dir;
> >+       struct linux_dirent __user *previous;
> >+       int count;
> >+       int error;
> >+};
> This should go into a header file.

Yes ideally. As the comment above says, it is copied from fs/readdir.c and
we should be using the definition from there. But that needs touching
additional files and we wanted to avoid that for this initial RFC post.

> 
> >+static int union_cache_find_entry(struct list_head *uc_list,
> >+                                 const char *name, int namelen)
> >+{
> >+       struct union_cache_entry *p;
> >+       int ret = 0;
> >+
> >+       list_for_each_entry(p, uc_list, list) {
> >+               if (p->name.len != namelen)
> >+                       continue;
> >+               if (strncmp(p->name.name, name, namelen) == 0) {
> >+                       ret = 1;
> >+                       break;
> >+               }
> >+       }
> >+       return ret;
> >+}
> Why not use strlen instead of having both string and length as parameter?
> 

All generic filldir routines in fs/readdir.c (filldir, fillonedir and
filldir64) don't depend on the dirent->d_name to be NULL terminated and
put a 0 themselves at the end. Hence we are also not depending on the
name string to be NULL terminated.

> >+static struct file * __dentry_open_read(struct dentry *dentry,
> >+                                       struct vfsmount *mnt, int flags)
> >+{
> >+       struct file *f;
> >+       struct inode *inode;
> >+       int error;
> >+
> >+       error = -ENFILE;
> >+       f = get_empty_filp();
> >+       if (!f)
> >+               goto out;
> This is the only case where error is not explicitly set to a different
> value before hitting out/cleanup => consider setting conditionally.

Sure can be done. Again this routine is copied from dentry_open() and
hence it is like that atm.

Thanks for your review.

Regards,
Bharata.
