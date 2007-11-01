Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbXKATxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbXKATxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbXKATxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:53:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56104 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbXKATxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:53:04 -0400
Subject: Re: [RFC][PATCH 1/3] [RFC][PATCH] Fix procfs task exe symlinks
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, viro@ftp.linux.org.uk,
       haveblue@us.ibm.com
In-Reply-To: <20071101122509.f26225bb.akpm@linux-foundation.org>
References: <20071101033508.720885000@us.ibm.com>
	 <20071101044124.209949000@us.ibm.com>
	 <20071101122509.f26225bb.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 01 Nov 2007 12:52:56 -0700
Message-Id: <1193946776.16995.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 12:25 -0700, Andrew Morton wrote:
> On Wed, 31 Oct 2007 20:35:09 -0700
> Matt Helsley <matthltc@us.ibm.com> wrote:
> 
> > +++ linux-2.6.23/include/linux/sched.h
> > @@ -430,10 +430,13 @@ struct mm_struct {
> >  	struct completion *core_startup_done, core_done;
> >  
> >  	/* aio bits */
> >  	rwlock_t		ioctx_list_lock;
> >  	struct kioctx		*ioctx_list;
> > +
> > +	/* store ref to file /proc/<pid>/exe symlink points to */
> > +	struct file *exe_file;
> >  };
> 
> I guess with a little work this could be made conditional on
> CONFIG_PROC_FS.  ie: change get_mm_exe_file() to

Sorry, I thought ifdefs were generally frowned upon in structs. I'll add
them here and make sure everthing still works properly.

> void get_mm_exe_file(struct mm_struct *newmm, struct mm_struct *old_mm);
> 
> > @@ -1716,10 +1744,14 @@ static void remove_vma_list(struct mm_st
> >  
> >  		mm->total_vm -= nrpages;
> >  		if (vma->vm_flags & VM_LOCKED)
> >  			mm->locked_vm -= nrpages;
> >  		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
> > +		if (mm->exe_file && (vma->vm_file == mm->exe_file)) {
> > +			fput(mm->exe_file);
> > +			mm->exe_file = NULL;
> > +		}
> >  		vma = remove_vma(vma);
> >  	} while (vma);
> >  	validate_mm(mm);
> >  }
> 
> hm, fput() while holding mmap_sem.  I wonder if that's a problem.
> 
> I assume you've runtime tested this with lockdep enabled, but fput() is one
> of those funny things which can call all sorts of things which one least
> expects and where testers hit things which developers don't.

It's being used under the mmap semaphore in remove_vma() so, even if
fput() with mmap_sem held is a bug, I'm not introducing any new bugs :).

Thanks,
	-Matt Helsley


