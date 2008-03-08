Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYCHSQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYCHSQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYCHSQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:16:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYCHSQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:16:33 -0500
Subject: Re: [patch] revert "dcdbas: add DMI-based module autloading"
From: Kay Sievers <kay.sievers@vrfy.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frank Sorenson <frank@tuxrocks.com>, Matt_Domsch@dell.com,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080308082243.GA18123@elte.hu>
References: <47D02940.1030707@tuxrocks.com> <20080306184954.GA15492@elte.hu>
	 <47D1971A.7070500@tuxrocks.com> <47D23B7E.3020505@tuxrocks.com>
	 <20080308082243.GA18123@elte.hu>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 19:16:12 +0100
Message-Id: <1205000172.8748.4.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.91 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX184sguzLpPZlrLhkEsa9qpDroQIfDZlGUpzqsV
 I2VM4YqQvXBf7lTg6EGcdxUCpu0DmP/7Hw3LLVm7yhpq/n6u/Y
 mKOjE7XfU6OIFK6bcxRY4CG+84dkxeB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-08 at 09:22 +0100, Ingo Molnar wrote:
> * Frank Sorenson <frank@tuxrocks.com> wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Frank Sorenson wrote:
> > > I did some additional debugging, and I believe you're correct about it
> > > being specific to my system.  The system seems to run fine until some
> > > time during the boot.  I booted with "init=/bin/sh" (that's how the
> > > system stayed up for 9 minutes), then it died when I tried starting
> > > things up.  I've further narrowed the OOM down to udev (though it's not
> > > entirely udev's fault, since 2.6.24 runs fine).
> > > 
> > > I ran your debug info tool before killing the box by running
> > > /sbin/start_udev.  The output of the tool is at
> > > http://tuxrocks.com/tmp/cfs-debug-info-2008.03.06-14.11.24
> > > 
> > > Something is apparently happening between 2.6.24 and 2.6.25-rc[34] which
> > > causes udev (or something it calls) to behave very badly.
> > 
> > Found it.  The culprit is 8f47f0b688bba7642dac4e979896e4692177670b
> >     dcdbas: add DMI-based module autloading
> > 
> >     DMI autoload dcdbas on all Dell systems.
> > 
> >     This looks for BIOS Vendor or System Vendor == Dell, so this should
> >     work for systems both Dell-branded and those Dell builds but brands
> >     for others.  It causes udev to load the dcdbas module at startup,
> >     which is used by tools called by HAL for wireless control and
> >     backlight control, among other uses.
> > 
> > What actually happens is that when udev loads the dcdbas module at 
> > startup, modprobe apparently calls "modprobe dcdbas" itself, repeating 
> > until the system runs out of resources (in this case, it OOMs).
> 
> nice work! I've attached the revert below against latest -git - just in 
> case no-one can think of an obvious fix to this bug.

Frank, can you grep for 'dcdbas' in the modprobe config files:
  modprobe -c | grep dcdbas
?

I wonder what's going on here, that modprobe calls itself.

Thanks,
Kay

