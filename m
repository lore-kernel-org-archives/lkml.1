Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYJKHDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYJKHDP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbYJKGre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:47:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40189 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbYJKGrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:47:33 -0400
Date: Sat, 11 Oct 2008 08:47:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] fastboot tree for v2.6.28
Message-ID: <20081011064712.GA25451@elte.hu>
References: <20081010003241.GA23940@elte.hu> <alpine.LFD.2.00.0810101254240.3503@nehalem.linux-foundation.org> <20081010154929.6ec201fe@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010154929.6ec201fe@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > You can try to convince me otherwise, but I really do think this 
> > patch is fundamentally the wrong approach.
> 
> there's an angle here which I would like to bring up. There is a 
> fundamental difference between a spider functionality like USB, and 
> "leaf drivers". Yes USB should do it right, it's drivers are 
> effectively a midlayer. (and again, pull gregkh's tree and you'll get 
> that; although even with that there's a noticeable amount of time 
> spent there).
> 
> For leaf drivers, it's a matter of where you want to push the 
> functionality. With leaf drivers I mean things like the ACPI battery 
> driver (or other ACPI drivers), but also various PCI drivers that 
> don't have or are elaborate subsystems or boot dependencies. We could 
> make all their probing functions async in each driver, or we could 
> provide the most simple interface as is done in this case, they just 
> change how they declare their initcall. (I'll grant you that we could 
> also do a pci_register_device_async() like of helper, but that's just 
> solving part of the same problem)
> 
> Personally for leaf drivers, I think the initcall-level approach is 
> much less error prone.

i'd like to inject my first-hand testing experience with your patches: 

When i saw your patches then initially my impression was "oh my, this 
will break a ton of stuff", so i asked you to: make it default-off 
(against Andrew's suggestion to just remove the config and make it a 
compulsory feature), to add various mechanisms to disable and isolate 
it, should it break something - which i expected to be a near certainty.

But i was wrong. We had only a single bug in fastboot-v1 three months 
ago which i bisected back to this series, and you fixed that quickly. 
And CONFIG_FASTBOOT=y is definitely one of the popular features that 
testers enable and there's all sorts of weird systems that are being 
tested with tip/master.

So tip/fastboot has certainly been a problem free topic in its 3 months 
of lifetime - and it got propagated to linux-next early on as well.

Our -tip testsystems boot with CONFIG_FASTBOOT=y about 50% of the time, 
once every couple of minutes on this test-system:

 config-Fri_Oct_10_23_06_21_CEST_2008.good:CONFIG_FASTBOOT=y
 config-Fri_Oct_10_23_07_54_CEST_2008.good:CONFIG_FASTBOOT=y
 config-Fri_Oct_10_23_14_08_CEST_2008.good:CONFIG_FASTBOOT=y
 config-Fri_Oct_10_23_15_54_CEST_2008.good:CONFIG_FASTBOOT=y
 config-Fri_Oct_10_23_21_37_CEST_2008.good:CONFIG_FASTBOOT=y
 config-Fri_Oct_10_23_22_56_CEST_2008.good:CONFIG_FASTBOOT=y
 config-Fri_Oct_10_23_27_14_CEST_2008.good:CONFIG_FASTBOOT=y

i checked the logs, just yesterday that meant 354 fastboot-enabled 
bootups on just that single test-system. So while i fully expected 
fragility from this topic, neither our testing nor our testers saw 
fragility in practice.

	Ingo
