Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbXFWPml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbXFWPml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 11:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXFWPme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 11:42:34 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:62735 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXFWPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 11:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y4fU13EHiHb+wu22qXSvL3g/BHYr6n2N2Dt5Djhg+V9jZ+mNwJApUfX474sPKyTLzr/KDlmFQT3ivVWe63rtuUwHu8xRdqFTKFsB595TMhnliI6zPXc0Uv0ZS3uGUL61XN82j7hdseMXaLPAIVm+RDz1dBnCrwTFjThCzrMdL6Q=
Message-ID: <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
Date: Sat, 23 Jun 2007 21:12:32 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: "upping" a semaphore from interrupt context?
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Florin Iucha" <florin@iucha.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706231402.03617.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622173839.GB8398@iucha.net>
	 <200706221934.18436.arnd@arndb.de>
	 <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain>
	 <200706231402.03617.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert, Arnd,

On 6/23/07, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 23 June 2007, Robert P. J. Day wrote:
> > On Fri, 22 Jun 2007, Arnd Bergmann wrote:
> > >
> > > yes, but you should not. The use of semaphores is not recommended
> > > for new code, it should be replaced with either a mutex or a
> > > completion.
> >
> > can you clarify this? it sounds like you're saying that the current
> > implementation of semaphores is entirely superfluous. but surely it
> > isn't possible to replace all semaphores with either mutexes or
> > completions, is it?

Semaphores being used as completions are superfluous, obsoleted
by completion handlers. Semaphores that are not counted (hence
binary) are superfluous, obsoleted by struct mutex. It's not that using
semaphores for the above two usages would be "incorrect", it's just that
the other options are precisely implemented for their specific purpose
and hence are better (benchmark struct mutex against (binary) struct
semaphore yourself, for example). So there's no good reason why a
driver's design would want to use semaphores as above with the other
available options.

A simple way to detect users who are still {mis}using semaphores
as completions are those that will (thus) inevitably have to declare
(or initialize) them as locked, say most (all?) users of
DECLARE_MUTEX_LOCKED.

22-rc5 has 4 such users, one of which is dead code inside a #if 0,
one declared a spurious semaphore variable without using it
anywhere else in the code (deleted in -mm), one has been converted
to completions (in -mm) already, and the last one (libusual.c) is the
problematic one which still exists, because of the comment in that
file that it wants the _completions_ to be also *counted*, and thus
ostensibly wants to use semaphores instead of completions.
However, that comment is totally wrong, and doesn't seem to know
about the existence of the complete_all() function that precisely
serves the purpose that libusual wants.

In short: there are _no_ valid excuses to use DECLARE_MUTEX_LOCKED
(or semaphores as completions) ever.

[ libusual's {ab}use of that semaphore is *insane* for several other
reasons, but then that will be the subject matter of another thread :-) ]

> No, not all of them, but the vast majority. There are multiple
> differences, the most important one being the 'counting' in
> semaphores. You can e.g. define a semaphore that can be held
> by N users at the same time, but not more. In a mutex, N is
> by definition 1, so only one thread can hold a mutex.
>
> There are other subtle differences in the implementation, e.g.
> you cannot mutex_trylock at interrupt time.

IMHO, mutexes (or semaphores, be it binary ones or counted)
are simply *not* the correct locking primitive to use from interrupt
context in the first place. down_trylock() did work from interrupt
contexts earlier (without producing any __might_sleep-induced
warnings either) but mutex_trylock() does not work, and rightly so.
Somebody using a down_trylock() from interrupt context is a
sure-shot sign of design error (or massive ugliness) in the driver
somewhere (which could, and should, be resolved in design).

To elaborate: what is the (only) valid way in which such code
(that attempts to down_trylock() or mutex_trylock() from interrupt
context) can be written?

*****
err = down_trylock(...);
if (err) {
	/*
	 * Either:
	 * 1. proceed although someone else owns the lock anyway => insane
	 * 2. too bad, so ignore this interrupt just this once => WTF?
	 * 3. set up a timer and schedule another function to service the
	 *    interrupt / do what needs to be done then, hopefully the mutex
	 *    would be uncontended then => *gargh*
	 */
}
/* do what needs to be done with the shared data to service this interrupt */
*****

Option 2 is nonsense. Option 3 (believe me, I've seen code like that) is even
more so :-) [ note that timers run in softirq-context, so illegal to use
mutex_lock() or down() there again, which means we'd *again* have to use
_trylock() variant there, with the same ugly error handling I described above. ]

Satyam
