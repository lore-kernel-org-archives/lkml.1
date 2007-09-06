Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbXIFIl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbXIFIl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 04:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbXIFIlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 04:41:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:60859 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbXIFIlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 04:41:19 -0400
Message-ID: <46DFBC7C.2020709@qumranet.com>
Date: Thu, 06 Sep 2007 11:38:20 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org
Subject: Re: [PATCH][RFC] pte notifiers -- support for external page tables
References: <11890207643068-git-send-email-avi@qumranet.com> <1189052899.6224.5.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1189052899.6224.5.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> On Wed, 2007-09-05 at 22:32 +0300, Avi Kivity wrote:
>   
>> [resend due to bad alias expansion resulting in some recipients
>>  being bogus]
>>
>> Some hardware and software systems maintain page tables outside the normal
>> Linux page tables, which reference userspace memory.  This includes
>> Infiniband, other RDMA-capable devices, and kvm (with a pending patch).
>>
>> Because these systems maintain external page tables (and external tlbs),
>> Linux cannot demand page this memory and it must be locked.  For kvm at
>> least, this is a significant reduction in functionality.
>>
>> This sample patch adds a new mechanism, pte notifiers, that allows drivers
>> to register an interest in a changes to ptes. Whenever Linux changes a
>> pte, it will call a notifier to allow the driver to adjust the external
>> page table and flush its tlb.
>>
>> Note that only one notifier is implemented, ->clear(), but others should be
>> similar.
>>
>> pte notifiers are different from paravirt_ops: they extend the normal
>> page tables rather than replace them; and they provide high-level
>> information
>> such as the vma and the virtual address for the driver to use.
>>     
> Looks great. So for kvm, all guest pages will be vma mapped?
> There are lock issues in kvm between kvm lock and page lock. 
>   

Yes, locking will be a headache.

> Will shadow page table be still stored in page->private? If yes, the
> page->private must be cleaned before add_to_swap.
>   

page->private can be in use by filesystems, so we will need to move rmap 
somewhere else.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

