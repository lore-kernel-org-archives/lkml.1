Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbZDQL1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbZDQL1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbZDQL1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:27:30 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53485 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbZDQL13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:27:29 -0400
Message-ID: <49E8679D.8010405@oss.ntt.co.jp>
Date: Fri, 17 Apr 2009 20:27:25 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: kamezawa.hiroyu@jp.fujitsu.com, yoshikawa.takuya@oss.ntt.co.jp,
       righi.andrea@gmail.com, menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, taka@valinux.co.jp, lizf@cn.fujitsu.com,
       matt@bluehost.com, dradford@bluehost.com, ngupta@google.com,
       randy.dunlap@oracle.com, roberto@unbit.it, s-uchida@ap.jp.nec.com,
       subrata@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Block I/O tracking (was Re: [PATCH 3/9] bio-cgroup controller)
References: <1239740480-28125-4-git-send-email-righi.andrea@gmail.com>	<49E7E037.9080004@oss.ntt.co.jp>	<20090417112433.085ed604.kamezawa.hiroyu@jp.fujitsu.com> <20090417.162201.183038478.ryov@valinux.co.jp>
In-Reply-To: <20090417.162201.183038478.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:
> Hi,
> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Fri, 17 Apr 2009 11:24:33 +0900
> 
>> On Fri, 17 Apr 2009 10:49:43 +0900
>> Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:
>>
>>> Hi,
>>>
>>> I have a few question.
>>>    - I have not yet fully understood how your controller are using
>>>      bio_cgroup. If my view is wrong please tell me.
>>>
>>> o In my view, bio_cgroup's implementation strongly depends on
>>>    page_cgoup's. Could you explain for what purpose does this
>>>    functionality itself should be implemented as cgroup subsystem?
>>>    Using page_cgoup and implementing tracking APIs is not enough?
>> I'll definitely do "Nack" to add full bio-cgroup members to page_cgroup.
>> Now, page_cgroup is 40bytes(in 64bit arch.) And all of them are allocated at
>> boot time as memmap. (and add member to struct page is much harder ;)
>>
>> IIUC, feature for "tracking bio" is just necesary for pages for I/O.
>> So, I think it's much better to add misc. information to struct bio not to the page.
>> But, if people want to add "small hint" to struct page or struct page_cgroup
>> for tracking buffered I/O, I'll give you help as much as I can.
>> Maybe using "unused bits" in page_cgroup->flags is a choice with no overhead.
> 
> In the case where the bio-cgroup data is allocated dynamically,
>    - Sometimes quite a large amount of memory get marked dirty.
>      In this case it requires more kernel memory than that of the
>      current implementation.
>    - The operation is expansive due to memory allocations and exclusive
>      controls by such as spinlocks.
> 
> In the case where the bio-cgroup data is allocated by delayed allocation, 
>   - It makes the operation complicated and expensive, because
>     sometimes a bio has to be created in the context of other
>     processes, such as aio and swap-out operation.
> 
> I'd prefer a simple and lightweight implementation. bio-cgroup only
> needs 4bytes unlike memory controller. The reason why bio-cgroup chose
> this approach is to minimize the overhead.

Elaborating on Yoshikawa-san's comment, I would like to propose a
generic I/O tracking mechanism that is not tied to all the cgroup
paraphernalia. This approach has several advantages:

- By using this functionality, existing I/O schedulers (well, some
relatively minor changes would be needed) would be able to schedule
buffered I/O properly.

- The amount of memory consumed to do the tracking could be
optimized according to the kernel configuration (do we really
need struct page_cgroup when the cgroup memory controller or all
of the cgroup infrastructure has been configured out?).

The I/O tracking functionality would look something like the following:

- Create an API to acquire the I/O context of a certain page, which is
cgroup independent. For discussion purposes, I will assume that the
I/O context of a page is the io_context of the task that dirtied the
page (this can be changed if deemed necessary, though).

- When cgroups are not being used, pages would be tracked using a
pfn-indexed array of struct io_context (à la memcg's array of
struct page_cgroup).

- When cgroups are activated but the memory controller is not, we
would have a pfn-indexed array of struct blkio_cgroup, which would
have both a pointer to the corresponding io_context of the page and a
reference to the cgroup it belongs to (most likely using css_id). The
API offered by the I/O tracking mechanism would be extended so that
the kernel can easily obtain not only the per-task io_context but also
the cgroup a certain page belongs to. Please notice that by doing this
we have all the information we need to schedule buffered I/O both at
the cgroup-level and the task-level. From the memory usage point of
view, memory controller-specific bits would be gone and to top it all
we save one indirection level (since struct page_cgroup would be out
of the picture).

- When the memory controller is active we would have the
pfn-indexed array of struct page_cgroup we have know plus a
reference to the corresponding cgroup and io_context (yes, I
still want to do proper scheduling of buffered I/O within a
cgroup).

- Finally, since bio entering the block layer can generate additional
bios it is necessary to pass the I/O context information of original
bio down to the new bios. For that stacking devices such as dm and
those of that ilk will have to be modified. To improve performance I/O
context information would be cached in bios (to achieve this we have
to ensure that all bios that enter the block layer have the right I/O
context information attached to it).

Yoshikawa-san and myself have been working on a patch-set that
implements just this and we have reached that point where the kernel
does not panic right after booting:), so we will be sending patches soon
(hopefully this weekend).

Any thoughts?

Regards,

Fernando
