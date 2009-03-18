Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZCRC5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZCRC5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZCRC5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:57:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbZCRC5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:57:45 -0400
Date: Tue, 17 Mar 2009 19:50:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Valdis.Kletnieks@vt.edu, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at
 kernel/workqueue.c:371
Message-Id: <20090317195004.18fb6af6.akpm@linux-foundation.org>
In-Reply-To: <49C05C94.7030104@cn.fujitsu.com>
References: <6648.1237271589@turing-police.cc.vt.edu>
	<20090317135424.9151c4f8.akpm@linux-foundation.org>
	<37742.1237327272@turing-police.cc.vt.edu>
	<49C05C94.7030104@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 10:29:40 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 17 Mar 2009 13:54:24 PDT, Andrew Morton said:
> > 
> >> It's an error in workqueue-avoid-recursion-in-run_workqueue.patch, methinks.
> > 
> > Thanks for the diagnosis - I got as far as realizing that any backtrace that
> > included flush_cpu_workqueue() and worker_thread() had a problem and got
> > stuck there.
> > 
> 
> It's dangerous when we allow recursion in run_workqueue().

static void run_workqueue(struct cpu_workqueue_struct *cwq)
{
	spin_lock_irq(&cwq->lock);
	cwq->run_depth++;
	if (cwq->run_depth > 3) {
		/* morton gets to eat his hat */
		printk("%s: recursion depth exceeded: %d\n",
			__func__, cwq->run_depth);
		dump_stack();
	}

That was added five or six years ago, and I never ever got to eat my hat.

> If it's hard for you avoid flush_scheduled_work() in
> keventd's work fuction by other fix, you can create
> another workqueue to handle your works, IMO.

Why do we need to change anything here?  No known bugs were fixed, and some
new ones were added.

