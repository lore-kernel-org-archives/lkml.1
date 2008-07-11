Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYGKVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYGKVNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYGKVNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:13:08 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:46184 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYGKVNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vMTmFEM6T+cJE5e9OoIr9p04uO1wkUwc/pcM/pbGuCKeel/DgbQ4uOoOJlJN0OX/tx
         Y7HzGZd2PqaISfmi1XzKgXNq6O9vtjqkUzQXMSEOtFb2n8FxFkYml5ZrrBIxsFB58wqy
         aChzKkjxDYtMdzpsGCkCZPCQ2X9ndliZwPC8I=
Message-ID: <86802c440807111413x493ef180r14a6bcb1a4a55924@mail.gmail.com>
Date: Fri, 11 Jul 2008 14:13:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: AMD Family 10H machine check on vmcore read
Cc: "Bob Montgomery" <bob.montgomery@hp.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080711205052.GC3298@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215472086.3361.297.camel@amd.troyhebe>
	 <20080708132855.GB7866@redhat.com>
	 <1215624760.3361.314.camel@amd.troyhebe>
	 <20080711205052.GC3298@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 1:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jul 09, 2008 at 11:32:40AM -0600, Bob Montgomery wrote:
>> On Tue, 2008-07-08 at 13:28 +0000, Vivek Goyal wrote:
>> > On Mon, Jul 07, 2008 at 05:08:06PM -0600, Bob Montgomery wrote:
>> > > We maintain a 2.6.18 derived kernel.
>> > > When testing kdump on a new AMD Family 10h (16) processor, once in the
>> > > kdump kernel, a read from either /proc/vmcore or /dev/oldmem that
>> > > corresponds to the area of memory identified in the original (crashing)
>> > > kernel by these boot messages:
>>
>> > >
>> > > On a Family 15 AMD64 processor running this kernel and kdump kernel, I
>> > > can read the areas identified as being in the aperture from the kdump
>> > > kernel and get values, but on the new processor, reads from the kdump
>> > > kernel that are within that address range result in the machine check:
>> > >
>> > > HARDWARE ERROR
>> > > CPU 0: Machine Check Exception:                4 Bank 4: be0000010005001b
>> > > TSC 141bd974323de ADDR 1c000000 MISC e00c0ffe01000000
>> > >
>>
>> > Hi Bob,
>> >
>> > I am not sure what's happening here. Because in /proc/iomem, GART reserved
>> > area is reported as System RAM, kdump kernel will try to read this area
>> > and save it. Now I am not sure, what is so special about this area that
>> > mapping it and reading it in second kernel would cause a MCE.
>> >
>> > CCing it to LKML, hoping people knowing GART will be able to provide some
>> > input.
>> >
>> > > But I don't see this fix upstream in the kernel.  So I'm wondering if
>> > > some other patch protects other kdump kernels from this problem.  In
>> > > particular, a recent patch that informed the e820 map about the gart
>> > > aperture to prevent a normal kernel and a kexec kernel from putting it
>> > > at different addresses.  It didn't mention machine checks from kdump
>> > > kernels, but I wonder if it would have prevented access to that memory
>> > > area by having it be excluded from the /proc/vmcore list of areas??
>> >
>> > Can you provide a link to the patch above? If /proc/iomem, does not report
>> > GART area as system ram then it will be excluded from the dump. (IIUC,
>> > IOMMU tables are in GART area and ideally one should be capturing it to
>> > find out how IOMMU tables looked like at the time of crash).
>>
>> The patch that I thought might be related is:
>>  x86: disable the GART early, 64-bit
>>
>> author     Yinghai Lu <Yinghai.Lu@Sun.COM>
>>            Wed, 30 Jan 2008 12:33:09 +0000 (13:33 +0100)
>> committer  Ingo Molnar <mingo@elte.hu>
>>            Wed, 30 Jan 2008 12:33:09 +0000 (13:33 +0100)
>> commit     aaf230424204864e2833dcc1da23e2cb0b9f39cd
>> tree       a42042f5135aa63a780964bd053ae174211ab62f
>>
>> I thought it might be relevant because of this included comment:
>>
>> > hm, i'm wondering, instead of modifying the GART, why dont we simply
>> > _detect_ whatever GART settings we have inherited, and propagate that
>> > into our e820 maps? I.e. if there's inconsistency, then punch that out
>> > from the memory maps and just dont use that memory.
>>
>> But this patch doesn't mention machine checks as the symptom that
>> initiated the patch.
>>
>> And my reason for looking was because I didn't think I could be the
>> first person to try reading /proc/vmcore on a Family 10h processor.  So
>> I wondered why it hadn't been seen by some other tester, and thought
>> some other patch might have "fixed" it a different way on newer kernels
>> than mine.
>>
>
> Hi Bob,
>
> So it looks like this patch will mark aperture region as non RAM and kudmp
> will not try to dump that memory and will not run into MCE. Have you tried
> the kernel with this patch? Does it work for you?
>
> At this point I don't know, why accessing the aperture region of first
> kernel causes MCE. May be Andi or Yinghai will know, CCing them.
>
> So backporting the Yinghai's patch to your kernel should help here.
>

two kernels could have different position with GART aperture allocated
from low ram.

so need to stop it in shutdown path of first kernel or startup path of
second kernel.

otherwise second kernel will try to use address of first kernel gart,
and later if the gart is disabled for new gart, the setting will be
lost.

with this patch could use MCE error and HT sync flood and warm reset

YH
