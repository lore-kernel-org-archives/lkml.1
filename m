Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbXGESQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbXGESQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbXGESPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:15:55 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:6794 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbXGESPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:15:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EF5q1fc3m1jnMlSNeFJ9BSthe3MYnx0K/iIlQS2OGHrk+5H1qXvFoG5PTOCwzZQKAb5akgPU9NLCIBh9YaphGuUjAJeyVUt5XCTr9O5YDfBRJZ2xHozSS6yLZfO6MhHkL29VPZdWcvS93RlR7LqXzYigSpZa6h/Wv65b3r4M/ls=
Message-ID: <f4527be0707051115p396bbc7ehbcbd293426f69073@mail.gmail.com>
Date: Thu, 5 Jul 2007 19:15:53 +0100
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Understanding I/O behaviour
In-Reply-To: <867098.12378.qm@web32607.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <867098.12378.qm@web32607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/07, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> Hi,
>
>  for a customer we are operating a rackful of HP/DL380/G4 boxes that
> have given us some problems with system responsiveness under [I/O
> triggered] system load.
>
>  The systems in question have the following HW:
>
> 2x Intel/EM64T CPUs
> 8GB memory
> CCISS Raid controller with 4x72GB SCSI disks as RAID5
> 2x BCM5704 NIC (using tg3)
>
>  The distribution is RHEL4. We have tested several kernels including
> the original 2.6.9, 2.6.19.2, 2.6.22-rc7 and 2.6.22-rc7+cfs-v18.
>
>  One part of the workload is when several processes try to write 5 GB
> each to the local filesystem (ext2->LVM->CCISS). When this happens, the
> load goes up to 12 and responsiveness goes down. This means from one
> moment to the next things like opening a ssh connection to the host in
> question, or doing "df" take forever (minutes). Especially bad with the
> vendor kernel, better (but not perfect) with 2.6.19 and 2.6.22-rc7.
>
>  The load basically comes from the writing processes and up to 12
> "pdflush" threads all being in "D" state.
>
>  So, what I would like to understand is how we can maximize the
> responsiveness of the system, while keeping disk throughput at maximum.
>
>  During my investiogation I basically performed the following test,
> because it represents the kind of trouble situation:
>
> ----
> $ cat dd3.sh
> echo "Start 3 dd processes: "`date`
> dd if=/dev/zero of=/scratch/X1 bs=1M count=5000&
> dd if=/dev/zero of=/scratch/X2 bs=1M count=5000&
> dd if=/dev/zero of=/scratch/X3 bs=1M count=5000&
> wait
> echo "Finish 3 dd processes: "`date`
> sync
> echo "Finish sync: "`date`
> rm -f /scratch/X?
> echo "Files removed: "`date`
> ----
>
>  This results in the following timings. All with the anticipatory
> scheduler, because it gives the best results:
>
> 2.6.19.2, HT: 10m
> 2.6.19.2, non-HT: 8m45s
> 2.6.22-rc7, HT: 10m
> 2.6.22-rc7, non-HT: 6m
> 2.6.22-rc7+cfs_v18, HT: 10m40s
> 2.6.22-rc7+cfs_v18, non-HT: 10m45s
>
>  The "felt" responsiveness was best with the last two kernels, although
> the load profile over time looks identical in all cases.
>
>  So, a few questions:
>
> a) any idea why disabling HT improves throughput, except for the cfs
> kernels? For plain 2.6.22 the difference is quite substantial

Under certain loads HT can reduce performance, I have had serious
performance problems on windows terminal servers with HT enabled, and
I now disable it on all servers, no matter what OS they run.

Why? http://blogs.msdn.com/slavao/archive/2005/11/12/492119.aspx

> b) any ideas how to optimize the settings of the /proc/sys/vm/
> parameters? The documentation is a bit thin here.

I cant offer any advice there, but is raid-5 really the best choice
for your needs? I would not choose raid-5 for a system that is
regularly performing lots of large writes at the same time, dont
forget that each write can require several reads to recalculate the
partity.

Does the raid card have much cache ram?

If you can afford to loose some space raid-10 would probably perform better.

Andy

>
> Thanks in advance
> Martin
>
> ------------------------------------------------------
> Martin Knoblauch
> email: k n o b i AT knobisoft DOT de
> www:   http://www.knobisoft.de
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
