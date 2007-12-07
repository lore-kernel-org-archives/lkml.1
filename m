Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXLGDCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXLGDCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 22:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXLGDCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 22:02:33 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:56094 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752545AbXLGDCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 22:02:32 -0500
Message-ID: <4758B7C2.8080806@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2007 08:32:26 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Badari Pulavarty <pbadari@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, rsa@us.ibm.com, apw@shadowen.org,
       balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on powerpc
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com> <47583D4F.2050707@linux.vnet.ibm.com> <20071206185006.GA21641@kroah.com> <47584672.8040201@linux.vnet.ibm.com> <20071206203118.GA28618@kroah.com> <1196985291.18388.19.camel@dyn9047017100.beaverton.ibm.com> <20071207003204.GA11947@kroah.com>
In-Reply-To: <20071207003204.GA11947@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Dec 06, 2007 at 03:54:51PM -0800, Badari Pulavarty wrote:
>> On Thu, 2007-12-06 at 12:31 -0800, Greg KH wrote:
>>> On Fri, Dec 07, 2007 at 12:28:58AM +0530, Balbir Singh wrote:
>>>> Greg KH wrote:
>>>>
>>>>>> Why release the spinlock here? It's done after the count is incremented.
>>>>>> This patch does not seem correct.
>>>>> Doh, you are correct, I'll make sure that I fix this up before applying
>>>>> it.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>> Hi, Greg,
>>>>
>>>> I ran some tests with the fixed up version of this patch and the system
>>>> fails to come up.
>>>>
>>>> I see the WARN_ON in lib/kref.c:33 and the system fails to boot beyond
>>>> that point. I have not yet found time to debug it though.
>>> That's not good, that warning means that someone has tried to use this
>>> kref _before_ it was initialized, so there is a logic error in the code
>>> that was previously being papered over with the lack of this message in
>>> the kobject code.
>>>
>>> I do have this same message availble as a patch for the kobject core, it
>>> would be interesting if you could just run 2.6.24-rc4 with just this
>>> patch:
>>> 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/kobject-warn.patch
>>>
>>> it might take some fuzz to fit properly, but all you really want to do
>>> is add:
>>> 	WARN_ON(atomic_read(&kobj->kref.refcount));
>>> before the kref_init() call in kobject_init().
>>>
>>> thanks,
>>>
>>> greg k-h
>> 2.6.24-rc4 with above patch booted fine without any warnings. 
>> But 2.6.24-rc4-mm1 doesn't boot, it hangs after following messages.
>>
>>
>> e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
>> e100: Copyright(c) 1999-2006 Intel Corporation
>> ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
>> ipr 0000:d0:01.0: Found IOA with IRQ: 119
>> ipr 0000:d0:01.0: Starting IOA initialization sequence.
>> ipr 0000:d0:01.0: Adapter firmware version: 020A005E
>> ipr 0000:d0:01.0: IOA initialized.
>> scsi0 : IBM 570B Storage Adapter
>> scsi 0:0:3:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
>> scsi 0:0:5:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
>> scsi 0:0:8:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
>> scsi 0:0:15:0: Enclosure         IBM      VSBPD4E2  U4SCSI 7134 PQ: 0 ANSI: 2
>> ------------[ cut here ]------------
>> Badness at lib/kref.c:33
>> NIP: c0000000002e1254 LR: c0000000002dfbd8 CTR: c0000000002e60f0
>> REGS: c00000003f0db050 TRAP: 0700   Not tainted  (2.6.24-rc4-mm1)
>> MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 28002042  XER: 0000000f
>> TASK = c00000003f0d78d0[1] 'swapper' THREAD: c00000003f0d8000 CPU: 0
>> GPR00: 0000000000000000 c00000003f0db2d0 c000000000724098 c00000003f131620
>> GPR04: fffffffffffffff1 fffffffffffffffe 000000000000000a ffffffffffffffff
>> GPR08: c00000003d4d9000 c00000003f0cbfe0 c000000000556591 0000000000000073
>> GPR12: 0000000024002084 c000000000651980 0000000000000000 0000000000000000
>> GPR16: 0000000000000000 d000080080080000 c00000000064d6f0 c00000003d4d9570
>> GPR20: c00000003d4d94b8 0000000000000002 c00000003d4d9170 c00000003d4d9170
>> GPR24: c00000003d4d9000 0000000000000001 c00000003d570d58 c00000003d570d18
>> GPR28: 0000000000000000 c00000003d4d9260 c0000000006b5400 c00000003f131618
>> NIP [c0000000002e1254] .kref_get+0x10/0x2c
>> LR [c0000000002dfbd8] .kobject_get+0x24/0x40
>> Call Trace:
>> [c00000003f0db2d0] [c00000003f0db360] 0xc00000003f0db360 (unreliable)
>> [c00000003f0db350] [c0000000002e00e8] .kobject_add+0x8c/0x21c
>> [c00000003f0db3e0] [c000000000344b00] .device_add+0xd4/0x680
>> [c00000003f0db4a0] [c0000000003a1c4c] .scsi_alloc_target+0x218/0x404
>> [c00000003f0db570] [c0000000003a1fb4] .__scsi_scan_target+0xa8/0x640
>> [c00000003f0db6b0] [c0000000003a25c4] .scsi_scan_channel+0x78/0xdc
>> [c00000003f0db750] [c0000000003a26f8] .scsi_scan_host_selected+0xd0/0x140
>> [c00000003f0db7f0] [c0000000003c3ff4] .ipr_probe+0x1270/0x1348
> 
> This looks like a scsi issue to me, I don't see how the kref changes
> could cause this backtrace/oops, do you?
> 
> thanks,
> 
> greg k-h

The 2.6.24-rc4 with the above patch, boots fine for me either, and with
2.6.24-rc4-mm1 i get similar backtrace,

Badness at lib/kref.c:33
NIP: c00000000021908c LR: c000000000217b88 CTR: c00000000029b71c
REGS: c00000003c066fc0 TRAP: 0700   Not tainted  (2.6.24-rc4-mm1-autokern1)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 88002022  XER: 00000001
TASK = c00000003ef4c840[339] 'insmod' THREAD: c00000003c064000 CPU: 0
GPR00: 0000000000000000 c00000003c067240 c0000000005d32c0 c00000003e0101a0 
GPR04: fffffffffffffff2 fffffffffffffffe 000000000000000a 0000000000000002 
GPR08: 0000000000000000 c00000003ef8ae50 ffffffffffffffff c000000000449269 
GPR12: 0000000024002084 c000000000515980 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000240000 0000000000000000 
GPR20: 0000000010000290 0000000000000002 c00000003ef3f970 c00000003ef3f970 
GPR24: 0000000000000001 0000000000000000 c00000003c039958 c00000003c039918 
GPR28: 0000000000000000 c00000003ef3fa60 c00000000058e588 c00000003e010198 
NIP [c00000000021908c] .kref_get+0x10/0x2c
LR [c000000000217b88] .kobject_get+0x20/0x3c
Call Trace:
[c00000003c067240] [c000000000217a48] .kobject_set_name_vargs+0x38/0x60 (unreliable)
[c00000003c0672c0] [c000000000217ffc] .kobject_add+0x88/0x20c
[c00000003c067350] [c00000000029b7ec] .device_add+0xd0/0x648
[c00000003c067410] [d000000000613c84] .scsi_alloc_target+0x238/0x414 [scsi_mod]
[c00000003c0674e0] [d000000000614e70] .__scsi_scan_target+0xac/0x718 [scsi_mod]
[c00000003c067630] [d00000000061566c] .scsi_scan_channel+0x78/0xdc [scsi_mod]
[c00000003c0676d0] [d0000000006157f0] .scsi_scan_host_selected+0x120/0x194 [scsi_mod]
[c00000003c067780] [d000000000682148] .ibmvscsi_probe+0x450/0x4fc [ibmvscsic]
[c00000003c067870] [c000000000025fe8] .vio_bus_probe+0x74/0x9c
[c00000003c067900] [c00000000029f2c8] .driver_probe_device+0x110/0x1ec
[c00000003c067990] [c00000000029f57c] .__driver_attach+0xd0/0x160
[c00000003c067a20] [c00000000029da58] .bus_for_each_dev+0x7c/0xcc
[c00000003c067ad0] [c00000000029f634] .driver_attach+0x28/0x40
[c00000003c067b50] [c00000000029e6a4] .bus_add_driver+0xe8/0x2b4
[c00000003c067c00] [c00000000029fd80] .driver_register+0x80/0x9c
[c00000003c067c80] [c0000000000260b0] .vio_register_driver+0x40/0x5c
[c00000003c067d10] [d000000000682c04] .init_module+0x68/0xa4 [ibmvscsic]
[c00000003c067da0] [c00000000009301c] .sys_init_module+0xf4/0x1ac
[c00000003c067e30] [c00000000000872c] syscall_exit+0x0/0x40
Instruction dump:
7d808120 4e800020 38a00000 4bfffad0 38000001 90030000 7c0004ac 4e800020 
80030000 7c0007b4 2f800000 40be0008 <0fe00000> 7c001828 30000001 7c00192d



-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
