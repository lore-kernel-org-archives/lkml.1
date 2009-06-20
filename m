Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZFTI55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZFTI55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 04:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZFTI5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 04:57:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:48977 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZFTI5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 04:57:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,258,1243839600"; 
   d="scan'208";a="156682633"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>
Date: Sat, 20 Jun 2009 16:57:43 +0800
Subject: RE: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
 just	because there's no local APIC
Thread-Topic: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
 just	because there's no local APIC
Thread-Index: AcnxgECFuUm7zR6rT+uZmFUuvQQfLgAAHqXw
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD62F1B68F3@pdsmsx502.ccr.corp.intel.com>
References: <C66250DB.DC85%keir.fraser@eu.citrix.com>
 <m1ljnnnwmc.fsf@fess.ebiederm.org>
In-Reply-To: <m1ljnnnwmc.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5K8wl54029520

>From: Eric W. Biederman
>Sent: 2009Äê6ÔÂ20ÈÕ 16:22
>
>Keir Fraser <keir.fraser@eu.citrix.com> writes:
>
>> On 20/06/2009 00:44, "Nakajima, Jun" <jun.nakajima@intel.com> wrote:
>>
>>>> I assume that putting AML into Xen has been considered, but I don't
>>>> anything about those deliberations.  Keir? Jun?
>>>> 
>>> 
>>> Yes, it was one of the options years ago. We did not do 
>that because Linux and
>>> Solaris (as dom0) already had the AML interpreter and it's 
>overkill and
>>> redundant to have such a large component in the Xen 
>hypervisor. Since the
>>> hypervisor does most of the power management (i.e. P, C, 
>S-state, etc.)
>>> getting the info from dom0 today, we might want to 
>reconsider the option.
>>
>> Yes, we could reconsider. However is there any stuff that 
>dom0 remains
>> responsible for (e.g., PCI management, and therefore PCI 
>hotplug) where it
>> would continue to need to be OSPM, interpreting certain AML 
>objects? In
>> general how safe would it be to have two layered entities 
>both playing at
>> being OSPM?
>
>Short of running the oddball acpi based drivers.  I'm not familiar with
>any acpi in the pci management.
>

PCIe hotplug is defined well by its own BUS spec. But conventional
PCI hotplug is implemented all kinds of strange things. Some is
through ACPI, and thus by moving ACPI into Xen, a new 'virtual' hotplug
architecture has to be introduced into dom0 Linux. Or Xen needs to 
emulate some known interface but as said there's no common standard
for PCI hotplug. What's worse is the docking station support which 
contains diverse legacy devices. How Xen pass those legacy device 
hotplug events into dom0 Linux become another gray area suffering from 
same question like whether IOAPIC needs to be changed for Xen...

Above comes from the exclusive assumption that ACPI is removed
from dom0 by moving into Xen.

Another choice is to have two layered ACPI in both dom0 and Xen
with dom0's ACPI virtualized a bit by Xen. However it's messy as 
ACPI encodes most stuff in its own AML encode as a gray box. 
Many ACPI methods talk to hardware bits internally even by hard 
coded I/O registers. You don't know whether one ACPI event 
should be handled by Xen or not, until some AML methods have 
been evaluated which then may already consume and change 
some device states and not reversible. Then Xen have to emulate 
those states when injecting a virtual ACPI event into dom0 as 
dom0 ACPI methods need to consume same states. However
automatic generating emulation code for diverse ACPI implementations
to me is far more complex than any discussion here. 

So the real trouble is ACPI , which encode all platform bits if 
they're not included in any existing BUS spec, such as power, 
thermal, processor, battery, PCI routing, hotplug, EC, etc. Some
are owned by dom0 and some by Xen. However ACPI's AML encoding
makes automatic division between two categories really difficult.

Thanks,
Kevinÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
