Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbXIFPU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbXIFPU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbXIFPUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:20:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:44710 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491AbXIFPUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:20:21 -0400
Message-ID: <46E019FC.5000001@qumranet.com>
Date: Thu, 06 Sep 2007 18:17:16 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       general@lists.openfabrics.org
Subject: Re: [PATCH][RFC] pte notifiers -- support for external page	tables
References: <11890207643068-git-send-email-avi@qumranet.com> <p73myw09g5w.fsf@bingen.suse.de>
In-Reply-To: <p73myw09g5w.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Avi Kivity <avi-atKUWr5tajBWk0Htik3J/w@public.gmane.org> writes:
>   
>> pte notifiers are different from paravirt_ops: they extend the normal
>> page tables rather than replace them; and they provide high-level information
>> such as the vma and the virtual address for the driver to use.
>>     
>
> Sounds like a locking horror to me.  To do anything with page tables
> you need locks. Both for the kernel page tables and for your new tables.
>
> What happens when people add all
> things of complicated operations in these notifiers? That will likely
> happen and then everytime you change something in VM code they 
> will break. This has the potential to increase the cost of maintaining
> VM code considerably, which would be a bad thing.
>
> This is quite different from paravirt ops because low level pvops
> can typically run lockless by just doing some kind of hypercall directly.
> But that won't work for maintaining your custom page tables.
>   

Okay, here's a possible fix: add ->lock() and ->unlock() callbacks, to 
be called when mmap_sem is taken either for read or write.  Also add a 
->release() for when the mm goes away to avoid the need to care about 
the entire data structure going away.

The notifier list would need to be kept sorted to avoid deadlocks.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

