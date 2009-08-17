Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZHQAbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZHQAbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 20:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbZHQAbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 20:31:39 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:47573 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbZHQAbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 20:31:38 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Date: Mon, 17 Aug 2009 00:31:38 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <h6a8da$40j$1@taverner.cs.berkeley.edu>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <20090816003326.GC7554@mit.edu> <h67kou$ahr$1@taverner.cs.berkeley.edu> <20090816013346.GA17958@mit.edu>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1250469098 4115 128.32.168.222 (17 Aug 2009 00:31:38 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 17 Aug 2009 00:31:38 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso  wrote:
>On Sun, Aug 16, 2009 at 12:44:14AM +0000, David Wagner wrote:
>> Theodore Tso  wrote:
>> > A configuration option which defaults to disabling ESP and EIP would
>> > be a simple way to prevent this specific instance of information
>> > leakage.  The problem is there are other files that might reveal
>> > timing information, but which are very useful for a system
>> > administrator.  A key example of this is /proc/$pid/wchan, which is
>> > responsible for the WCHAN column is a ps listing.
>> 
>> If they're useful for system administrators, would making them
>> readable to root (but not everyone) be enough?
>
>I suppose sysadmins use "sudo ps" instead of "ps", but that would be a
>bit inconvenient and would certainly clutter the sudo logs.  It might
>also cause people to decide it's more trouble than it's worth, and
>configure their system not restrict the various proc files.

OK.  What about this:

(a) Remove ESP and EIP from /proc/$pid/stat{,us} entirely.  Put them in
some other file that is only readable by root and by the owner of the
process, but is not world-readable.  We know that ESP and EIP can be used
for keystroke recovery, and they are not usually used by administrators,
so the first step is to lock them down tightly: there is no downside.

(b) Keep /proc/$pid/wchan.  We suspect that it's possible this might
be usable for keystroke recovery, but we're not sure, and we do know
that blocking this entirely might annoy administrators, so rather than
blocking access entirely, apply a more lenient policy.  If the user
is not the owner of the process and is not root, allow up to about 10
accesses to /proc/$pid/wchan per, say, 10 minutes; if a user makes more
than 10 accesses per 10-minute period, insert random delays on the order
of a few hundred milliseconds into every access to /proc/$pid/wchan.

Notes: It is critical to do this by user, rather than by process;
otherwise a malicious user can fork a bazillion processes, each of which
reads /proc/$pid/wchan a constant number of times.  The "few hundred
milliseconds" comes from the fact that, for touch typists, typing two
keys with alternating hands typically takes something like 0-150ms,
whereas typing two keys with the same hand typically takes something
like 150-300ms; so if we want to obfuscate the difference between these
two, we need several hundreds of milliseconds of delay.  Allowing more
than a small number of undelayed accesses to /proc/$pid/wchan may not
be safe: passwords typically have less than a dozen characters in them,
and it may be possible to mount non-trivial attacks with only a few
probes per keypress (perhaps as few as two probes).

These two steps could be implemented separately.  Given that there are
demonstrated attacks that exploit ESP and EIP, it might be reasonable
to undertake step (a) right away.
