Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbZEaQ4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbZEaQ4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 12:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbZEaQ4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 12:56:34 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:61407 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbZEaQ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 12:56:34 -0400
Subject: Re: [PATCH] coredump: Retry writes where appropriate
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Olivier Galibert <galibert@pobox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090531140354.GA92675@dspnet.fr.eu.org>
References: <1243748019.7369.319.camel@homebase.localnet>
	 <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	 <20090531140354.GA92675@dspnet.fr.eu.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GNU's Not Unix!
Date: Sun, 31 May 2009 12:56:22 -0400
Message-Id: <1243788982.7369.370.camel@homebase.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-31 at 16:03 +0200, Olivier Galibert wrote:
> On Sun, May 31, 2009 at 11:18:51AM +0100, Alan Cox wrote:
> > On Sun, 31 May 2009 01:33:39 -0400
> > Paul Smith <paul@mad-scientist.net> wrote:
> > 
> > > coredump: Retry writes where appropriate
> > > 
> > > Core dump write operations (especially to a pipe) can be incomplete due
> > > to signal reception or possibly recoverable partial writes.
> > 
> > NAK this
> > 
> > > Previously any incomplete write in the ELF core dumper caused the core
> > > dump to stop, giving short cores in these cases.  Modify the core dumper
> > > to retry the write where appropriate.
> > 
> > The existing behaviour is an absolute godsend when you've something like
> > a core dump stuck on an NFS mount or something trying to core dump to
> > very slow media.
> > 
> > In fact the signals checks were *purposefully added* some time ago.

This is what Olivier mentioned as well, and I do see the benefit in
being able to get rid of hung up coredumps.  But to me it's more
important to have reliable and robust coredumping, and I'm getting
reports of short cores on my systems at least once a week due to this
problem (the userspace applications I'm working with use signals for
certain well-defined situations, that tend to happen at around the same
time as you might expect core dumps).

> Perhaps removing the "|| r == -EINTR" part would make both of you
> happy?  He gets the reliability on pipes, you keep the interrupt on
> signals.

I'm getting back ERESTARTSYS in my environment, and it's happening
because pipe_write() detects a signal pending.  I don't think this is
due to SIGPIPE, and I'm not sure that removing EINTR will give Alan the
behavior he is looking for.

Another possibility would be to examine the signal itself and don't
retry if it's SIGKILL.  I'm too much of a kernel hacking noob to know
offhand how to find the pending signal but I can certainly figure it
out.  If it's possible, Alan, would that be an acceptable alternative?

I'm not entirely happy with this because, as was discussed in an earlier
thread, there are plenty of common idioms where you can expect to
receive a SIGKILL while you're in the middle of dumping core (lots of
userspace setups will send a few HUPs, followed by a few INTs, and if
the process is still there they send KILLs).  However, for my specific
purposes this would be sufficient.

Other ideas?
