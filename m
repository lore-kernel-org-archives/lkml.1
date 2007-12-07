Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbXLGMGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbXLGMGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXLGMGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:06:42 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56167 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbXLGMGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:06:41 -0500
Date: Fri, 7 Dec 2007 14:55:05 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
Message-ID: <20071207115505.GA18013@2ka.mipt.ru>
References: <1196983219534-git-send-email-zach.brown@oracle.com> <11969832193635-git-send-email-zach.brown@oracle.com> <1196983219225-git-send-email-zach.brown@oracle.com> <11969832192868-git-send-email-zach.brown@oracle.com> <1196983219370-git-send-email-zach.brown@oracle.com> <11969832192130-git-send-email-zach.brown@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11969832192130-git-send-email-zach.brown@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zach.

On Thu, Dec 06, 2007 at 03:20:18PM -0800, Zach Brown (zach.brown@oracle.com) wrote:
> +/*
> + * XXX todo:
> + *  - do we need all this '*cur = current' nonsense?
> + *  - try to prevent userspace from submitting too much.. lazy user ptr read?
> + *  - explain how to deal with waiting threads with stale data in current
> + *  - how does userspace tell that a syslet completion was lost?
> + *  	provide an -errno argument to the userspace return function?
> + */
> +
> +/*
> + * These structs are stored on the kernel stack of tasks which are waiting to
> + * return to userspace.  They are linked into their parent's list of syslet
> + * children stored in 'syslet_tasks' in the parent's task_struct.
> + */
> +struct syslet_task_entry {
> +	struct task_struct *task;
> +	struct list_head item;
> +};
> +
> +/*
> + * syslet_ring doesn't have any kernel-side storage.  Userspace allocates them
> + * in their address space and initializes their fields and then passes them to
> + * the kernel.
> + *
> + * These hashes provide the kernel-side storage for the wait queues which
> + * sys_syslet_ring_wait() uses and the mutex which completion uses to serialize
> + * the (possible blocking) ordered writes of the completion and kernel head
> + * index into the ring.
> + *
> + * We chose the bucket that supports a given ring by hashing a u32 that
> + * userspace sets in the ring.
> + */
> +#define SYSLET_HASH_BITS (CONFIG_BASE_SMALL ? 4 : 8)
> +#define SYSLET_HASH_NR (1 << SYSLET_HASH_BITS)
> +#define SYSLET_HASH_MASK (SYSLET_HASH_NR - 1)
> +static wait_queue_head_t syslet_waitqs[SYSLET_HASH_NR];
> +static struct mutex syslet_muts[SYSLET_HASH_NR];

Why do you care about hashed tables scalability and not using trees?

-- 
	Evgeniy Polyakov
