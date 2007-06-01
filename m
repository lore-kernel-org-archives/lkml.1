Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbXFAOTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbXFAOTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761210AbXFAOTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:19:19 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48107 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761131AbXFAOTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:19:16 -0400
X-Sasl-enc: uZQc7dxRLCC2klY2rFHEBtMDUx7HYPDbIqQhNIbQremv 1180707554
Date: Fri, 1 Jun 2007 11:19:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Richard Hughes <hughsient@gmail.com>,
       linux-acpi@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
Message-ID: <20070601141910.GB8211@khazad-dum.debian.net>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <20070601012928.GD5407@khazad-dum.debian.net> <20070601014453.GA3711@srcf.ucam.org> <200705312333.11477.dtor@insightbb.com> <20070601040824.GA5042@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601040824.GA5042@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007, Matthew Garrett wrote:
> On Thu, May 31, 2007 at 11:33:10PM -0400, Dmitry Torokhov wrote:
> > On Thursday 31 May 2007 21:44, Matthew Garrett wrote:
> > > It's not trivial at all. You need to introduce a mechanism for noting a 
> > > KEY_UNKNOWN keypress. It then needs to signal the user (dbus is probably 
> > > the best layer for this), but you need to ensure that you only signal 
> > > the user who is currently at the keyboard. This needs to be presented to 
> > > the user via some sort of UI, which will then need to signal some sort 
> > > of privileged process to actually change the keymap.
> > 
> > Not necessarily priveleged - you most likely already change ownership
> > of event devices to user who is logged at console (so your force feedback
> > joysticks work).
> 
> If you let users alter the kernel keymap, then you need to implement 
> support for resetting the kernel keymap on exit. Otherwise it's a 
> trivial DoS.

True, and unfortunately this is not something that can be done right with
what we have now and playing with udev.  Oh dear, I was too hasty to think
that we had all the infrastructure needed already...

Changing system-wide keymap should be a privileged operation.  Changing
per-user keymaps should not screw up any system-wide keymap changes made by
the administrator, and it needs to go away for the next user.

And for multi-user systems, you likely need to be able to switch keyboard
maps when VTs are switched.   This does not look like an easy thing to fix
properly.

The truth is that what we currently have seems suitable only for
system-administrator level changes (aka trusted, global changes), and should
be restricted to CAP_SYSADMIN.

> > I think we should aim at the most common case - when there are no multiple
> > users on the box. Then the utility that detects KEY_UNKNOWN just saves the
> > mapping user chose and automatically reload keymap upon next reboot.

I disagree.  It is one thing to do extremely broken optimizations like not
unloading heads on scsi disks "because it could be in a multiple initiator
system", thus breaking 99% of the systems out there.  It is a very different
thing to not support a multi-user system scenario at all re. keyboard maps.

I don't care if we default for single-user systems, but we definately have
to properly support the multi-user system case, and it *is* a very common
case in business workstations AND home user systems anywhere computers are
not as cheap as a ticket to the movies.

At the very least we need to protect the keymap from untrusted changes while
we don't have anything but system-wide ones.  And we should start working on
per-user (really, copy-on-write per-fd keymaps. Yuck!) or per-VT/pty keymaps
done safely, too.

> The standard setup for home machines tends to be an account per family 
> member. The standard setup in an office environment is likely to be 
> multiuser.

Agreed.  This is what I see in Brazil.  Most homes have only ONE computer,
when they have one at all.  And most office environments have one computer
per seat, and less seats than there are workers.

> > Note that KEY_UNKNOWN solution does not preculde futher customization on
> > per-user base once default action is established.
> 
> No, but it makes it significantly more confusing. User 1 chooses a 
> setup. This gets saved. User 2 remaps keys based on User 1's settings 
> (which have been restored at bootup). User 1 alters key mapping. User 2 
> suddenly becomes hugely confused.

Well, the proper fix for this has nothing to do with KEY_UNKNOWN, and it is
per-user/per-VT/pty keymaps and a reset IOCTL (or automatic reset in the
per-user case).

> > > Alternatively, we could generate a keycode and then let the user map 
> > > that to an X keysym. We've even already got code to do this.
> > >
> > 
> > There is world outside of X.
> 
> On machines like we're discussing (laptops, basically) it's a tiny 
> world. Optimise for the common case, not the rare one.

If the input system is going to start breaking The Console now, you can
expect to have me fighting you all the way.  I do agree that a
system-admin-only case for the console is good enough, though: multi user
systems that have to bother with per-user keymaps will be running X or
something like that.

> > > That's a ridiculously niche case, and can be handled in userspace. Just 
> > > have udev do remapping when it detects multiple keyboards that both have 
> > > KEY_PROG* layers, or let X have different keymaps for different input 
> > > devices. We shouldn't make the (by far) common case significantly more 
> > > difficult to deal with this one.
> > > 
> > 
> > No, it is not a niche case. I think it is much more common than the case where
> > you have multiple users for the same box using different keymaps. Even if box
> > is shared there most likely will be one person setting it up in the beginning
> > and the rest will follow his/her setup.
> 
> How many users plug external keyboards with unlabelled keys into a 
> laptop? No, I really don't think that's a common case at all.

Err... potentially a lot of them could.  Good laptop manufacturers sell
keyboards with the touchpad and hot keys matching the laptop, you know.  It
is what you get for The Boss to go with his shiny dock so that he doesn't
have to plug cables on the laptop, ever (you also get a matching set for his
home and send someone there to set it up for him).  Heck, for thinkpads I
could get even a keyboard with the touchpad and ultranav (the "nipple") if I
wanted!

And keyboards nowadays are *full* of weird keys, many of them unlabelled so
that "gamers" can assign them different functions...

Unlabelled keys are *common* these days.   What I agree to be uncommon is
two or more keyboards per machine with different users on them (i.e.
multi-head boxes), but that's just because Linux is starting to get really
friendly out-of-the-box to multi-head boxes now.  I know they would be using
them like crazy at work if it was something easier to set-up and maintain.

> The solution that satisfies the largest number of users with the 
> smallest amount of work is the one where pressing a key on the keyboard 
> results in X events being generated. Right now, that requires that the 
> key generate a real keycode.

Well, if key_unknown is a very very uncommon thing, we could have the
system-admin-only nature of keyboard remapping (thus avoiding DoS attacks on
multi-user systems). and be done with this.  But for that, we need KEY_MAX
bumped up.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
