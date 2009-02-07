Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZBGGi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZBGGi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 01:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbZBGGis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 01:38:48 -0500
Received: from omr8.networksolutionsemail.com ([205.178.146.58]:47711 "EHLO
	omr8.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbZBGGir convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 01:38:47 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Feb 2009 01:38:47 EST
From: "Gary L. Grobe" <gary@grobe.net>
To: linux-kernel@vger.kernel.org
Importance: Normal
Message-ID: <W8783110601149981233988222@webmail54>
X-Mailer: Network Solutions Webmail, Build 11.2.30
X-Originating-IP: [98.195.68.133]
X-Forwarded-For: [(null)]
Date: Sat, 07 Feb 2009 06:30:22 +0000
Subject: processes in D State too long too often
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently running 2.6.27-r7 with ether and myrinet interconnects on slave quad and dual-quad dell 1950's w/ 16-32Gb's ram and a master node that is a Dell 6850 w/ 32Gb.

I've got processes running on diskless nodes mounted to a master node via NFS. I see that several of these processes are in a D state, yet they recover in a very short time back to running (a few seconds) and then the CPU goes from 0% to 100% usage (which is correct, these CPU's should be running @ 100% as they're running some number crunching simulations, but when in D state CPU usage goes to 0%).

So why they are in a D state and waiting on I/O? Then I look on the master node and see that several nfsd's are also in a D state, and shortly recover back to running (I see this shown as '-' if using ps, or R in 'top').

Running 'ps -eal', I see in the WCHAN column for the processes in a D state the following (which I believe is what the processes are waiting on). It can be a mix of these. I usually see 'sync_p', 'nfs_wa', 'lmGrou', and 'txLock'. My file system type is JFS.

Here's a snipped 'ps -eal' listing on the master node.

1 D     0 26709     2  0  75  -5 -     0 lmGrou ?        00:00:07 nfsd
1 S     0 26710     2  0  75  -5 -     0 -      ?        00:00:07 nfsd
1 S     0 26711     2  0  75  -5 -     0 -      ?        00:00:04 nfsd
1 S     0 26712     2  0  75  -5 -     0 -      ?        00:00:08 nfsd
1 D     0 26713     2  0  75  -5 -     0 lmGrou ?        00:00:10 nfsd
1 S     0 26714     2  0  75  -5 -     0 -      ?        00:00:09 nfsd
1 D     0 26715     2  0  75  -5 -     0 txLock ?        00:00:08 nfsd
1 D     0 26716     2  0  75  -5 -     0 -      ?        00:00:09 nfsd
1 D     0 26717     2  0  75  -5 -     0 txLock ?        00:00:09 nfsd
1 S     0 26718     2  0  75  -5 -     0 -      ?        00:00:07 nfsd
1 D     0 26719     2  0  75  -5 -     0 -      ?        00:00:08 nfsd
1 D     0 26720     2  0  75  -5 -     0 sync_p ?        00:00:09 nfsd
1 S     0 26721     2  0  75  -5 -     0 -      ?        00:00:09 nfsd
1 S     0 26722     2  0  75  -5 -     0 -      ?        00:00:09 nfsd

And here's the same command on a diskless node which shows that my processes are in a D state w/ what seems to be nfs_wait (and from which they recover quite quickly, a few seconds later) ...

# ps -eal
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
...
1 S  1001  6145     1  0  80   0 -  6560 924758 ?        00:00:01 orted
0 D  1001  6146  6145 71  80   0 - 941316 nfs_wa ?       19:27:10 lve_1
0 D  1001  6147  6145 58  80   0 - 894594 nfs_wa ?       15:57:56 lve_1
0 R  1001  6148  6145 57  80   0 - 901343 -     ?        15:33:07 lve_1
0 R  1001  6149  6145 78  80   0 - 896065 -     ?        21:31:32 lve_1
...

'rpcinfo -p master_node' shows that I have portmapper, mountd, nlockmgr, and nfs running w/ all the correct normal info.

It would seem as if NFS was dropping out intermittently, but I've really gone all throughout the NFS config and see nothing wrong, my DNS servers are working fine, it's all running on a local LAN (no firewall issues), and I see the same results on many different diskless nodes so I don't believe it's a hardware issues. All my previous installations have run fine w/ this same NFS config.

Others have suggested this may be a 2.6.27-r7 kernel bug. I must note that I did not have this same problem running a 2.6.17 kernel w/ XFS. The hold up seems to be in the kernel and I'm looking for any advice is this might be the case.

Because these processes are going into a D state so often, a simulation that might normally run for 6 hours now takes 2 days to complete. I've tested the myrinet and ether interconnects and I see no issues from node to node or switch. I can reproduce the problem every time between any one node and the master.

So I'm looking for thoughts as to what might be going on and how to further investigate if this is in fact a kernel issue.






