Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYJTLjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYJTLjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJTLjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:39:45 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:57784 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751587AbYJTLjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:39:44 -0400
From: swivel@shells.gnugeneration.com
Date: Mon, 20 Oct 2008 06:39:42 -0500
To: Nicolas Cannasse <ncannasse@motion-twin.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: poll() blocked / packets not received ?
Message-ID: <20081020113942.GJ2811@fc6222126.aspadmin.net>
References: <48FC4066.9060303@motion-twin.com> <20081020101549.GH2811@fc6222126.aspadmin.net> <48FC61A0.7010003@motion-twin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FC61A0.7010003@motion-twin.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 12:46:56PM +0200, Nicolas Cannasse wrote:
> >>We have Shorewall installed and enabled, but what seems strange is that 
> >>the problem depends on multithreading. It also occurs much more often on 
> >>the 4 core machines than on a 2 core ones (both with Hyperthreading 
> >>activated). We're using kernel 2.6.20-15-server (#2 SMP) provided by 
> >>Ubuntu.
> >>
> >>Any tip on we could fix that or investigate further would be 
> >>appreciated. After one month of debugging we're really out of solution 
> >>now.
> >>
> >>Best,
> >>Nicolas
> >
> >Your usage pattern is a very common one, I highly doubt you are 
> >experiencing
> >a kernel bug here or many people (including myself) would be complaining.
> >
> >Shorewall sounds like it might be suspect, are FIN's not coming in when the
> >remote closes?  You can look in the output of netstat to see what state the
> >TCP is in, still ESTABLISHED?
> 
> Yes, it's still ESTABLISHED, but we can't see the corresponding 
> connection on the other machine while running netstat. I'm not a TCP 
> expert, so I'm not sure in which case this can occur.

If the end that's blocking still has the TCP in ESTABLISHED state, and
the other end doesnt have the TCP at all... you've already identified
why the one end is still ESTABLISHED.  ESTABLISHED state won't be left
until the FIN is received from the other end, then entering CLOSE_WAIT
state.

When the other end of the TCP is _gone_ that leads me to believe a FIN
will not be coming, hence the indefinite ESTABLISHED state.  Why it's
gone is a different question, maybe your problem is at the other end?
The end initiating a shutdown has to enter FIN_WAIT_1 then FIN_WAIT_2,
these transitions require the other side to leave ESTABLISHED (receive a
FIN then ACK) at the very least to proceed.

> 
> I agree with your comment in general, except that we have been running 
> the same application in single-thread environment for years without 
> running into this very specific problem.
> 

Perhaps when you run in multicore/threaded you are stressing the network
stacks at both ends more, including everything in-between?  The
threading vs. single process relationship is probably not causal, but
just coincidental.

What is the protocol?  Are there any timeouts to take care of these
situations?  Do you schedule an alarm or use SO_RCVTIMEO to shutdown
dead connections and free up consumed threads?

TCP being reliable can block indefinitely, you can employ TCP keepalive
to change indefinite to quite a long time.

Regards,
Vito Caputo
