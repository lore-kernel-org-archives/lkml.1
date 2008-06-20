Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbYFTLX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbYFTLX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYFTLXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:23:20 -0400
Received: from mout.perfora.net ([74.208.4.195]:54063 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbYFTLXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:23:19 -0400
Date: Fri, 20 Jun 2008 06:22:20 -0500 (CDT)
From: "R.L. Horn" <lists@eastcheap.org>
X-X-Sender: rlhorn@hani.compact.internal
To: Hans-Peter Jansen <hpj@urpla.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
In-Reply-To: <200806200146.03805.hpj@urpla.net>
Message-ID: <alpine.LNX.1.00.0806200314190.1258@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <200806180215.45925.hpj@urpla.net> <20080618185534.5f969f63@lxorguk.ukuu.org.uk> <200806200146.03805.hpj@urpla.net>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX1807FkGyLTdyG2ILmx2sRbxVQ1/E9zC3vapUuu
 0gB4vdyoXUvSyJN6wg2wyVEPgKDMybo3MbBZBG5un/nZSIocm9
 RARhKu9CRtK2HxV5XpSCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Hans-Peter Jansen wrote:

> Alan, I got to test this by applying the changeset (Olivier, many thanks
> for your valuable hint, I'm sure, I will reuse this knowledge soon), to
> the otherwise unchanged kernel, but unfortunately, it doesn't solve my
> issue.
>
> A different patch must have changed the behavior/state of some RS232 lines
> in the 2.6.25 time frame,

There was a deliberate change in DTR behavior, though I'm not up on the 
details.  If you have a copy of 2.6.25.something handy and want to check 
that that's the problem, you might look at drivers/serial/serial_core.c. 
Round about line 2160 (in uart_configure_port()), you'll see:

   /*
    * Ensure that the modem control lines are de-activated.
    * keep the DTR setting that is set in uart_set_options()
    * We probably don't need a spinlock around this, but
    */
   spin_lock_irqsave(&port->lock, flags);
   port->ops->set_mctrl(port, port->mctrl & TIOCM_DTR);

Change the last line to:

   port->ops->set_mctrl(port, 0);

which reverts to 2.6.24 behavior.

If your problem isn't resolved here, please contact me off-list with some 
details about your receiver, ntpd version, etc. and I'll look into it 
further.  I've been thinking about building a WWVB doodad, and a solution 
to this might save me some grief later on.

> As another data point: using a usb <-> rs232 converter, the dcf device 
> got back to life again. It still doesn't work in its entirety, but at 
> least, some data arrives in ntpd. Expected is something similar to:
> -#--#-#####-###--D--S124--2-p------p-----21-4-24-----8-- (incomplete)
> but it reads:
> ###############RADMLS1248124P124812P1248121241248112481248P
> thus, obviously it doesn't get any 0 values back (displayed as - above).

That looks like a hardware problem.  Odds are, something here (and it 
could be the USB<->RS232 converter or the DCF receiver or both) either 
isn't up to RS-232 specs or the receiver is making unfounded assumptions 
about the DTE port.  In particular, I'd want to know the mark/space 
voltages coming out of that USB thingy.
