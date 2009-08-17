Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZHQCWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZHQCWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 22:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbZHQCWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 22:22:19 -0400
Received: from thunk.org ([69.25.196.29]:54753 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbZHQCWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 22:22:18 -0400
Date: Sun, 16 Aug 2009 22:22:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Message-ID: <20090817022215.GI17958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Wagner <daw-news@cs.berkeley.edu>,
	linux-kernel@vger.kernel.org
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <20090816003326.GC7554@mit.edu> <h67kou$ahr$1@taverner.cs.berkeley.edu> <20090816013346.GA17958@mit.edu> <h6a8da$40j$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h6a8da$40j$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 12:31:38AM +0000, David Wagner wrote:
> 
> OK.  What about this:
> 
> (a) Remove ESP and EIP from /proc/$pid/stat{,us} entirely.  Put them in
> some other file that is only readable by root and by the owner of the
> process, but is not world-readable.  We know that ESP and EIP can be used
> for keystroke recovery, and they are not usually used by administrators,
> so the first step is to lock them down tightly: there is no downside.

Agreed.

> (b) Keep /proc/$pid/wchan.  We suspect that it's possible this might
> be usable for keystroke recovery, but we're not sure, and we do know
> that blocking this entirely might annoy administrators, so rather than
> blocking access entirely, apply a more lenient policy.  If the user
> is not the owner of the process and is not root, allow up to about 10
> accesses to /proc/$pid/wchan per, say, 10 minutes; if a user makes more
> than 10 accesses per 10-minute period, insert random delays on the order
> of a few hundred milliseconds into every access to /proc/$pid/wchan.
> 
> Notes: It is critical to do this by user, rather than by process;
> otherwise a malicious user can fork a bazillion processes, each of which
> reads /proc/$pid/wchan a constant number of times.  The "few hundred
> milliseconds" comes from the fact that, for touch typists, typing two
> keys with alternating hands typically takes something like 0-150ms,

I was going to suggest instead of doing it by user or by process,
doing it globally; that is, *any* non-root process tries to access a
particular task's wchan /proc file more than X accesses per Y minutes,
we start inserting random delays.  Note that the "top" program by
default will refresh the screen once every 3 seconds, so allowing at
least 20 accesses per minute would be necessary to prevent "top" from
getting hit by a pretty massive slowdown.

That should be fine, I think; even if someone were to query wchan once
a second, it doesn't seem likely that would be enough to be able to
carry out a keystroke timing attack.

As far as "not being sure" whether it can be used for keystroke
recovery, after reading the Usenix security paper, I'm quite certain
that it would be enough; all the attack relies on is knowing when the
user's keystrokes have been recorded.  The EIP/ESP is one way of
figuring this out; but so is checking to see whether the process is
blocked on n_tty_wait or not.  In fact, arguably it would be
**easier** to use wchan, since with the EIP/ESP route you need to
figure out what EIP is associated with the read system call, where as
knowledge of whether the process is blocked on n_tty_wait far more
telling.

In addition, if you know that the user is entering a password at that
point in time, simply looking to see whether the process is in state
'R' or 'S' might be enough to know when the keystrokes are being
entered.  I might be willing to put that in the category, "We suspect
that it's possible this might be usable for keystroke recovery, but
we're not sure" --- but it would be a pretty strong suspicion.  As far
as whether you could use WCHAN for keystroke recovery, I'd call that a
near-certainty.

There are other timing channels I'd be wary of as well; for example,
simply using stat on the pseudo-tty will record the last access time
to a very high degree of accuracy:

% stat  /dev/pts/0
  File: `/dev/pts/0'
  Size: 0		Blocks: 0          IO Block: 1024   character special file
Device: ah/10d		Inode: 3           Links: 1     Device type: 88,0
Access: (0620/crw--w----)  Uid: (15806/   tytso)   Gid: (    5/     tty)
Access: 2009-08-16 22:21:06.847035909 -0400
Modify: 2009-08-16 22:21:06.847035909 -0400
Change: 2009-08-14 09:13:58.915700017 -0400

Maybe we should only be recording the last access and last modified
time on pseudo-tty's to a second granularity, hmmm?

						- Ted
