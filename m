Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbYCASgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbYCASgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 13:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYCASgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 13:36:33 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18144 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYCASgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 13:36:32 -0500
Date: Sat, 1 Mar 2008 19:36:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: petkovbb@gmail.com, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/24] ide-tape: remove pipelined mode operation
Message-ID: <20080301183627.GB6704@kernel.dk>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <20080301095518.GW6704@kernel.dk> <20080301154529.GB30547@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301154529.GB30547@gollum.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01 2008, Borislav Petkov wrote:
> On Sat, Mar 01, 2008 at 10:55:18AM +0100, Jens Axboe wrote:
> > On Sat, Mar 01 2008, Borislav Petkov wrote:
> > > Hi Bart,
> > > 
> > > here's the 1st draft of the pipeline removal series. As the diffstat below openly
> > > states it, a lot of code got removed - even more than the cleanup series we did
> > > earlier. There are several issues that we need to address concerning these
> > > patches:
> > > 
> > > 1. only compile-tested since i don't have the hardware, i.e. longer -mm brewing is
> > > advisable the least.
> > > 
> > > 2. I have left the tape->merge_stage buffer structure along with its
> > > alloc/free functions intact for now, for simplicity. The next step would be
> > > to go and carefully audit the code and then remove that last piece
> > > too and use allocations on the stack instead. I guess we still expect
> > > Jens's response on whether blk_{get,put}_request is the way to go here.
> > > 
> > > Jens?
> > 
> > Hm, I have not seen any questions regarding this directed my way :-)
> > Please point me to the original question and I'll take a look at it.
> 
> Hi Jens,
> 
> sorry but maybe we weren't that explicit, here's a pointer to the
> relevant thread:
> http://www.mail-archive.com/linux-ide@vger.kernel.org/msg15541.html.
> It boils down to removing the statically allocated arrays of buffers
> for pc and rq structs in ide-floppy and ide-tape, and using GFP_ATOMIC
> stack memory instead.  Bart's idea was to even go a step further and
> even avoid allocation errors in out-of-mem situations by reusing
> requests from the request queue but wasn't sure whether this'll fly
> and wanted to run it by you...

That sounds like asking for trouble, if you ask me (well you did :-)

And being a very rarely exercised path (if at all, you should be very
unlucky to NOT get a request even with GFP_ATOMIC), then it wont even
get tested properly. So I'd say stick to GFP_ATOMIC, and just plug the
device and retry if you get into allocation errors.

-- 
Jens Axboe

