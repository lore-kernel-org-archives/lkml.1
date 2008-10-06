Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYJFFR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYJFFR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYJFFRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:17:20 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:47054 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752465AbYJFFRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:17:19 -0400
Date: Mon, 6 Oct 2008 00:17:18 -0500
From: lkml@pengaru.com
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20081006051718.GA2811@fc6222126.aspadmin.net>
References: <20080921220926.GA18569@fc6222126.aspadmin.net> <20081005.132722.203253085.davem@davemloft.net> <20081005214556.GL18569@fc6222126.aspadmin.net> <20081005.153059.111120997.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005.153059.111120997.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 03:30:59PM -0700, David Miller wrote:
> From: swivel@shells.gnugeneration.com
> Date: Sun, 5 Oct 2008 16:45:57 -0500
> 
> > I will be testing this patch today.  At a glance it appears with this
> > patch we're still not taking rcvlowat into consideration in recv()
> > with MSG_PEEK flag set.  This should probably also be corrected, as
> > mentioned in the thread previously.
> 
> Yes, I remember you mentioning that.
> 
> I'll look into it.


Looks like the RCVLOWAT patch breaks the tcp poll logic in the normal
case.

I didn't have a chance to scrutinize the changes but with the patch
applied simple things like a telnet to 127.0.0.1:80 exit immediately
with "Connection closed by foreign host".

In strace of the above telnet failure I see recv() returning EAGAIN
before exiting.  Telnet expected a select() to block until data was
available and didn't expect recv() to find nothing available when the
select() reported there was something.  Select() was no longer behaving
properly on ipv4 tcp sockets.

Regards,
Vito Caputo
