Return-Path: <linux-kernel-owner+w=401wt.eu-S1764017AbYDXPoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764017AbYDXPoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbYDXPns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:43:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23682 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759309AbYDXPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:43:46 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: x86: 4kstacks default
Date: Thu, 24 Apr 2008 11:41:30 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Arjan van de Ven <arjan@infradead.org>, T David Chinner <dgc@sgi.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, sandeen@redhat.com
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080423174516.0982a325@laptopd505.fenrus.org> <20080424095215.GA13088@infradead.org>
In-Reply-To: <20080424095215.GA13088@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241141.31198.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2008, Christoph Hellwig wrote:
> On Wed, Apr 23, 2008 at 05:45:16PM -0700, Arjan van de Ven wrote:
> > THe good news is that direct reclaim is.. rare.
> > And I also doubt XFS is unique here; imagine the whole stacking thing on
> > x86-64 just the same ...
>
> It's bad news actually.  Beause it means the stack overflow happens
> totally random and hard to reproduce.   And no, XFS is not unique there,
> any filesystem with a complex enough writeback path (aka extents +
> delalloc + smart allocator) will have to use quite a lot here.  I'll be
> my 2 cent that ext4 one finished up will run into this just as likely.
>
> > I wonder if the direct reclaim path should avoid direct reclaim if the
> > stack has only X bytes left. (where the value of X is... well we can
> > figure that one out later)
>
> Actually direct reclaim should be totally avoided for complex
> filesystems.  It's horrible for the stack and for the filesystem
> writeout policy and ondisk allocation strategies.

Just as a data point, XFS isn't alone.  I run through once or twice a month 
and try to get rid of any new btrfs stack pigs, but keeping under the 4k 
stack barrier is a constant challenge.  

My storage configuration is fairly simple, if we spin the wheel of stacked IO 
devices...it won't be pretty.

Does it make more sense to kill off some brain cells on finding ways to 
dynamically increase the stack as we run out?  Or even give the robust stack 
users like xfs/btrfs a way to say: I'm pretty sure this call path is going to 
hurt, please make my stack bigger now.

We have relatively few entry points between the rest of the kernel and the FS, 
there should be some ways to compromise here.

-chris
