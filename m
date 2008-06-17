Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYFQUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYFQUTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 16:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYFQUTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 16:19:36 -0400
Received: from lazybastard.de ([212.112.238.170]:59880 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYFQUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:19:35 -0400
Date: Tue, 17 Jun 2008 22:19:25 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the kernel
Message-ID: <20080617201925.GB31224@logfs.org>
References: <48580116.9070504@am.sony.com> <20080617190750.GA31224@logfs.org> <485815F6.20507@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <485815F6.20507@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 June 2008 12:52:22 -0700, Tim Bird wrote:
> Jörn Engel wrote:
> > On Tue, 17 June 2008 11:23:18 -0700, Tim Bird wrote:
> >> I'm not that happy using an ioctl for this trigger.  What is
> >> the preferred method of activating a kernel feature like this?
> >> I presume something in /proc or /sys, but I'm not sure.
> > 
> > I personally would be unhappy with any kind of interface for this.  It
> > would be much nicer to make it transparent and still get the benefits.
> > One option would be to start a kernel thread for the initialization and
> > renice it to 19 or so.
> 
> That's an interesting idea. I'm pretty sure the product guys want
> an explicit trigger, so they can make sure they've got the main
> application well underway before this deferred initialization occurs.

Well, there should be a way to ensure this doesn't hog the cpu at all -
unless it is idle or someone is actually waiting for the initialization
to finish.  Not sure if nice 19 is good enough for that.

> > If you want an explicit trigger, you could either hook into init_post()
> > or have hooks in the open functions of drivers with deferred
> > initialization.
> 
> This would presumably require multiple calls (one to the open of
> each deferred module).  I would still need a trigger for the memory
> free operation, unless I hardcode the order of the opening and just
> "know" that the last one should free the memory.  I'll have to see
> if all the modules being loaded like this have open()s.

If you want to keep things simple - and I believe initially you should -
you can simply do all initializations in one go.  Something like this:

int foo_open(...)
{
	wait_for_deferred_init();
	...
}

static DECLARE_COMPLETION(init_complete);

void wait_for_deferred_init(void)
{
	static atomic_t in_progress = ATOMIC_INIT(-1);

	if (!atomic_inc_not_zero(in_progress) {
		wait_for_completion(init_complete);
		return;
	}

	for (all deferred initcalls)
		foo_init();

	complete(init_complete);
	free_memory();
}

Jörn

-- 
Anything that can go wrong, will.
-- Finagle's Law
