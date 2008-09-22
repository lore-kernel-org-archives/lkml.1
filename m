Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYIVRr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYIVRr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYIVRrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:47:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36846 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIVRrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:47:19 -0400
Date: Mon, 22 Sep 2008 19:47:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, prarit@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: setup before enabling NMI watchdog
Message-ID: <20080922174709.GB10535@elte.hu>
References: <20080922171347.GI16840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922171347.GI16840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Aristeu Rozanski <aris@redhat.com> wrote:

> There's a small window when NMI watchdog is being set up that if any NMIs
> are triggered, the NMI code will make make use of not initalized wd_ops
> elements:
> 	void setup_apic_nmi_watchdog(void *unused)
> 	{       
> 		if (__get_cpu_var(wd_enabled))
> 			return;
> 
> 		/* cheap hack to support suspend/resume */
> 		/* if cpu0 is not active neither should the other cpus */
> 		if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
> 			return;
> 
> 		switch (nmi_watchdog) {
> 		case NMI_LOCAL_APIC:
> 			/* enable it before to avoid race with handler */
> -->			__get_cpu_var(wd_enabled) = 1;
> -->			if (lapic_watchdog_init(nmi_hz) < 0) {
> (...)
> 	asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> 	{       
> 	(...)
> 			if (nmi_watchdog_tick(regs, reason))
> 				return;
> (...)
> 	notrace __kprobes int
> 	nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
> 	{       
> 	(...)
> 		if (!__get_cpu_var(wd_enabled))
> 			return rc;
> 		switch (nmi_watchdog) {
> 		case NMI_LOCAL_APIC:
> 			rc |= lapic_wd_event(nmi_hz);
> (...)
> int lapic_wd_event(unsigned nmi_hz)
> {       
> 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
> 	u64 ctr;
> 
> -->	rdmsrl(wd->perfctr_msr, ctr);
> 
> and wd->*_msr will be initialized on each processor type specific setup, after
> enabling NMIs for PMIs. Since the counter was just set, the chances of an
> performance counter generated NMI is minimal, but any other unknown NMI would
> trigger the problem. This patch fixes the problem by setting everything up
> before enabling performance counter generated NMIs and will set wd_enabled
> using a callback function.
> 
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> Acked-by: Don Zickus <dzickus@redhat.com>
> Acked-by: Prarit Bhargava <prarit@redhat.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

applied to tip/x86/nmi-watchdog, thanks Aristeu!

	Ingo
