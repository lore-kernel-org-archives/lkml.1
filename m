Return-Path: <linux-kernel-owner+w=401wt.eu-S1030410AbXBZS2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030410AbXBZS2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030393AbXBZS2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:28:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32920 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030408AbXBZS2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:28:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Subject: Re: [RFC][PATCH 3/3] Freezer: Prevent ___call_usermodehelper from missing freezing requests
Date: Mon, 26 Feb 2007 19:30:55 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Pavel Machek" <pavel@ucw.cz>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl> <200702261152.18379.rjw@sisk.pl> <cc723f590702260358u7b9da770v42964d534182ee4d@mail.gmail.com>
In-Reply-To: <cc723f590702260358u7b9da770v42964d534182ee4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261930.56550.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 February 2007 12:58, Aneesh Kumar wrote:
> On 2/26/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > NOTE: Alternatively, we can just drop flush_signals() from there, but I'm not
> > sure that's the right thing to do.
> >
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Since ____call_usermodehelper() calls flush_signals(current), the task that
> > enters it may miss a freezing request.  However, if ____call_usermodehelper()
> > clears TIF_FREEZE for the current task after flush_signals(current) returns, the
> > freezer will generate one more freezing request for this task.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  kernel/kmod.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > Index: linux-2.6.20-mm2/kernel/kmod.c
> > ===================================================================
> > --- linux-2.6.20-mm2.orig/kernel/kmod.c 2007-02-25 12:07:15.000000000 +0100
> > +++ linux-2.6.20-mm2/kernel/kmod.c      2007-02-25 12:49:16.000000000 +0100
> > @@ -34,6 +34,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/init.h>
> >  #include <linux/resource.h>
> > +#include <linux/freezer.h>
> >  #include <asm/uaccess.h>
> >
> >  extern int delete_module(const char *name, unsigned int flags);
> > @@ -258,6 +259,7 @@ static int ____call_usermodehelper(void
> >         new_session = key_get(sub_info->ring);
> >         flush_signals(current);
> >         spin_lock_irq(&current->sighand->siglock);
> > +       do_not_freeze(current);
> >         old_session = __install_session_keyring(current, new_session);
> >         flush_signal_handlers(current, 1);
> >         sigemptyset(&current->blocked);
> >
> 
> 
> this need a comment . Otherwise one reading will read it as we don't
> want it to freeze.
> 
> How about
> /*
> clears TIF_FREEZE for the current task after flush_signals(current)
> returns, so that the
> freezer will generate one more freezing request for this task.
> 
> */

Looks reasonable, but Oleg wants to drop the flush_signals(current) ...

Rafael
