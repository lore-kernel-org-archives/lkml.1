Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZEOSZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZEOSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZEOSZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:25:47 -0400
Received: from THUNK.ORG ([69.25.196.29]:41188 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZEOSZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:25:47 -0400
Date: Fri, 15 May 2009 14:25:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Timo Sirainen <tss@iki.fi>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org
Subject: Re: ext3/ext4 directories don't shrink after deleting lots of files
Message-ID: <20090515182541.GB6641@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Timo Sirainen <tss@iki.fi>,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org
References: <1242338523.6933.664.camel@timo-desktop> <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com> <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi> <20090515105815.GD6816@mit.edu> <1242408544.6933.687.camel@timo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242408544.6933.687.camel@timo-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 01:29:04PM -0400, Timo Sirainen wrote:
> On Fri, 2009-05-15 at 06:58 -0400, Theodore Tso wrote:
> > > I was rather thinking something that I could run while the system was  
> > > fully operational. Otherwise just moving the files to a temp directory + 
> > > rmdir() + rename() would have been fine too.
> > >
> > > I just tested that xfs, jfs and reiserfs all shrink the directories  
> > > immediately. Is it more difficult to implement for ext* or has no one  
> > > else found this to be a problem?
> > 
> > It's probably fairest to say no one has thought it worth the effort.
> 
> My problem is with mail servers and Maildir format where it's possible
> that a user has tons of emails and wants to delete them. The mailbox
> maybe slowly grows back to the huge size, but in the meantime it's
> slower than necessary.

The problem is that unless the user is deleting a *huge* number of
files, it's rare that the directory entry block goes completely empty.
If you shrink from 15,000 messages to 12,000 messages, say, because of
the fact that we use a hashed b-tree as our data structure, the leaf
blocks in the btree generally still contain some directory entries.
So to fix this we need to actually coalesce directory leaf blocks on
the fly, on top of everything else that I had mentioned.  It's
certianly doable, but again, someone would have to submit a patch.  We
might get around to it one of these days, but plates of those of us
who are doing ext4 are pretty full with higher priority items at
present.

There is an off-line fix that works quite well -- e2fsck -fD, but
obviously that requires scheduling downtime.

How big of a deal is this for you?  I use a local maildir myself, and
they can get quite large:

% ls /home/tytso/isync/mit
total 2132
1412 cur/   716 new/     4 tmp/

But once they are in cache, it's no longer a major problem.  I suppose
on a mail server where you have a very large number of users, caching
2 megs of directory data per user could get ugly; and it does take
time the first time you pull their directory entry into the cache.
What sort of performance degredation are you measuring, and what are
the impacts operationally at the moment for you?  Is this just a
theoretical concern, or are you measuring a significant slowdown as a result?

	    	     	    		    - Ted
