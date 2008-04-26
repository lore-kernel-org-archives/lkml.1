Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYDZSjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYDZSjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYDZSjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:39:09 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:58654 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbYDZSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k10dYnt+Fyc1qzzhTrgL1/XYO+pqd9l8n3Fu9hfd4FBtQx8HAymz3bwmauiV7c/EHLWqr5/mLrCt0wCjpHrhbpeXc5XjCqPlW55ZHp+hCuTQZRYw3+xPZzkC0uN8qhmiNb0mXjcZpopre0ufspIGLNS+SmgdVGpJHHr5Ro65ysM=
Message-ID: <dd18b0c30804261139s7ab20704l5d86e2ddd65f34a3@mail.gmail.com>
Date: Sat, 26 Apr 2008 18:39:06 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: spinlock lockup on CPU#0
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080426112907.77613dee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804231841m3bbfab44x53d635b7ea6fc58d@mail.gmail.com>
	 <20080426112907.77613dee.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 6:29 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Thu, 24 Apr 2008 01:41:32 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
>
>  > Hello, I recorded a .mov of a spinlock, but cant seem to send it out,
>  > so I have to manually write it down:
>  >
>  > BUG: spinlock lockup on CPU#0, swapper/0, c17fa6c0
>  > Pid: 0. swapper Not tainted 2.6.25-03562-g3dc5063 #1
>  > [<c0219fbb>]  _raw_spin_lock+0xd5/0xf9
>  > [<c0377c6b>] _spin_lock+0x8/0xa
>  > [<c011cdce>]  task_rq_lock+0x44/0x6b
>  > [<c011cfb4>]   try_to_wake+0x2a/0x1c4
>  > [<co11d159>]  default_wake_function+0xb/0xd
>  > [<co118847>] __wake_up_common+0x2f/0x5a
>  > [<c011bc11>] complete+0x2b/0x3e
>  > [<c02ad79a>] usb_api_blocking_completion+0x13/0x15
>  > [<c02abadc>] usb_hcd_giveback_urb+0x52/0x82
>  > [<f88686c7>] ehci_urb_done+0x6f/0x7c [ehci_hcd]
>  > [<f8869614>] qh_completions+0x2d7/0x348 [ehci_hcd]
>  > [<f8869721>] ehci_work+0x9c [ehci_hcd]
>  > [<c0107c35>] ? sched_clock+0xb/0x1c
>  > [<c0119bec>] ? __update_rq_clock+0x94/0x15a
>  > [<f886c827>] ehci_irq+0x138/0x15f [ehci_hcd]
>  > [<c02abd9> ] usb_hcd_irq+0x23/0x51
>  > [<c0151c43>] handle_IRQ_event+0x2a/0x5a
>  > [<c0152d2c>] handle_fasteoi_irq+0x74/0xb6
>  > [<c01058c5>] do_IRQ+0x71/0x8c
>  > [<c01042f7>] common_interrupt+0x23/0x28
>  > [<c011fb07>] ? sched_clock_idle_wakeup_event+0x5b/0x74
>  > [<c02cc212>] acpi_idle_enter_bm+0x2a4/0x31f    [processor]
>  > [<c02cc212>] cpuidle_idle_call+0x5c/0x8c
>  > [<c02cc1b4>] ? cpuidle_idle_call+0x0/0x8c
>  > [<c0102571>] cpu_idle+0xb1/0xd1
>  > [<c036b371>] reset_init+0x49/0x4b
>  > =====================================================
>  >
>  >
>  > Hopefully the numbers are right, and hopefully this provides enough
>  > info to help the kernel out
>
>  Well that's cute.  At a guess I'd say that acpi_processor_idle() managed to
>  call sched_clock_idle_wakeup_event() with local interrupts enabled.  We
>  took an interrupt with rq->lock held and things went downhill from there.
>
>  Can you add this please, see if it triggers?
>
>
>  --- a/kernel/sched.c~a
>  +++ a/kernel/sched.c
>  @@ -811,6 +811,7 @@ void sched_clock_idle_sleep_event(void)
>   {
>         struct rq *rq = cpu_rq(smp_processor_id());
>
>  +       WARN_ON(!irqs_disabled());
>         spin_lock(&rq->lock);
>         __update_rq_clock(rq);
>         spin_unlock(&rq->lock);
>  @@ -826,6 +827,7 @@ void sched_clock_idle_wakeup_event(u64 d
>         struct rq *rq = cpu_rq(smp_processor_id());
>         u64 now = sched_clock();
>
>  +       WARN_ON(!irqs_disabled());
>         rq->idle_clock += delta_ns;
>         /*
>          * Override the previous timestamp and ignore all
>  _
>
>

Yeah, I dont mind adding this to see what happens.
regards

-- 
Justin P. Mattock
