Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbZHaXvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbZHaXvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZHaXvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:51:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZHaXva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:51:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=GGTRuVkp+PWHCU2AE6WITUooY+lkOcwpYsS3PxOjf0+SYB2/JKlMed2Ux2HEKmO6e
	lFf/rGIfYbX+rxzSXWqhg==
MIME-Version: 1.0
In-Reply-To: <20090831185640.GF3758@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	 <1251495072-7780-19-git-send-email-vgoyal@redhat.com>
	 <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com>
Date: Mon, 31 Aug 2009 16:51:25 -0700
Message-ID: <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to 
	track async bios.
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 11:56 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Mon, Aug 31, 2009 at 01:34:54PM -0400, Rik van Riel wrote:
>> Vivek Goyal wrote:
>>> o blkio_cgroup patches from Ryo to track async bios.
>>>
>>> o This functionality is used to determine the group of async IO from page
>>>   instead of context of submitting task.
>>>
>>> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
>>> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>
>> This seems to be the most complex part of the code so far,
>> but I see why this code is necessary.
>>
>
> Hi Rik,
>
> Thanks for reviewing the patches. I wanted to have better understanding of
> where all does it help to associate a bio to the group of process who
> created/owned the page. Hence few thoughts.
>
> When a bio is submitted to IO scheduler, it needs to determine the group
> bio belongs to and group which should be charged to. There seem to be two
> methods.
>
> - Attribute the bio to cgroup submitting process belongs to.
> - For async requests, track the original owner hence cgroup of the page
>  and charge that group for the bio.
>
> One can think of pros/cons of both the approaches.
>
> - The primary use case of tracking async context seems be that if a
>  process T1 in group G1 mmaps a big file and then another process T2 in
>  group G2, asks for memory and triggers reclaim and generates writes of
>  the file pages mapped by T1, then these writes should not be charged to
>  T2, hence blkio_cgroup pages.
>
>  But the flip side of this might be that group G2 is a low weight group
>  and probably too busy also right now, which will delay the write out
>  and possibly T2 will wait longer for memory to be allocated.
>
> - At one point of time Andrew mentioned that buffered writes are generally a
>  big problem and one needs to map these to owner's group. Though I am not
>  very sure what specific problem he was referring to. Can we attribute
>  buffered writes to pdflush threads and move all pdflush threads in a
>  cgroup to limit system wide write out activity?
>
> - Somebody also gave an example where there is a memory hogging process and
>  possibly pushes out some processes to swap. It does not sound fair to
>  charge those proccess for that swap writeout. These processes never
>  requested swap IO.
>
> - If there are multiple buffered writers in the system, then those writers
>  can also be forced to writeout some pages to disk before they are
>  allowed to dirty more pages. As per the page cache design, any writer
>  can pick any inode and start writing out pages. So it can happen a
>  weight group task is writting out pages dirtied by a lower weight group
>  task. If, async bio is mapped to owner's group, it might happen that
>  higher weight group task might be made to sleep on lower weight group
>  task because request descriptors are all consumed up.
>
> It looks like there does not seem to be a clean way which covers all the
> cases without issues. I am just trying to think, what is a simple way
> which covers most of the cases. Can we just stick to using submitting task
> context to determine a bio's group (as cfq does). Which can result in
> following.
>
> - Less code and reduced complexity.
>
> - Buffered writes will be charged to pdflush and its group. If one wish to
>  limit buffered write activity for pdflush, one can move all the pdflush
>  threads into a group and assign desired weight. Writes submitted in
>  process context will continue to be charged to that process irrespective
>  of the fact who dirtied that page.

What if we wanted to control buffered write activity per group? If a
group keeps dirtying pages, we wouldn't want it to dominate the disk
IO capacity at the expense of other cgroups (by dominating the writes
sent down by pdflush).

>
> - swap activity will be charged to kswapd and its group. If swap writes
>  are coming from process context, it gets charged to process and its
>  group.
>
> - If one is worried about the case of one process being charged for write
>  out of file mapped by another process during reclaim, then we can
>  probably make use of memory controller and mount memory controller and
>  io controller together on same hierarchy. I am told that with memory
>  controller, group's memory will be reclaimed by the process requesting
>  more memory. If that's the case, then IO will automatically be charged
>  to right group if we use submitting task context.
>
> I just wanted to bring this point forward for more discussions to know
> what is the right thing to do? Use bio tracking or not.
>
> Ryo, any thoughts on this?
>
> Thanks
> Vivek
>
>> Acked-by: Rik van Riel <riel@redhat.com>
>
