Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYLBP0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYLBP0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYLBP00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:26:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38196 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754528AbYLBP0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:26:25 -0500
Date: Tue, 2 Dec 2008 16:26:18 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, mikulas@artax.karlin.mff.cuni.cz,
       clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081202152618.GA1646@ucw.cz>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202140439.GF16172@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-02 09:04:39, Theodore Tso wrote:
> On Tue, Dec 02, 2008 at 10:40:59AM +0100, Pavel Machek wrote:
> > Actually, it looks like POSIX file interface is on the lowest step of
> > Rusty's scale: one that is impossible to use correctly. Yes, it seems
> > impossible to reliably&safely write file to disk under Linux. Double
> > plus uncool.
> > 
> > So... how to write file to disk and wait for it to reach the stable
> > storage, with proper error handling?
> 
> Are you trying to do this in C or shell?  There is no "fsync" shell
> command as far as I know, which is what is confusing me.  And whether
> "> file" checks for errors or not obviously depends on the application
> which is writing to stdout.  Some might check for errors, some might
> not....

True. I'd prefer to use shell, but C is okay, too. 'fsync' shell
command seems to exist on opensuse, sorry for confusion.

> Why do you feel the need to error check "fsync ../.." and "fsync
> ../../..", et.  al?

> I can understand why you might want to fsync the containing directory
> to make sure the directory entry got written to disk --- but if you're
> that paranoid, many modern filesystems use some kind of tree
> structure

If I'm trying to write foo/bar/baz/file, and file/baz inodes/dentries
are written to disk, but foo is not, file still will not be found
under full name - and recovering it from lost&found is hard to do
automatically.

> for the directory, and there is always the chance that a second later,
> in a b-tree node split, due to a disk error the directory entry gets
> lost.

If disk looses data after acknowledging the write, all hope is lost.
Else I expect filesystem to preserve data I successfully synced.

     (In the b-tree split failed case I'd expect transaction commit to
     fail because new data could not be weitten; at that point
     disk+journal should still contain all the data needed for
     recovery of synced/old files, right?)

> What exactly are your requirements here, and what are you trying to
> do?  What are you worried about?  Most MTA's are quite happy
> settling

I'm trying to put my main filesystem on a SD card. hp2133 has only 4GB
internal flash, so I got 32GB SDHC. Unfortunately, SD card on hp is
very easy to eject by mistake.

> with an fsync() to make sure the data made it to the disk safely and
> the super-paranoid might also keep an open fd on the spool directory
> and fsync that too.  That's been enough for most POSIX programs.

Well.. I believe those POSIX programs are unsafe on removable media.

mta #1 	 	       	     	      mta #2

cat > mail1
fsync mail1
					cat > mail2
					fsync mail2
		(spool media
				removed)
					fsync . -> ERROR
					corrrectly reports
					mail2 as undelivered
fsync . -> success; first fsync cleared
      	   error condition


I'm trying to figure out why I'm loosing data on flashes. So far it
seems that both SD cards and USB flash disks have problems, and that
ext2/3 have problems... and that combination of ext2/3+flash  can't
even work in thery :-(.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
