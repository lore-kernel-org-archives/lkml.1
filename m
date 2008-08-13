Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYHMT3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYHMT3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYHMT30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:29:26 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44488 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756345AbYHMT3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:29:25 -0400
Date: Wed, 13 Aug 2008 15:29:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Paris <eparis@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813192922.GI8232@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Paris <eparis@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	andi@firstfloor.org, riel@redhat.com, greg@kroah.com,
	viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk,
	peterz@infradead.org, hch@infradead.org
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org> <20080813181549.GH8232@mit.edu> <1218654168.3540.115.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218654168.3540.115.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 03:02:48PM -0400, Eric Paris wrote:
> I never suggested putting a scanner in kernel.  Sound like you want the
> "allow don't cache" response from your userspace scanner while this is
> going on.  The kernel doesn't need to be making decisions about when to
> send events, nor should userspace tell the kernel not to send events.
> Its up to whatever the scanner is to agree not to actually do any
> scanning...

And if the system isn't running a virus checker, but just a file
indexer (ala tracker), it shouldn't go to userspace at all.  In that
case all that is necessary is an asynchronous notification.

Also something else that is needed is support for multiple clients.
(i.e., what happens if the user runs two virus checkers, or a virus
checker plus a hierarchical storage manager driving a tape robot, or
all of the above plus trackerd --- where some clients need to block
open(2) access, and some do not need block open(2) --- and in the case
of HSM, ordering becomes important; you want to retrieve the file from
the tape robot first, *then* scan it using the virus checker.  :-)

> No.  How in the heck can some out of kernel database store information
> about what inodes have been scanned in any even slightly sane way?  And
> people think the race between open and read is too large and you suggest
> moving clean/dirty marking to a userspace database?  I MUCH prefer my
> (and it sounds like arjan agrees) clean/dirty versioned flag in inode.

Don't ask me; I think most AV checkers for linux are security theater
and not very much use (other than making money for the AV company's
shareholders) anyway.  I thought you were the one who wanted to record
information about which version of the virus db a particular file had
been scanned against.  The place where I can see this being useful is
what happens you get a new virus DB, and so you need to start scanning
all of the files in your 5TB enterprise file server --- and then the
system crashes or it needs to be taken down for scheduled maintenance.

You want to have *some* off-line database for storing this
information, since it would be silly to want to have the first thing
that happens after a new virus DB gets downloaded is to interate over
the entire filesystem, clearing a persistent the "clean" bit --- that
would take *forever* on a 5TB filerserver; and what happens if you
crash in the middle of clearing the "clean" bit..  And if the system
gets shutdown in the middle of the scan, you need some way of
remembering which inodes have been scanned using the "new" db, and
which ones haven't yet been scanned via the new virus db.  All of this
should be kept in userpsace, and is strictly speaking Not Our Problem.

I'm just arguing that there should be absolutely *no* support in the
kernel for solving this particular problem, since the question of
whether a file has been scanned with a particular version of the virus
DB is purely a userspace problem.

						- Ted
