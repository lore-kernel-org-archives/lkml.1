Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbYCWMVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbYCWMVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYCWMU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:20:57 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:48974
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbYCWMU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:20:56 -0400
Message-ID: <47E64B27.3060400@qumranet.com>
Date: Sun, 23 Mar 2008 14:20:55 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ioan Ionita <opslynx@gmail.com>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc5-git5 KVM memory not freed
References: <df47b87a0803200941q7cbee10ev5a57f7cb25406896@mail.gmail.com> <47E63161.90002@qumranet.com>
In-Reply-To: <47E63161.90002@qumranet.com>
Content-Type: multipart/mixed;
 boundary="------------040702020201010300070104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040702020201010300070104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Avi Kivity wrote:
> Ioan Ionita wrote:
>> Hi,
>>
>> I'm using KVM and the qemu kvm modified to run a windows guest. I'm
>> allocating 900 MB to the guest. Seems that when I terminate a qemu
>> process, the memory that was allocated to qemu is not freed:
>>
>>
>> Mem:       2058140    1739156     318984          0     226944     
>> 425140
>> -/+ buffers/cache:    1087072     971068
>> Swap:            0          0          0
>>
>> So I'm using 1GB of ram even though I've terminated qemu. If I attempt
>> to start qemu again, the machine locks up. No message in the logs.
>>
>> Command to start qemu:
>> /usr/local/kvm/bin/qemu-system-x86_64 b.data -no-acpi -m 900 -net nic
>> -net user -hdb temp.raw -usbdevice tablet
>>
>> uname -a
>> Linux ops-desktop 2.6.25-rc5-git5 #1 SMP PREEMPT Sat Mar 15 14:47:25
>> EET 2008 x86_64 GNU/Linux
>>
>>
>> Not sure whether this is a problem on the kernel side.  I don't
>> pretend to understand linux memory management. But it wasn't occurring
>> with older kernels. I'll attempt to bisect.
>>   
>
> I reproduced this and am investigating.
>
>

Attached patch ought to fix this.

-- 
error compiling committee.c: too many arguments to function


--------------040702020201010300070104
Content-Type: text/x-patch;
 name="fix-kvm-2.6.25-rc6-leak.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-kvm-2.6.25-rc6-leak.patch"

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4ba85d9..e55af12 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1412,7 +1412,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	up_read(&current->mm->mmap_sem);
 
 	vcpu->arch.update_pte.gfn = gfn;
-	vcpu->arch.update_pte.page = gfn_to_page(vcpu->kvm, gfn);
+	vcpu->arch.update_pte.page = page;
 }
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,

--------------040702020201010300070104--
