Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXFAEIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXFAEIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 00:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbXFAEIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 00:08:37 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:60422 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXFAEIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 00:08:36 -0400
Date: Fri, 1 Jun 2007 05:08:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Message-ID: <20070601040824.GA5042@srcf.ucam.org>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <20070601012928.GD5407@khazad-dum.debian.net> <20070601014453.GA3711@srcf.ucam.org> <200705312333.11477.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705312333.11477.dtor@insightbb.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 11:33:10PM -0400, Dmitry Torokhov wrote:
> On Thursday 31 May 2007 21:44, Matthew Garrett wrote:
> > It's not trivial at all. You need to introduce a mechanism for noting a 
> > KEY_UNKNOWN keypress. It then needs to signal the user (dbus is probably 
> > the best layer for this), but you need to ensure that you only signal 
> > the user who is currently at the keyboard. This needs to be presented to 
> > the user via some sort of UI, which will then need to signal some sort 
> > of privileged process to actually change the keymap.
> 
> Not necessarily priveleged - you most likely already change ownership
> of event devices to user who is logged at console (so your force feedback
> joysticks work).

If you let users alter the kernel keymap, then you need to implement 
support for resetting the kernel keymap on exit. Otherwise it's a 
trivial DoS.

> > When the user logs  
> > out, you'll then need to unmap the key again and repeat as necessary for 
> > any new user who logs in.
> 
> I think we should aim at the most common case - when there are no multiple
> users on the box. Then the utility that detects KEY_UNKNOWN just saves the
> mapping user chose and automatically reload keymap upon next reboot.

The standard setup for home machines tends to be an account per family 
member. The standard setup in an office environment is likely to be 
multiuser.

> Note that KEY_UNKNOWN solution does not preculde futher customization on
> per-user base once default action is established.

No, but it makes it significantly more confusing. User 1 chooses a 
setup. This gets saved. User 2 remaps keys based on User 1's settings 
(which have been restored at bootup). User 1 alters key mapping. User 2 
suddenly becomes hugely confused.

> > 
> > Alternatively, we could generate a keycode and then let the user map 
> > that to an X keysym. We've even already got code to do this.
> >
> 
> There is world outside of X.

On machines like we're discussing (laptops, basically) it's a tiny 
world. Optimise for the common case, not the rare one.

> > That's a ridiculously niche case, and can be handled in userspace. Just 
> > have udev do remapping when it detects multiple keyboards that both have 
> > KEY_PROG* layers, or let X have different keymaps for different input 
> > devices. We shouldn't make the (by far) common case significantly more 
> > difficult to deal with this one.
> > 
> 
> No, it is not a niche case. I think it is much more common than the case where
> you have multiple users for the same box using different keymaps. Even if box
> is shared there most likely will be one person setting it up in the beginning
> and the rest will follow his/her setup.

How many users plug external keyboards with unlabelled keys into a 
laptop? No, I really don't think that's a common case at all.

The solution that satisfies the largest number of users with the 
smallest amount of work is the one where pressing a key on the keyboard 
results in X events being generated. Right now, that requires that the 
key generate a real keycode.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
