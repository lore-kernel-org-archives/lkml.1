Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYI3NSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYI3NSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYI3NSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:18:14 -0400
Received: from fhw-relay07.plus.net ([212.159.14.148]:55280 "EHLO
	fhw-relay07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYI3NSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:18:14 -0400
Message-ID: <48E22720.9030603@yahoo.com>
Date: Tue, 30 Sep 2008 14:18:24 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com> <48D9460C.5040504@yahoo.com> <48D96725.1080909@yahoo.com> <20080927204834.GA31650@elte.hu> <48DFEF8A.3000502@yahoo.com> <20080929083709.GD18663@elte.hu> <48E16097.8060905@yahoo.com> <20080930112241.GC21367@elte.hu>
In-Reply-To: <20080930112241.GC21367@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 41ff41c45fbafd1dbd2d5e076d267175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
>>              cat-7717  [000]  1392.941867: __tasklet_schedule <-ath5k_intr
>>              cat-7717  [000]  1393.005963: __tasklet_schedule <-ath5k_intr
>>              cat-7717  [000]  1393.033222: __switch_to <-schedule
>>
>> Here a schedule seemingly doesn't happen for a few hundredths of a second...
> 
> that's about 60 msecs. ath5k_intr IRQ handling overhead? IRQ handlers 
> are non-preemptible. (even under CONFIG_PREEMPT=y)

What about the piece leading up to that:

              cat-7717  [000]  1392.752092: del_timer <-schedule_timeout
              cat-7717  [000]  1392.772263: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.773224: __tasklet_schedule <-kbd_event
              cat-7717  [000]  1392.773225: schedule_console_callback 
<-kbd_event
              cat-7717  [000]  1392.773225: schedule_work 
<-schedule_console_callback
              cat-7717  [000]  1392.773226: queue_work <-schedule_work
              cat-7717  [000]  1392.773232: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.773240: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.773251: schedule_delayed_work 
<-put_queue
              cat-7717  [000]  1392.773251: queue_delayed_work 
<-schedule_delayed_work
              cat-7717  [000]  1392.773258: schedule_console_callback 
<-kbd_event
              cat-7717  [000]  1392.773258: schedule_work 
<-schedule_console_callback
              cat-7717  [000]  1392.773259: queue_work <-schedule_work
              cat-7717  [000]  1392.773267: schedule_console_callback 
<-kbd_event
              cat-7717  [000]  1392.773268: schedule_work 
<-schedule_console_callback
              cat-7717  [000]  1392.773268: queue_work <-schedule_work
              cat-7717  [000]  1392.807931: account_scheduler_latency 
<-enqueue_task_fair
              cat-7717  [000]  1392.839464: __tasklet_schedule <-ath5k_intr

Here's a snippet from 
http://sucs.org/~sits/test/eeepc-debug/20080929/trace-on-battery.txt.bz2 :
              cat-7717  [000]  1392.752092: del_timer <-schedule_timeout
              cat-7717  [000]  1392.752092: acpi_ec_check_status 
<-acpi_ec_wait
              cat-7717  [000]  1392.752093: constant_test_bit 
<-acpi_ec_check_status
              cat-7717  [000]  1392.752095: mutex_unlock 
<-acpi_ec_transaction
              cat-7717  [000]  1392.752096: acpi_ex_enter_interpreter 
<-acpi_ev_address_space_dispatch
              cat-7717  [000]  1392.752097: acpi_os_wait_semaphore 
<-acpi_ut_acquire_mutex
              cat-7717  [000]  1392.752097: down_timeout 
<-acpi_os_wait_semaphore
              cat-7717  [000]  1392.752098: acpi_ex_release_global_lock 
<-acpi_ex_read_data_from_field
              cat-7717  [000]  1392.752099: acpi_ex_release_mutex_object 
<-acpi_ex_release_global_lock
              cat-7717  [000]  1392.752100: acpi_ev_release_global_lock 
<-acpi_ex_release_mutex_object
              cat-7717  [000]  1392.752100: __acpi_release_global_lock 
<-acpi_ev_release_global_lock
              cat-7717  [000]  1392.752101: acpi_os_signal_semaphore 
<-acpi_ev_release_global_lock
              cat-7717  [000]  1392.752102: up <-acpi_os_signal_semaphore
...
              cat-7717  [000]  1392.839447: 
acpi_ex_truncate_for32bit_table <-acpi_ds_exec_end_op
              cat-7717  [000]  1392.839447: acpi_ps_next_parse_state 
<-acpi_ps_parse_loop
              cat-7717  [000]  1392.839448: acpi_ps_complete_op 
<-acpi_ps_parse_loop
              cat-7717  [000]  1392.839448: acpi_ps_complete_this_op 
<-acpi_ps_complete_op
              cat-7717  [000]  1392.839449: acpi_ps_delete_parse_tree 
<-acpi_ps_complete_this_op
              cat-7717  [000]  1392.839449: acpi_ps_get_arg 
<-acpi_ps_delete_parse_tree
              cat-7717  [000]  1392.839450: acpi_ps_get_opcode_info 
<-acpi_ps_get_arg
              cat-7717  [000]  1392.839450: acpi_ps_get_arg 
<-acpi_ps_delete_parse_tree
              cat-7717  [000]  1392.839451: acpi_ps_get_opcode_info 
<-acpi_ps_get_arg
              cat-7717  [000]  1392.839452: do_IRQ <-common_interrupt
              cat-7717  [000]  1392.839453: irq_enter <-do_IRQ
              cat-7717  [000]  1392.839453: irq_to_desc <-do_IRQ
              cat-7717  [000]  1392.839454: handle_fasteoi_irq <-do_IRQ
              cat-7717  [000]  1392.839455: handle_IRQ_event 
<-handle_fasteoi_irq
              cat-7717  [000]  1392.839455: usb_hcd_irq <-handle_IRQ_event
              cat-7717  [000]  1392.839456: uhci_irq <-usb_hcd_irq
              cat-7717  [000]  1392.839458: ath5k_intr <-handle_IRQ_event
              cat-7717  [000]  1392.839459: ath5k_hw_is_intr_pending 
<-ath5k_intr
              cat-7717  [000]  1392.839461: ath5k_hw_get_isr <-ath5k_intr
              cat-7717  [000]  1392.839464: __tasklet_schedule <-ath5k_intr


Why didn't another process cut in from 1392.752092 to 1392.839464? In 
the schedule grep normally runs for cat are half as long e.g.:

           <idle>-0     [000]  1392.747102: __switch_to <-schedule
              cat-7717  [000]  1392.747103: del_timer <-schedule_timeout
              cat-7717  [000]  1392.747107: 
schedule_timeout_uninterruptible <-msleep
              cat-7717  [000]  1392.747107: schedule_timeout 
<-schedule_timeout_uninterruptible
              cat-7717  [000]  1392.747108: init_timer <-schedule_timeout
              cat-7717  [000]  1392.747108: __mod_timer <-schedule_timeout
              cat-7717  [000]  1392.747111: __switch_to <-schedule
           <idle>-0     [000]  1392.749067: account_scheduler_latency 
<-enqueue_task_fair


Further why (after taking a break to process the ath5k interrupt) did it 
not schedule another process other than cat until 1393.033226:

              cat-7717  [000]  1393.033215: set_normalized_timespec 
<-ktime_get_ts
              cat-7717  [000]  1393.033216: ktime_add_safe 
<-hrtimer_start_range_ns
              cat-7717  [000]  1393.033217: ktime_add_safe 
<-hrtimer_start_range_ns
              cat-7717  [000]  1393.033217: enqueue_hrtimer 
<-hrtimer_start_range_ns
              cat-7717  [000]  1393.033222: __switch_to <-schedule
  hald-addon-inpu-3237  [000]  1393.033226: fget_light <-do_sys_poll

-- 
Sitsofe | http://sucs.org/~sits/
