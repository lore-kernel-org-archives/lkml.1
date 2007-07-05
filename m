Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXGEPk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXGEPk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbXGEPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:40:18 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:44974 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757693AbXGEPkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:40:17 -0400
X-YMail-OSG: gPnCOQcVM1nGDeGwACyzDa5u85ykp8dVYmpbDdMQ6aEdrjAABLYOE7meUSgsLisDZiTZ93va3sOsWZW2y.xn6SvXXajc9z0-
X-RocketYMMF: knobi.rm
Date: Thu, 5 Jul 2007 08:40:16 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Understanding I/O behaviour
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <867098.12378.qm@web32607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 for a customer we are operating a rackful of HP/DL380/G4 boxes that
have given us some problems with system responsiveness under [I/O
triggered] system load.

 The systems in question have the following HW:

2x Intel/EM64T CPUs
8GB memory
CCISS Raid controller with 4x72GB SCSI disks as RAID5
2x BCM5704 NIC (using tg3)

 The distribution is RHEL4. We have tested several kernels including
the original 2.6.9, 2.6.19.2, 2.6.22-rc7 and 2.6.22-rc7+cfs-v18.

 One part of the workload is when several processes try to write 5 GB
each to the local filesystem (ext2->LVM->CCISS). When this happens, the
load goes up to 12 and responsiveness goes down. This means from one
moment to the next things like opening a ssh connection to the host in
question, or doing "df" take forever (minutes). Especially bad with the
vendor kernel, better (but not perfect) with 2.6.19 and 2.6.22-rc7.

 The load basically comes from the writing processes and up to 12
"pdflush" threads all being in "D" state.

 So, what I would like to understand is how we can maximize the
responsiveness of the system, while keeping disk throughput at maximum.

 During my investiogation I basically performed the following test,
because it represents the kind of trouble situation:

----
$ cat dd3.sh
echo "Start 3 dd processes: "`date`
dd if=/dev/zero of=/scratch/X1 bs=1M count=5000&
dd if=/dev/zero of=/scratch/X2 bs=1M count=5000&
dd if=/dev/zero of=/scratch/X3 bs=1M count=5000&
wait
echo "Finish 3 dd processes: "`date`
sync
echo "Finish sync: "`date`
rm -f /scratch/X?
echo "Files removed: "`date`
----

 This results in the following timings. All with the anticipatory
scheduler, because it gives the best results:

2.6.19.2, HT: 10m
2.6.19.2, non-HT: 8m45s
2.6.22-rc7, HT: 10m
2.6.22-rc7, non-HT: 6m
2.6.22-rc7+cfs_v18, HT: 10m40s
2.6.22-rc7+cfs_v18, non-HT: 10m45s

 The "felt" responsiveness was best with the last two kernels, although
the load profile over time looks identical in all cases.

 So, a few questions:

a) any idea why disabling HT improves throughput, except for the cfs
kernels? For plain 2.6.22 the difference is quite substantial
b) any ideas how to optimize the settings of the /proc/sys/vm/
parameters? The documentation is a bit thin here.

Thanks in advance
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
