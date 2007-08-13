Return-Path: <linux-kernel-owner+w=401wt.eu-S943614AbXHMQUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943614AbXHMQUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947878AbXHMPFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:05:30 -0400
Received: from mail.ocs.com.au ([203.34.248.175]:24361 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S946805AbXHMPFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:05:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: Andi Kleen <ak@suse.de>
cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] x86: optionally show last exception from/to register contents 
In-reply-to: Your message of "Mon, 13 Aug 2007 15:08:45 +0200."
             <20070813130845.GA3406@bingen.suse.de> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 14 Aug 2007 01:05:17 +1000
Message-ID: <18110.1187017517@ocs10w.ocs.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen (on Mon, 13 Aug 2007 15:08:45 +0200) wrote:
>On Mon, Aug 13, 2007 at 12:33:05PM +0100, Jan Beulich wrote:
>
>
>>  
>>  	if (cpu_has_ds) {
>>  		unsigned int l1;
>> --- linux-2.6.23-rc3/arch/i386/kernel/traps.c	2007-08-13 08:59:45.000000000 +0200
>> +++ 2.6.23-rc3-x86-ler/arch/i386/kernel/traps.c	2007-08-07 10:42:55.000000000 +0200
>> @@ -321,6 +321,13 @@ void show_registers(struct pt_regs *regs
>>  		unsigned int code_len = code_bytes;
>>  		unsigned char c;
>>  
>> +		if (__get_cpu_var(ler_msr)) {
>> +			u32 from, to, hi;
>> +
>> +			rdmsr(__get_cpu_var(ler_msr), from, hi);
>> +			rdmsr(__get_cpu_var(ler_msr) + 1, to, hi);
>> +			printk("LER: %08x -> %08x\n", from, to);
>> +		}
>
>This seems racy -- AFAIK the MSR will record the last branch
>before an interrupt too, and the trap handlers enable interrupts
>before coming here. 
>
>Can't think of a good way to avoid that for page fault at least
>without impacting interrupt latency or reading the MSR always.

KDB used to have a "last branch recording" (lbr) feature.  The page
fault handler was modified to disable lbr before entering
do_page_fault().  Nobody seemed to care about the slight slowdown but
also nobody seemed to be using that feature for debugging, we rarely
get wild branches into the middle of nowhere.  lbr was messy to
maintain for very little gain, so I removed it from KDB at
2.6.17-i386-2.

