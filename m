Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbZC2Dp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbZC2Dp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 23:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZC2DpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 23:45:15 -0400
Received: from thunk.org ([69.25.196.29]:49661 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZC2DpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 23:45:13 -0400
Date: Sat, 28 Mar 2009 23:43:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090329034346.GA10984@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>, david@lang.hm,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <alpine.DEB.1.10.0903281726100.22577@asgard.lang.hm> <49CECDEB.7040704@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CECDEB.7040704@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 09:24:59PM -0400, Jeff Garzik wrote:
>> ted's suggestion (in his blog) to tweak fsync to 'misbehave' when 
>> laptop mode is enabled (only pushing data out to disk when the disk is 
>> awake anyway, or the time has hit) would really work well for most 
>> users. servers (where you have the data integrity fsync useage) don't 
>> use laptop mode. desktops could use 'laptop mode' with a delay of 0.5 
>> or 1 second and get prety close the the guarentee that users want 
>> without a huge performance hit.
>
> The existential struggle is overall amusing:
>
> Application writers start using userland transactional databases for  
> crash recovery and consistency, and in response, OS writers work to  
> undercut the consistency guarantees currently provided by the OS.

Actually, it makes a lot of sense, if you think about it in this way. 

The requirement is this; by default, data which is critical shouldn't
be lost.  (Whether this should be done by the filesystem performing
magic, or the application/database programmer being careful about
using fsync --- and whether we should treat all files as critical and
to hell with performance, or only those which the application has
designated as precious or nonprecious --- there is some dispute.)

However, the system administrator should be able to say, "I want
laptop mode functionality", and with the turn of a single dial, be
able to say, "In order to save batteries, I'm OK with losing up to X
seconds/minutes worth of work."  I would envision a control panel GUI
where there is one checkbox, "enable laptop mode", and another
checkbox, "enable laptop mode only when on battery" (which is greyed
out unless the first is checkbox is enabled), and then a slidebar
which allows the user to set how many seconds and/or minutes the user
is willing to lose if the system crashes.

At that point, it's up to the user.  Maybe the defaults should be
something like 15 seconds; maybe the defaults should be 5 seconds.
Maybe the defaults should be automatically set to different values by
different distributions, depending on whether said distro is willing
to use badly unstable proprietary bindary video drivers that crash if
you look at them funny.

The advantage of such a scheme is that there's a single knob for the
user to control, instead one for each application.  And fundamentally,
it should be OK for a user of the desktop and/or the system
administrator to make this tradeoff.  That's where the choice belongs;
not to the application writer, and not to the filesystem maintainer,
or OS programmers in general.

If I have an Lenovo X61s which is rock solid stable, with Intel video
drivers, I might be willing to risk lose up to 10 minutes of work,
secure in the knowledge it's highly unlikely to happen.  If I'm an
Ubuntu user with so super-unstable proprietary video driver, maybe I'd
be more comfortable with this being 5 or 10 seconds.  But if we leave
it up to the user, and they have an easy-to-use control panel that
controls it, the user can decide for themself where they want to trade
off performance, battery life, and potential window for data loss.

So having some mode where we can suspend all writes to the disk for up
to a user-defined limit --- and then once the disk wakes up, for
reading or for writing, we flush out all dirty data --- makes a lot of
sense.  Laptop mode does most of this already, except that it doesn't
intercept fsync() requests.  And as long as the user has given
permission to the operating system to defer fsync() requests by up to
some user-specified time limit, IMHO that's completely fair game.

							- Ted
