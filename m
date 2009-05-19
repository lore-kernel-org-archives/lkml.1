Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZEST2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZEST2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 15:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZEST2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 15:28:41 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34175 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbZEST2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 15:28:40 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Weidong Han <weidong.han@intel.com>, dwmw2@infradead.org,
       suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
	<1242757912-6041-3-git-send-email-weidong.han@intel.com>
	<20090519115055.GB14305@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 19 May 2009 12:28:36 -0700
In-Reply-To: <20090519115055.GB14305@elte.hu> (Ingo Molnar's message of "Tue\, 19 May 2009 13\:50\:55 +0200")
Message-ID: <m1k54cj3iz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: mingo@elte.hu, kvm@vger.kernel.org, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, dwmw2@infradead.org, weidong.han@intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Weidong Han <weidong.han@intel.com> wrote:
>
>> To support domain-isolation usages, the platform hardware must be 
>> capable of uniquely identifying the requestor (source-id) for each 
>> interrupt message. Without source-id checking for interrupt 
>> remapping , a rouge guest/VM with assigned devices can launch 
>> interrupt attacks to bring down anothe guest/VM or the VMM itself.
>> 
>> This patch adds source-id checking for interrupt remapping, and 
>> then really isolates interrupts for guests/VMs with assigned 
>> devices.
>> 
>> Because PCI subsystem is not initialized yet when set up IOAPIC 
>> entries, use read_pci_config_byte to access PCI config space 
>> directly.
>> 
>> Signed-off-by: Weidong Han <weidong.han@intel.com>
>> ---
>>  arch/x86/kernel/apic/io_apic.c |    6 +++
>>  drivers/pci/intr_remapping.c   |   90 ++++++++++++++++++++++++++++++++++++++-
>>  drivers/pci/intr_remapping.h   |    2 +
>>  include/linux/dmar.h           |   11 +++++
>>  4 files changed, 106 insertions(+), 3 deletions(-)
>
> Code structure looks nice now. (and i susect you have tested this on 
> real and relevant hardware?) I've Cc:-ed Eric too ... does this 
> direction look good to you too Eric?

Being a major nitpick, I have to point out that the code is not
structured to support other iommus, and I think AMD has one that can
do this as well. 

The early pci reading of the bus is just wrong.  What happens if the
pci layer decided to renumber things?  It looks like we have a real
dependency on pci there and are avoiding sorting it out with this.

Hmm.  But that is what we use in setup_ioapic_sid....
I expect the right solution is to delay enabling ioapic entries
until driver enable them.   That could also reduce screaming
irqs during bootup in the kdump case.

set_msi_sid looks wrong.  The comment are unhelpful. irte->svt should
get an enum value or a deine (removing the repeated explanations of
the magic value) and then we could have room to explain why we
are doing what we are doing.

Not finding an upstream pcie_bridge and then concluding we are a pcie
device seems bogus.

Why if we do have an upstream pcie bridge do we only want to do a bus
range verification instead of checking just for the bus :devfn?

The legacy PCI case seems even stranger.

....

The table of apic information by apic_id also seems wrong.   Don't
we have chip_data or something that should point it  that we can
get from the irq?

Eric
