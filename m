Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbZFIXJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbZFIXJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZFIXJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:09:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44016 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZFIXJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:09:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Wed, 10 Jun 2009 00:44:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906082034.31091.rjw@sisk.pl> <200906090925.18866.oliver@neukum.org>
In-Reply-To: <200906090925.18866.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906100044.03230.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, Oliver Neukum wrote:
> Am Montag, 8. Juni 2009 20:34:30 schrieb Rafael J. Wysocki:
> > On Monday 08 June 2009, Oliver Neukum wrote:
> > > Am Montag, 8. Juni 2009 13:29:26 schrieb Rafael J. Wysocki:
> 
> > > Secondly, you are not using a counter. Therefore only one driver can
> > > control the PM state of a device at a given time. Is that wise?
> >
> > I didn't think about it to be honest.  Obviously this patch doesn't cover
> > all of the possible cases and I'm not even sure it's worth trying to cover
> > them upfront.
> 
> I am thinking of multimedia cards, which have separate drivers for i2c, tuner
> and so on.

Hmm, OK there.  But there's only one bus type per device anyway, isn't it?
So I'm not sure how a counter can help in this case.

> > > Why is this needed?
> >
> > In some subsystems, like PCI, devices will be resumed by the BIOS
> > unconditionally in the majority of cases and then it's not worth trying to
> > complete run-time PM requests from before the suspend.
> 
> But why is it worth canceling them? That feature seems to be an unnecessary
> complication. As long as you can safely suspend them, why not do it?

Because that's an operation that need not be necessary.  I'd like to avoid
unnecessary operations, but you're right, it can be done differently.

> > > > +/**
> > > > + * __pm_schedule_resume - Schedule run-time resume of given device.
> > > > + * @dev: Device to resume.
> > > > + * @autocancel: If set, the request will be cancelled during a resume from a 
> > > > + *	system-wide sleep state if it happens before pm_autoresume() can be run.
> > > > + */
> > >
> > > Eeek! This is a bad idea. You never want to a resume to be cancelled.
> >
> > Sometimes I do (see above).
> 
> Well no. A driver requests a resume because it has to.
> This needs a defined call sequence.
> 
> Do you guarantee that autoresume follows autosuspend or not?

Not necessarily.  If there's an autoresume request pending during STR or STD,
the "sleep resume" will do very much the same thing as the autoresume, it will
put the device into the full power state.  IOW, the "sleep resume" can satisfy
an autoresume request, so there should be a mechanism to cancel pending
autoresume requests during 'sleep resume'.  Still, it may be better if the
driver's or bus type's ->resume() does that.

> If not what sequences can happen? Obviously an autosuspended device
> can be unplugged.
> But the problem here is STR or STD. How do you notify drivers that the BIOS
> has resumed their device instead of autoresume() being called? A driver
> has to know that its device has become active without its knowledge.

Actually, the driver will know what happens to the device anyway, because
its ->resume() callback is going to be executed and it has to be synchronized
with the ->auto[suspend|resume]() callbacks.

> > > > +		cancel_delayed_work_sync(&dev->power.suspend_work);
> > >
> > > That is the most glorious abuse of an API I've seen this year :-)
> >
> > Heh.
> >
> > OK, what would you do instead?
> 
> A waitqueue.

Or perhaps a completion?

OK

I tried to address the majority of your comments in the new version of the
patch which I'm going to send in a while in a reply to an Alan's message.

Best,
Rafael

