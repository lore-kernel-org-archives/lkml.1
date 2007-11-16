Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbXKPVDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbXKPVDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934512AbXKPVDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:03:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594AbXKPVDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:03:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Franck Bui-Huu" <vagabon.xyz@gmail.com>
Subject: Re: apm emulation driver broken ?
Date: Fri, 16 Nov 2007 22:20:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com> <200711161720.50313.rjw@sisk.pl> <cda58cb80711160929i4dbac6b7xb9d1bcc9223ddd7b@mail.gmail.com>
In-Reply-To: <cda58cb80711160929i4dbac6b7xb9d1bcc9223ddd7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711162220.56494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 16 of November 2007, Franck Bui-Huu wrote:
> On Nov 16, 2007 5:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > The freezer doesn't regard the current task as freezable.
> >
> 
> 
> Hmm, I don't get your point.
> 
> If I understood this driver correctly, several processes can be
> waiting for a suspend event by reading /dev/apm_bios, apmd (the _user_
> space daemon) can be one of them.
> 
> Then another process asks to suspend the system by calling 'apm -s',
> which results in a apm_ioctl() call. This process will basically
> execute:
> 
> 	err = queue_suspend_event(APM_USER_SUSPEND, as);
> 	flags = current->flags;
> 	wait_event_interruptible(apm_suspend_waitqueue,
> 			as->suspend_state == SUSPEND_DONE);
> 
> It's basically waiting for the waiters to ack the event. But it won't
> be the process that is going to suspend the system, right ?
> 
> So now all waiting processes are waken up and need to acknolwedge the
> event for the system to actually suspend. So they need to call
> apm_ioctl(). They'll basically do:
> 
> 	flags = current->flags;
> 	wait_event(apm_suspend_waitqueue,
> 			as->suspend_state == SUSPEND_DONE);
> 
> Except for the last acknowledging process which will do instead:
> 
> 	apm_suspend();
> 
> It's a call to pm_suspend().
> 
> So you can see that the process which initiates the suspend, the one
> that calls 'apm -s', is not the current process but is going to be
> waken up by the fake signal sent by freeze_task().
> 
> One of the consequence I can see is at this time 'as->result' won't be
> setup, so the return value of apm_ioctl() may be wrong.

Ah, that.  Yes, I see your point.

However, using PF_NOFREEZE to prevent this from happening doesn't seem to be
a good idea.

I'd probably use wait_event_freezable() (defined in include/linux/freezer.h)
for that.

> As I said, I'm not familiar with this code, so please correct me if
> I'm wrong.

No, you're not wrong and I have overlooked the problem.

> BTW, how does try_to_freeze_tasks() deal with user land thread waiting
> in the UNINTERRUPTIBLE state ?

It tries to send them fake signals and waits for them to freeze.  If they don't
freeze within the timeout, it fails and clears their TIF_FREEZE bits.

Greetings,
Rafael
