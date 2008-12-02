Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYLBOEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYLBOEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 09:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYLBOEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 09:04:46 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45895 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753932AbYLBOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 09:04:45 -0500
Date: Tue, 2 Dec 2008 09:04:39 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081202140439.GF16172@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>, mikulas@artax.karlin.mff.cuni.cz,
	clock@atrey.karlin.mff.cuni.cz,
	kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
References: <20081202094059.GA2585@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202094059.GA2585@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 10:40:59AM +0100, Pavel Machek wrote:
> Actually, it looks like POSIX file interface is on the lowest step of
> Rusty's scale: one that is impossible to use correctly. Yes, it seems
> impossible to reliably&safely write file to disk under Linux. Double
> plus uncool.
> 
> So... how to write file to disk and wait for it to reach the stable
> storage, with proper error handling?

Are you trying to do this in C or shell?  There is no "fsync" shell
command as far as I know, which is what is confusing me.  And whether
"> file" checks for errors or not obviously depends on the application
which is writing to stdout.  Some might check for errors, some might
not....

Why do you feel the need to error check "fsync ../.." and "fsync
../../..", et.  al?

I can understand why you might want to fsync the containing directory
to make sure the directory entry got written to disk --- but if you're
that paranoid, many modern filesystems use some kind of tree structure
for the directory, and there is always the chance that a second later,
in a b-tree node split, due to a disk error the directory entry gets
lost.

What exactly are your requirements here, and what are you trying to
do?  What are you worried about?  Most MTA's are quite happy settling
with an fsync() to make sure the data made it to the disk safely and
the super-paranoid might also keep an open fd on the spool directory
and fsync that too.  That's been enough for most POSIX programs.

More generally, if you have a higher need for making sure, most system
administrators will spend effort robustifying the storage layer (i.e.,
RAID, battery-backed journals, etc.) rather than obsession over some
API that can tell an application --- "you know that file you just
finished writing 50 milliseconds ago?  Well, another application
created 100 files, which forced a b-tree node split, and
golly-gee-willickers, when I tried to modify the directory to
accomodate the node split, we ended up losing 50 directory entries,
including that file you just finished writing, fsyncing, and
closing...."

						- Ted
