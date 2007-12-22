Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbXLVJbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbXLVJbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 04:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbXLVJbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 04:31:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbXLVJbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 04:31:03 -0500
Date: Sat, 22 Dec 2007 01:30:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Jon Masters <jcm@redhat.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
Message-Id: <20071222013021.db2528cb.akpm@linux-foundation.org>
In-Reply-To: <20071217234314.540b59bd@hammerfall>
References: <20071217234314.540b59bd@hammerfall>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 23:43:14 +0100 Michal Schmidt <mschmidt@redhat.com> wrote:

> kthreadd, the creator of other kernel threads, runs as a normal
> priority task. This is a potential for priority inversion when a task
> wants to spawn a high-priority kernel thread. A middle priority
> SCHED_FIFO task can block kthreadd's execution indefinitely and thus
> prevent the timely creation of the high-priority kernel thread.
>     
> This causes a practical problem. When a runaway real-time task is
> eating 100% CPU and we attempt to put the CPU offline, sometimes we
> block while waiting for the creation of the highest-priority
> "kstopmachine" thread. 
> 
> The fix is to run kthreadd with the highest possible SCHED_FIFO
> priority. Its children must still run as slightly negatively reniced
> SCHED_NORMAL tasks.

Did you hit this problem with the stock kernel, or have you been working on
other stuff?

A locked-up SCHED_FIFO process will cause kernel threads all sorts of
problems.  You've hit one instance, but there will be others.  (pdflush
stops working, for one).

The general approach we've taken to this is "don't do that".  Yes, we could
boost lots of kernel threads in the way which this patch does but this
actually takes control *away* from userspace.  Userspace no longer has the
ability to guarantee itself minimum possible latency without getting
preempted by kernel threads.

And yes, giving userspace this minimum-latency capability does imply that
userspace has a responsibility to not 100% starve kernel threads.  It's a
reasonable compromise, I think?

