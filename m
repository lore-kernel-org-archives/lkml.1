Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZBPVdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZBPVdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZBPVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:33:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54164 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZBPVdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:33:41 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Arjan van de Ven <arjan@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
CC: Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Date: Mon, 16 Feb 2009 15:32:06 -0600
Subject: RE: [RFD] Automatic suspend
Thread-Topic: [RFD] Automatic suspend
Thread-Index: AcmQd51IcBbZvZveSL+Y0Jk8KnI/iQAABPkQ
Message-ID: <13B9B4C6EF24D648824FF11BE896716203771DCF1E@dlee02.ent.ti.com>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	<Pine.LNX.4.44L0.0902161537080.19732-100000@netrider.rowland.org>
 <20090216124520.315320dc@infradead.org>
In-Reply-To: <20090216124520.315320dc@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Arjan van de Ven [mailto:arjan@infradead.org]
> Sent: Monday, February 16, 2009 2:45 PM

> On Mon, 16 Feb 2009 15:39:15 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
>
> > On Mon, 16 Feb 2009, Kyle Moffett wrote:
> >
> > > Userspace may not have a useful decision-making capability regarding
> > > functionality versus power-saving, but the user it's talking to
> > > might!
> > >
> > > I think it would be very useful to have a mechanism for userspace to
> > > find out "Link detection on this NIC costs ~50mW" and "No link has
> > > been detected for the last 15 minutes", so that it can compile all
> > > that sort of information and prompt the user what devices they would
> > > like to disable.  Perhaps an "airline mode" sort of thing?
> >
> > Even if drivers don't know how much power their devices consume (and
> > generally I wouldn't expect them to), it still makes sense to offer
> > userspace the discretionary power to force devices into a low-power
> > mode.  USB does this.
>
> "stop using it" isn't this discretionary power ?
> (for NICs this is "ifconfig .. down")

Allowing a trusted user space process some hook in kernel PM has turned out useful for us.

- It gives a way for frame works which load codecs into DSPs a way to specify needs before loading. The DSP has its own internal dynamic predictor but it is not always good enough. Feeding this info in from user space is easy as it knows everything about the DSP algorithm it is loading. There isn't a reason to re-export all of that back into the kernel and might hurt DSP performance if it ran on it natively.

- It provides a way to handle overdrive/turbo operating points out of band from the generically tuned cpufreq governors like ondemand.  The way we characterize overdrive is stricter then what Intel has talked about for x86.

In TI-reference code we effectively export sysfs knobs which influence system p-state and c-state choices (we borrowed Intel terms here as they are useful). This was done before pmqos was available. We would have considered extending pmqos but a couple things stopped this. One being it wasn't in kernel at the time and two being any change picks up a year of disagreements. As such we put some front end wrappers on the calls which use it to some degree.

There is a community-reference targeting kernel merging but I think it is only now reaching the point of the user space interface. People working there have expressed interest in a direct pmqos interface and removing our wrapping calls.

What we have done more follows what happens when you have a complex driver/subsystem which has pieces in both users and kernel space.  It works ok for this.

This is ok for making sure the complex driver works well. It doesn't address all the other user space things going on which also need some kind of management so they don't sink system power. This is where wakelocks start to do something more generically useful.

Right now it seems no one is willing to own the whole system. It is easier to just say user space sucks and someone else should fix it...or my driver is fine it is someone else's problem. However, by not giving some kind of useful constraints interface to help control bad (or uncontrollable) elements the end result are non-competitive Linux systems or ugly out of tree vendor hacks. This is where wakelocks actually stand out.  They actually try and do something useful generically.

It seems the perfect is often the enemy of the good when it comes to Linux PM discussions.

Regards,
Richard W.

