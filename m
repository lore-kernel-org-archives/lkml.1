Return-Path: <linux-kernel-owner+w=401wt.eu-S936523AbZAPRzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936523AbZAPRzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZAPRzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:55:22 -0500
Received: from relay2.sgi.com ([192.48.179.30]:52600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762101AbZAPRzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:55:20 -0500
Message-ID: <4970CA05.8010303@sgi.com>
Date: Fri, 16 Jan 2009 09:55:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
References: <49704DF6.8040205@sgi.com> <20090116093442.GE4305@elte.hu>
In-Reply-To: <20090116093442.GE4305@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> --- a/arch/x86/kernel/microcode_core.c
>> +++ b/arch/x86/kernel/microcode_core.c
>> @@ -104,7 +104,7 @@ static struct microcode_ops *microcode_ops;
>>  /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
>>  static DEFINE_MUTEX(microcode_mutex);
>>  
>> -struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
>> +struct ucode_cpu_info *ucode_cpu_info;
>>  EXPORT_SYMBOL_GPL(ucode_cpu_info);
>>  
>>  #ifdef CONFIG_MICROCODE_OLD_INTERFACE
>> @@ -471,6 +471,13 @@ static int __init microcode_init(void)
>>  {
>>  	struct cpuinfo_x86 *c = &cpu_data(0);
>>  	int error;
>> +	size_t size = sizeof(*ucode_cpu_info) * nr_cpu_ids;
>> +
>> +	ucode_cpu_info = kmalloc(size, GFP_KERNEL);
>> +	if (!ucode_cpu_info) {
>> +		WARN(1, "CPU: cannot allocate microcode info structure\n");
>> +		return -ENOMEM;
>> +	}
>>  
>>  	if (c->x86_vendor == X86_VENDOR_INTEL)
>>  		microcode_ops = init_intel_microcode();
> 
> look how this code continues:
> 
>         else if (c->x86_vendor == X86_VENDOR_AMD)
>                 microcode_ops = init_amd_microcode();
> 
>         if (!microcode_ops) {
>                 printk(KERN_ERR "microcode: no support for this CPU vendor\n");
>                 return -ENODEV;
>         }
> 
> see the memory leak? Again, this patch too is trivially broken.
> 
>> commit beec9183a43f8a42f5b790326a3b120a3b513590
>> Author: Mike Travis <travis@sgi.com>
>> Date:   Fri Jan 16 00:22:33 2009 -0800
>>
>>     xen: reduce static memory usage
> 
> this one looks good in a quick check but please send it to Jeremy first or 
> get his Ack.
> 
> 	Ingo

Ok, thanks!

