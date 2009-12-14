Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZLNU2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZLNU2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbZLNU2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:28:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:53217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbZLNU17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:27:59 -0500
Message-ID: <4B269F92.1050909@kernel.org>
Date: Mon, 14 Dec 2009 12:26:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko@ursulin.net>
CC: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Are these MTRR settings correct?
References: <200912130807.44905.tvrtko@ursulin.net> <200912141934.10628.tvrtko@ursulin.net> <4B26965C.6020203@kernel.org> <200912142016.53160.tvrtko@ursulin.net>
In-Reply-To: <200912142016.53160.tvrtko@ursulin.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin wrote:
> On Monday 14 Dec 2009 19:47:40 Yinghai Lu wrote:
>> Tvrtko Ursulin wrote:
>>> On Monday 14 Dec 2009 11:25:58 Yinghai Lu wrote:
>>>>>> something wrong, we should not check that with e820 or acpi resource
>>>>>> in that case. please check
>>>>>>
>>>>>> {PATCH] x86/pci: don't check mmconf again if it is from MSR with amd
>>>>>> faml0h
>>>>>>
>>>>>> for AMD Fam10h, it we read mmconf from MSR early, we should just trust
>>>>>> it because we check it and correct it already.
>>>>>>
>>>>>> so skip the reject check there.
>>>>> [path snipped]
>>>>>
>>>>> Do you want me to test with this patch and that pci=.. option active
>>>>> and post dmesg? Or without the pci=... option?
>>>> with this patch and pci=... and post dmesg...
>>> Here you go:
>> ...
>>
>>> [    0.250041] node 0 link 0: io port [1000, ffffff]
>>> [    0.250043] TOM: 00000000e0000000 aka 3584M
>>> [    0.250044] Fam 10h mmconf [e0000000, efffffff]
>>> [    0.250046] node 0 link 0: mmio [a0000, bffff]
>>> [    0.250048] node 0 link 0: mmio [e0000000, efffffff] ==> none
>>> [    0.250050] node 0 link 0: mmio [f0000000, fe7fffff]
>>> [    0.250051] node 0 link 0: mmio [fe800000, fe9fffff]
>>> [    0.250053] node 0 link 0: mmio [fea00000, ffefffff]
>>> [    0.250054] TOM2: 0000000120000000 aka 4608M
>>> [    0.250056] bus: [00,07] on node 0 link 0
>>> [    0.250057] bus: 00 index 0 io port: [0, ffff]
>>> [    0.250058] bus: 00 index 1 mmio: [a0000, bffff]
>>> [    0.250060] bus: 00 index 2 mmio: [f0000000, ffffffff]
>>> [    0.250061] bus: 00 index 3 mmio: [120000000, fcffffffff]
>>> [    0.250068] ACPI: bus type pci registered
>>> [    0.250091] PCI: Found AMD Family 10h NB with MMCONFIG support.
>>> [    0.254793] PCI: Using MMCONFIG at e0000000 - efffffff
>>> [    0.254795] PCI: Using configuration type 1 for base access
>> ...
>>
>> thanks, mmconf works on your system.
> 
> So I should keep using both your patch and pci=check_enable_amd_mmconf option?
> 

I will push the driver to Jesse.

but you need to have pci=check_enable_amd_mmconf, unless we add one DMI entry for your kind of system.

in arch/x86/kernel/mmconf-fam10h_64.c.
static int __devinit set_check_enable_amd_mmconf(const struct dmi_system_id *d)
{
        pci_probe |= PCI_CHECK_ENABLE_AMD_MMCONF;
        return 0;
}

static const struct dmi_system_id __cpuinitconst mmconf_dmi_table[] = {
        {
                .callback = set_check_enable_amd_mmconf,
                .ident = "Sun Microsystems Machine",
                .matches = {
                        DMI_MATCH(DMI_SYS_VENDOR, "Sun Microsystems"),
                },
        },
        {}
};

void __cpuinit check_enable_amd_mmconf_dmi(void)
{
        dmi_check_system(mmconf_dmi_table);
}

