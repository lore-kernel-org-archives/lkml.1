Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbZHDWTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbZHDWTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZHDWTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:19:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbZHDWTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:19:35 -0400
Date: Tue, 4 Aug 2009 15:18:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] serial167: Read buffer overflow
Message-Id: <20090804151838.c5cb362b.akpm@linux-foundation.org>
In-Reply-To: <4A76D4DA.8090905@gmail.com>
References: <4A76D4DA.8090905@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Aug 2009 14:15:22 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> @@ -222,7 +222,7 @@ static inline int serial_paranoia_check(struct cyclades_port *info, char *name,
>  	}
>  
>  	if ((long)info < (long)(&cy_port[0])
> -	    || (long)(&cy_port[NR_PORTS]) < (long)info) {
> +	    || (long)(&cy_port[NR_PORTS-1]) < (long)info) {
>  		printk("Warning: cyclades_port out of range for (%s) in %s\n",
>  				name, routine);

OK, that hurts my brain.  And all those casts are pointless.  How about this?

	if (info < &cy_port[0] || info >= &cy_port[NR_PORTS]) {
		printk("Warning: cyclades_port out of range for (%s) in %s\n",
				name, routine);
		return 1;
	}



btw, m68k allmodconfig in current mainline is sick:

In file included from /usr/src/devel/arch/m68k/include/asm/pgtable.h:4,
                 from include/linux/mm.h:40,
                 from drivers/char/serial167.c:62:
/usr/src/devel/arch/m68k/include/asm/pgtable_mm.h:148:1: warning: "pgprot_noncached" redefined
In file included from /usr/src/devel/arch/m68k/include/asm/pgtable_mm.h:138,
                 from /usr/src/devel/arch/m68k/include/asm/pgtable.h:4,
                 from include/linux/mm.h:40,
                 from drivers/char/serial167.c:62:
include/asm-generic/pgtable.h:133:1: warning: this is the location of the previous definition


And in linux-next m68k allmodconfig is dead as a doornail:

drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined from 'boolean' to 'tristate'
In file included from include/linux/irq.h:12,
                 from include/asm-generic/hardirq.h:6,
                 from /usr/src/devel/arch/m68k/include/asm/hardirq.h:4,
                 from include/linux/hardirq.h:10,
                 from /usr/src/devel/arch/m68k/include/asm/system_mm.h:69,
                 from /usr/src/devel/arch/m68k/include/asm/system.h:4,
                 from include/linux/list.h:7,
                 from include/linux/preempt.h:11,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/m68k/kernel/asm-offsets.c:12:
include/linux/smp.h:17: error: field 'list' has incomplete type
In file included from include/linux/mmzone.h:9,
                 from include/linux/gfp.h:4,
                 from include/linux/irq.h:20,
                 from include/asm-generic/hardirq.h:6,
                 from /usr/src/devel/arch/m68k/include/asm/hardirq.h:4,
                 from include/linux/hardirq.h:10,
                 from /usr/src/devel/arch/m68k/include/asm/system_mm.h:69,
                 from /usr/src/devel/arch/m68k/include/asm/system.h:4,
                 from include/linux/list.h:7,
                 from include/linux/preempt.h:11,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/m68k/kernel/asm-offsets.c:12:
include/linux/wait.h:37: error: field 'task_list' has incomplete type
include/linux/wait.h:51: error: expected specifier-qualifier-list before 'spinlock_t'
include/linux/wait.h: In function 'waitqueue_active':
include/linux/wait.h:108: error: implicit declaration of function 'list_empty'
include/linux/wait.h:108: error: 'wait_queue_head_t' has no member named 'task_list'
include/linux/wait.h: In function '__add_wait_queue':
include/linux/wait.h:117: error: implicit declaration of function 'list_add'
include/linux/wait.h:117: error: 'wait_queue_head_t' has no member named 'task_list'
include/linux/wait.h: In function '__add_wait_queue_tail':
include/linux/wait.h:126: error: implicit declaration of function 'list_add_tail'
include/linux/wait.h:126: error: 'wait_queue_head_t' has no member named 'task_list'
include/linux/wait.h: In function '__remove_wait_queue':
include/linux/wait.h:132: error: implicit declaration of function 'list_del'

