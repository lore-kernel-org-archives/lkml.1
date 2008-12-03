Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYLCBep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYLCBep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYLCBeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:34:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:37048 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYLCBeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:34:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KYWJJlivT4PcJZZZauTBrC9m4bHbFeXBOrLBzkvHuXW78PvR9yii2xVkD0PiUpxbn8
         uFlWb/Q7YGBxPXUF9uqs1HdTEBbF9s3UzPzg2IuOZwW5O2vkemQ2O5QbB2YKF4ctlc4k
         tB3wsVqsHd+yJYXHyqDfRQ8F33EEhw8Oidytk=
Message-ID: <4935E226.3060906@gmail.com>
Date: Wed, 03 Dec 2008 02:34:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration output
References: <4935E19C.3090501@gmail.com>
In-Reply-To: <4935E19C.3090501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Impact: better output of duration for long calls
> 
> The old duration output didn't exceeded 9999.999 us to fit the column
> and the nanosecs were always 3 numbers. As Ingo suggested, it's better
> to have the whole microseconds elapsed time and shift the nanosecs precision
> if needed to fit the maximum 7 numbers. And usec need more number, the case
> should be rare and important enough to break a bit the column alignment to
> show it.
> 
> So, depending of the duration value, we now have these patterns:
> 
> u.nnn
> uu.nnn
> uuu.nnn
> uuuu.nnn
> uuuuu.nn
> uuuuuu.n
> uuuuuuuu.....


An example of a trace after these two patches (with funcgraph-proc enabled):

 0)    cat-2796    |               |            put_prev_task_fair() {
 0)    cat-2796    |   0.609 us    |              update_curr();
 0)    cat-2796    |   1.842 us    |            }
 0)    cat-2796    |               |            pick_next_task_fair() {
 0)    cat-2796    |   0.526 us    |              wakeup_preempt_entity();
 0)    cat-2796    |   0.797 us    |              set_next_entity();
 0)    cat-2796    |   0.541 us    |              hrtick_start_fair();
 0)    cat-2796    |   4.195 us    |            }
 0)    cat-2796    |   1.263 us    |            _spin_trylock();
 0)    cat-2796    |   0.624 us    |            _spin_unlock();
 0)    cat-2796    |   0.789 us    |            _spin_trylock();
 0)    cat-2796    |   0.617 us    |            _spin_unlock();
 0)    cat-2796    |   0.579 us    |            native_load_sp0();
 0)    cat-2796    |   0.722 us    |            native_load_tls();

 ------------------------------------------
 | 0)    cat-2796    =>   events/-9   
 ------------------------------------------

 0)   events/-9    |               |    finish_task_switch() {
 0)   events/-9    |   0.789 us    |      _spin_unlock_irq();
 0)   events/-9    |   2.309 us    |    }
 0)   events/-9    | ! 269848.5 us |  }
 0)   events/-9    |   0.601 us    |  finish_wait();
 0)   events/-9    |   0.662 us    |  kthread_should_stop();
 0)   events/-9    |               |  run_workqueue() {
 0)   events/-9    |   1.136 us    |    _spin_lock_irq();
 0)   events/-9    |   0.918 us    |    _spin_unlock_irq();
 0)   events/-9    |               |    console_callback() {
 0)   events/-9    |               |      acquire_console_sem() {
 0)   events/-9    |               |        down() {
 0)   events/-9    |   1.534 us    |          _spin_lock_irqsave();
 0)   events/-9    |   0.812 us    |          _spin_unlock_irqrestore();
 0)   events/-9    |   4.369 us    |        }
 0)   events/-9    |   5.903 us    |      }
