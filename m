Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0CLErw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:47:52 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:51784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0CLErv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:47:51 -0500
Subject: Re: firmware loading vs. initrd
From: Johannes Berg <johannes@sipsolutions.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tomas Winkler <tomasw@gmail.com>,
       Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <ac3eb2511003112032s6d4b097aqda02143edfec5a3@mail.gmail.com>
References: <1268347174.4142.11.camel@jlt3.sipsolutions.net>
	 <ac3eb2511003112032s6d4b097aqda02143edfec5a3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 20:48:10 -0800
Message-ID: <1268369290.4828.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 05:32 +0100, Kay Sievers wrote:
> On Thu, Mar 11, 2010 at 23:39, Johannes Berg <johannes@sipsolutions.net> wrote:
> > We recently converted a few wireless drivers to use
> > request_firmware_nowait() in order to be able to load firmware from
> > probe. We would like to continue with that so we can load the firmware
> > before registering with any other subsystems, as we had discussed at the
> > wireless summit last year.
> >
> > However, in actually trying this today, I noticed that there's a problem
> > with this. I made my drivers all built in, and then I ended up with it
> > not working because the firmware agent that was in my initrd was telling
> > [1], and the kernel that the firmware could not be found.
> >
> > I thought of modifying the firmware agent in the initrd to not tell the
> > kernel it doesn't have it, but that is problematic when using
> > request_firmware(), the kernel boot will be delayed until the timeout
> > (one minute).
> >
> > This can be solved by adding an environment variable to the uevent that
> > tells userspace whether or not this is coming from request_firmware() or
> > request_firmware_nowait(). I will follow up with a patch doing that.
> >
> > Additionally, however, we need to make a change like below to the
> > firmware agent in order to not reply to asynchronous firmware loads
> > during the initrd stage. I'm not sure how to actually check that we're
> > running in an initrd (is that possible?) nor did I actually verify that
> > the NOWAIT environment variable is set properly.
> >
> > Thoughts? It seems like this would solve our problems nicely if we can
> > determine whether we're in the initrd or not.
> 
> I don't think we can reliably make the decision that the firmware is
> not available at a later point.
> 
> Depending on the system, we can have several re-trigger of the same
> events during bootup, and the firmware loader does not have any idea
> in which state the system is.

Oh, interesting, I had no idea.

> What's wrong to leave the request staying around for forever, until it
> is possibly canceled from userspace? So this event could be
> re-triggered from userspace any time later. Whatever will cancel the
> firmware requests in the end, it needs to be something that knows more
> about the state of "booting" than the firmware loader knows today, I
> guess.

Nothing in particular, although when you've set the timeout to 0 (no
timeout) this would have the request and a kernel thread stick around
forever. But I didn't know about multiple stages etc. here, so yes it
would probably make sense to just leave the request around until we know
we can reliably say we don't have it.

johannes

