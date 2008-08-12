Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYHLOtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYHLOtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYHLOtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:49:13 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55681 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbYHLOtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:49:12 -0400
Date: Tue, 12 Aug 2008 09:49:05 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpoint/restart ABI
Message-ID: <20080812144905.GA16016@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel> <200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com> <200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz> <48A0CD86.6030704@goop.org> <87d4kfds5i.wl%peterc@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4kfds5i.wl%peterc@chubb.wattle.id.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Chubb (peterc@gelato.unsw.edu.au):
> >>>>> "Jeremy" == Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
> Jeremy> Dave Hansen wrote:
> >> Arnd, Jeremy and Oren,
> >> 
> 
> 
> Jeremy>    * multiple processes * pipes * UNIX domain sockets * INET
> Jeremy> sockets (both inter and intra machine) * unlinked open files *
> Jeremy> checkpointing file content * closed files (ie, files which
> Jeremy> aren't currently open, but will be soon, esp tmp files) *
> Jeremy> shared memory * (Peter, what have I forgotten?)
> 
> File sharing; multiple threads with wierd sharing arrangements (think:
> clone with various parameters, followed by exec in some of the threads
> but not others); MERT/system-V shared memory, semaphores and message
> queues; devices (audio, framebuffer, etc), HugeTLBFS, numa issues
> (pinning, memory layout), processes being debugged (so,
> checkpoint.restart a gdb/target pair), futexes, etc., etc.  Linux
> process state keeps expanding.
> 
> Jeremy> Having gone through this before, I don't think an all-kernel
> Jeremy> solution can work except for the most simple cases.
> 
> I agree ... it's better to put mechanisms into the kernel that can
> then be used by a user-space programme to actually do the
> checkpointing and restarting.
> 
> Beefing up ptrace or fixing /proc to be a real debugging interface
> would be a start ... when you can get at *all* the info you need,

Except we don't really want to export all the info you need for a
complete restartable checkpoint.  And especially not make it
generally writable.

We have also started down that path using ptrace (see cryo, at
git://git.sr71.net/~hallyn/cryodev.git).

Right before the containers mini-summit, where the general agreement was
that a complete in-kernel solution ought to be pursued, I had tried
a restart using a binary format that read a checkpoint file and used
cryo (userspace using ptrace) for the rest of the restart, only
because there was no other reasonable way to set tsk->did_exec on
restart.

> quickly and easily, the userspace checkpoint falls out fairly
> naturally.  You still have to work out an extensible file format to
> store stuff, and how to restore all that state you've so lovingly
> collected.
> 
> Jeremy> Lightweight filesystem checkpointing, such as btrfs provides,
> Jeremy> would seem like a powerful mechanism for handling a lot of the
> Jeremy> filesystem state problems.  It would have been useful when we
> Jeremy> did this...
> 
> And how!  saving bits of files was very timeconsuming.

Yes, we're looking forward to using btrfs' snapshots :)

-serge
