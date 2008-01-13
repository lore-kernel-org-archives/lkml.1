Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbYAMXMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbYAMXMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 18:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYAMXL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 18:11:56 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44694 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754240AbYAMXLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 18:11:55 -0500
Date: Sun, 13 Jan 2008 18:11:50 -0500
From: Theodore Tso <tytso@mit.edu>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080113231150.GB23906@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi> <20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 12:23:10AM +0200, Tuomo Valkonen wrote:
> On 2008-01-14 00:13 +0200, Tuomo Valkonen wrote:
> > Also, I must say that e2fsck is brain-damaged, if it can be confused 
> > by/do the stupid then when the system clock has warped by just a few
> > hours, not the _days_ that a file system check interval typically is,
> > and users need to specifically kludge around such misbehaviour in 
> > e2fsck.
> 
> Just to clarify, I had about 60 days of uptime, and hence at least
> 60 days since the last FS check/mount/etc., when Linux crashed those
> few days ago, and wanted to start checking disks with "9192 days since
> last file system check".

Well, let's see.  9192 days is a little over 25 years, so that means
the filesystem was marked as having done an fsck in 2008-25 or roughly
1983.  If you're not seeing any other corruption when e2fsck runs,
it's highly unlikely that the superblock is getting corrupted.  It's
much more likely that this early in your boot cycle, your clock is
sometimes incorrect.

My suggestion to you is to rig your init scripts to print out the the
current time/date using "/bin/date" and to print out the superblock
information using "dumpe2fs -h /dev/hdXX" and record the information
someplace useful.  A simple way to do this would be via the following
command inserted into /etc/init.d/checkroot.sh:

(date; /sbin/dumpe2fs -h /dev/XXX) | logsave -a /var/log/boot-debug -

where you've replaced /dev/XXX with the block device of the filesystem
which keeps on getting checked erroneously.

All I can say is that most people aren't see what you're seeing, so
there is something unique about your system which is causing this
problem to show up.  9192 days means it's not the time going backwards
scenario; somehow the last checked value is getting set to some very
bogus value.  Normally the only way this could happen is for the time
to be set to a bogus value (i.e., 1982) when the filesystem check
takes place.  Is the "9192" number roughly constant, or is it always
changing?

I wonder if the battery-backed hardware clock in your system is
busted, and so you're always starting the system with some completely
bogus time.  If your machine is on the network, then the "ntpdate"
program could be setting your time so that it looks correct, but
that's after e2fsck is run.  If you really, really, can't guarantee
that the time on your system is correct in early boot, about the only
thing you really *can* do is to use the command "tune2fs -i 0
/dev/XXX" and disable time-based checks altogether.

Regards and best of luck,

						- Ted
