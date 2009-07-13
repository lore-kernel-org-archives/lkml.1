Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZGMVUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZGMVUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbZGMVUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:20:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbZGMVT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:19:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=b0w9b/5t94OXwxpCOj0b6JsNeLxI7wavSXADZf9kxwzav47R/nGx2rUtHL1Y5TqUT
	r/ZtLkhVz+AzY0gOFL10A==
MIME-Version: 1.0
In-Reply-To: <1247425030-25344-1-git-send-email-vgoyal@redhat.com>
References: <1247425030-25344-1-git-send-email-vgoyal@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 13 Jul 2009 14:19:32 -0700
Message-ID: <af41c7c40907131419t4dcca78fmba16c99bbf4ebc4c@mail.gmail.com>
Subject: Re: [RFC] Improve CFQ fairness
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
     I saw a similar issue when running some tests with parallel sync
workloads. Looking at the blktrace output and staring at the
idle_window and seek detection code I realized that the think time
samples were taken for all consecutive IOs from a given cfqq. I think
doing so is not entirely correct as it also includes very long ttime
values for consecutive IOs which are separated by timeslices for other
sync queues too. To get a good estimate of the arrival pattern for a
cfqq we should only consider samples where the process was allowed to
send consecutive IOs down to the disk.
   I have a patch that fixes this which I will rebase and post soon.
This might help you avoid the idle window disabling.

Regards,
Divyesh

On Sun, Jul 12, 2009 at 11:57 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
>
> Hi,
>
> Sometimes fairness and throughput are orthogonal to each other. CFQ provides
> fair access to disk to different processes in terms of disk time used by the
> process.
>
> Currently above notion of fairness seems to be valid only for sync queues
> whose think time is within slice_idle (8ms by default) limit.
>
> To boost throughput, CFQ disables idling based on seek patterns also. So even
> if a sync queue's think time is with-in slice_idle limit, but this sync queue
> is seeky, then CFQ will disable idling on hardware supporting NCQ.
>
> Above is fine from throughput perspective but not necessarily from fairness
> perspective. In general CFQ seems to be inclined to favor throughput over
> fairness.
>
> How about introducing a CFQ ioscheduler tunable "fairness" which if set, will
> help CFQ to determine that user is interested in getting fairness right
> and will disable some of the hooks geared towards throughput.
>
> Two patches in this series introduce the tunable "fairness" and also do not
> disable the idling based on seek patterns if "fairness" is set.
>
> I ran four "dd" prio 0 BE class sequential readers on SATA disk.
>
> # Test script
> ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile1
> ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile2
> ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile3
> ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile4
>
> Normally one would expect that these processes should finish in almost similar
> time but following are the results of one of the runs (results vary between runs).
>
> 234179072 bytes (234 MB) copied, 6.0338 s, 38.8 MB/s
> 234179072 bytes (234 MB) copied, 6.34077 s, 36.9 MB/s
> 234179072 bytes (234 MB) copied, 8.4014 s, 27.9 MB/s
> 234179072 bytes (234 MB) copied, 10.8469 s, 21.6 MB/s
>
> Different between first and last process finishing is almost 5 seconds (Out of
> total 10 seconds duration). This seems to be too big a variance.
>
> I ran the blktrace to find out what is happening, and it seems we are very
> quick to disable idling based mean seek distance. Somehow initial 7-10 reads
> seem to be seeky for these dd processes. After that things stablize and we
> enable back the idling. But some of the processes get idling enabled early
> and some get it enabled really late and that leads to discrepancy in results.
>
> With this patchset applied, following are the results for above test case.
>
> echo 1  > /sys/block/sdb/queue/iosched/fairness
>
> 234179072 bytes (234 MB) copied, 9.88874 s, 23.7 MB/s
> 234179072 bytes (234 MB) copied, 10.0234 s, 23.4 MB/s
> 234179072 bytes (234 MB) copied, 10.1747 s, 23.0 MB/s
> 234179072 bytes (234 MB) copied, 10.4844 s, 22.3 MB/s
>
> Notice, how close the finish time and effective bandwidth are for all the
> four processes. Also notice that I did not witness any throughput degradation
> at least for this particular test case.
>
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
