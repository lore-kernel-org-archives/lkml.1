Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYCQRCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYCQRCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYCQRB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:01:58 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:40509
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYCQRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:01:57 -0400
Message-ID: <47DEA401.7080407@qumranet.com>
Date: Mon, 17 Mar 2008 19:01:53 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: kvm-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, hpa <hpa@zytor.com>,
       mingo <mingo@redhat.com>
Subject: Re: [kvm-devel] [PATCH] x86: don't allow KVM_CLOCK without HAVE_KVM
References: <20080314104444.ca80e434.randy.dunlap@oracle.com>	<47DD00C4.2070100@qumranet.com> <20080317085555.b5168b6f.randy.dunlap@oracle.com>
In-Reply-To: <20080317085555.b5168b6f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 16 Mar 2008 13:13:08 +0200 Avi Kivity wrote:
>
>   
>> Randy Dunlap wrote:
>>     
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Make KVM_CLOCK depend on HAVE_KVM.  Otherwise a Voyager build can
>>> fail with:
>>>
>>>   CC      arch/x86/kernel/asm-offsets.s
>>> In file included from include2/asm/irqflags.h:59,
>>>                  from /local/linsrc/next-20080314/include/linux/irqflags.h:46,
>>>                  from include2/asm/system.h:11,
>>>                  from include2/asm/processor.h:21,
>>>                  from include2/asm/atomic_32.h:5,
>>>                  from include2/asm/atomic.h:2,
>>>                  from /local/linsrc/next-20080314/include/linux/crypto.h:20,
>>>                  from /local/linsrc/next-20080314/arch/x86/kernel/asm-offsets_32.c:7,
>>>                  from /local/linsrc/next-20080314/arch/x86/kernel/asm-offsets.c:2:
>>> include2/asm/paravirt.h: In function 'startup_ipi_hook':
>>> include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
>>> include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
>>> include2/asm/paravirt.h:856: error: memory input 4 is not directly addressable
>>> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>>> make[1]: *** [prepare0] Error 2
>>> make: *** [sub-make] Error 2
>>>
>>>   
>>>       
>> Looks like it's a general paravirt vs voyager issue, nothing kvmclock 
>> specific about it.  Wouldn't it be better to have voyager and paravirt 
>> mutually exclude each other, rather than every paravirt user?
>>     
>
> They do generally mutually exclude each other.  I think that the problem
> is just that dirty old "select PARAVIRT" in config KVM_CLOCK.
> PARAVIRT depends on !(X86_VISWS || X86_VOYAGER), but "select" doesn't
> care^W honor that.  As Documentation/kbuild/kconfig-language.txt says:
>
> 	"In general use select only for
> 	non-visible symbols (no prompts anywhere) and for symbols with
> 	no dependencies. That will limit the usefulness but on the
> 	other hand avoid the illegal configurations all over. kconfig
> 	should one day warn about such things."
>
> so changing the select to depends on would fix it, but that's the
> only fix that I know of.
>   

A depends is horrible from the user point of view as it hides the 
feature completely if paravirt is not enabled.  So your original 
workaround is probably best.

Or maybe
   depends on PARAVIRT_CAPABLE
   selects PARAVIRT

Where PARAVIRT_CAPABLE is a synonym for !(X86_REMOVE_ME || 
X86_TOTAL_SILLYNESS), so we don't have to repeat it everywhere.

-- 
error compiling committee.c: too many arguments to function

