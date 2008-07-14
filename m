Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYGNHL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYGNHL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbYGNHLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:11:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:50135 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbYGNHLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dejxxWAVHFYw42zbCi9I6k+CWDbGqdhhuZeinqh7sUUX2Nq3Ek75svv0h4FZChcBGD
         fRefMn86gJ5OOTRYc7kvyhCqAI81EJFHT5P1JV8I8c0yeNfMCKc2rewJcmmP0eDp9kzW
         VIvk6dqP1NPhM9Giq+pOLhSrhC9t9L9GJrBkA=
Message-ID: <86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
Date: Mon, 14 Jul 2008 00:11:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation automatically
Cc: "Bernhard Walle" <bwalle@suse.de>, kexec@lists.infradead.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080627133256.GB5801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	 <20080627133256.GB5801@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 6:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jun 26, 2008 at 09:54:08PM +0200, Bernhard Walle wrote:
>> This patch removes the need of the crashkernel=...@offset parameter to define
>> a fixed offset for crashkernel reservation. That feature can be used together
>> with a relocatable kernel where the kexec-tools relocate the kernel and
>> get the actual offset from /proc/iomem.
>>
>> The use case is a kernel where the .text+.data+.bss is after 16M physical
>> memory (debug kernel with lockdep on x86_64 can cause that) which caused a
>> major pain in autoconfiguration in our distribution.
>>
>> Also, that patch unifies crashdump architectures a bit since IA64 has
>> that semantics from the very beginning of the kdump port.
>>
>> Please provide feedback!
>>
>
> Hi Bernhard,
>
> This looks like a good idea. That means distributions don't have to
> hardcode the crashbase at 16MB and the decision to find a free memory
> can be left on kernel. Users will also find it easy that way.
>
>>
>> Signed-off-by: Bernhard Walle <bwalle@suse.de>
>> ---
>>  arch/x86/kernel/setup.c |   70 +++++++++++++++++++++++++++++++++++------------
>>  1 files changed, 52 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index a81d82c..c30bb7b 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -435,6 +435,34 @@ static inline unsigned long long get_total_mem(void)
>>  }
>>
>>  #ifdef CONFIG_KEXEC
>> +
>> +/**
>> + * Reserve @size bytes of crashkernel memory at any suitable offset.
>> + *
>> + * @size: Size of the crashkernel memory to reserve.
>> + * Returns the base address on success, and -1ULL on failure.
>> + */
>> +unsigned long long find_and_reserve_crashkernel(unsigned long long size)
>> +{
>> +     const unsigned long long alignment = 16<<20;    /* 16M */
>> +     unsigned long long start = 0LL;
>> +
>> +     while (1) {
>> +             int ret;
>> +
>> +             start = find_e820_area(start, ULONG_MAX, size, alignment);

should use min_t(u64, 1ULL<<32, max_low_pfn<<PAGE_SHIFT) replace ULONG_MAX

YH
