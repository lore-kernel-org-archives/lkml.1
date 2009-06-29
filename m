Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZF2Cgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZF2Cgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZF2Cgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:36:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50172 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZF2Cgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:36:35 -0400
Date: Sun, 28 Jun 2009 22:36:21 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090629023621.GA4289@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090629003514.GC2479@localhost.localdomain> <20090628222455.GA21475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090628222455.GA21475@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 12:24:55AM +0200, Oleg Nesterov wrote:
> On 06/28, Neil Horman wrote:
> >
> > Allow for the kernel to wait for a core_pattern process to complete
> 
> (please change the subject to match)
> 
Fine.

> > One of the things core_pattern processes might do is interrogate the status of a
> > crashing process via its /proc/pid directory.  To ensure that that directory is
> > not removed prematurely, we wait for the process to exit prior to cleaning it
> > up.
> >
> > Since the addition of this feature makes it possible to block the reaping of a
> > crashed process (if the collecting process never exits), Also introduce a new
> > sysctl: core_pipe_limit.
> 
> Perhaps this sysctl should be added in a separate patch? This patch mixes
> differents things imho.
> 
No, I disagree. If we're going to have a sysctl, It should be added in this
patch.  I agree that since these processes run as root, we can have all sort of
bad things happen.  But I think theres an advantage to being able to limit the
damage that a core_pattern process can do if it never exits.   This is a problem
we can avoid easily, and I'd rather not introduce the possibility of waiting
(forever) on a process without the ability to mitigate the risks that incurrs.

> But in fact I don't really understand why do we need the new sysctl. Yes,
> if the collecting process never exits, the coredumping thread can't be reaped.
> But this process runs as root, it can do other bad things. And let's suppose
> it just does nothing, say sleeps forever, and do not read the data from pipe.
> In that case, regardless of any sysctls, ->core_dump() never finishes too.
> 
Not always true, in the event that the core file is smaller than the pipe size.
But regardless, if ->core_dump never returns due to the aforementioned
situation, the sysctl provides the ability to mitigate the damange that can do,
since the dump count is held while ->core_dump is called.

> > +fail_dropcount:
> > +	if (dump_count) {
> > +		while (core_pipe_limit && inode->i_pipe->readers)
> > +			pipe_wait(inode->i_pipe);
> 
> No, no, this is racy and wrong.
> 
> First, it is possible that it exits between ->readers != 0 check and
> pipe_wait(), we will sleep forever.
> 
Its my understanding that pipe_wait returns from any pipe event, including the
closing of a pipe, I would have thought that the above code would catch that,
although, as I type that, I can see how it wouldn't without a lock.

> Also, pipe_wait() should be called under pipe_lock(), I guess lockdep
> should complain if you test your patch ;)
> 
I did test it, and received no such lockdep warnings.

> I'd suggest you to make a simple helper,
> 
> 	static inline void xxx(struct file *file)
> 	{
> 		struct pipe_inode_info *pipe = file->...;
> 
> 		wait_event(pipe->wait, pipe->readers == 0);
> 	}
> 
> I believe we don't need pipe_lock().
> 
Ok, I like that, I'll repost tomorrow morning, after I get some sleep.
Thanks!
Neil

> Oleg.
> 
> 
> 
