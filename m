Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYGQFwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYGQFwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 01:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYGQFwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 01:52:41 -0400
Received: from il.qumranet.com ([212.179.150.194]:46829 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYGQFwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:52:40 -0400
Message-ID: <487EDE26.8040201@qumranet.com>
Date: Thu, 17 Jul 2008 08:52:38 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
Subject: Re: KVM overflows the stack
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>	 <1206629709.7883.30.camel@nimitz.home.sr71.net>	 <47EBB63E.2060306@qumranet.com>	 <1212445810.8211.9.camel@nimitz.home.sr71.net>	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz>	 <1216244660.8711.6.camel@nimitz> <1216248527.11664.9.camel@nimitz>
In-Reply-To: <1216248527.11664.9.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2008-07-16 at 14:44 -0700, Dave Hansen wrote:
>   
>> On a suggestion of Anthony's, I tried a defconfig kernel.
>>
>> It is now bombing out on an assertion in the lapic code:
>>
>> 	http://sr71.net/~dave/linux/2.6.26-oops1.txt
>>     
>
> I think I found it!!!
>
> $ (objdump -d kvm.ko ; objdump -d kvm-intel.ko ) | egrep 'sub.*0x...,.*esp|>:'  | egrep sub -B1
> 00001a90 <kvm_vcpu_ioctl>:
>     1a9a:	81 ec 60 06 00 00    	sub    $0x660,%esp
> --
> 00004e90 <kvm_arch_vcpu_ioctl>:
>     4e9d:	81 ec 6c 08 00 00    	sub    $0x86c,%esp
> --
> 00005900 <kvm_arch_vm_ioctl>:
>     5903:	81 ec 34 05 00 00    	sub    $0x534,%esp
> --
> 0000d4f0 <paging64_prefetch_page>:
>     d4f8:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
> --
> 0000dfd0 <paging32_prefetch_page>:
>     dfd8:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
> --
> 0000f390 <kvm_pv_mmu_op>:
>     f3a1:	81 ec 28 02 00 00    	sub    $0x228,%esp
>
> We're simply overflowing the stack.  I changed all of the large on-stack
> allocations to 'static', and it actually boots now.  I know 'static'
> isn't safe, but it was good for a quick test.
>
>   

Yes!   It's obvious, once you know it...

> A 'make stackcheck' confirms this:
>
> dave@nimitz:~/kernels/linux-2.6.git$ make checkstack
> objdump -d vmlinux $(find . -name '*.ko') | \
> 	perl /home/dave/kernels/linux-2.6.git-t61/scripts/checkstack.pl i386
> 0x000042d3 kvm_arch_vcpu_ioctl [kvm]:			2148
> 0x000012e3 kvm_vcpu_ioctl [kvm]:			1620
> 0x00004a83 kvm_arch_vm_ioctl [kvm]:			1332
> 0x00009a26 airo_get_aplist [airo]:			1140
> 0x00009b76 airo_get_aplist [airo]:			1140
> 0x00009c82 airo_get_aplist [airo]:			1140
> ...
>
> In other words, kvm has the top 3 stack users in my kernel.  As you can
> see from my trace above, these things also get called with super-long
> stacks already.  Man.  That sucked to find.
>
> Avi, how would you like this fixed?  I'd be happy to prepare some
> patches.  Do you have a particular approach that you think we should
> use?  Just make the big objects dynamically allocated?
>   

Yes, things like kvm_lapic_state are way too big to be on the stack.  
There's an additional problem here, that apparently your gcc (which 
version?) doesn't fold objects in a switch statement into the same stack 
slot:

switch (...) {
    case x: {
         struct medium a;
         ...
    }
    case y:
          struct medium b;
          ...
    }
};

These could be solved either by stack allocation, or by moving into 
functions marked noinline.  Whichever is easier.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

