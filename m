Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbYK0KTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbYK0KTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYK0KTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:19:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYK0KTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:19:12 -0500
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
 trace output
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <492DEDE9.9010109@gmail.com>
References: <492DEDE9.9010109@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Nov 2008 11:19:06 +0100
Message-Id: <1227781146.4454.1369.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 01:46 +0100, Frederic Weisbecker wrote:
> Impact: enhancement
> 
> This patch applies some ideas of Ingo Molnar and Steven Rostedt.
> 
> * Output leaf functions in one line with parenthesis, semicolon and duration
>   output.
> 
> * Add a second column (after cpu) for an overhead sign.
>   if duration > 100 us, "!"
>   if duration > 10 us, "+"
>   else " "
> 
> * Print output in us with remaining nanosec: u.n
> 
> * Print duration on the right end, following the indentation of the functions.
>   Use also visual clues: "-" on entry call (no duration to output) and "+" on
>   return (duration output).
> 
> The name of the tracer has been fixed as well: function-branch becomes
> function_branch.
> 
> Here is an example of the new output:
> 
> CPU[000]           dequeue_entity() {                    -
> CPU[000]             update_curr() {                    -
> CPU[000]               update_min_vruntime();                    + 0.512 us
> CPU[000]             }                                + 1.504 us
> CPU[000]             clear_buddies();                    + 0.481 us
> CPU[000]             update_min_vruntime();                    + 0.504 us
> CPU[000]           }                                + 4.557 us
> CPU[000]           hrtick_update() {                    -
> CPU[000]             hrtick_start_fair();                    + 0.489 us
> CPU[000]           }                                + 1.443 us
> CPU[000] +       }                                + 14.655 us
> CPU[000] +     }                                + 15.678 us
> CPU[000] +   }                                + 16.686 us
> CPU[000]     msecs_to_jiffies();                    + 0.481 us
> CPU[000]     put_prev_task_fair();                    + 0.504 us
> CPU[000]     pick_next_task_fair();                    + 0.482 us
> CPU[000]     pick_next_task_rt();                    + 0.504 us
> CPU[000]     pick_next_task_fair();                    + 0.481 us
> CPU[000]     pick_next_task_idle();                    + 0.489 us
> CPU[000]     _spin_trylock();                    + 0.655 us
> CPU[000]     _spin_unlock();                    + 0.609 us
> 
> CPU[000]  ------------8<---------- thread bash-2794 ------------8<----------
> 
> CPU[000]               finish_task_switch() {                    -
> CPU[000]                 _spin_unlock_irq();                    + 0.722 us
> CPU[000]               }                                + 2.369 us
> CPU[000] !           }                                + 501972.605 us
> CPU[000] !         }                                + 501973.763 us
> CPU[000]           copy_from_read_buf() {                    -
> CPU[000]             _spin_lock_irqsave();                    + 0.670 us
> CPU[000]             _spin_unlock_irqrestore();                    + 0.699 us
> CPU[000]             copy_to_user() {                    -
> CPU[000]               might_fault() {                    -
> CPU[000]                 __might_sleep();                    + 0.503 us
> CPU[000]               }                                + 1.632 us
> CPU[000]               __copy_to_user_ll();                    + 0.542 us
> CPU[000]             }                                + 3.858 us
> CPU[000]             tty_audit_add_data() {                    -
> CPU[000]               _spin_lock_irq();                    + 0.609 us
> CPU[000]               _spin_unlock_irq();                    + 0.624 us
> CPU[000]             }                                + 3.196 us
> CPU[000]             _spin_lock_irqsave();                    + 0.624 us
> CPU[000]             _spin_unlock_irqrestore();                    + 0.625 us
> CPU[000] +         }                                + 13.611 us
> CPU[000]           copy_from_read_buf() {                    -
> CPU[000]             _spin_lock_irqsave();                    + 0.624 us
> CPU[000]             _spin_unlock_irqrestore();                    + 0.616 us
> CPU[000]           }                                + 2.820 us
> CPU[000]

May I suggest putting the times in front of the functions, the times can
be rendered in fixed with, avoiding all this unaligned foobar.

Furthermore, it would be really sweet if ftrace_printk() output would be
at the right indentation level wrt the function it was called from. eg.

CPU[000] -          do_sync_read() {
CPU[000]              # sock: 0x12345 flag: 1
CPU[000] -            sock_aio_read() {
...
CPU[000] + 0.123    }


Where the # line is the ftrace_printk() output.

