Return-Path: <linux-kernel-owner+w=401wt.eu-S1751787AbXBMT1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbXBMT1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXBMT1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:27:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbXBMT1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:27:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: NAK new drivers without proper power management?
Date: Tue, 13 Feb 2007 20:24:18 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Manu Abraham <abraham.manu@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Robert Hancock <hancockr@shaw.ca>
References: <1171059433.8675.195.camel@laptopd505.fenrus.org> <200702122131.33662.rjw@sisk.pl> <45D18805.9080607@imap.cc>
In-Reply-To: <45D18805.9080607@imap.cc>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200702132024.20053.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 13 February 2007 10:42, Tilman Schmidt wrote:
> Rafael J. Wysocki schrieb:
> > I think we can introduce a "pm_safe" flag that will indicate if the driver
> > handles suspend/resume correctly.  If we do it, we can flag all of the drivers
> > currently in the tree as "pm_safe" unless we know that they aren't.  Next,
> > we can convert the core to fail the suspend for any driver that is not flagged
> > as "pm_safe".  But I think that will take time.
> 
> Why a new flag?

For example, there are drivers that define .suspend() and .resume() which
do not work correctly and we can use the flag to mark them.

> IMHO it would be both more readable and more efficient 
> to create a pm_generic_nosuspend() function which does "return -ENOSYS",
> and set that as the .suspend method on drivers known to break
> suspend/resume. New drivers should either have .suspend and .resume
> methods of their own or set .suspend = pm_generic_nosuspend.

This is quite similar to what we are trying to do now: ask driver authors to
define .suspend that will return -ENOSYS if they can't ensure that the driver
will handle the suspend and resume correctly.

> That way, NULL .suspend/.resume methods retain their current semantics
> ("don't know whether suspend would work, never thought about it"),

I think this convention is unfortunate.  The default should be to fail the
suspend if there's no .suspend defined, IMO.  Still, it's hard to change now.

> error-returning ones would clearly signal "cannot suspend safely", and
> success-returning ones would equally clearly signal "suspend works ok".
> (Bugs nonwithstanding.)
> 
> There could then be a policy parameter (Kconfig selectable to start)
> to abort suspend when encountering a driver without .suspend/.resume
> methods, or to proceed with a warning message.

I think there are many drivers without .suspend and .resume already in the
tree, so that wouldn't be practical.

Greetings,
Rafael
