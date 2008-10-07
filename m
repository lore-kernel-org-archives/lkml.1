Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYJGPpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYJGPpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYJGPpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:45:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:39496 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYJGPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=q7zlXhLM4lptO3rAmjzwkTcLQLeAib36SpVtFd9h2d/yB4k2JKIFtOEW8NWUpEZ6ba
         LUID7YtKEjWpYH4Wx0FCZIHE7uWe+xaJcebwbGTGzQlT2d+wU19Na4QoXVFGv23iMEV1
         wbRubLAjIxJrDV6AMRluX5yqDFm9ih1WQS9V8=
Message-ID: <7c86c4470810070845w1346107cx211148c52fd03b68@mail.gmail.com>
Date: Tue, 7 Oct 2008 17:45:32 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: linux-kernel@vger.kernel.org
Subject: NMI watchdog setup_lapic_nmi_watchdog() problem
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <andi@firstfloor.org>, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was doing some more testing with perfmon when I ran into
a problem with the NMI watchdog code in 2.6.27-rc8.

Since 2.6.20, it is possible to enable/disable the NMI watchdog
on-the-fly via /proc/sys/kernel/nmi_watchdog. This is a nice option
which avoids having to reboot the kernel.

Enabling/disabling the NMI watchdog uses two internal functions
enable_lapic_nmi_watchdog() and disable_lapic_nmi_watchdog().

Enable_lapic_nmi_watchdog() uses  a IPI handler to setup the
APIC on each CPU. However, it turns out that this handler, namely,
setup_apic_nmi_watchdog() relies on some explicit ordering constraint
due to suspend/resume constraints as explained in the comment
below:

void setup_apic_nmi_watchdog(void *unused)
{
        if (__get_cpu_var(wd_enabled))
                return;

        /* cheap hack to support suspend/resume */
        /* if cpu0 is not active neither should the other cpus */
        if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
                return;

        switch (nmi_watchdog) {
[snip]
}

Supposing watchdog was disabled via /proc, nmi_active = 0. Then if you
re-enable, and if CPU0 is not the first to execute the IPI handler, then none
of the other CPUS will re-enable their NMI watchdog timer.  On a quad-core
system, I have seen, for instance, 2 out of 4 with NMI watchdogs re-enabled.

I am not an expert at suspend/resume. I am assuming there was a race condition
there and that's why this code was added early on. The problem is that it now
conflicts with the /proc option.

It is not clear to me how this works during boot. Obviously the order
is respected
and all CPUs have their NMI watchdog enabled.

Until I understand the suspend/resume issue, it is hard to provide a
fix for this.

Any comments?
