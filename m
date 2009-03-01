Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZCAFnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZCAFnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 00:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZCAFnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 00:43:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:18108 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZCAFm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 00:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PBiRE+pWfotOemvQznxinvyiCOCFGHQyxO7vvDAMot8avvsxpoEkMM57zHR5wwUYQ2
         V8RA9mORJiggXZ0WBwAp8GogH/8k6QeuUuGjpM7rDiWQcxBL1HbHYCyM2VfT7pP8DYoU
         MYcOUHhA87m1Qlcn0R0OAX8R3DEW7a5Oes1wk=
MIME-Version: 1.0
In-Reply-To: <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>
References: <49A965AD.10701@redhat.com>
	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>
Date: Sat, 28 Feb 2009 21:42:56 -0800
X-Google-Sender-Auth: 7377c25e7bc5e244
Message-ID: <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Yinghai Lu <yinghai@kernel.org>
To: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 8:14 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Feb 28, 2009 at 8:26 AM, Brian Maly <bmaly@redhat.com> wrote:
>>
>>   On some EFI systems (i.e. Apple) EFI runtime is mapped into higher mem
>> regions. These EFI mem regions are not always taken into consideration when
>> max_pfn is calculated in setup.c being that e820_end_of_ram_pfn() only
>> counts
>> mappings types marked as usable (E820_RAM). Currently we only count to the
>> last
>> usable e820 address range and nothing beyond. EFI can be mapped anywhere
>> within
>> e820 and is not always marked as usable e820, and so EFI runtime may be
>> missed
>> if mapped somewhere beyond last usable e820. This patch attempts to resolve
>> this problem by including all E820 mappings when EFI is enabled, so that
>> the entire e820 (and EFI runtime area) is included in computing max_pfn.
>> Tested
>> on a MacBook Pro 3.1 and resolves the issue (system now boots w/elilo+grub &
>> EFI).
>>
>
> it seems you should check and enable directly mapping when EFI runtime
> service is enabled.

it seems in efi_enter_virtual_mode already called efi_ioremap() for
the range above max_low_pfn_mapped...

so it seems you meet other problems.

YH

void __init efi_enter_virtual_mode(void)
{
        efi_memory_desc_t *md;
        efi_status_t status;
        unsigned long size;
        u64 end, systab, addr, npages;
        void *p, *va;

        efi.systab = NULL;
        for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
                md = p;
                if (!(md->attribute & EFI_MEMORY_RUNTIME))
                        continue;

                size = md->num_pages << EFI_PAGE_SHIFT;
                end = md->phys_addr + size;

                if (PFN_UP(end) <= max_low_pfn_mapped)
                        va = __va(md->phys_addr);
                else
                        va = efi_ioremap(md->phys_addr, size);

                md->virt_addr = (u64) (unsigned long) va;

                if (!va) {
                        printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
                               (unsigned long long)md->phys_addr);
                        continue;
                }

                if (!(md->attribute & EFI_MEMORY_WB)) {
                        addr = md->virt_addr;
                        npages = md->num_pages;
                        memrange_efi_to_native(&addr, &npages);
                        set_memory_uc(addr, npages);
                }

                systab = (u64) (unsigned long) efi_phys.systab;
                if (md->phys_addr <= systab && systab < end) {
                        systab += md->virt_addr - md->phys_addr;
                        efi.systab = (efi_system_table_t *) (unsigned
long) systab;
                }
        }
