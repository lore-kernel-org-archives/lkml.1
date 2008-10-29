Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbYJ2IKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbYJ2IKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYJ2IKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:10:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55034 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYJ2IKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:10:33 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, ncunningham@crca.org.au,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <200810290059.38411.rjw@sisk.pl>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
References: <1224886068.6478.21.camel@nigel-laptop> <200810282321.59041.rjw@sisk.pl> <E1Kuxsg-0006PR-Tr@pomaz-ex.szeredi.hu> <200810290059.38411.rjw@sisk.pl>
Message-Id: <E1Kv688-0007Kp-SN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Oct 2008 09:10:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Rafael J. Wysocki wrote:
> On Wednesday, 29 of October 2008, Miklos Szeredi wrote:
> > On Tue, 28 Oct 2008, Rafael J. Wysocki wrote:
> > > On Tuesday, 28 of October 2008, Miklos Szeredi wrote:
> > > > I would prefer a freezer-less solution.  Suspend to ram doesn't need
> > > > the freezer,
> > > 
> > > Well, yes it does.  And it will in forseeable future, AFAICS.
> > 
> > Umm, OK.  Last I remember everybody agreed that there's absolutely no
> > reason why processes need to be frozen, and the only important thing
> > is that drivers are not twiddling the hardware during suspend, and
> > this can usually easily be solved on the subsystem level.
> 
> Well, this turned out not to be the case in the meantime.
> 
> In fact to handle that without the freezer we'd have to synchronize
> every driver's suspend/resume callbacks with every possible way in
> which applications can access the device for regular I/O (for
> example for PCI devices this means any I/O other than configuration
> space accesses).

Not all callbacks.  I don't know what the current model is but AFAIR
it should be something like this:

  1) call drivers to prepare for suspend (allocate space, etc)
  2) stop all driver activity (plug queues, disable interrupts, etc)
  3) call drivers to actually save state and power down
  4) suspend

The part we are concerned is stopping driver activity.  It could be
done with a mutex, or it could be done by freezing tasks.  Adding a
mutex or other mechanism is the one I most like, but it's probably the
biggest work, so lets look at how to fix the freezing:

Currently the criteria for freezing is that userspace task has to exit
kernelspace, and kernel task has to hit a specific "freeze point".
This causes problems where we want to freeze tasks which are "stuck"
inside filesystems or other non-driver parts of the kernel.  We can
fix this two ways:

  a) mark additional places to freeze for userspace tasks as
  well. This is the direction Nigel seems to be taking.

  b) or instead we could allow freezing anywhere in uninterruptible
  sleep, _except_ where explicity marked.

Which is easier?  I don't know.  But I very storgly feel that marking
un-freezable places instead of marking freezable places is a much
cleaner solution.  It only affects parts of the kernel which have
something to do with suspend, instead of affecting parts of the kernel
which have absolutely nothing to do with suspend.

Miklos
