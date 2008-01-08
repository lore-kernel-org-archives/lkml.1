Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYAHV53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYAHV53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYAHV5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:57:21 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55449 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480AbYAHV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:57:20 -0500
Date: Tue, 8 Jan 2008 16:57:06 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080108215706.GS27800@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, Tuomo Valkonen <tuomov@iki.fi>,
	linux-kernel@vger.kernel.org
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <p73odbwqmx2.fsf@bingen.suse.de> <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi> <20080108181525.GL27800@mit.edu> <p734pdoqbva.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p734pdoqbva.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 09:51:53PM +0100, Andi Kleen wrote:
> Theodore Tso <tytso@mit.edu> writes:
> >
> > Now, there are good reasons for doing periodic checks every N mounts
> > and after M months.  And it has to do with PC class hardware.  (Ted's
> > aphorism: "PC class hardware is cr*p"). 
> 
> If these reasons are good ones (some skepticism here) then the correct
> way to really handle this would be to do regular background scrubbing
> during runtime; ideally with metadata checksums so that you can actually
> detect all corruption.

That's why we're adding various checksums to ext4...

And yes, I agree that background scrubbing is a good idea.  Larry
McVoy a while back told me the results of using a fast CRC to get
checksums on all of his archived data files, and then periodically
recalculating the CRC's and checking them against the stored checksum
values.  The surprising thing was that once every so often (and the
fact that it happens at all is disturbing), he would find that a file
had a broken checksum even though it had apparently never been
intentionally modified (it was in an archived file set, the modtime of
the file hadn't changed, etc.)

And the fact that disk manufacturers on their high end enterprise
disks design their block guard system to detect cases where a block
gets written to a different part of the disk than where the OS
requested it to be written, and that I've been told of at least one
commercial large-scale enterprise database which puts a logical block
number in the on-disk format of their tablespace files to detect this
problem --- should give you some pause about how much faith at least
some people who are paid a lot of money to worry about absolute data
integrity have in modern-day hard drives....

> But since fsck is so slow and disks are so big this whole thing
> is a ticking time bomb now. e.g. it is not uncommon to require tens
> of minutes or even hours of fsck time and some server that reboots
> only every few months will eat that when it happens to reboot.
> This means you get a quite long downtime. 

What I actually recommend (and what I do myself) is to use
devicemapper to create a snapshot, and then run "e2fsck -p" on the
snapshot.  If the snapshot without *any* errors (i.e., exit code of
0), then it can run "tune2fs -C 0 -T now /dev/XXX", and discard the
snapshot, and exit.  If e2fsck returns any non-zero error code,
indicating that it found changes, the output of e2fsck should be sent
e-mailed to the system administrator so they can schedule downtime and
fix the filesystem corruption.

This avoids the long downtime at reboot time.  You can do the above in
a cron script that runs at some convenient time during low usage
(i.e., 3am localtime on a Saturday morning, or whatever).

					- Ted
