Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbZDBPZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbZDBPZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbZDBPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:25:00 -0400
Received: from fir.cise.ufl.edu ([128.227.205.250]:4275 "EHLO
	mail.cise.ufl.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756761AbZDBPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:24:59 -0400
X-Greylist: delayed 1125 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 11:24:59 EDT
Message-ID: <52041.128.227.162.217.1238684768.squirrel@webmail.cise.ufl.edu>
Date: Thu, 2 Apr 2009 11:06:08 -0400 (EDT)
Subject: I/O throughput problem in newer kernels
From: adobra@cise.ufl.edu
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.5.1 [CVS]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While putting together a not so average machine for database research, I
bumped into the following performance problem with the newer kernels (I
tested 2.6.27.11, 2.6.29): the aggregate throughput drops drastically when
more than 20 hard drives are involved in the operation. This problem is
not happening on 2.6.22.9 or 2.6.20 (did not test other kernels).

Since I am not subscribed to the mailing list, I would appreciate you
cc-ing me on any reply or discussion.

1. Description of the machine
-----------------------------------------------
8 Quad-Core AMD Opteron(tm) Processor 8346 HE
Each processor has independent memory banks (16GB in each bank for 128GB
total)
Two PCI busses (connected in different places in the NUMA architecture)
8 hard drives installed into the base system on SATA interfaces
    First hard drive dedicated to the OS
    7 Western Digital hard drives (90 MB/s max throughput)
    Nvidia SATA chipset
4 Adaptec 5805 RAID cards installed in PCI-E 16X slots (all running at 8X
speed)
   The 4 cards live on two separate PCI busses
6 IBM EXP3000 disk enclosures
   2 cards connect to 2 enclosures each, the other 2 to 1 enclosure
8 Western Digital Velociraptor HD in each enclosure
   Max measured throughput 110-120 MB/s

Total number of hard drives used the tests: 7+47=54 or subsets
The Adaptec cards are configure to expose each disk individually to the
OS. Any RAID configuration seems to limit the throughput at 300-350MB/s
which is too low for the purpose of this system.

2. Throughput tests
--------------------------------
I did two types of tests: using dd (spawning parallel dd jobs that lasted
at least 10s) or using a multi-threaded program that simulates the
intended usage for the system. Results using both are consistent so I will
only report the results with the custom program. Both the dd test and the
custom one do reads in large chunks (256K/request at least). All request
in the custom program are made with "read" system call to page aligned
memory (allocated with mmap to make sure). The kernel is doing a zero-copy
to user space otherwise the speeds observed are not possible.

Here is what I observed in terms of throughput:
a. Speed/WD disk: 90 MB/s
b. Speed/Velociraptor disk: 110 MB/s
c. Speed of all WD disks in base system: 700MB/s
d. Speed of disks in one enclosure: 750 MB/s
e. Speed of disks connected to one Adaptec card: 1000 MB/s
f. Speed of disks connected on a single PCI bus: 2000 MB/s

The above numbers look good and are consistent on all kernels that I tried.

THE PROBLEM: when the number of disks exceeds 20 the throughput plummets
on newer kernels.

g. SPEED OF ALL DISKS: 600 MB/s on newer kernels, 2700 MB/s on older kernels
The throughput drops drastically the moment 20-25 hard drives are involved

3. Tests I performed to ensure the number of hard drives is the culprit
----------------------------------------------------------------------------------------------------------------
a. Took 1, 2, 3 and 4 disks from each enclosure to ensure uniform load on
buses
    performance going up as expected until 20 drives reached than dropping

b. Involved combinations of the regular WD drives and the Velociraptors.
    Had no major influence on the observation

c. Involved combinations of enclosures
    No influence

d. Used the hard drives in decreasing order of measured speed (as reported
by hdparm)
    Only minor influence and still drastic drop at 20

e. Changed the I/O scheduler used for the hard drives
    No influence

4. Things that I do not think are wrong
--------------------------------------------------------------
a. aacraid or scsi_nv drivers
    The problem depends only on the number of hard drives not the
combination of the drives themselves

b. Limitations on the buses
    The measured speeds of the subsystems indicate that no bottleneck on
individual buses is reached. Even if this is the case, the throughput
should level up not drop dramatically

c. Failures in the system
    No errors reported in /var/log/messages or other logs related to I/O

Of course, this begs the question WHAT IS WRONG?

I would be more than happy to run any tests you suggest on my system to
find the problem.

Alin

-- 
Alin Dobra
Assistant Professor
Computer Information Science & Engineering Department
University of Florida

