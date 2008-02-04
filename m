Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYBDW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYBDW6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYBDW6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:58:06 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60583 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbYBDW6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:58:03 -0500
Message-ID: <47A7986B.1070206@garzik.org>
Date: Mon, 04 Feb 2008 17:57:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net> <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain> <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204210121.GF18682@fieldses.org> <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So no, performance is not the only reason to move to kernel space. It can 
> easily be things like needing direct access to internal data queues (for a 
> iSCSI target, this could be things like barriers or just tagged commands - 
> yes, you can probably emulate things like that without access to the 
> actual IO queues, but are you sure the semantics will be entirely right?
> 
> The kernel/userland boundary is not just a performance boundary, it's an 
> abstraction boundary too, and these kinds of protocols tend to break 
> abstractions. NFS broke it by having "file handles" (which is not 
> something that really exists in user space, and is almost impossible to 
> emulate correctly), and I bet the same thing happens when emulating a SCSI 
> target in user space.

Well, speaking as a complete nutter who just finished the bare bones of 
an NFSv4 userland server[1]...  it depends on your approach.

If the userland server is the _only_ one accessing the data[2] -- i.e. 
the database server model where ls(1) shows a couple multi-gigabyte 
files or a raw partition -- then it's easy to get all the semantics 
right, including file handles.  You're not racing with local kernel 
fileserving.

Couple that with sendfile(2), sync_file_range(2) and a few other 
Linux-specific syscalls, and you've got an efficient NFS file server.

It becomes a solution similar to Apache or MySQL or Oracle.


I quite grant there are many good reasons to do NFS or iSCSI data path 
in the kernel...  my point is more that "impossible" is just from one 
point of view ;-)


> Maybe not. I _rally_ haven't looked into iSCSI, I'm just guessing there 
> would be things like ordering issues.

iSCSI and NBD were passe ideas at birth.  :)

Networked block devices are attractive because the concepts and 
implementation are more simple than networked filesystems... but usually 
you want to run some sort of filesystem on top.  At that point you might 
as well run NFS or [gfs|ocfs|flavor-of-the-week], and ditch your 
networked block device (and associated complexity).

iSCSI is barely useful, because at least someone finally standardized 
SCSI over LAN/WAN.

But you just don't need its complexity if your filesystem must have its 
own authentication, distributed coordination, multiple-connection 
management code of its own.

	Jeff


P.S.  Clearly my NFSv4 server is NOT intended to replace the kernel one. 
  It's more for experiments, and doing FUSE-like filesystem work.


[1] http://linux.yyz.us/projects/nfsv4.html

[2] well, outside of dd(1) and similar tricks... the same "going around 
its back" tricks that can screw up a mounted filesystem.

