Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXHQCPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXHQCPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 22:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759888AbXHQCP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 22:15:26 -0400
Received: from waste.org ([66.93.16.53]:35274 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758846AbXHQCPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 22:15:24 -0400
Date: Thu, 16 Aug 2007 21:16:17 -0500
From: Matt Mackall <mpm@selenic.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Al Viro <viro@ftp.linux.org.uk>,
       John Berthels <jjberthels@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] maps: address based vma walking
Message-ID: <20070817021617.GI30556@waste.org>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.192029043@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816220849.192029043@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 06:05:18AM +0800, Fengguang Wu wrote:
> Split large vmas into page groups of proc_maps_private.batch_size bytes, and
> iterate them one by one for seqfile->show. This allows us to export large scale
> process address space information via the seqfile interface. The old behavior
> of walking one vma at a time can be achieved by setting the batching size to
> ~0UL.
> 
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Al Viro <viro@ftp.linux.org.uk>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  fs/proc/task_mmu.c      |  105 ++++++++++++--------------------------
>  include/linux/proc_fs.h |    6 +-
>  mm/mempolicy.c          |    2 
>  3 files changed, 38 insertions(+), 75 deletions(-)
> 
> --- linux-2.6.23-rc2-mm2.orig/include/linux/proc_fs.h
> +++ linux-2.6.23-rc2-mm2/include/linux/proc_fs.h
> @@ -283,9 +283,9 @@ static inline struct proc_dir_entry *PDE
>  struct proc_maps_private {
>  	struct pid *pid;
>  	struct task_struct *task;
> -#ifdef CONFIG_MMU
> -	struct vm_area_struct *tail_vma;
> -#endif
> +	struct mm_struct *mm;
> +	/* walk min(batch_size, remaining_size_of(vma)) bytes at a time */
> +	unsigned long batch_size;
>  };
>  
>  #endif /* _LINUX_PROC_FS_H */
> --- linux-2.6.23-rc2-mm2.orig/mm/mempolicy.c
> +++ linux-2.6.23-rc2-mm2/mm/mempolicy.c
> @@ -1937,7 +1937,5 @@ out:
>  	seq_putc(m, '\n');
>  	kfree(md);
>  
> -	if (m->count < m->size)
> -		m->version = (vma != priv->tail_vma) ? vma->vm_start : 0;
>  	return 0;
>  }

What's this bit for?

> --- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
> +++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
> @@ -115,99 +115,65 @@ static void pad_len_spaces(struct seq_fi
>  	seq_printf(m, "%*c", len, ' ');
>  }
>  
> -static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
> +static void *seek_vma_addr(struct seq_file *m,
> +			   struct vm_area_struct *vma, loff_t *pos)
>  {
> -	if (vma && vma != priv->tail_vma) {
> -		struct mm_struct *mm = vma->vm_mm;
> -		up_read(&mm->mmap_sem);
> -		mmput(mm);
> -	}
> +	struct proc_maps_private *priv = m->private;
> +	unsigned long addr = *pos;
> +
> +	if (addr & ~PAGE_MASK) { /* time for next batch */
> +		if (vma->vm_end - addr < priv->batch_size) {
> +			vma = vma->vm_next;
> +			if (!vma || vma == get_gate_vma(priv->task))
> +				goto done;
> +		} else
> +			addr = (addr + priv->batch_size) & PAGE_MASK;
> +	}
> +	if (addr < vma->vm_start)
> +	    addr = vma->vm_start;
> +
> +	m->version = *pos = addr;
> +	return vma;
> +done:
> +	return NULL;
>  }
>  
>  static void *m_start(struct seq_file *m, loff_t *pos)
>  {
>  	struct proc_maps_private *priv = m->private;
> -	unsigned long last_addr = m->version;
> -	struct mm_struct *mm;
> -	struct vm_area_struct *vma, *tail_vma = NULL;
> -	loff_t l = *pos;
> -
> -	/* Clear the per syscall fields in priv */
> -	priv->task = NULL;
> -	priv->tail_vma = NULL;
> -
> -	/*
> -	 * We remember last_addr rather than next_addr to hit with
> -	 * mmap_cache most of the time. We have zero last_addr at
> -	 * the beginning and also after lseek. We will have -1 last_addr
> -	 * after the end of the vmas.
> -	 */
> -
> -	if (last_addr == -1UL)
> -		return NULL;
> +	struct vm_area_struct *vma;
>  
> +	priv->mm = NULL;
>  	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
>  	if (!priv->task)
>  		return NULL;
>  
> -	mm = get_task_mm(priv->task);
> -	if (!mm)
> +	priv->mm = get_task_mm(priv->task);
> +	if (!priv->mm)
>  		return NULL;
>  
> -	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
> -	down_read(&mm->mmap_sem);
> +	down_read(&priv->mm->mmap_sem);
>  
> -	/* Start with last addr hint */
> -	if (last_addr && (vma = find_vma(mm, last_addr))) {
> -		vma = vma->vm_next;
> -		goto out;
> -	}
> -
> -	/*
> -	 * Check the vma index is within the range and do
> -	 * sequential scan until m_index.
> -	 */
> -	vma = NULL;
> -	if ((unsigned long)l < mm->map_count) {
> -		vma = mm->mmap;
> -		while (l-- && vma)
> -			vma = vma->vm_next;
> -		goto out;
> -	}
> -
> -	if (l != mm->map_count)
> -		tail_vma = NULL; /* After gate vma */
> -
> -out:
> -	if (vma)
> -		return vma;
> +	vma = find_vma(priv->mm, *pos);
> +	if (!vma || vma == get_gate_vma(priv->task))
> +		return NULL;
>  
> -	/* End of vmas has been reached */
> -	m->version = (tail_vma != NULL)? 0: -1UL;
> -	up_read(&mm->mmap_sem);
> -	mmput(mm);
> -	return tail_vma;
> +	return seek_vma_addr(m, vma, pos);
>  }
>  
>  static void *m_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> -	struct proc_maps_private *priv = m->private;
> -	struct vm_area_struct *vma = v;
> -	struct vm_area_struct *tail_vma = priv->tail_vma;
> -
>  	(*pos)++;
> -	if (vma && (vma != tail_vma) && vma->vm_next)
> -		return vma->vm_next;
> -	vma_stop(priv, vma);
> -	return (vma != tail_vma)? tail_vma: NULL;
> +	return seek_vma_addr(m, v, pos);
>  }
>  
>  static void m_stop(struct seq_file *m, void *v)
>  {
>  	struct proc_maps_private *priv = m->private;
> -	struct vm_area_struct *vma = v;
> -
> -	vma_stop(priv, vma);
> +	if (priv->mm) {
> +		up_read(&priv->mm->mmap_sem);
> +		mmput(priv->mm);
> +	}
>  	if (priv->task)
>  		put_task_struct(priv->task);
>  }
> @@ -220,6 +186,7 @@ static int do_maps_open(struct inode *in
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>  	if (priv) {
>  		priv->pid = proc_pid(inode);
> +		priv->batch_size = ~0;
>  		ret = seq_open(file, ops);
>  		if (!ret) {
>  			struct seq_file *m = file->private_data;
> @@ -291,8 +258,6 @@ static int show_map(struct seq_file *m, 
>  	}
>  	seq_putc(m, '\n');
>  
> -	if (m->count < m->size)  /* vma is copied successfully */
> -		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
>  	return 0;
>  }

-- 
Mathematics is the supreme nostalgia of our time.
