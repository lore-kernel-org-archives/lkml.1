Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbYF3RuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbYF3RuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYF3Rt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:49:59 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34892 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbYF3Rt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:49:58 -0400
Message-ID: <48691CC5.4050603@sgi.com>
Date: Mon, 30 Jun 2008 10:49:57 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com> <485ADBCF.5040101@goop.org>
In-Reply-To: <485ADBCF.5040101@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
...
>> I'm not sure yet what to put into acpi_save_state_mem:
>>
>>         initial_code = (unsigned long)wakeup_long64;
>> +       /* ZZZ initial_pda = (unsigned long)?; */
>>   
> 
> You'll need to change wakeup_long64 to load the right value into the
> GS_BASE msr anyway.
> 
>    J

I'm afraid I don't quite understand the transitioning of the
ACPI states to figure out the correct thing to do.  My first
inclination would be to:  [sorry, cut and pasted]

--- linux-2.6.tip.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6.tip/arch/x86/kernel/acpi/sleep.c
@@ -89,6 +89,8 @@ int acpi_save_state_mem(void)
 #ifdef CONFIG_SMP
        stack_start.sp = temp_stack + 4096;
 #endif
+       early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+       initial_pda = (unsigned long)get_cpu_pda(cpu);
        initial_code = (unsigned long)wakeup_long64;
        saved_magic = 0x123456789abcdef0;
 #endif /* CONFIG_64BIT */


But I'd like some confirmation that this is right thing to do...

[This mimics what smpboot.c:do_boot_cpu() does.]

Len - I'll cc you on the full patch submission shortly.

Thanks,
Mike
