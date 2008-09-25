Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYIYROF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYIYROF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYIYRNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:13:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:23640 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbYIYRNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xzWeULYLxWDp0Mdg5eJwIXVTvt/9mPobD/JX8NrsZYLemefBUfIiThuLgluM1wFk0A
         q1HSCje7bHyciOjWBeGzp0eKpRsLFN4smqEyB/l5s4F+6oB6py2ufyX5CS3D35QTvW/l
         ROwBEnWAOi8i8vPZtNinNhj54H5l1PoesL5+g=
Message-ID: <86802c440809251013u84ac6cocf2741b485202b44@mail.gmail.com>
Date: Thu, 25 Sep 2008 10:13:45 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Yan Li" <elliot.li.tech@gmail.com>
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message when running as VMware guest
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, "Thomas Gleixner" <tglx@linutronix.de>,
       nancydreaming@gmail.com
In-Reply-To: <20080925141828.GB15948@yantp.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com>
	 <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
	 <86802c440809240939h63b14efdm1382ffe4c44c6660@mail.gmail.com>
	 <20080925141828.GB15948@yantp.cn.ibm.com>
X-Google-Sender-Auth: cfa455b2fcd21e08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 7:18 AM, Yan Li <elliot.li.tech@gmail.com> wrote:
> On Wed, Sep 24, 2008 at 09:39:20AM -0700, Yinghai Lu wrote:
>> On Wed, Sep 24, 2008 at 5:24 AM, Yan Li <elliot.li.tech@gmail.com> wrote:
>> > Since the mtrr empty was detected very early before we can use DMI or
>> > PCI to check whether we are running as a VMware guest or not, we now
>> > only print an info there. Warning will only be issued later when we
>> > are sure that we are not running as a VMware guest.
>> >
>> > mtrr_trim_uncached_memory() is modified to return meaningful codes for
>> > later warning decision.
>>
>> we have moved dmi_scan_machine() much early...
>>
>> so please check with latest tip/master to use
>> dmi_check_system with that.
>
> I checked your patch 1c6e5503 that moved dmi_scan_machine() earlier,
> but it's still behind mtrr_trim_uncached_memory(), so we still can't
> use DMI to check for VMware there.
>

you must be kidding!

...

        dmi_scan_machine();

        dmi_check_system(bad_bios_dmi_table);

#ifdef CONFIG_X86_32
        probe_roms();
#endif

        /* after parse_early_param, so could debug it */
        insert_resource(&iomem_resource, &code_resource);
        insert_resource(&iomem_resource, &data_resource);
        insert_resource(&iomem_resource, &bss_resource);

        if (efi_enabled)
                efi_init();

#ifdef CONFIG_X86_32
        if (ppro_with_ram_bug()) {
                e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
                                  E820_RESERVED);
                sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
                printk(KERN_INFO "fixed physical RAM map:\n");
                e820_print_map("bad_ppro");
        }
#else
        early_gart_iommu_check();
#endif

        /*
         * partially used pages are not usable - thus
         * we are rounding upwards:
         */
        max_pfn = e820_end_of_ram_pfn();

        /* preallocate 4k for mptable mpc */
        early_reserve_e820_mpc_new();
        /* update e820 for memory not covered by WB MTRRs */
        mtrr_bp_init();
        if (mtrr_trim_uncached_memory(max_pfn))
                max_pfn = e820_end_of_ram_pfn();
