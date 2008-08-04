Return-Path: <linux-kernel-owner+w=401wt.eu-S1765486AbYHDWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765486AbYHDWER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762011AbYHDWDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:03:15 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:45645 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764647AbYHDWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:03:08 -0400
Message-ID: <48977C96.2090005@skyrush.com>
Date: Mon, 04 Aug 2008 16:03:02 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: tty: ctrl-c not always echoed, especially under load
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am experiencing a rather intermittent and hard-to-reproduce issue in the tty
layer, and I am posting here to get ideas on how to debug it from those of you
who have delved into the tty internals.  I suspect some kind of race is going on
or the echo is caught in the tty buffer when it gets flushed (and never makes it
to the tty).  Heavy load (compiling, etc.) seems to make it more likely.

When a signal character (e.g. ctrl-c) is received, the tty ldisc and driver are
flushed, the character is echoed (e.g. "^C" if echoctl is on), and the signal is
issued.  Because the flush happens first, the echo should always appear on the
tty, but sometimes it does not.  What I am wondering is how the echo could get
"swallowed".  The code I have been using to test this is:

#include <stdio.h>

main()
{
    while (1) {
                printf("a");
                fflush(stdout);
    }
}

During the run, I simply hit ctrl-c to break out, and I've also tried
ctrl-s/ctrl-q (alternating), then ctrl-c when stopped.  Normally, the echo is
displayed, but sometimes not.

Two things come to mind...  First, there is this caveat in the code (n_tty.c,
write_chan()):

 *	Write function of the terminal device. This is serialized with
 *	respect to other write callers but not to termios changes, reads
 *	and other such events. We must be careful with N_TTY as the receive
 *	code will echo characters, thus calling driver write methods.

This talks specifically about echo during receive, so I am wondering if there is
some timing-sensative thing going on.

Second, perhaps the echo is caught in the driver pipe when the flush is done,
and that's why the echo is getting eaten by the flush.

Would it make sense to flush_to_ldisc from within the ldisc before the buffer is
flushed to make sure the pipe is empty?

It can take quite a few tries before I see the issue, but I have seen it in
2.6.26.  If anyone has some ideas, let me know.

					Thanks, Joe
