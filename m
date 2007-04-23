Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXDWJHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXDWJHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXDWJHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:07:03 -0400
Received: from svr68.ehostpros.com ([67.15.48.48]:20328 "EHLO
	svr68.ehostpros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbXDWJG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:06:59 -0400
Subject: Re: Testing framework
From: Kalpak Shah <kalpak@linsyssoft.com>
To: Karuna sagar K <karunasagark@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com>
References: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 14:39:39 +0530
Message-Id: <1177319379.4579.13.camel@garfield>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - svr68.ehostpros.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linsyssoft.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 02:16 +0530, Karuna sagar K wrote:
> Hi,
> 
> For some time I had been working on this file system test framework.
> Now I have a implementation for the same and below is the explanation.
> Any comments are welcome.
> 
> Introduction:
> The testing tools and benchmarks available around do not take into
> account the repair and recovery aspects of file systems. The test
> framework described here focuses on repair and recovery capabilities
> of file systems. Since most file systems use 'fsck' to recover from
> file system inconsistencies, the test framework characterizes file
> systems based on outcomes of running 'fsck'.

<snip>

> Higher level perspective/approach:
> In this approach the file system is viewed as a tree of nodes, where
> nodes are either files or directories. The metadata information
> corresponding to some randomly chosen nodes of the tree are corrupted.
> Nodes which are corrupted are marked or recorded to be able to replay
> later. This file system is called source file system while the file
> system on which we need to replay the corruption is called target file
> system. The assumption is that the target file system contains a set
> of files and directories which is a superset of that in the source
> file system. Hence to replay the corruption we need point out which
> nodes in the source file system were corrupted in the source file
> system and corrupt the corresponding nodes in the target file system.
> 
> A major disadvantage with this approach is that on-disk structures
> (like superblocks, block group descriptors, etc.) are not considered
> for corruption.
> 
> Lower level perspective/approach:
> The file system is looked upon as a set of blocks (more precisely
> metadata blocks). We randomly choose from this set of blocks to
> corrupt. Hence we would be able to overcome the deficiency of the
> previous approach. However this approach makes it difficult to have a
> replayable corruption. Further thought about this approach has to be
> given.
> 

Fill a test filesystem with data and save it. Corrupt it by copying a
chunk of data from random locations A to B. Save positions A and B so
that you can reproduce the corruption. 

Or corrupt random bits (ideally in metadata blocks) and maintain the
list of the bit numbers for reproducing the corruption.

> We could have a blend of both the approaches in the program to
> compromise between corruption and replayability.
> 
> Repair Phase:
> The corrupted file system is repaired and recovered with 'fsck' or any
> other tools; this phase considers the repair and recovery action on
> the file system as a black box. The time taken to repair by the tool
> is measured.

I see that you are running fsck just once on the test filesystem. It
might be a good idea to run it twice and if second fsck does not find
the filesystem to be completely clean that means it is a bug in fsck.

<snip>

> Summary Phase:
> This is the final phase in the model. A report file is prepared which
> summarizes the result of this test run. The summary contains:
> 
> Average time taken for recovery
> Number of files lost at the end of each iteration
> Number of files with metadata corruption at the end of each iteration
> Number of files with data corruption at the end of each iteration
> Number of files lost and found at the end of each iteration
> 
> Putting it all together:
> The Corruption, Repair and Comparison phases could be repeated a
> number of times (each repetition is called an iteration) before the
> summary of that test run is prepared.
> 
> TODO:
> Account for files in the lost+found directory during the comparison phase.
> Support for other file systems (only ext2 is supported currently)
> State of the either file system is stored, which may be huge, time
> consuming and not necessary. So, we could have better ways of storing
> the state.

Also, people may want to test with different mount options, so something
like "mount -t $fstype -o loop,$MOUNT_OPTIONS $imgname $mountpt" may be
useful. Similarly it may also be useful to have MKFS_OPTIONS while
formatting the filesystem.

Thanks,
Kalpak.

> 
> Comments are welcome!!
> 
> Thanks,
> Karuna

