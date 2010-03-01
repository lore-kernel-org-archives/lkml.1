Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0CAXBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:01:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55300 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0CAXBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AZ/qqko9/en4Fb6Yk/KKjhvlIj6w6RCXyMDj0KM78uZoXBUbALlTW1SYSjCtJXvI2S
         NvSTWnKLK1CW5wbLepUZjbCfcg7MIqhQiRjIx+Bfab6C395pfkdtABSN6k0leaqQmdKt
         dpIEbhlgTySEP47fu3qIePHWlHvhab5iS6FKE=
MIME-Version: 1.0
In-Reply-To: <20100301163552.GA3109@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com>
	 <20100301163552.GA3109@redhat.com>
Date: Tue, 2 Mar 2010 00:01:19 +0100
Message-ID: <4e5e476b1003011501h7b4ed638w3a620fa26ffec522@mail.gmail.com>
Subject: Re: [RFC, PATCH 0/2] Reworking seeky detection for 2.6.34
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, #@redhat.com,
       This@redhat.com, line@redhat.com, is@redhat.com, "ignored."@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Mon, Mar 1, 2010 at 5:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Feb 27, 2010 at 07:45:38PM +0100, Corrado Zoccolo wrote:
>>
>> Hi, I'm resending the rework seeky detection patch, together with
>> the companion patch for SSDs, in order to get some testing on more
>> hardware.
>>
>> The first patch in the series fixes a regression introduced in 2.6.33
>> for random mmap reads of more than one page, when multiple processes
>> are competing for the disk.
>> There is at least one HW RAID controller where it reduces performance,
>> though (but this controller generally performs worse with CFQ than
>> with NOOP, probably because it is performing non-work-conserving
>> I/O scheduling inside), so more testing on RAIDs is appreciated.
>>
>
> Hi Corrado,
>
> This time I don't have the machine where I had previously reported
> regressions. But somebody has exported me two Lun from an storage box
> over SAN and I have done my testing on that. With this seek patch applied,
> I still see the regressions.
>
> iosched=cfq     Filesz=1G   bs=64K
>
>                        2.6.33              2.6.33-seek
> workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
> --------  --- --  ----------  ----------  ----------  ----------   ---- ----
> brrmmap   3   1   7113        0           7044        0              0% 0%
> brrmmap   3   2   6977        0           6774        0             -2% 0%
> brrmmap   3   4   7410        0           6181        0            -16% 0%
> brrmmap   3   8   9405        0           6020        0            -35% 0%
> brrmmap   3   16  11445       0           5792        0            -49% 0%
>
>                        2.6.33              2.6.33-seek
> workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
> --------  --- --  ----------  ----------  ----------  ----------   ---- ----
> drrmmap   3   1   7195        0           7337        0              1% 0%
> drrmmap   3   2   7016        0           6855        0             -2% 0%
> drrmmap   3   4   7438        0           6103        0            -17% 0%
> drrmmap   3   8   9298        0           6020        0            -35% 0%
> drrmmap   3   16  11576       0           5827        0            -49% 0%
>
>
> I have run buffered random reads on mmaped files (brrmmap) and direct
> random reads on mmaped files (drrmmap) using fio. I have run these for
> increasing number of threads and did this for 3 times and took average of
> three sets for reporting.
>
> I have used filesize 1G and bz=64K and ran each test sample for 30
> seconds.
>
> Because with new seek logic, we will mark above type of cfqq as non seeky
> and will idle on these, I take a significant hit in performance on storage
> boxes which have more than 1 spindle.

Thanks for testing on a different setup.
I wonder if the wrong part for multi-spindle is the 64kb threshold.
Can you run with larger bs, and see if there is a value for which
idling is better?
For example on a 2 disk raid 0 I would expect  that a bs larger than
the stripe will still benefit by idling.

>
> So basically, the regression is not only on that particular RAID card but
> on other kind of devices which can support more than one spindle.
>
> I will run some test on single SATA disk also where this patch should
> benefit.
>
> Based on testing results so far, I am not a big fan of marking these mmap
> queues as sync-idle. I guess if this patch really benefits, then we need
> to first put in place some kind of logic to detect whether if it is single
> spindle SATA disk and then on these disks, mark mmap queues as sync.
>
> Apart from synthetic workloads, in practice, where this patch is helping you?

The synthetic workload mimics the page fault patterns that can be seen
on program startup, and that is the target of my optimization. In
2.6.32, we went the direction of enabling idling also for seeky
queues, while 2.6.33 tried to be more friendly with parallel storage
by usually allowing more parallel requests. Unfortunately, this
impacted this peculiar access pattern, so we need to fix it somehow.

Thanks,
Corrado

>
> Thanks
> Vivek
>
>
>> The second patch changes the seeky detection logic to be meaningful
>> also for SSDs. A seeky request is one that doesn't utilize the full
>> bandwidth for the device. For SSDs, this happens for small requests,
>> regardless of their location.
>> With this change, the grouping of "seeky" requests done by CFQ can
>> result in a fairer distribution of disk service time among processes.
>
