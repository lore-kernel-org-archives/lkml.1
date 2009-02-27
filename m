Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbZB0XTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbZB0XTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZB0XTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:19:05 -0500
Received: from n16a.bullet.mail.mud.yahoo.com ([68.142.207.126]:35629 "HELO
	n16a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754004AbZB0XTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:19:04 -0500
X-Greylist: delayed 83307 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Feb 2009 18:19:03 EST
X-Yahoo-Newman-Id: 361514.57687.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pO3ffI7gY+L0vFN8avWkr5pz4jGH/l3WoxR5UtE6tP3mrpq0UqNux0RkVYq4dP8hBv45Vgu7sKbPVx/m8Df7iasgbvxE+I4TqQt8flQLTvXpjwy9gZ+zU0NPbuzLT0+qPlRIbJl9lmWwmpzUfS7xT+cwfal3fUFGNW8YI+HDUOs=  ;
X-YMail-OSG: AMi3MgUVM1nlFSSHOSt2MkZB47k16rMyTYUL5O1nMGh0bs67lvJBSFumYDVkuR8c1TbFAsgn0xVt_8UEAdRaK3Q4aOXQMhIc5HW8panJkS.xiDSxOZGj5tLa3dlQd1sJ1tb41gjchRcg92LvSfKgMshz
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Fri, 27 Feb 2009 15:18:57 -0800
User-Agent: KMail/1.9.10
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902271350.32380.david-b@pacbell.net> <20090227140907.f159be9b.akpm@linux-foundation.org>
In-Reply-To: <20090227140907.f159be9b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902271518.58246.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Andrew Morton wrote:
> 
> > There are actually two issues.  The lockdep issue is
> > one ... the above #ifdef suffices to work around it
> > for all the TWL4030 (family) IRQs.

(And other similar cases, of course, including those
MMC cases that crap out in the ARM memory management
code when lockdep wrongly disables IRQs.)


> > The other is that Linux needs real support for threaded
> > interrupts.  Almost every I2C (or SPI) device that raises
> > an IRQ needs its IRQ handler to run in a thread, and most
> > of them have the same type of workqueue-based hack to
> > get such a thread.  (Some others have bugs instead...)
> > 
> > Obviously, if any threaded IRQ handler grabs a mutex,
> > but lockdep has disabled IRQs, trouble ensues...
> 
> What's going on here?  hardirq handlers cannot take mutexes and cannot
> sleep, period.  

But these handlers are *NOT* running in hardirq context;
so such thought doesn't apply.  The hardirq bit of the
IRQ-handling activity completed quite a bit earlier.

Being able to sleep and grab mutexes is one of the main
reasons for wanting threaded IRQ handlers.  For common
(embedded) I2C hardware, if threaded IRQ handlers can't
sleep they're completely useless.

And something that may eventually matter for mainline:
in RT contexts, thread priority applies to mutex grabbing,
and helps manage priority inversion.  That's equivalent
to sleeping.

This stuff just pokes at some annoying current gaps in the
IRQ framework.  I'll be glad when eventually there's no
need to work around those weaknesses ... that is, when
real threaded IRQ support is available.


> Enabling local interrupts might shut up some warning, 
> but won't fix the deadlocks which that warning is there to warn us
> about.

Wrong; all such warnings are false, in these cases.

- Dave

