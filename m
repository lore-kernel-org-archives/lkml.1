Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYDRMoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYDRMoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYDRMo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:44:28 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:47330 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbYDRMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:44:27 -0400
Date: Fri, 18 Apr 2008 15:46:00 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <20080413082815.GA20108@infradead.org>
Message-ID: <Pine.LNX.4.61.0804181331260.29728@dhcppc2>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
 <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet>
 <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org>
 <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 13 Apr 2008, Christoph Hellwig wrote:
> > I'm not complaining about anything.  Who has?
> > 
> > As the filesystem is for occasional, non-performance-sensitive use
> > by a very small number of people, doing it via FUSE sounds like an
> > all-round more practical approach.  This has nothing to do with quality of
> > implementation at all.
> 
> It's a stupid idea.  

FUSE is more than just providing a framework for block based filesystems. 
Sometimes FUSE is criticised for the extra useful features it provides. 
Sometimes the criticism comes from misunderstandings.

> less efficient because of the additional context switches 

This is about as true as claiming FUSE doesn't have any context switch 
overhead. Sometimes it has none, sometimes small, sometimes it can be 
significant (e.g. when not using the 50 fold context switch speed up 
patch). The question is, how releavant it is? Just some short notes,

 1. Using the in-kernel cached data involves no context switch for FUSE.

 2. On commodity hardware Linux can do a million context switches. 
    File system workloads barely need or can do more than a few tens 
    of thousands file operations per second (fsops) due to storage 
    bottlenecks. Which means maximum about only extra 5% CPU use for 
    block based FUSE file systems. 

    If they do more fsops then typically it's served from the kernel caches
    and no user space and context switches are involved at all.

 3. ext3 with the highly optimized dir_index is far the fastest 
    traditional block based file system in file creation. Once I wrote
    a FUSE file system which apparently would have been faster if the 
    VFS wouldn't do needlessly a lookup() before create(). AFAIK some 
    network file systems have the some performance problem because of 
    this.

 4. The dominant factors for performance is design, quality of the
    implementation and lead time to optimize for the (latest) hardware. 
    What's the best way to realize this depends on many factors.

 5. Some workloads can indeed trigger very high context switches. This 
    could be improved/solved but probably it would be more beneficial to 
    improve context switch performance in software and hardware.

> and harder to use because you need additional userspace packages and need 
> to setup fuse.

The fuse install should solve all setup issues and a fuse fs can be written 
where the traditional commands work:

	mount -t fstype device mountpoint
	umount mountpoint

Ntfs-3g doesn't even need fuse user space being installed, only a 
modprobeable fuse kernel module.

	Szaka

-- 
NTFS-3G:  http://ntfs-3g.org
