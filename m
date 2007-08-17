Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbXHQCzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbXHQCzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 22:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXHQCy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 22:54:59 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46208 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751274AbXHQCy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 22:54:58 -0400
Message-ID: <387319294.62579@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 17 Aug 2007 10:54:54 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@osdl.org>, Al Viro <viro@ftp.linux.org.uk>,
       John Berthels <jjberthels@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] maps: address based vma walking
Message-ID: <20070817025454.GB5521@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.192029043@mail.ustc.edu.cn> <20070817021617.GI30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817021617.GI30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:16:17PM -0500, Matt Mackall wrote:
> On Fri, Aug 17, 2007 at 06:05:18AM +0800, Fengguang Wu wrote:
> > Split large vmas into page groups of proc_maps_private.batch_size bytes, and
> > iterate them one by one for seqfile->show. This allows us to export large scale
> > process address space information via the seqfile interface. The old behavior
> > of walking one vma at a time can be achieved by setting the batching size to
> > ~0UL.
> > 
> > Cc: Matt Mackall <mpm@selenic.com>
> > Cc: Al Viro <viro@ftp.linux.org.uk>
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> > ---
> >  fs/proc/task_mmu.c      |  105 ++++++++++++--------------------------
> >  include/linux/proc_fs.h |    6 +-
> >  mm/mempolicy.c          |    2 
> >  3 files changed, 38 insertions(+), 75 deletions(-)
> > 
> > --- linux-2.6.23-rc2-mm2.orig/include/linux/proc_fs.h
> > +++ linux-2.6.23-rc2-mm2/include/linux/proc_fs.h
> > @@ -283,9 +283,9 @@ static inline struct proc_dir_entry *PDE
> >  struct proc_maps_private {
> >  	struct pid *pid;
> >  	struct task_struct *task;
> > -#ifdef CONFIG_MMU
> > -	struct vm_area_struct *tail_vma;
> > -#endif
> > +	struct mm_struct *mm;
> > +	/* walk min(batch_size, remaining_size_of(vma)) bytes at a time */
> > +	unsigned long batch_size;
> >  };
> >  
> >  #endif /* _LINUX_PROC_FS_H */
> > --- linux-2.6.23-rc2-mm2.orig/mm/mempolicy.c
> > +++ linux-2.6.23-rc2-mm2/mm/mempolicy.c
> > @@ -1937,7 +1937,5 @@ out:
> >  	seq_putc(m, '\n');
> >  	kfree(md);
> >  
> > -	if (m->count < m->size)
> > -		m->version = (vma != priv->tail_vma) ? vma->vm_start : 0;
> >  	return 0;
> >  }
> 
> What's this bit for?

This function is called by show_numa_map_checked(), which in turn also
uses m_start/m_next/m_stop. m->version used to store start address of
vmas, but now may also point to the middle of a vma.

