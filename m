Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbYF0Ss0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbYF0Ss0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYF0SsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:48:17 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38117 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753753AbYF0SsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:48:16 -0400
Date: Fri, 27 Jun 2008 13:48:16 -0500
From: Robin Holt <holt@sgi.com>
To: xialiang <xiaiaxaxi@sjtu.edu.cn>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How can I migrate a currently running task?
Message-ID: <20080627184815.GB10511@sgi.com>
References: <20080627211712.6cto2d1zks848c88@webmail1.sjtu.edu.cn> <e2e108260806270625o44ebe7a0u8250fa0bd5e976bd@mail.gmail.com> <20080627213805.jdqshto0ys4oookk@webmail1.sjtu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080627213805.jdqshto0ys4oookk@webmail1.sjtu.edu.cn>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 09:38:05PM +0800, xialiang wrote:
> Quoting Bart Van Assche <bart.vanassche@gmail.com>:
>
>> On Fri, Jun 27, 2008 at 3:17 PM, 夏亮 <xiaiaxaxi@sjtu.edu.cn> wrote:
>>> I am working on Intel Duo Core with Linux OS 2.6.21, and I'd like to
>>> migrate task from one cpu to another cpu.
>>> In SMP systems, load_balance() function uses move_tasks() to move processes
>>> from source runqueue to local runqueue, but it does not move a currently
>>> running task. If I want to migrate a currently running task from source
>>> runqueue to local runqueue, how can I do? Any suggestion is preferred.
>>
>> Are you familiar with the glibc pthread_setaffinity_np() function
>> and/or the sched_setaffinity() system call ?
>>
>> Bart.
>>
>
> Yes. I know sched_setaffinity(), it sets cpu_mask of a task. I want to  
> use it in a timer interrupt( scheduler_tick() ), can I?

Don't use it from a timer handler.  You can use migrate_task() to move the
task, but your email from a couple days ago said you wanted to move the
task at the head of the runqueue due to cpu heat or something like that.
That is a very imprecise way to move the task as any unfortunate task
that happens to be running when the timer tick occurs could get migrated,
not the one generating the work.

I think you really want to look at the other areas of the kernel which do
stuff like throttling the cpu.  Just moving a task off the cpu does not
prevent it from being used for another compute intesive load.  You could
take the cpu offline.  I guess to do that, I would use schedule_work()
or kthread_create() to get out of the timer context and into a regular
thread context then take the cpu offline from there.

Good Luck,
Robin
