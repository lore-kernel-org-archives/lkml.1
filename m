Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbZLOT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbZLOT6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759861AbZLOT57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:57:59 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49180 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbZLOT56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:57:58 -0500
Date: Tue, 15 Dec 2009 20:57:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
Message-ID: <20091215195756.GW28252@kernel.dk>
References: <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk> <4B27D7E9.4030105@kernel.org> <20091215185941.GO28252@kernel.dk> <4B27DDD7.5040301@kernel.org> <20091215191129.GQ28252@kernel.dk> <4B27E71E.6020709@kernel.org> <20091215194818.GU28252@kernel.dk> <4B27E85C.20006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27E85C.20006@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Yinghai Lu wrote:
> Jens Axboe wrote:
> > On Tue, Dec 15 2009, Yinghai Lu wrote:
> >> Jens Axboe wrote:
> >>> On Tue, Dec 15 2009, Yinghai Lu wrote:
> >>>> Jens Axboe wrote:
> >>>>> On Tue, Dec 15 2009, Yinghai Lu wrote:
> >>>>>> [   13.018720] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
> >>>>>>
> >>>>>> [   13.100724] [Firmware Bug]: PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources
> >>>>> On a "normal" non-kexec boot, I get:
> >>>>>
> >>>>> [   12.173583] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
> >>>>> [   12.184075] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
> >>>>> [   12.216874] PCI: Using configuration type 1 for base access
> >>>>>
> >>>> can you run following scripts in first kernel?
> >>>>
> >>>> cd /sys/firmware/memmap
> >>>> for dir in * ; do
> >>>>   start=$(cat $dir/start)
> >>>>   end=$(cat $dir/end)
> >>>>   type=$(cat $dir/type)
> >>>>   printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type" >> /tmp/memmap.txt
> >>>> done
> >>>>
> >>>> and send out /tmp/memmap.txt
> >>> Below.
> >>>
> >>>> what is your kexec tools version? could be too old?
> >>> It says:
> >>>
> >>> kexec-tools-testing 20080324 released 24th March 2008
> >>>
> >>>
> >>> 0000000000000000-0000000000098800 (System RAM)
> >>> 0000000000098800-00000000000a0000 (reserved)
> >>> 0000000079301000-0000000079303000 (reserved)
> >>> 0000000079303000-0000000079305000 (ACPI Tables)
> >>> 0000000079305000-0000000079310000 (reserved)
> >>> 0000000079310000-0000000079314000 (ACPI Tables)
> >>> 0000000079314000-0000000079319000 (reserved)
> >>> 0000000079319000-0000000079336000 (ACPI Tables)
> >>> 0000000079336000-0000000079358000 (reserved)
> >>> 0000000079358000-0000000079388000 (ACPI Tables)
> >>> 0000000079388000-00000000793c9000 (reserved)
> >>> 00000000793c9000-000000007968f000 (ACPI Tables)
> >>> 00000000000e0000-0000000000100000 (reserved)
> >>> 000000007968f000-00000000796bb000 (reserved)
> >>> 00000000796bb000-00000000799d8000 (ACPI Tables)
> >>> 00000000799d8000-0000000079bd8000 (ACPI Non-volatile Storage)
> >>> 0000000079bd8000-0000000079d8b000 (ACPI Tables)
> >>> 0000000079d8b000-0000000079d8c000 (reserved)
> >>> 0000000079d8c000-0000000079dc8000 (ACPI Tables)
> >>> 0000000079dc8000-0000000079dcb000 (reserved)
> >>> 0000000079dcb000-0000000079e1c000 (ACPI Tables)
> >>> 0000000079e1c000-0000000079e87000 (reserved)
> >>> 0000000079e87000-000000007bd5f000 (ACPI Tables)
> >>> 0000000000100000-0000000078c59000 (System RAM)
> >>> 000000007bd5f000-000000007be4f000 (reserved)
> >>> 000000007be4f000-000000007bf87000 (ACPI Tables)
> >> so following ranges are not passed to second kernel by kexec?
> > 
> > I have the following addition to my kexec kernel command line:
> > 
> > memmap=62G@4G
> > 
> > since that last big 62G RAM entry doesn't show up without it, that's why
> > you see a user defined e820 map as well in the boot logs. So a kexec'ed
> > kernel is missing at least that entry.
> > 
> > I just tried with the latest and greatest kexec-tools (2.0.1) and
> > there's no difference.
> 
> current kernel kexec 2.6.32 make numa and mmconf working on second kernel?

Just tested that configuration, and with current -git booted and
kexec into 2.6.32 gets me working numa but mmconf still complains:

[   15.669222] PCI: MCFG configuration 0: base 80000000 segment 0 buses
0 - 255
[   15.677166] PCI: Not using MMCONFIG.
[...]
[   15.971448] PCI: MCFG configuration 0: base 80000000 segment 0 buses
0 - 255
[   16.066995] PCI: BIOS Bug: MCFG area at 80000000 is not reserved in
ACPI motherboard resources
[   16.076705] PCI: Not using MMCONFIG.

SRAT looks good:

[...]
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-480000000
[    0.000000] SRAT: Node 2 PXM 1 480000000-880000000
[    0.000000] SRAT: Node 1 PXM 2 880000000-c80000000
[    0.000000] SRAT: Node 3 PXM 3 c80000000-1080000000
[    0.000000] NUMA: Using 31 for the hash shift.
[snip same working NUMA config]

-- 
Jens Axboe

