Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYHSSVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYHSSVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYHSSVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:21:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59769 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751777AbYHSSVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:21:05 -0400
Date: Tue, 19 Aug 2008 14:21:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: juanslayton@dslextreme.com
cc: Aivils Stoss <aivils@latnet.lv>, <jkosina@suse.cz>,
       lud <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       <linuxconsole-dev@lists.sourceforge.net>, <linux-input@vger.kernel.org>
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
In-Reply-To: <25da0a65dd8a41208a8a0c0a.20080819094057.whnafynlgba@webmail.dslextreme.com>
Message-ID: <Pine.LNX.4.44L0.0808191400150.3391-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 juanslayton@dslextreme.com wrote:

> I have to apologize for my limited knowledge, but mere ignorance never yet
> kept a teacher quiet.  I am trying to follow this discussion because
> Aivils and I are  basically trying to do the same thing.  In my case I am
> presently running 20 keyboards on a 2.6.26 kernel, using an EHCI
> controller, and they all work fine.

You must be using some hubs.  The results you get will depend on the 
type of hub you use.

> If I understand your analysis, Aivils' problem is because the UHCI
> controllers are too slow.

Not just that; it also is a question of scheduling.  The uhci-hcd
driver isn't very clever about scheduling, and it tries to put all the
packets into the same frame.  If the packets were distributed among
multiple frames then the limit would be considerably higher (eight
times higher in this case).

I'm not sure of the scheduling details in the ohci-hcd driver; they
might well be more flexible than in uhci-hcd.  In which case a single
OHCI controller would be able to handle up to 32 of these keyboards, 
even though it is no faster than a UHCI controller.

>  (I just happened to get lucky with another
> controller.)  I am left with two questions.
> 
> 1.  What if Aivils needs more than 16 keyboards?  (Standard class sizes
> here in California run from 20 to about 30.)  Is there any way he can do
> this without a faster controller?

You should realize that Aivils _does_ have an EHCI controller.  He just
isn't using it, because his hubs are old.  So the easiest approach for 
him would be to buy USB-2.0 hubs.

If he doesn't want to do that there are a few ways, but they mostly
boil down to getting more controllers.  If he is good at kernel
programming, he could upgrade the scheduling algorithm in uhci-hcd --
but that will be a messy job and probably not worth the time spent
(which is why I've never done it).

> 2.  What does the bandwidth limitation say about the maximum number of
> boards with the EHCI controller?  I modified the kernel evdev.c and
> input.c files to raise the maximum events from 32 to 64, but I hadn't
> figured in the effects of bandwidth.

Like I said above, it depends on the type of hub you use.  If you have
hubs with multiple Transaction Translators then the bandwidth limit
will be very high.  I don't know how high exactly, but probably higher
than other limits, like the maximum number of USB devices on a single
bus (127).

If you have hubs with only a single Transaction Translator then the
limit will be lower, but still pretty high.  Certainly you would be
able to connect no more than four keyboards to each hub, but you could
have many hubs.  The details would depend on the scheduling algorithm 
in ehci-hcd, which I'm also not familiar with.

If you have only full-speed hubs (i.e., USB-1.1 hubs rather than
USB-2.0) then you won't be able to make use of the EHCI controller at
all.  That's the situation Aivils is in.

Alan Stern

