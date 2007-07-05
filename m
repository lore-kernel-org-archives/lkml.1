Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbXGEXtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbXGEXtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbXGEXtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:49:09 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:21383 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102AbXGEXtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:49:08 -0400
Date: Thu, 05 Jul 2007 17:47:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Understanding I/O behaviour
In-reply-to: <fa.gAvf+r9fiPwNwNVqahYy5u1/Is0@ifi.uio.no>
To: knobi@knobisoft.de
Cc: linux-kernel@vger.kernel.org
Message-id: <468D832B.4060002@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.gAvf+r9fiPwNwNVqahYy5u1/Is0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
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
> b) any ideas how to optimize the settings of the /proc/sys/vm/
> parameters? The documentation is a bit thin here.

Try playing with reducing /proc/sys/vm/dirty_ratio and see how that 
helps. This workload will fill up memory with dirty data very quickly, 
and it seems like system responsiveness often goes down the toilet when 
this happens and the system is going crazy trying to write it all out.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

