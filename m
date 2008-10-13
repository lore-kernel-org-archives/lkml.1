Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYJMIc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYJMIc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYJMIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:32:16 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:38114 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756094AbYJMIcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:32:15 -0400
Date: Mon, 13 Oct 2008 03:32:14 -0500
From: swivel@shells.gnugeneration.com
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20081013083214.GN2811@fc6222126.aspadmin.net>
References: <20081005.132722.203253085.davem@davemloft.net> <20081005214556.GL18569@fc6222126.aspadmin.net> <20081005.153059.111120997.davem@davemloft.net> <20081013.003441.109866647.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013.003441.109866647.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 12:34:41AM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 05 Oct 2008 15:30:59 -0700 (PDT)
> 
> > From: swivel@shells.gnugeneration.com
> > Date: Sun, 5 Oct 2008 16:45:57 -0500
> > 
> > > I will be testing this patch today.  At a glance it appears with this
> > > patch we're still not taking rcvlowat into consideration in recv()
> > > with MSG_PEEK flag set.  This should probably also be corrected, as
> > > mentioned in the thread previously.
> > 
> > Yes, I remember you mentioning that.
> > 
> > I'll look into it.
> 
> Were you able to test my updated patch?
> 
> If it makes your application work, I might want to defer messing around
> with MSG_PEEK semantics in recvmsg().
> 
> So I've been waiting for your test results before I proceed.


Didn't test your latest patch after you mentioned that you had tested it
yourself successfully.

The application is still broken having recv() not behave normally with
the MSG_PEEK flag.  The app will spin calling recv() repeatedly once any
data has made it into the rcvbuf, because recv() will always immediately
return with the >0 # of bytes in the buffer.

I'm using the pseudo-blocking recv() behavior achieved with SO_RCVTIMEO.
Thus my app expects recv() to block until SO_RCVLOWAT is met or SO_RCVTIMEO
expired.  Upon timeout expiration recv() is supposed to return -1 with
errno=EAGAIN.  With recv() immediately returning on MSG_PEEK there's no
possibility for timeout expiration.  recv() behaves perfectly in this
regard without MSG_PEEK, it just needs some minor adjustment to behave
the same with MSG_PEEK specified.

There's a simple diagram illustrating the application implementation
in general.  This may help understand the implications of recv() not
blocking once there is data in the rcvbuf without wasting much of your
time:
http://serverkit.org/modules/httpx/httpx.png

Thanks for the follow-up.

Regards,
Vito Caputo
