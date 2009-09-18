Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbZIRSiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbZIRSiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbZIRSiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:38:14 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:38625 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447AbZIRSiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:38:13 -0400
Date: Fri, 18 Sep 2009 11:37:57 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Fasheh <mfasheh@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
Message-ID: <20090918183757.GA8551@mail.oracle.com>
Mail-Followup-To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
References: <20090915005417.GD4507@mail.oracle.com>
 <alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
 <20090915040601.GE4507@mail.oracle.com>
 <alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
 <20090915214530.GA11060@mail.oracle.com>
 <alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
 <20090916044047.GA30453@mail.oracle.com>
 <alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
 <20090918014333.GD15620@mail.oracle.com>
 <4AB38C5A.4070506@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AB38C5A.4070506@draigBrady.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AB3D389.00D3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 02:34:18PM +0100, Pádraig Brady wrote:
> Joel Becker wrote:
> > On Thu, Sep 17, 2009 at 09:29:14AM -0700, Linus Torvalds wrote:
> >> Why would anybody want to hide it at all? Why even the libc hiding?
> >>
> >> Nobody is going to use this except for special apps. Let them see what
> >> they can do, in all its glory.
> >
> > 	I expect everyone will use this through cp(1), so that cp(1) can
> > try to get server-side copy on the network filesystms.
> 
> For reference, cp(1) has a --reflink option as of
> coreutils-7.5 which currently just does:
> 
>   ioctl (dest_fd, BTRFS_IOC_CLONE, src_fd);

	Note that the btrfs ioctl is not a reflink(), so this probably
wants changing (OCFS2_IOC_REFLINK is the ocfs2 ioctl, sys_reflink() was
going to be the syscall).

> There is a specific option in cp to do this because
> a "reflink copy" was seen to have these disadvantages:
> 
>   1. one copy of data blocks so more chances of data loss
>   2. disk head seeking deferred to modification process
>   3. possible fragmentation on write
>   4. possible ENOSPC on write
> 
> Now 2. will go away with time, and 3 & 4 may be alleviated
> by the use of fallocate(), but 1. was deemed important
> enough to not enable by default.

	1, 2, and 3 are definitely in the category of "it would be nice
to choose the behavior".  4 is the big one, because it breaks default
cp(1) assumptions.  The good news is that the current copyfile
idea of copyfile(src, dst, 0) would satisfy 1-4 and be efficient or
return -ENOTSUPP/-ENOSYS if it couldn't be.  Then cp(1) falls back to
the read-write loop.
	cp --reflink would become copyfile(src, dst, COPYFILE_SNAPSHOT)

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
