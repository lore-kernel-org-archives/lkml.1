Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXFDWJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXFDWJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXFDWJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:09:39 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.212]:60801 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbXFDWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:09:38 -0400
Date: Mon, 4 Jun 2007 18:09:10 -0400
From: Jeremy Maitin-Shepard <jmaitins@andrew.cmu.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: A kexec approach to hibernation
Message-ID: <20070604220910.GB2515@andrew.cmu.edu>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604104621.GB4405@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 12:46:21PM +0200, Pavel Machek wrote:

> [snip]

> > You might claim then that the solution is to simply keep the network
> > driver quiesced or stopped.  But then it is impossible to write the
> > image over the network.  The way to get around this problem is to write
> > the image over the network using a fresh network stack.
> 
> The "fresh network stack" will RST any connections that were going,
> which is ugly, too.

It will only do this if you bring up the network device with the same IP 
address in the new kernel (which you would have no reason to do if you don't 
need to write the image over the network.)  Maybe the ideal behavior would be 
to tell the network stack to just ignore unexpected TCP packets, rather than 
send RST, while saving or reading the image, but that is probably not necessary 
for most uses and would be a hack.

I also think that sending RST is far better than sending ACK and then silently 
tossing out the data, which is what is currently done.  (Since I 
believe currently the network devices are brought back up along with 
all other devices after the atomic copy is made.)  Silently losing data is 
something that should only occur on a crash.  This is likely to actually be a 
somewhat serious problem for servers on which hibernate is used to move the 
server between rooms without losing connections.

Of course, you can get around this by adding a hack to not bring up network 
devices based on some option or other, but that just solves one specific 
case with an ugly solution.  In contrast, using the kexec approach, the network 
device or any other device would quite naturally not be brought back up unless 
it was needed for hibernate, and even if it is brought back up, no data are 
silently lost.

> [snip]

> > To me, it seems a lot easier to get right than the current approaches.
> 
> Well, you are certainly welcome to create the patch. "suspend3" name
> is still free, AFAICT.

I could be sneaky and call it "hibernate".  Probably nicer though to use the 
name "kexec hibernate" to be later simplified to just "hibernate".

I was hoping that everyone would like the idea so much that they would rush to 
implement it, so that I wouldn't have to try.  (I haven't written much kernel 
code before, and I have a number of other time-requiring projects to work on.) 
It looks like that is not too likely to happen though ;).

Maybe I'll try implementing it though, and find that it isn't very much work.

It would be very convenient if the current work being done to improve the 
driver interfaces for hibernate also results in the proper interfaces needed 
for this approach.  It looks like the resume path should be exactly the same 
with this approach as with the existing approaches, but the hibernate path is 
not exactly the same.  In particular, it seems that all devices should be shut 
down to a greater extent that merely the quiescing neccessary for the current 
approaches while making an atomic copy, but also they should not be completely 
shut down to the extent that they cannot be restored to the desired state when 
resuming or aborting.

> 
> If _I_ were willing to add some runtime overhead to make hibernation
> simpler, I'd just use some virtualization to do that... with added
> advantage of "hibernate here, resume on different hw".

I don't believe there is going to be any runtime overhead.

To some extent, (see some of the explanations I gave in the other e-mail I
sent a few minutes ago in reply to Nigel) I think the kexec appraoch can be
viewed as a cleaner variant of userspace hibernate.

-- 
Jeremy Maitin-Shepard
