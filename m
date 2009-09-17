Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZIQUgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZIQUgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZIQUgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:36:36 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:53465 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZIQUgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:36:35 -0400
Date: Thu, 17 Sep 2009 13:34:54 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland Dreier <rdreier@cisco.com>, Mark Fasheh <mfasheh@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
Message-ID: <20090917203453.GA15620@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Roland Dreier <rdreier@cisco.com>, Mark Fasheh <mfasheh@suse.com>,
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
 <adabpl9ct3y.fsf@cisco.com>
 <alpine.LFD.2.01.0909171316230.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909171316230.4950@localhost.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AB29DAC.0008:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:17:55PM -0700, Linus Torvalds wrote:
> On Thu, 17 Sep 2009, Roland Dreier wrote:
> > 
> > I guess one bit of semantics to figure out is what happens if copyfile()
> > does the async case but then copyfile_ctrl() returns an error halfway
> > through... is the state of the dest file just undefined?
> 
> I think that's the one that most filesystems would prefer. Maybe the file 
> is there, it's just that it's only half copied because the filesystem 
> filled up. 

	I have to say, adding 'undefined behavior' things isn't fun in a
call that is already potentially confusing.  We have a bunch of flags
and behaviors we're covering.

> Making filesystems give atomicity guarantees would be hard for the async 
> case. 

	Note that "cleaning up after an error" and "atomic" are not the
same.  Atomicity implies that not only do you see all or none, but that
the contents are a point-in-time of the source file.  A non-atomic
implementation may be affected by writes that happen during the copy
(like any read-write-loop copy would be).
	As an example, ocfs2_reflink() builds the target inode in the
orphan directory.  If the operation fails at any point, it's removed.
If we crash, orphan cleanup happens.  Only if it succeeds do we move it
to the target directory.  ocfs2_reflink() is an atomic snapshot, of
course, but recoverability is certainly possible for a non-atomic
copyfile() on filesystems with similar orphan schemes (ext3 is the
obvious example).
	Of course, how the network filesystems might see it, I don't
know.  NFS/CIFS folks, please speak up.

> Of course, if the filesystem can do the copy entirely atomically (ie by 
> just incrementing a refcount), then it can give atomicity guarantees, but 
> then you'd never see the async case either.

	Even the atomic copy might take a little time (say, to bump up
and write out the metadata structures).  Do you want to define that as
not being async?  I was figuring COPYFILE_ATOMIC and COPYFILE_WAIT to be
separate flags.

Joel

-- 

"Behind every successful man there's a lot of unsuccessful years."
        - Bob Brown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
