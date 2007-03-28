Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbXC1NoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbXC1NoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXC1NoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:44:00 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:58110 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXC1Nn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jI4BDNa1gpBXdEWC4dyKUZfpuEGP7mBzw/naq2/dvlFNgwnyEXIeFTzoRZrdHadtL4GGBhGtGfTyOJIQeTbwajQnhWhHyJs/vXvWE1GsR1z/yB/MNUB+fPKiKUvF+57ecsf0ggSbKQA29HrDaICHIBT6YB53dygXLbcMuuX0uY0=
From: Maxim <maximlevitsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Date: Wed, 28 Mar 2007 15:43:46 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <b6a2187b0703261046r46782eedv64464ceddb44bc27@mail.gmail.com> <1175065468.4017.1.camel@chaos>
In-Reply-To: <1175065468.4017.1.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281543.47049.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 09:04:28 Thomas Gleixner wrote:
> On Tue, 2007-03-27 at 01:46 +0800, Jeff Chua wrote:
> > On 3/27/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > > It's related. I tested without CONFIG_HPET_TIMER, and now my X60 can
> > > > suspend and resume from RAM (s2ram). Even better, it works
> > > > with/without CONFIG_NO_HZ.
> > >
> > > Does the patch below fix the HPET_TIMER=y case ?
> > 
> > Thomas, I tried, but it didn't help. Upon resume from ram, "date"
> > still didn't advance.
> 
> Can you please issue a SysRq-Q in this situation and provide the dmesg
> output ?
> 
> Thanks,
> 
> 	tglx
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Hi,
	I almost sure Iknow why this happens,
		The problem is that both hpet clock source and hpet clockevents doesn't have a suspend/resume function
		On resume we should enable the main counter _and_ enable legacy replacement mode,
		On my system main counter in enabled, by I think by bios, but legacy replacement mode is not, so if
		a system doesn't use lapic as a tick source, but use hpet+broadcast, it will hang for sure on resume, and i tested it

		The patch below is a temporally fix, until clock-events and clocksources will get proper suspend/resume hooks:

		Regards,
			Maxim Levitsky

---

Add suspend/resume for HPET
Signed-off-by: Maxim Levitsky <maximlevisky@gmail.com>

---

diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index 0fd9fba..a1ec79e 100644
--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -152,6 +152,16 @@ static void hpet_set_mode(enum clock_event_mode mode,
 	unsigned long cfg, cmp, now;
 	uint64_t delta;
 
+
+	if ( mode != CLOCK_EVT_MODE_UNUSED && mode != CLOCK_EVT_MODE_SHUTDOWN)
+	{
+		unsigned long cfg = hpet_readl(HPET_CFG);
+		cfg |= HPET_CFG_ENABLE | HPET_CFG_LEGACY;
+		hpet_writel(cfg, HPET_CFG);
+		
+	}
+		
+
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * hpet_clockevent.mult;

