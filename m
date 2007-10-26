Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbXJZOZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbXJZOZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXJZOZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:25:24 -0400
Received: from web32612.mail.mud.yahoo.com ([68.142.207.239]:46524 "HELO
	web32612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750865AbXJZOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:25:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 10:25:22 EDT
X-Mailer: YahooMailRC/814.06 YahooMailWebService/0.7.152
Date: Fri, 26 Oct 2007 07:18:41 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: 2.6.24-rc1: First impressions
To: linux-kernel@vger.kernel.org
Cc: Peter zijlstra <a.p.zijlstra@chello.nl>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <796505.25770.qm@web32612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

 just to give some feedback on 2.6.24-rc1. For some time I am tracking IO/writeback problems that hurt system responsiveness big-time. I tested Peters stuff together with Fenguangs additions and it looked promising. Therefore I was very happy to see Peters stuff going into 2.6.24 and waited eagerly for rc1. In short, I am impressed. This really looks good. IO throughput is great and I could not reproduce the responsiveness problems so far.

 Below are a some numbers of my brute-force I/O tests that I can use to bring responsiveness down. My platform is a HP/DL380g4, dual CPUs, HT-enabled, 8 GB Memory, SmartaArray6i controller with 4x72GB SCSI disks as RAID5 (battery protected writeback cahe enabled) and gigabit networking (tg3). User space is 64-bit RHEL4.3

 I am basically doing copies using "dd" with 1MB blocksize. Local Filesystem ist ext2 (noatime). IO-Scheduler is dealine, as it tends to give best results. NFS3 Server is a Sun/T2000/Solaris10. The tests are:

dd1 - copy 16 GB from /dev/zero to local FS
dd1-dir - same, but using O_DIRECT for output
dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to local FS
dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo local FS
net1 - copy 5.2 GB from NFS3 share to local FS
mix3 - copy 3x5.2 GB from /dev/zero to local disk and two NFS3 shares

 I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1. All units are MB/sec.

test           2.6.19.2     2.6.22.6    2.6.24.-rc1
----------------------------------------------------------------
dd1           28            50                96
dd1-dir     88                88                86
dd2          2x16.5       2x11            2x44.5
dd2-dir      2x44          2x44            2x43
dd3            3x9.8        3x8.7         3x30
dd3-dir      3x29.5      3x29.5        3x28.5
net1            30-33         50-55         37-52
mix3           17/32         25/50        96/35 (disk/combined-network)


 Some observations:

- single threaded disk speed really went up wit 2.6.24-rc1. It is now even better than O_DIRECT
- O_DIRECT took a slight hit compared to the older kernels. Not an issue for me, but maybe others care
- multi threaded non O_DIRECT scales for the first time ever !!!! Almost no loss compared to single threaded !!!!!!
- network throughput took a hit from 2.6.22.6 and is not as repeatable. Still better than 2.6.19.2 though

 What actually surprises me most is the big performance win on the single threaded non O_DIRECT dd test. I did not expect that :-) What I had hoped for was of course the scalability.

 So, this looks great and most likely I will push 2.6.24 (maybe .X) into my environment.

Happy weekend
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de


