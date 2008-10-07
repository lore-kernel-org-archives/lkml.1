Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYJGUWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYJGUWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYJGUWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:22:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbYJGUWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:22:22 -0400
Date: Tue, 7 Oct 2008 13:21:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: eranian@gmail.com
Cc: eranian@googlemail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org, tglx@linutronix.de,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: NMI watchdog setup_lapic_nmi_watchdog() problem
Message-Id: <20081007132158.009669d2.akpm@linux-foundation.org>
In-Reply-To: <7c86c4470810070845w1346107cx211148c52fd03b68@mail.gmail.com>
References: <7c86c4470810070845w1346107cx211148c52fd03b68@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008 17:45:32 +0200
"stephane eranian" <eranian@googlemail.com> wrote:

> Hello,
> 
> I was doing some more testing with perfmon when I ran into
> a problem with the NMI watchdog code in 2.6.27-rc8.
> 
> Since 2.6.20, it is possible to enable/disable the NMI watchdog
> on-the-fly via /proc/sys/kernel/nmi_watchdog. This is a nice option
> which avoids having to reboot the kernel.
> 
> Enabling/disabling the NMI watchdog uses two internal functions
> enable_lapic_nmi_watchdog() and disable_lapic_nmi_watchdog().
> 
> Enable_lapic_nmi_watchdog() uses  a IPI handler to setup the
> APIC on each CPU. However, it turns out that this handler, namely,
> setup_apic_nmi_watchdog() relies on some explicit ordering constraint
> due to suspend/resume constraints as explained in the comment
> below:
> 
> void setup_apic_nmi_watchdog(void *unused)
> {
>         if (__get_cpu_var(wd_enabled))
>                 return;
> 
>         /* cheap hack to support suspend/resume */
>         /* if cpu0 is not active neither should the other cpus */
>         if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
>                 return;
> 
>         switch (nmi_watchdog) {
> [snip]
> }
> 
> Supposing watchdog was disabled via /proc, nmi_active = 0. Then if you
> re-enable, and if CPU0 is not the first to execute the IPI handler, then none
> of the other CPUS will re-enable their NMI watchdog timer.  On a quad-core
> system, I have seen, for instance, 2 out of 4 with NMI watchdogs re-enabled.
> 
> I am not an expert at suspend/resume. I am assuming there was a race condition
> there and that's why this code was added early on. The problem is that it now
> conflicts with the /proc option.
> 
> It is not clear to me how this works during boot. Obviously the order
> is respected
> and all CPUs have their NMI watchdog enabled.
> 
> Until I understand the suspend/resume issue, it is hard to provide a
> fix for this.
> 
> Any comments?

The "cheap hack" was added in September 2006.

2.6.20 was released in Feb 2007.

So presumably this problem has always been there, since
/proc/sys/kernel/nmi_watchdog was first added, only nobody has hit it
before.

Have you only recently started to use /proc/sys/kernel/nmi_watchdog, or
did it work OK on any earlier kernel?

