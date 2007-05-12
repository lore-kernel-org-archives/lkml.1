Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXELWEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXELWEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 18:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXELWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 18:04:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36426 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXELWE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 18:04:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFD] Freezing of kernel threads
Date: Sun, 13 May 2007 00:08:59 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200705122017.32792.rjw@sisk.pl> <20070512191709.GA428@elf.ucw.cz>
In-Reply-To: <20070512191709.GA428@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705130009.00439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 12 May 2007 21:17, Pavel Machek wrote:
> Hi!
> 
> > Having considered the issue of freezing (or not freezing) kernel threads for a
> > longer while I tend to agree with Linus that we shouldn't be freezing as many
> > kernel threads as we currently freeze, but there's one thing that he doesn't
> > seem to take into account.  Namely, there may be some kernel threads that
> > actually *want* (or need) to be frozen. :-)
> > 
> > For the suspend they may be kernel threads that otherwise would need some
> > special synchronization with some device drivers' .suspend() and .resume()
> > callbacks or fs-related kernel threads.  For the CPU hotplug they might be
> > kernel threads that otherwise would interfere with the removal or addition of
> > CPUs.  Still, in each case there seems to be a limited group of kernel threads
> > that may want to be frozen and the remaining kernel threads that shouldn't be
> > involved in any freezer-related actions at all.  However, we currently require
> > all kernel threads to take part in the freezing mechanism, which doesn't seem to
> > be correct.
> 
> Well.. It is actually a feature.
> 
> These days, you have to either add PF_NOFREEZE explicitly (which
> hopefully means you know what you are doing) or add try_to_freeze() at
> specific place.
> 
> If you fail to do that, we'll see freezer failure, quickly, and catch
> the simple bug.

Well, not if PF_NOFREEZE is used.
 
> I'm afraid that if we default to "do not freeze by default", someone
> will just port zfs, will know nothing about suspend, and his 
> "write management info somewhere periodically" thread will corrupt
> people's disks.

We'll have exactly the same result right now if said developer uses
PF_NOFREEZE.
 
> OTOH... perhaps suspend/resume is common enough operation that people
> _know_ they need to stop their writing? ...no, I do not think we are
> there yet.

We never will be there if we don't change the default.

Besides, if a kernel thread calls I_want_to_be_frozen_during_suspend() and
then try_to_freeze(), this seems to be a bit more meaningful than just calling
try_to_freeze() which (almost) everybody does.

Greetings,
Rafael
