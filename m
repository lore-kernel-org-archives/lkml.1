Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0BKApp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:45:45 -0500
Received: from mail-pz0-f173.google.com ([209.85.222.173]:47035 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0BKApn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NXBATphn21dKnZSGDce4S4n1wmdEVu4Ab4YLrLjia/NF2/wmQu4gxsW7b5rZb/C9hC
         kpu2BN7NzfFUjEr0P8G+kBlD3wNp+CjfxadLGnUyw2GEbgQAF1sLR968UpmxWjjUqWt1
         zw5kVnrLvJXp3fkOJkeNdXduhjFBYKiJK7pRk=
MIME-Version: 1.0
In-Reply-To: <4B72E74C.9040001@nortel.com>
References: <4B71927D.6030607@nortel.com>
	 <20100210093140.12D9.A69D9226@jp.fujitsu.com>
	 <4B72E74C.9040001@nortel.com>
Date: Thu, 11 Feb 2010 09:45:42 +0900
Message-ID: <28c262361002101645g3fd08cc7t6a72d27b1f94db62@mail.gmail.com>
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
From: Minchan Kim <minchan.kim@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Chris.

On Thu, Feb 11, 2010 at 2:05 AM, Chris Friesen <cfriesen@nortel.com> wrote:
> On 02/09/2010 06:32 PM, KOSAKI Motohiro wrote:
>
>> can you please post your /proc/meminfo?
>
>
> On 02/09/2010 09:50 PM, Balbir Singh wrote:
>> Do you have swap enabled? Can you help with the OOM killed dmesg log?
>> Does the situation get better after OOM killing.
>
>
> On 02/09/2010 10:09 PM, KOSAKI Motohiro wrote:
>
>> Chris, 2.6.27 is a bit old. plese test it on latest kernel. and please
> don't use
>> any proprietary drivers.
>
>
> Thanks for the replies.
>
> Swap is enabled in the kernel, but there is no swap configured.  ipcs
> shows little consumption there.
>
> The test load relies on a number of kernel modifications, making it
> difficult to use newer kernels. (This is an embedded system.)  There are
> no closed-source drivers loaded, though there are some that are not in
> vanilla kernels.  I haven't yet tried to reproduce the problem with a
> minimal load--I've been more focused on trying to understand what's
> going on in the code first.  It's on my list to try though.
>
> Here are some /proc/meminfo outputs from a test run where we
> artificially chewed most of the free memory to try and force the oom
> killer to fire sooner (otherwise it takes days for the problem to trigger).
>
> It's spaced with tabs so I'm not sure if it'll stay aligned.  The first
> row is the sample number.  All the HugePages entries were 0.  The
> DirectMap entries were constant. SwapTotal/SwapFree/SwapCached were 0,
> as were Writeback/NFS_Unstable/Bounce/WritebackTmp.
>
> Samples were taken 10 minutes apart.  Between samples 49 and 50 the
> oom-killer fired.
>
>                13              49              50
> MemTotal        4042848         4042848         4042848
> MemFree         113512          52668           69536
> Buffers         20              24              76
> Cached          1285588         1287456         1295128
> Active          2883224         3369440         2850172
> Inactive        913756          487944          990152
> Dirty           36              216             252
> AnonPages       2274756         2305448         2279216
> Mapped          10804           12772           15760
> Slab            62324           62568           63608
> SReclaimable    24092           23912           24848
> SUnreclaim      38232           38656           38760
> PageTables      11960           12144           11848
> CommitLimit     2021424         2021424         2021424
> Committed_AS    12666508        12745200        7700484
> VmallocUsed     23256           23256           23256
>
> It's hard to get a good picture from just a few samples, so I've
> attached an ooffice spreadsheet showing three separate runs.  The
> samples above are from sheet 3 in the document.
>
> In those spreadsheets I notice that
> memfree+active+inactive+slab+pagetables is basically a constant.
> However, if I don't use active+inactive then I can't make the numbers
> add up.  And the difference between active+inactive and
> buffers+cached+anonpages+dirty+mapped+pagetables+vmallocused grows
> almost monotonically.

Such comparison is not right. That's because code pages of program account
with cached and mapped but they account just one in lru list(active +
inactive).
Also, if you use mmap on any file, above is applied.

I can't find any clue with your attachment.
You said you used kernel with some modification and non-vanilla drivers.
So I suspect that. Maybe kernel memory leak?

Now kernel don't account kernel memory allocations except SLAB.
I think this patch can help you find the kernel memory leak.
(It isn't merged with mainline by somewhy but it is useful to you :)

http://marc.info/?l=linux-mm&m=123782029809850&w=2


>
> Thanks,
>
> Chris
>



-- 
Kind regards,
Minchan Kim
