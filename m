Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZI3VXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZI3VXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZI3VXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:23:38 -0400
Received: from thunk.org ([69.25.196.29]:58594 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbZI3VXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:23:38 -0400
Date: Wed, 30 Sep 2009 17:23:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Josh Stone <jistone@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Add a stub for mpage_da_data in the trace header
Message-ID: <20090930212332.GN24383@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Josh Stone <jistone@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1254260407-14276-1-git-send-email-jistone@redhat.com> <20090930133335.GA14585@infradead.org> <20090930142049.GH24383@mit.edu> <4AC3B553.7070704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC3B553.7070704@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 12:45:23PM -0700, Josh Stone wrote:
> If you just want the data in the trace buffer, then SystemTap is not the
> tool for you.  By all means, just write yourself a perl script or
> something that parses the trace buffer however you like.
> 
> On the other hand, stap is useful to do some processing/inspection
> *live*, at the moment the event happens.  For that, we register our own
> tracepoint handler that can do something different than ftrace.

So there are two things I would point out here.  First of all, now
that ftrace has the ability to do basic filtering, just about the only
thing SystemTap can do which is unique is either complex filtering,
summary statistics, or some kind of correlation between multiple
events (within the limits of restricted memory allocation limits of
SystemTap).  So I'm not sure it's such a great idea to cede a large
bit of functionality to as being something that SystemTap will never
accomplish --- especially when it's far more convenient and stable to
depend on fixed trace points than setting arbitrary dynamic trace
points in the middle of source files which will break all the time
when distro's release new kernels, etc.

Secondly, while I'm not so sure it's that big of a restriction to have
Systemtap pull events out of the trace buffer, if you must capture the
event right as it happens, it should be possible set a kprobe in the
ftrace subsystem, and then pull out the data of the event from the
trace buffer.  Keep in mind that one of the advantage DTrace has over
SystemTap is that it can use pre-defined events in the kernel, and not
have to keep userspace macro files in sync with a changing kernel
source base.  It seems counterproductive to throw away the opportunity
of being able to read the tracepoint event data, since it would give
SystemTap a lot more power.  As people start creating more and more
tracepoints, being able to tap into them without needing to download
(or build) symbol tables would be a huge advantage.

> FWIW, Fedora rawhide's x86_64 kernel-debuginfo is a ~140MB package,
> which installs to ~1.1GB, so that situation is not quite so bad.  The
> compile time is of course still a beast.
> 
> However, SystemTap does *not* require the kernel debuginfo for using
> tracepoints, even when reading parameters.  It should work in the
> complete absence of CONFIG_DEBUGINFO, so if you find otherwise, please
> let me know and I will fix it.

Well, how is it going to do that if you don't have access to the
structure definition?  This is why fetching the information from the
ring buffer is much more powerful.

						- Ted
