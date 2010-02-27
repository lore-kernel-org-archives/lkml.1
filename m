Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030681Ab0B0TER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:04:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35566 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030667Ab0B0TEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:04:16 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: tip-bot for Yinghai Lu <yinghai@kernel.org>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       trenn@suse.de
References: <4B882182.4030205@kernel.org>
	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
	<20100227130113.GA18661@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 27 Feb 2010 11:04:03 -0800
In-Reply-To: <20100227130113.GA18661@elte.hu> (Ingo Molnar's message of "Sat\, 27 Feb 2010 14\:01\:13 +0100")
Message-ID: <m1y6ieo5zw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Causes:
>
>  arch/x86/kernel/apic/io_apic.c:1042: error: implicit declaration of function ?remap_ioapic_gsi_to_irq?
>
> Please send delta fix.

I am certain I have said this before but the entire concept of 
irq != gsi is broken.  We used to have code that did this and it was a
non-ending source of problems that we finally removed after we pushed
up the limit on the number of irqs.

We already have the irq_2_pin list which allows for arbitrary mappings
between irqs and the ioapics and pins.  So there should be no problem
mapping irq to gsi and assigning irqs to arbitrary ioapic pins.

I have yet to see something that even purports to be an explanation
of why our handling of acpi int_src_overrides is broken and why
it needs the mess that is a remapper.

I don't doubt YHs changes fix something but this feels like a direction
that trades off one bug for another instead of actually fixing the code.

It does look like we have weird old hard codes in some of the
irq_2_pin and pin_2_irq paths that YH is touching, and it may make sense
to introduce a concept of ioapic pin index.  

The touching of drivers/pnp/pnpacpi/rsparser.c feels like just the tip of
the iceberg in dealing with weird bugs if we continue down this path.

Eric
