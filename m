Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab0BNKM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:12:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab0BNKMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:12:49 -0500
Subject: Re: [PATCH tip/core/rcu 07/13] vfs: apply lockdep-based checking
 to rcu_dereference() uses
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Alexander Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <1265932839-25899-7-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100212000016.GA25781@linux.vnet.ibm.com>
	 <1265932839-25899-7-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 11:12:10 +0100
Message-ID: <1266142330.5273.414.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-11 at 16:00 -0800, Paul E. McKenney wrote:
> 
> -#define files_fdtable(files) (rcu_dereference((files)->fdt))
> +#define files_fdtable(files) \
> +       (rcu_dereference_check((files)->fdt, \
> +                              rcu_read_lock_held() || \
> +                              lockdep_is_held(&(files)->file_lock) ||
> \
> +                              atomic_read(&files->count) == 1))
>  
>  struct file_operations;
>  struct vfsmount;
> @@ -78,7 +82,7 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
>         struct fdtable *fdt = files_fdtable(files);
>  
>         if (fd < fdt->max_fds)
> -               file = rcu_dereference(fdt->fd[fd]);
> +               file = rcu_dereference_check(fdt->fd[fd], rcu_read_lock_held() || lockdep_is_held(&files->file_lock) || atomic_read(&files->count) == 1);
>         return file; 

I'm almost thinking you can do something smart here and not replicate
that condition :-)


