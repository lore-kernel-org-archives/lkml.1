Return-Path: <linux-kernel-owner+w=401wt.eu-S966738AbXHIRqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966738AbXHIRqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965186AbXHIRpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:45:52 -0400
Received: from gw.goop.org ([64.81.55.164]:52785 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964774AbXHIRpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:45:51 -0400
Message-ID: <46BB5258.8040609@goop.org>
Date: Thu, 09 Aug 2007 10:43:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865468394005-git-send-email-gcosta@redhat.com> <11865468431616-git-send-email-gcosta@redhat.com> <200708081144.04119.ak@suse.de>
In-Reply-To: <200708081144.04119.ak@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> -static void discover_ebda(void)
>> +void native_ebda_info(unsigned *addr, unsigned *size)
>>     
>
> I guess it would be better to use the resources frame work here. 
> Before checking EBDA check if it is already reserved. Then lguest/Xen
> can reserve these areas and stop using it.
>   

What's the EBDA actually used for?  The only place which seems to use
ebda_addr is in the e820 code to avoid that area as RAM.

Seems to me that we can just arrange to have the early lguest/xen setup
code set the EBDA_ADDR pointer to NULL and make discover_ebda() special
case that to zero out ebda_addr/size.

>> +/* Overridden in paravirt.c if CONFIG_PARAVIRT */
>> +void __attribute__((weak)) memory_setup(void)
>> +{
>> +       return setup_memory_region();
>> +}
>> +
>> +
>>  void __init setup_arch(char **cmdline_p)
>>  {
>>  	printk(KERN_INFO "Command line: %s\n", boot_command_line);
>> @@ -231,12 +255,19 @@ void __init setup_arch(char **cmdline_p)
>>  	saved_video_mode = SAVED_VIDEO_MODE;
>>  	bootloader_type = LOADER_TYPE;
>>
>> +	/*
>> +	 * By returning non-zero here, a paravirt impl can choose to
>> +	 * skip the rest of the setup process
>> +	 */
>> +	if (paravirt_arch_setup())
>> +		return;
>>     
>
> Sorry, but that's an extremly ugly and clumpsy interface and will lead
> to extensive code duplication in hypervisors because so much code
> is disabled.
>
> This needs to be solved in some better way.
>   

Yeah, it seems a bit hamfisted.  Looks like it would be better to deal
with it by some combination of:

   1. implement pv analogues of existing functions
   2. try to neutralize functions we don't care about in pv-land
   3. refactoring the setup() function to make the pv-friendly and
      pv-hostile parts clearly distinct

and remember: native isn't a special case; its just another pv driver.

    J
