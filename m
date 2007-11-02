Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbXKBBdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbXKBBdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXKBBdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:33:24 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:50638 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752611AbXKBBdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:33:23 -0400
Date: Fri, 2 Nov 2007 02:33:21 +0100
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: linux-kernel@vger.kernel.org
Subject: TCP_DEFER_ACCEPT issues
Message-ID: <20071102013321.GA30893@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to use TCP_DEFER_ACCEPT in my web server.

There are some operational problems.  First of all: timeout handling.  I
would like to be able to set a timeout in seconds (or better:
milliseconds) for how long the socket is allowed to sit there without
data coming in.  For high load situations, I have been enforcing
timeouts in the range of 15 seconds, otherwise someone can DoS the
server by opening a lot of connections and tying up data structures.

It is still possible, of course, to tie up kernel memory this way, by
not reacting to the FIN or RST packets and running into a timeout there,
too, but that is partially tunable via sysctl.

According to tcp(7) the int argument to TCP_DEFER_ACCEPT is in seconds.
In the kernel code, it's converted to TCP timeout units.  When I ran my
server, and connected without sending any data, nothing happened.  No
timeout.  Minutes later, the connection was still there.  Even worse:
when I killed (!) the server process (thus closing the server socket),
the client did not get a reset.  Only when I type something in the
telnet, I get a reset.  This appears to be very broken.

My suggestion:

  1. make the argument to the setsockopt be in seconds, or milliseconds.
  2. if the server socket is closed, reset all pending connections.

Comments?

Felix
