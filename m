Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936349Ab0B0WSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:18:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57068 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936308Ab0B0WSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:18:13 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
References: <4B882182.4030205@kernel.org>
	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>
	<4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org>
	<4B8995FB.9000908@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 27 Feb 2010 14:18:03 -0800
In-Reply-To: <4B8995FB.9000908@kernel.org> (Yinghai Lu's message of "Sat\, 27 Feb 2010 14\:00\:27 -0800")
Message-ID: <m1mxyue31g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
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

Yinghai Lu <yinghai@kernel.org> writes:

> On 02/27/2010 01:30 PM, Eric W. Biederman wrote:
> then will have all irq_desc for ioapic stay with BSP node.

This is what I am thinking....

static void __init setup_IO_APIC_irqs(void)
{
	int apic_id, pin, idx, irq;
	int notcon = 0;
	struct irq_desc *desc;
	struct irq_cfg *cfg;
	int node = cpu_to_node(boot_cpu_id);

	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");

	for(apic_id = 0; apic_id < nr_ioapics; apic_id++) {
		for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
			idx = find_irq_entry(apic_id, pin, mp_INT);
			if (idx == -1) {
				if (!notcon) {
					notcon = 1;
					apic_printk(APIC_VERBOSE,
						KERN_DEBUG " %d-%d",
						mp_ioapics[apic_id].apicid, pin);
				} else
					apic_printk(APIC_VERBOSE, " %d-%d",
						mp_ioapics[apic_id].apicid, pin);
				continue;
			}
			if (notcon) {
				apic_printk(APIC_VERBOSE,
					" (apicid-pin) not connected\n");
				notcon = 0;
			}
			
			irq = pin_2_irq(idx, apic_id, pin);

+			if ((apic_id > 0) && (irq > 16))
+				continue;

			
			/*
			 * Skip the timer IRQ if there's a quirk handler
			 * installed and if it returns 1:
			 */
			if (apic->multi_timer_check &&
				apic->multi_timer_check(apic_id, irq))
				continue;
			
			desc = irq_to_desc_alloc_node(irq, node);
			if (!desc) {
				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
				continue;
			}
			cfg = desc->chip_data;
			add_pin_to_irq_node(cfg, node, apic_id, pin);
			/*
			 * don't mark it in pin_programmed, so later acpi could
			 * set it correctly when irq < 16
			 */
			setup_IO_APIC_irq(apic_id, pin, irq, desc,
				irq_trigger(idx), irq_polarity(idx));
		}
	}
	
	if (notcon)
		apic_printk(APIC_VERBOSE,
			" (apicid-pin) not connected\n");
}


>> YH your current remapping patch looks like a pretty horrible hack
>> instead of real solution to the problem.  I honestly think starting
>> with it will just obscure what is going and make it harder to
>> introduce a clean gsi_to_irq/irq_to_gsi.
>
> good, the mapping looks much clear.

Thanks.  This code is just too convoluted to introduce many more
hacks and not have it fall over.

Eric
