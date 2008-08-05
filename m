Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbYHESJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbYHESJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761233AbYHESIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:08:52 -0400
Received: from gw.goop.org ([64.81.55.164]:40891 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525AbYHESIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:08:50 -0400
Message-ID: <48989727.8090804@goop.org>
Date: Tue, 05 Aug 2008 11:08:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Christian Borntraeger <cborntra@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Spinlock recursion in hvc_poll
References: <48973E59.1000904@citrix.com> <489742CF.2030305@goop.org> <4898096F.4030607@citrix.com> <48987526.40500@goop.org> <48987DD8.8080009@citrix.com>
In-Reply-To: <48987DD8.8080009@citrix.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
>>> Well I say fixed - it just means I can proceed to a spinlock recursion
>>> BUG() 2 secs into the boot process, but it should be easier to track down
>>> with printks and a coherent stack dump at my disposal.
>>>   
>>>       
>> What's the backtrace on this?
>>     
>
> I just turned DEBUG_SPINLOCKS back on to try catch this bug again, and it
> seems to occur (very roughly) 1/10 of the time, with nothing changing between
> runs.
>   

OK, I added some cc:s.

This is definitely a relatively new bug, because I was running with 
spinlock debugging on all the time a couple of months ago, with no problems.

> Backtrace attached.
>   
(Should paste it inline so it gets quoted in replies.)

> [    0.752696] Freeing unused kernel memory: 284k freed
> [    0.772757] BUG: spinlock recursion on CPU#0, swapper/1
> [    0.772782]  lock: eaca7000, .magic: dead4ead, .owner: swapper/1, .owner_cpu: 0
> [    0.772814] Pid: 1, comm: swapper Not tainted 2.6.27-rc1 #350
> [    0.772843]  [<c021f48d>] spin_bug+0x7c/0x87
> [    0.772878]  [<c021f5d5>] _raw_spin_lock+0x35/0xda
> [    0.772904]  [<c030c501>] _spin_lock_irqsave+0x3c/0x45
> [    0.772932]  [<c027a394>] ? hvc_poll+0x15/0x1ac
> [    0.772964]  [<c027a394>] hvc_poll+0x15/0x1ac
>   
OK, I suspect this is a result of Christian Borntraeger's patches to 
make hvc console cope without interrupts.  It's certainly a suggestive 
set of changes in the right place in the code.

But I have to admit I didn't look at the patches very closely when they 
went by, so I'm just finger-pointing at the moment.  Perhaps it's a 
pre-existing bug.

    J

> [    0.772990]  [<c0166b1f>] ? ftrace_record_ip+0x19f/0x1ee
> [    0.773024]  [<c027a6a2>] hvc_handle_interrupt+0xf/0x21
> [    0.773051]  [<c015f7dc>] handle_IRQ_event+0x1f/0x4f
> [    0.773080]  [<c0160d1f>] handle_level_irq+0xc4/0xd1
> [    0.773107]  [<c010b3ee>] do_IRQ+0x5c/0x7a
> [    0.773133]  [<c0263573>] xen_evtchn_do_upcall+0xad/0x109
> [    0.773164]  [<c01096cb>] xen_do_upcall+0x7/0xc
> [    0.773189]  [<c0102227>] ? _stext+0x227/0x1000
> [    0.773219]  [<c0105be3>] ? xen_force_evtchn_callback+0xf/0x14
> [    0.773253]  [<c0106366>] check_events+0x8/0xe
> [    0.773278]  [<c0106297>] ? xen_irq_enable_direct_end+0x0/0x1
> [    0.773310]  [<c018bc07>] ? cache_alloc_refill+0x251/0x4b4
> [    0.773342]  [<c0105be3>] ? xen_force_evtchn_callback+0xf/0x14
> [    0.773375]  [<c0106366>] ? check_events+0x8/0xe
> [    0.773405]  [<c018bef8>] __kmalloc+0x8e/0xd6
> [    0.773428]  [<c010972b>] ? mcount_call+0x5/0xa
> [    0.773457]  [<c01c3490>] __proc_create+0x78/0xfb
> [    0.773485]  [<c01c380a>] proc_mkdir_mode+0x23/0x48
> [    0.773512]  [<c01c3843>] proc_mkdir+0x14/0x16
> [    0.773536]  [<c016112e>] register_irq_proc+0x70/0xca
> [    0.773562]  [<c0160013>] setup_irq+0x1bc/0x1f2
> [    0.773587]  [<c01600d2>] request_irq+0x89/0xa6
> [    0.773614]  [<c027a693>] ? hvc_handle_interrupt+0x0/0x21
> [    0.773645]  [<c027a681>] notifier_add_irq+0x2f/0x41
> [    0.773670]  [<c027a2aa>] hvc_open+0x6f/0xc9
> [    0.773693]  [<c027a23b>] ? hvc_open+0x0/0xc9
> [    0.773720]  [<c026b436>] tty_open+0x198/0x299
> [    0.773746]  [<c0190fbe>] chrdev_open+0x12c/0x143
> [    0.773772]  [<c018d170>] __dentry_open+0x113/0x201
> [    0.773797]  [<c018d282>] nameidata_to_filp+0x24/0x38
> [    0.773823]  [<c0190e92>] ? chrdev_open+0x0/0x143
> [    0.773852]  [<c019845d>] do_filp_open+0x351/0x636
> [    0.773878]  [<c010972b>] ? mcount_call+0x5/0xa
> [    0.773907]  [<c021f5f3>] ? _raw_spin_lock+0x53/0xda
> [    0.773937]  [<c021f50c>] ? _raw_spin_unlock+0x74/0x78
> [    0.773967]  [<c018cf19>] ? get_unused_fd_flags+0xad/0xb7
> [    0.773997]  [<c018cf68>] do_sys_open+0x45/0xbb
> [    0.774022]  [<c018d02a>] sys_open+0x23/0x2b
> [    0.774046]  [<c0103048>] init_post+0x2a/0xce
> [    0.774070]  [<c010967b>] ? kernel_thread_helper+0x7/0x10
> [    0.774101]  =======================
>   

