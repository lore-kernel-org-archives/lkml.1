Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179AbYHLGWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbYHLGWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYHLGWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:22:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57123 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYHLGWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:22:42 -0400
Date: Tue, 12 Aug 2008 07:22:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] readdir mess
Message-ID: <20080812062241.GQ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	When getdents() had been introduced in 1.3.0, ->readdir() has grown
a callback and became an iterator.  The type of that iterator had been
a Bloody Bad Idea(tm); it returns a value that gets reduced to one bit
by all callers.  Basically it's "do we stop or do we move to the next
entry?".  0 means "go on" for all ->readdir() instances, negative - "stop".
Positives are treated inconsistently.

	Note that it can not be used to return an error.  In particular,
the callback of getdents(2) returns "stop" when we run out of buffer.
If any instance of ->readdir() would ever treat that as an error to
pass back to caller, it would break spectaculary on the first ls(1) on
a directory large enough to require more than one getdents(2) call.

	Anything that wants to pass errors back to caller of ->readdir()
has to store it in whatever struct we are passing to the callback.

	That had lead to two recurring classes of bugs:
1) something_readdir() treats "callback returned negative" as "return
than negative".  Breaks pretty fast.
2) whatever_filldir() happily returns some error value and expects it
to be seen by caller of ->readdir().  Somehow.  Doesn't work.  We do
have such bugs right now.

	In addition, we have other kinds of crap going on around ->readdir()
(the most popular being "whaddya mean, somebody might've done lseek(2) and
set offset to hell knows what???"), but those are separate story.

	An obvious way to deal with that would be to have filldir_t return
bool; true => stop, false => go on.  However, that's going to cause silent
breakage of out-of-tree filesystems.  Even though e.g. ext2 had always
treated any non-zero return value of filldir as "stop", we'd grown filesystems
that check for return value < 0 instead.  Having it return true (i.e. 1)
will break all of those.  Note that generic callbacks currently return
negative values for "stop", so they work with those filesystems right now.

	FWIW, I'm seriously tempted to go for the following variant:
new __bitwise type with two values - READDIR_STOP and READDIR_CONTINUE,
-1 and 0 resp.  The type of filldir_t would become filldir_res_t (*)(......),
all existing instances of ->readdir() would keep working and sparse
would catch all mismatches.

	Another variant is to change filldir_t in visible incompatible way
that would have bool as return value and let readdir instances adjust or
refuse to compile; maintainers of out-of-tree code would presumably notice
that, so we would just have to document the calling conventions and say
that checking for < 0 doesn't work anymore.

	Comments?
