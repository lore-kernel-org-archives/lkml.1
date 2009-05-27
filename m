Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbZE0GDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbZE0GDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZE0GDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:03:00 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:28651 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZE0GDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:03:00 -0400
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090526172935.fad52c49.akpm@linux-foundation.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
	 <878wkjobbm.fsf@basil.nowhere.org>
	 <20090526160017.98fc62e4.akpm@linux-foundation.org>
	 <20090526231428.GK846@one.firstfloor.org>
	 <20090526162821.02e11d5b.akpm@linux-foundation.org>
	 <20090526234109.GL846@one.firstfloor.org>
	 <20090526164532.6c780234.akpm@linux-foundation.org>
	 <20090527001104.GN846@one.firstfloor.org>
	 <20090526172935.fad52c49.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GNU's Not Unix!
Date: Wed, 27 May 2009 02:02:53 -0400
Message-Id: <1243404173.7369.158.camel@homebase.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 17:29 -0700, Andrew Morton wrote:
> On Wed, 27 May 2009 02:11:04 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > I dunno.  Is this true of all linux filesystems in all cases?  Maybe.
> > 
> > Assuming one of them is not would you rather want to fix that file system
> > or 10 zillion user programs (including the kernel core dumper) that 
> > get it wrong? @)
> 
> I think that removing one bug is better than adding one.
> 
> Many filesystems will return a short write if they hit a memory
> allocation failure, for example.  pipe_write() sure will.  Retrying
> is appropriate in such a case.

As a mainly userspace guy maybe I'm missing some details for kernel
behavior, but I know I would never write a program that used write(2)
and assumed it would never return a short write.  The documentation for
write(2) is very clear that short writes are possible and any reasonably
robust program will handle this.  Consider things like NFS filesystems,
etc. where who knows what behavior is found.

I'm more concerned with the loss of the signal mask settings in the core
dump in Andi's patch.  This seems to be losing important information.
Andi, why did you prefer that to clearing the pending signal and
retrying the write?  I'm definitely not familiar enough with signal
management in the kernel to know what side-effects there might be from
just clearing the pending flag without doing anything else: I did it
that way because fs/exec.c:do_coredump() does this before it runs the
->core_dump function.

I wonder whether dump_write() shouldn't be rewritten along the lines of
a normal, robust userspace writer, where we handle EAGAIN and EINTR (can
we ever get these at this level, or do we ever just get ERESTARTSYS?),
short writes, etc.


PS. I have a thought about why this happens for me; I doubt I'm getting
SIGPIPE.  In our system it's almost certain that these worker processes
will get a signal (SIGUSR1 or something: I forget exactly which one) if
they are still alive after a few seconds.  I suspect that the core dump
takes long enough that this signal is received in the middle of the core
dump.  It may be that this problem hasn't been noticed before because
it's unlikely you'll receive a signal in the middle of dumping core, and
if you do get one every now and then, and get a short core, it's not
easily reproducible.  I left my debugging in the kernel and I get
exactly one instance of signal_pending() per process, so having the
signal be SIGPIPE seems unlikely.
