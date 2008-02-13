Return-Path: <linux-kernel-owner+w=401wt.eu-S1764660AbYBMD70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764660AbYBMD70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYBMD7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:59:18 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1970 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752262AbYBMD7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:59:17 -0500
Message-ID: <47B26A6A.4000209@myri.com>
Date: Tue, 12 Feb 2008 22:56:26 -0500
From: Patrick Geoffray <patrick@myri.com>
Organization: Myricom, Inc
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Christoph Lameter <clameter@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Rik van Riel <riel@redhat.com>, steiner@sgi.com,
       Andrea Arcangeli <andrea@qumranet.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, linux-kernel@vger.kernel.org, avi@qumranet.com,
       linux-mm@kvack.org, daniel.blueman@qua
Subject: Re: [ofa-general] Re: Demand paging for memory regions
References: <20080209075556.63062452@bree.surriel.com> <Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com> <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com> <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com> <adazlu5vlub.fsf <20080213032533.GC32047@obsidianresearch.com>
In-Reply-To: <20080213032533.GC32047@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

Jason Gunthorpe wrote:
> I don't know much about Quadrics, but I would be hesitant to lump it
> in too much with these RDMA semantics. Christian's comments sound like
> they operate closer to what you described and that is why the have an
> existing patch set. I don't know :)

The Quadrics folks have been doing RDMA for 10 years, there is a reason 
why they maintained a patch.

> What it boils down to is that to implement true removal of pages in a
> general way the kernel and HCA must either drop packets or stall
> incoming packets, both are big performance problems - and I can't see
> many users wanting this. Enterprise style people using SCSI, NFS, etc
> already have short pin periods and HPC MPI users probably won't care
> about the VM issues enough to warrent the performance overhead.

This is not true, HPC people do care about the VM issues a lot. Memory 
registration (pinning and translating) is usually too expensive to be 
performed in the critical path before and after each send or receive. So 
they factor it out by registering a buffer the first time it is used, 
and keeping it registered in a registration cache. However, the 
application may free() a buffer that is in the registration cache, so 
HPC people provide their own malloc to catch free(). They also try to 
catch sbrk() and munmap() to deregister memory before it is released to 
the OS. This is a Major pain that a VM notifier would easily solve. 
Being able to swap registered pages to disk or migrate them in a NUMA 
system is a welcome bonus.

Patrick
-- 
Patrick Geoffray
Myricom, Inc.
http://www.myri.com
