Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZIOAGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZIOAGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 20:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZIOAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 20:05:59 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:45510 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbZIOAF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 20:05:58 -0400
Date: Mon, 14 Sep 2009 17:04:17 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
Message-ID: <20090915000417.GC4507@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20090911200458.GA15416@mail.oracle.com>
 <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
 <20090914221434.GA4507@mail.oracle.com>
 <alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AAEDA5C.00E9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 04:27:59PM -0700, Linus Torvalds wrote:
> On Mon, 14 Sep 2009, Joel Becker wrote:
> >From all but a performance standpoint, it's a copy. It has absolutely 
> _zero_ "link" semantics. When you do a symlink or a hardlink, you see it 
> in the resulting semantics: changing one changes the other. 

	It's creating a new entry in the name space based on an old one.

> And the thing to note is that it doesn't even have to be optimized as a 
> "link". Think about network filesystems: maybe they want to implement this 
> thing as a server-side "copy" operation (with atomicity guarantees).

	reflink doesn't merely guarantee atomicity, it guarantees the
shared data extents.  Under the auspices of reflink a network filesystem
cannot merely provide an atomic copy.  A separate copyfile call might
allow that, but reflink doesn't.  This is deliberate, because the caller
wants the shared storage, not just a copy.

> I also still didn't get any answer to the "freflink()" question. You just 
> said that we wouldn't do it, with no explanation. Why? We've discussed 
> 'flink()' in the past, I just want to know that when we do a new system 
> call there is some _reason_ why it's not going to explode into many 
> different variants later...

	Well, obviously I started from the fact that we don't have
flink().  But it doesn't really fit anyway.  reflink is a namespace
operation - give me a new item in the namespace that shares the data
extents of the old item.  So working from a file descriptor doesn't
quite fit.  Plus, flink and freflink would have to deal with
recovering already-orphaned inodes.
	Where do you stand on flink?  If it actually makes sense to
you, then perhaps we should consider it and freflinkat.  It doesn't
strike me as the way to go, but throughout all the discussion I'm quite
willing to be convinced.

Joel

-- 

"I don't know anything about music. In my line you don't have
 to."
        - Elvis Presley

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
