Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbYIXStR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbYIXStR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYIXStH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:49:07 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:39891 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXStG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:49:06 -0400
Message-ID: <48DA8B9C.1070200@skyrush.com>
Date: Wed, 24 Sep 2008 12:49:00 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071119)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Advice sought: pty/tty gets into "gridlock" if it does too much input/output
 while stopped
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been investigating an issue I ran into recently, and I am not yet sure how
to fix it, so I am soliciting suggestions.

Basically, it is quite easy to "gridlock" (I avoided the term "deadlock", since
this is not a locking issue) a shell/xterm session by stopping the tty (e.g.
hitting ^S) and then causing lots of input and output.  Here is an easy way to
do it:

1) open an xterm
2) type "grep foo"
3) hit ^S
4) paste a large number of lines (more than the 4k size)
   containing the word "foo" (this causes output for every input)

There is now no way to break out of this condition in a normal way.  Signals
(e.g. ^C, ^Z) and ^Q cannot break out of this state, since the input character
cannot make it into the line discipline (I never see it in the buffer in
pty_write() after the condition takes hold).  The only thing that can be done is
to close the xterm window.

The problem is that pty_write() (when trying to process typed characters) finds
that "to->receive_room" is zero, so no data is passed to n_tty_receive_buf(),
and nothing can move.  Since both the reads and writes (both of which pass
through the pty_write() function) are waiting to have some space with which to
work, and the tty is stopped, things are stuck.  Since signal and ^Q chars do
not need buffer space, perhaps these could (perhaps) get a higher priority and
be sent through, but since I do not see them in the pty_write() buffer when
issued *during* the condition, it is not clear where this should be done, or if
it is the right solution.  I've verified this as far back as 2.6.24.

							-Joe


