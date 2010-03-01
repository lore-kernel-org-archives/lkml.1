Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0CAThg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:37:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43828 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0CAThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:37:34 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
References: <4B882182.4030205@kernel.org>
	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>
	<4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org>
	<4B8995FB.9000908@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Mar 2010 11:37:26 -0800
In-Reply-To: <4B8995FB.9000908@kernel.org> (Yinghai Lu's message of "Sat\, 27 Feb 2010 14\:00\:27 -0800")
Message-ID: <m18wabzvd5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> /* By default isa irqs are identity mapped to gsis */
>> unsigned int isa_irq_to_gsi[16] = {
>> 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
>> };
>> 
>> unsigned int gsi_to_irq(unsigned int gsi)
>> {
>> 	unsigned int irq = gsi + 16;
>> 	unsigned int i;
>> 	for (i = 0; i < 16; i++) {
>> 		if (isa_irq_to_gsi[i] == gsi)
>> 			irq = i;
>> 	}
>> 	return irq;
>> }

I just realized that we already have this function in
arch/x86/kernel/acpi/boot.c and arch/ia64/kernel/acpi.c it is called:
acpi_gsi_to_irq()

We still need this implementation but it will get really confusing if
we have two functions with the same name trying to do the same job.

I am relieved to see this because this should mean we shouldn't have
many hard fixed assumptions that irq == gsi.

This does mean though that your patch has a real bug in it because
you have not updated acpi_gsi_to_irq.

Eric

>> unsigned int irq_to_gsi(unsigned int irq)
>> {
>> 	unsigned int gsi;
>> 	if (irq < 16) {
>> 		gsi = isa_irq_to_gsi[irq];
>> 	} else {
>>         	gsi = irq - 16;
>>         }
>>         return gsi;
>> }
