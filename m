Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXLLT5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXLLT5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbXLLT5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:57:36 -0500
Received: from mail.fieldses.org ([66.93.2.214]:46820 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbXLLT5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:57:35 -0500
Date: Wed, 12 Dec 2007 14:57:32 -0500
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org
Subject: Re: A peek at the future of storage
Message-ID: <20071212195732.GC31412@fieldses.org>
References: <200712120846.18320.phillips@phunq.net> <20071212174613.GA16656@fieldses.org> <200712121002.44643.phillips@phunq.net> <1197484765.32283.106.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197484765.32283.106.camel@tara.firmix.at>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 07:39:25PM +0100, Bernd Petrovitsch wrote:
> On Mit, 2007-12-12 at 10:02 -0800, Daniel Phillips wrote:
> > On Wednesday 12 December 2007 09:46, J. Bruce Fields wrote:
> [...]
> > > People have proposed writing a daemon that just reads
> > > /proc/net/rpc/nfsd periodically and uses that to adjust the number of
> > > threads from userspace, probably subject to some limits in a config
> > > file someplace. (Think that could do the job, or is there some reason
> [...]
> > So how would a userspace daemon know that kernel is blocking and new 
> > threads are needed?

The last number on the "th" line in /proc/net/rpc/nfsd should tell you
how many seconds all threads have been busy (and previous lines tell you
how much time they've been 90% busy, etc).  That seems like sufficient
information at least for a rough guess.  It wouldn't allow as fast a
response time, but perhaps that doesn't matter.

> > In kernel this is pretty easy: when a new request 
> > arrives, look on the thread list and if none are available, generate a 
> > new one.  Something special needs to be done to handle the case where 
> > there are no threads available because they are all piled up on a 
> > semaphore due to, for example, somebody unplugging the network cable 
> > for a remote disk.

Ideally you'd like to limit the number of threads that that can happen
to, so that we still have a few threads free to handle rpc requests that
don't depend on some borked disk.  I don't know how to do that, though.

> > We have to avoid generating infinite threads in 
> > that case.  Ideas?
> 
> Add a sysctl configurable maximum number of NFS threads and default it
> to 8 (or whatever now the default value is).
> And one wants probably some logic to kill them again if they are not
> used long enough. And then you need/want another variable for the
> minimum number of NFS threads around.

If that's enough configuration for everyone, then fine.  If we suspect
people might need to do something more complicated, that might be an
argument for trying to do the tuning in userspace until we figure out
exactly what knobs are needed.

--b.
