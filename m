Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYL1SSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYL1SSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 13:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYL1SR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 13:17:57 -0500
Received: from brick.kernel.dk ([93.163.65.50]:17076 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbYL1SR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 13:17:56 -0500
Date: Sun, 28 Dec 2008 19:17:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: eagle black <rochacker@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [BUG] It seems that i found a bug in the linux kernel, and it also in the newest kernel version
Message-ID: <20081228181706.GW32491@kernel.dk>
References: <cbe409c50812252315w1bb62fa0n3c0e05e7d9432e40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbe409c50812252315w1bb62fa0n3c0e05e7d9432e40@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26 2008, eagle black wrote:
> let's see, int the function elevator_init of block/elevator.c ,
> if the function elevator_init_queue failed for some reason, and the memory
> of elevator_alloc  alloced does not free!
> 
> int elevator_init(struct request_queue *q, char *name)
> {
>         struct elevator_type *e = NULL;
>         struct elevator_queue *eq;
>         int ret = 0;
>         void *data;
> 
>         INIT_LIST_HEAD(&q->queue_head);
>         q->last_merge = NULL;
>         q->end_sector = 0;
>         q->boundary_rq = NULL;
> 
>         if (name) {
>                 e = elevator_get(name);
>                 if (!e)
>                         return -EINVAL;
>         }
> 
>         if (!e && *chosen_elevator) {
>                 e = elevator_get(chosen_elevator);
>                 if (!e)
>                         printk(KERN_ERR "I/O scheduler %s not found\n",
>                                                         chosen_elevator);
>         }
> 
>         if (!e) {
>                 e = elevator_get(CONFIG_DEFAULT_IOSCHED);
>                 if (!e) {
>                         printk(KERN_ERR
>                                 "Default I/O scheduler not found. " \
>                                 "Using noop.\n");
>                         e = elevator_get("noop");
>                 }
>         }
> 
>         eq = elevator_alloc(q, e);
>         if (!eq)
>                 return -ENOMEM;
> 
>         data = elevator_init_queue(q, eq);
>         if (!data) {
>                 kobject_put(&eq->kobj);

See the kobject_put() there. It'll put the one and only reference to
this kobject, which wil end up in elevator_release() that then frees
'eq' (called 'e' there).

-- 
Jens Axboe

