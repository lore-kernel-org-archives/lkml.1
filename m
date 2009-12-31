Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbZLaHfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbZLaHfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 02:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZLaHfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 02:35:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50841 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZLaHfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 02:35:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l8iu/vBCnOf3RT93ov0gguo8MrLRcxODb3CL372r031iwb09XuY6rXPnP4eH0OQles
         vv8Hekg6gsDElJafvUlIiqKGLRWpPO0KcCvDtL/Lc39DIPo/D9wBBLCWtHl/o7oMaGHA
         akFI+NxAlWPCXsMDKh8fP4YIAbdu58L44fdnI=
Date: Wed, 30 Dec 2009 23:35:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091231073547.GA14333@core.coreip.homeip.net>
References: <20091228145749.GD4994@basil.fritz.box>
 <1262016510.12656.25.camel@wall-e>
 <20091228172651.GE4994@basil.fritz.box>
 <1262030653.15368.37.camel@wall-e>
 <20091228204003.GH4994@basil.fritz.box>
 <1262076056.23095.21.camel@wall-e>
 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
 <20091230020830.GA7049@core.coreip.homeip.net>
 <1262194152.5645.10.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262194152.5645.10.camel@palomino.walls.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 12:29:12PM -0500, Andy Walls wrote:
> On Tue, 2009-12-29 at 18:08 -0800, Dmitry Torokhov wrote:
> > A: http://en.wikipedia.org/wiki/Top_post
> > Q: Were do I find info about this thing called top-posting?
> > A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > 
> > On Tue, Dec 29, 2009 at 08:18:50PM -0500, Vikram Dhillon wrote:
> > > IMHO you can process elements rather than bytes, which is a good
> > > improvement, but then again its my opinion, if others don't like it
> > > then we can always change it :D
> > 
> > Right, I was not arguing against having a record-oriented interface, I
> > was questioning the utility of processing several records at a time.
> > Kfifo users that I have seen so far were working in a record-at-a-time
> > mode.
> 
> I have a use case in linux/drivers/media/video/cx23885/cx23888-ir.c
> right now.
> 
> I have a hardware fifo that can hold up to 8 values, 17 bits each - and
> the high bit of the value is a flag indicating if more data is in the
> hardware fifo.
> 
> The hardware fifo watermark for generating an interrupt is 4 or more
> values in the hardware fifo.
> 
> I use a kfifo that needs to be protected with a spinlock.
> 
> It in much better in the IRQ context to drain the hardware fifo and then
> put records in the kfifo all at once (or at least in groups of 8 or less
> but usually greater than 1).

Hmm, so there you have a local buffer that you fill by reading from the
device word by word, then you copy that data over into fifo and then you
upper layer again fetches that fifo as byte stream...

I'd probably simply move the processing that you are doing in
cx23888_ir_rx_read() into cx23888_ir_irq_handler() (since it is very
simple) and then used kfifo in simple byte mode (since that is what
upper layer seem to expect).

-- 
Dmitry
