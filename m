Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZC2Nh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZC2Nh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZC2Nhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:37:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42803 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZC2Nho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:37:44 -0400
Message-ID: <49CF79A2.9020202@redhat.com>
Date: Sun, 29 Mar 2009 16:37:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] kvm mmu: implement necessary data structures for
 second huge page accounting
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-5-git-send-email-joerg.roedel@amd.com> <49CF7716.1000008@redhat.com>
In-Reply-To: <49CF7716.1000008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Joerg Roedel wrote:
>> This patch adds the necessary data structures to take care of write
>> protections in place within a second huge page sized page.
>>
>>
>> +#ifdef KVM_PAGES_PER_LHPAGE
>> +    if (npages && !new.hpage_info) {
>> +        int hugepages = npages / KVM_PAGES_PER_LHPAGE;
>> +        if (npages % KVM_PAGES_PER_LHPAGE)
>> +            hugepages++;
>> +        if (base_gfn % KVM_PAGES_PER_LHPAGE)
>> +            hugepages++;
>>   
>
> Consider a slot with base_gfn == 1 and npages == 1.  This will have 
> hugepages == 2, which is wrong.
>
> I think the right calculation is
>
>  ((base_gfn + npages - 1) / N) - (base_gfn / N) + 1
>
> i.e. index of last page, plus one so we can store it.
>
> The small huge page calculation is off as well.
>

I fixed the existing case with

commit 1a967084dbe97a2f4be84139d14e2d958d7ffc46
Author: Avi Kivity <avi@redhat.com>
Date:   Sun Mar 29 16:31:25 2009 +0300

    KVM: MMU: Fix off-by-one calculating large page count
   
    The large page initialization code concludes there are two large 
pages spanned
    by a slot covering 1 (small) page starting at gfn 1.  This is 
incorrect, and
    also results in incorrect write_count initialization in some cases 
(base = 1,
    npages = 513 for example).
   
    Cc: stable@kernel.org
    Signed-off-by: Avi Kivity <avi@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8aa3b95..3d31557 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1076,6 +1076,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
        int r;
        gfn_t base_gfn;
        unsigned long npages;
+       int largepages;
        unsigned long i;
        struct kvm_memory_slot *memslot;
        struct kvm_memory_slot old, new;
@@ -1151,11 +1152,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
                        new.userspace_addr = 0;
        }
        if (npages && !new.lpage_info) {
-               int largepages = npages / KVM_PAGES_PER_HPAGE;
-               if (npages % KVM_PAGES_PER_HPAGE)
-                       largepages++;
-               if (base_gfn % KVM_PAGES_PER_HPAGE)
-                       largepages++;
+               largepages = 1 + (base_gfn + npages - 1) / 
KVM_PAGES_PER_HPAGE;
+               largepages -= base_gfn / npages;
 
                new.lpage_info = vmalloc(largepages * 
sizeof(*new.lpage_info));

-- 
error compiling committee.c: too many arguments to function

