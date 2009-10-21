Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZJUTWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZJUTWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbZJUTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:22:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273AbZJUTWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:22:18 -0400
Message-ID: <4ADF5F52.10508@redhat.com>
Date: Wed, 21 Oct 2009 14:21:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: XFS stack overhead
References: <20091015183540.GA8098@redhat.com> <20091015190720.GA19467@elte.hu> <4ADF2DAA.9030604@redhat.com> <20091021110053.26ab9982@infradead.org> <4ADF59F8.7010205@redhat.com> <20091021191648.GA12259@elte.hu>
In-Reply-To: <20091021191648.GA12259@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> Arjan van de Ven wrote:
>>> On Wed, 21 Oct 2009 10:50:02 -0500
>>> Eric Sandeen <sandeen@redhat.com> wrote:
>>>
>>>> Ingo Molnar wrote:
>>>>> (Cc:-ed Arjan too.)
>>>>>
>>>>> * Dave Jones <davej@redhat.com> wrote:
>>>>>
>>>>>> 113c5413cf9051cc50b88befdc42e3402bb92115 introduced a change that
>>>>>> made CC_STACKPROTECTOR_ALL not-selectable if someone enables 
>>>>>> CC_STACKPROTECTOR.
>>>>>>
>>>>>> We've noticed in Fedora that this has introduced noticable
>>>>>> overhead on some functions, including those which don't even have
>>>>>> any on-stack variables.
>>>>>>
>>>>>> According to the gcc manpage, -fstack-protector will protect
>>>>>> functions with as little as 8 bytes of stack usage. So we're
>>>>>> introducing a huge amount of overhead, to close a small amount of
>>>>>> vulnerability (the >0 && <8 case).
>>>>>>
>>>>>> The overhead as it stands right now means this whole option is 
>>>>>> unusable for a distro kernel without reverting the above commit.
>>>>> Exactly what workload showed overhead, and how much?
>>>>>
>>>>> 	Ingo
>>>> I had xfs blowing up pretty nicely; granted, xfs is not svelte but it
>>>> was never this bad before.
>>>>
>>> do you have any indication that SP actually increases the stack
>>> footprint by that much? it's only a few bytes....
>>>
>>>
>> Here's a sample of some of the largest xfs stack users,
>> and the effect stack-protector had on them.  This was just
>> done with objdump -d xfs.ko | scripts/checkstack.pl; I don't
>> know if there's extra runtime stack overhead w/ stackprotector?
>>
>> -Eric
>>
>> function                  nostack stackprot delta delta %
>> xfs_bmapi                      376      408    32  9%
>> xfs_bulkstat                   328      344    16  5%
>> _xfs_trans_commit              296      312    16  5%
>> xfs_iomap_write_delay          264      280    16  6%
>> xfs_file_ioctl                 248      312    64 26%
>> xfs_symlink                    248      264    16  6%
>> xfs_bunmapi                    232      280    48 21%
>> xlog_do_recovery_pass          232      248    16  7%
>> xfs_trans_unreserve_and_mod_sb 224      240    16  7%
>> xfs_bmap_del_extent            216      248    32 15%
>> xfs_cluster_write              216      232    16  7%
>> xfs_file_compat_ioctl          216      296    80 37%
>> xfs_attr_set_int               200      216    16  8%
>> xfs_bmap_add_extent_delay_real 200      248    48 24%
> 
> Note that those are very large stack frames to begin with.
> 
> 3496 bytes - that's a _lot_ - can anyone even run XFS with 4K stacks on? 

The above isn't a callchain; those are just the biggest users.

Yes, xfs works w/4k stacks but sometimes not over complex storage.

> With stackprotector it's 3928 - a 12% increase - which certainly does 
> not help - but the basic problem is the large stack footprint to begin 
> with.

I can find plenty of examples of > 300 bytes stack users in the core
kernel write path too, I'm just using xfs as an example...

> Also, the posting apparently mixes 'stack overhead' with 'runtime 
> overhead'.

right, that's why I asked, I'm not sure if stackprotector has runtime
overhead as well.

-Eric

> 	Ingo

