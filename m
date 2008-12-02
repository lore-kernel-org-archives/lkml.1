Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYLBQhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYLBQhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYLBQh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:37:26 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:59148 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbYLBQhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:37:25 -0500
Date: Tue, 2 Dec 2008 11:37:20 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081202163720.GB18162@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>, mikulas@artax.karlin.mff.cuni.cz,
	clock@atrey.karlin.mff.cuni.cz,
	kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202152618.GA1646@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 04:26:18PM +0100, Pavel Machek wrote:
> > I can understand why you might want to fsync the containing directory
> > to make sure the directory entry got written to disk --- but if you're
> > that paranoid, many modern filesystems use some kind of tree
> > structure
> 
> If I'm trying to write foo/bar/baz/file, and file/baz inodes/dentries
> are written to disk, but foo is not, file still will not be found
> under full name - and recovering it from lost&found is hard to do
> automatically.

Only if you've freshly created the foo/bar/baz directories...  If you
have, then yes, you'll need to sync each one.  Normally the paranoid
programs do this after each mkdir call, though.

For ext3/ext4, becaused of the entangled commit factor, fsync()'ing
the file is sufficient, but that's not something you can properly
count upon.

> If disk looses data after acknowledging the write, all hope is lost.
> Else I expect filesystem to preserve data I successfully synced.
> 
>      (In the b-tree split failed case I'd expect transaction commit to
>      fail because new data could not be weitten; at that point
>      disk+journal should still contain all the data needed for
>      recovery of synced/old files, right?)

Not necessarily.  For filesystems that do logical journalling (i.e.,
xfs, jfs, et. al), the only thing written in the journal is the
logical change (i.e., "new dir entry 'file_that_causes_the_node_split'").

The transaction commits *first*, and then the filesystem tries to
write update the filesystem with the change, and it's only then that
the write fails.  Data can very easily get lost.

Even for ext3/ext4 which is doing physical journalling, it's still the
case that the journal commits first, and it's only later when the
write happens that we write out the change.  If the disk fails some of
the writes, it's possible to lose data, especially if the two blocks
involved in the node split are far apart, and the write to the
existing old btree block fails.

> > What exactly are your requirements here, and what are you trying to
> > do?  What are you worried about?  Most MTA's are quite happy
> > settling
> 
> I'm trying to put my main filesystem on a SD card. hp2133 has only 4GB
> internal flash, so I got 32GB SDHC. Unfortunately, SD card on hp is
> very easy to eject by mistake.

So what you really want is some way of constantly flushing data to the
disk, probably after every single mkdir, every single close operation.
Of course, that has the tradeoff your flash card will get a lot of
extra wear.  I hate to say this, but have you considered something
like tape or velcro to secure the SD card?

						- Ted
