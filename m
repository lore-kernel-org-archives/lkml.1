Return-Path: <linux-kernel-owner+w=401wt.eu-S965386AbXBLUyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965386AbXBLUyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965394AbXBLUyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:54:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44550 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965386AbXBLUyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:54:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 21:06:25 +0100
User-Agent: KMail/1.9.5
Cc: Tilman Schmidt <tilman@imap.cc>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <45CFB06B.5080102@imap.cc> <1171253309.5473.15.camel@nigel.suspend2.net>
In-Reply-To: <1171253309.5473.15.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122106.25939.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 February 2007 05:08, Nigel Cunningham wrote:
> Howdy!
> 
> On Mon, 2007-02-12 at 01:10 +0100, Tilman Schmidt wrote:
> > Hi,
> > 
> > Am 11.02.2007 23:37 schrieb Nigel Cunningham:
> > > On Sun, 2007-02-11 at 00:45 +0100, Tilman Schmidt wrote:
> > >> Am 10.02.2007 23:37 schrieb Nigel Cunningham:
> > >>> If your device requires power management, and you know it requires power
> > >>> management, why not just implement power management? [...]
> > >> Like it or not, power management is far from trivial, and people
> > >> writing device drivers have limited resources. [...]
> > > It's not that complex. All we're really talking about is a bit of extra
> > > code to cleanup and configure hardware state; things that the driver
> > > author already knows how to do. S3 might require a bit more
> > > initialisation if firmware needs to be reloaded or more extensive
> > > configuration needs to be done, but if there's firmware to be loaded,
> > > there is a reasonably good probability that we loaded it from Linux to
> > > start with anyway.
> > 
> > You are assuming a perfect world where driver authors have complete
> > knowledge of their devices. In reality, many drivers (including
> > those I have the mixed pleasure of maintaining) are based at least
> > in part on reverse engineering, and managing power states may well
> > fall into the domain of things not yet sufficiently reverse
> > engineered.
> 
> Nope. I'm assuming that the driver author knows what needs to be done to
> get the driver out of whatever state the BIOS puts it in to start with,
> and into an operational state, and that they therefore also know what
> needs to be done to take it out of the operational state again. I'm
> admitting that there's also another state - the post suspend-to-ram
> driver state - that they may not know how to deal with. But for
> suspend-to-disk, if you know how to get the driver to work in the first
> place, you know enough to stop it working (.suspend) and start it up
> again (.resume) for the hibernate case at least.

We're talking about _both_ the STR and STD.  The drivers that have problems
with the STR cannot be regarded as suspend/resume-safe IMO.

> I'm not assuming that you know enough to be able to put the driver into
> a low state and get it out again. This is definitely preferable, and at
> least possibly essential for suspend to ram, but for some unknown reason
> I'm quite hibernation focused, and for that, just the above is
> sufficient.

Please take the STR into consideration too.  After all we use the same
suspend/resume code for both STD and STR so it should work with both.  If it
doesn't work with one of them, we have a problem.

> > >> Also, in your argument you neglected a few cases:
> > >> - What if my device does not require power management?
> > > 
> > > Then you as a generic routine that does nothing but return success
> > > (potentially shared with other drivers that are in the same situation).
> > 
> > But if I just write an empty routine like that I open myself up to
> > criticism along the lines of "writing dummy routines just in order
> > to shut up kernel warnings". BTDT.
> 
> Well, it might not be completely empty. I think someone already pointed
> out that there's a minimal workset for the pci bus that pci drivers
> would want to invoke. But we wouldn't (rightly) accuse you of such
> things if we decided that the policy was "Every driver ought to have a
> resume routine, even if it's just a minimal I-just-work route".

I'm still thinking that would be wasteful.  I think there are more drivers that
work than there are drivers that don't work.

> > >> - What if I don't know whether my device requires power management?
> > > 
> > > The questions are straight forward: Is there hardware state that needs
> > > to be configured if you've just booted the computer and nothing else has
> > > touched it? If so, that needs to be done in a resume method. Do you need
> > > to clean up state prior to doing the things in the resume method, or
> > > otherwise do things to quiesce the driver? If so, they will need to be
> > > done in the suspend method. The result will be roughly similar to what
> > > you do for module load/unload, except maybe less complete in some cases.
> > 
> > I don't doubt your basic assessment. However it doesn't translate that
> > easily into a real implementation. In my case, I maintain a USB driver,
> > so I have to deal with USB specifics of suspend/resume which happen not
> > to be that well documented. My driver provides an isdn4linux device but
> > isdn4linux knows nothing about suspend/resume so I am on my own on how
> > to reconcile the two. The device itself, though in turn far from trivial,
> > is actually the least of my worries.
> 
> Mmm, so that's a case where we need to prod those who write
> documentation and bus support first. You're probably closer! :)

Actually, the lack of documentation is a major problem that we all should
try to fix in the first place.  Unfortunately the code has been recently
changing quite often, so that's difficult.

Greetings,
Rafael

