Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZKFPln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZKFPln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 10:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZKFPlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 10:41:42 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:46033 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZKFPlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:41:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ozqmbz1CEX7k5i7xTYyiy3hIimCFbnXtpuJDj1tgmfLn2KPo/wle2371Z4roXaALUH
         gJ8gK+FkNwFMpv14cXqQTmdKb981s7KXIUjpMtRPyKa2JDEwvcEN85y45VX213AxOYNV
         J+WzYo3XWZOLji44A08xY6vlDcb5VIMXxDwnU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1>
	 <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1>
Date: Sat, 7 Nov 2009 00:41:40 +0900
Message-ID: <28c262360911060741x3f7ab0a2k15be645e287e05ac@mail.gmail.com>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter 
	instead
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Christoph.

How about change from 'mm_readers' to 'is_readers' to improve your
goal 'scalibility'?
===
static inline int is_readers(struct mm_struct *mm)
{
       int cpu;
       int ret = 0;

       for_each_possible_cpu(cpu) {
               if (per_cpu(mm->rss->readers, cpu)) {
                      ret = 1;
                      break;
                 }
       }

       return ret;
}
===


On Fri, Nov 6, 2009 at 4:20 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> From: Christoph Lamter <cl@linux-foundation.org>
> Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter instead
>
> Instead of a rw semaphore use a mutex and a per cpu counter for the number
> of the current readers. read locking then becomes very cheap requiring only
> the increment of a per cpu counter.
>
> Write locking is more expensive since the writer must scan the percpu array
> and wait until all readers are complete. Since the readers are not holding
> semaphores we have no wait queue from which the writer could wakeup. In this
> draft we simply wait for one millisecond between scans of the percpu
> array. A different solution must be found there.
>
> Patch is on top of -next and the percpu counter patches that I posted
> yesterday. The patch adds another per cpu counter to the file and anon rss
> counters.
>
> Signed-off-by: Christoph Lamter <cl@linux-foundation.org>
>
> ---
>  include/linux/mm_types.h |   68 ++++++++++++++++++++++++++++++++++++++---------
>  mm/init-mm.c             |    2 -
>  2 files changed, 56 insertions(+), 14 deletions(-)
>
> Index: linux-2.6/include/linux/mm_types.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm_types.h     2009-11-05 13:03:11.000000000 -0600
> +++ linux-2.6/include/linux/mm_types.h  2009-11-05 13:06:31.000000000 -0600
> @@ -14,6 +14,7 @@
>  #include <linux/page-debug-flags.h>
>  #include <asm/page.h>
>  #include <asm/mmu.h>
> +#include <linux/percpu.h>
>
>  #ifndef AT_VECTOR_SIZE_ARCH
>  #define AT_VECTOR_SIZE_ARCH 0
> @@ -27,6 +28,7 @@ struct address_space;
>  struct mm_counter {
>        long file;
>        long anon;
> +       long readers;
>  };
>
>  /*
> @@ -214,7 +216,7 @@ struct mm_struct {
>        atomic_t mm_users;                      /* How many users with user space? */
>        atomic_t mm_count;                      /* How many references to "struct mm_struct" (users count as 1) */
>        int map_count;                          /* number of VMAs */
> -       struct rw_semaphore sem;
> +       struct mutex lock;
>        spinlock_t page_table_lock;             /* Protects page tables and some counters */
>
>        struct list_head mmlist;                /* List of maybe swapped mm's.  These are globally strung
> @@ -285,64 +287,104 @@ struct mm_struct {
>  #endif
>  };
>
> +static inline int mm_readers(struct mm_struct *mm)
> +{
> +       int cpu;
> +       int readers = 0;
> +
> +       for_each_possible_cpu(cpu)
> +               readers += per_cpu(mm->rss->readers, cpu);
> +
> +       return readers;
> +}
> +
>  static inline void mm_reader_lock(struct mm_struct *mm)
>  {
> -       down_read(&mm->sem);
> +redo:
> +       this_cpu_inc(mm->rss->readers);
> +       if (mutex_is_locked(&mm->lock)) {
> +               this_cpu_dec(mm->rss->readers);
> +               /* Need to wait till mutex is released */
> +               mutex_lock(&mm->lock);
> +               mutex_unlock(&mm->lock);
> +               goto redo;
> +       }
>  }
>
>  static inline void mm_reader_unlock(struct mm_struct *mm)
>  {
> -       up_read(&mm->sem);
> +       this_cpu_dec(mm->rss->readers);
>  }
>
>  static inline int mm_reader_trylock(struct mm_struct *mm)
>  {
> -       return down_read_trylock(&mm->sem);
> +       this_cpu_inc(mm->rss->readers);
> +       if (mutex_is_locked(&mm->lock)) {
> +               this_cpu_dec(mm->rss->readers);
> +               return 0;
> +       }
> +       return 1;
>  }
>
>  static inline void mm_writer_lock(struct mm_struct *mm)
>  {
> -       down_write(&mm->sem);
> +redo:
> +       mutex_lock(&mm->lock);
> +       if (mm_readers(mm) == 0)

We can change this.

if (!is_readers(mm))
         return;

> +               return;
> +
> +       mutex_unlock(&mm->lock);
> +       msleep(1);
> +       goto redo;
>  }
>
>  static inline void mm_writer_unlock(struct mm_struct *mm)
>  {
> -       up_write(&mm->sem);
> +       mutex_unlock(&mm->lock);
>  }
>
>  static inline int mm_writer_trylock(struct mm_struct *mm)
>  {
> -       return down_write_trylock(&mm->sem);
> +       if (!mutex_trylock(&mm->lock))
> +               goto fail;
> +
> +       if (mm_readers(mm) == 0)
> +               return 1;

if (!is_readers(mm))
        return 1;

> +
> +       mutex_unlock(&mm->lock);
> +fail:
> +       return 0;
>  }
>

-- 
Kind regards,
Minchan Kim
