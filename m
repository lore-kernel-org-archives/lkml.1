Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYC1Ovf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYC1Ovf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbYC1OkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:40:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54283 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758064AbYC1OkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:40:06 -0400
Message-ID: <47ED0343.1070708@sgi.com>
Date: Fri, 28 Mar 2008 07:40:03 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: modify show_shared_cpu_map in intel_cacheinfo
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>	 <20080327231654.599276000@polaris-admin.engr.sgi.com> <36ca99e90803280201i708ce9b7y293a2c68e733f088@mail.gmail.com>
In-Reply-To: <36ca99e90803280201i708ce9b7y293a2c68e733f088@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Fri, Mar 28, 2008 at 12:16 AM, Mike Travis <travis@sgi.com> wrote:
>> Used cpulist_scnprintf to print cpus on a leaf instead of requiring
>>  a new "cpumask_scnprintf_len" function to determine the size of
>>  the temporary buffer.  cpulist_scnprintf can be used to print directly
>>  to the output buffer, eliminating the need for the temporary buffer.
>>
>>  Based on:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>         git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>>
>>  Signed-off-by: Mike Travis <travis@sgi.com>
>>  ---
>>   arch/x86/kernel/cpu/intel_cacheinfo.c |   25 +++++++++++++++++--------
>>   1 file changed, 17 insertions(+), 8 deletions(-)
>>
>>  --- linux.trees.git.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
>>  +++ linux.trees.git/arch/x86/kernel/cpu/intel_cacheinfo.c
>>  @@ -593,14 +593,23 @@ static ssize_t show_size(struct _cpuid4_
>>
>>   static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
>>   {
>>  -       int n = 0;
>>  -       int len = cpumask_scnprintf_len(nr_cpu_ids);
>>  -       char *mask_str = kmalloc(len, GFP_KERNEL);
>>  -
>>  -       if (mask_str) {
>>  -               cpumask_scnprintf(mask_str, len, this_leaf->shared_cpu_map);
>>  -               n = sprintf(buf, "%s\n", mask_str);
>>  -               kfree(mask_str);
>>  +       /*
>>  +        * cpulist_scnprintf() has the advantage of compressing
>>  +        * consecutive cpu numbers into a single range which seems
>>  +        * appropriate for cpus on a leaf.  This will change what is
>>  +        * output so scripts that process the output will have to change.
> So this breaks user space?
> 
> Bert

Potentially, yes.  But I suspect with 4096 cpus, user scripts will have
to change anyways.  Currently it is represented as sets of 32 bit mask
outputs with comma separators, so 1152 characters would be output.

Is there a special notice I should provide to announce this change?

(And this output does conform with other syntax for printing and parsing
strings of bits.)

Thanks,
Mike
