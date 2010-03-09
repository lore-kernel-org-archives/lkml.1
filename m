Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0CIQ7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:59:33 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:60192 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab0CIQ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:59:28 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between irq_finalize_oneshot and handle_level_irq
In-Reply-To: Your message of "Tue, 09 Mar 2010 08:58:11 +0100."
             <alpine.LFD.2.00.1003090855250.22855@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>
            <alpine.LFD.2.00.1003090855250.22855@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268153945_4540P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Mar 2010 11:59:05 -0500
Message-ID: <5309.1268153945@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4B967E5A.029B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268153945_4540P
Content-Type: text/plain; charset=us-ascii

On Tue, 09 Mar 2010 08:58:11 +0100, Thomas Gleixner said:
> On Tue, 9 Mar 2010, Lars-Peter Clausen wrote:
> 
> > If the kernel has been compiled with preemtion support and handle_level_irq is
> > called from process context for a oneshot irq there is a race between
> > irq_finalize_oneshot and handle_level_irq which results in the irq not being
> > unmasked after its handlers have been run.
> > 
> > irq_finalize_oneshot is expected to unmask the irq after the threaded irq
> > handler has been run. It only does so if IRQ_MASKED is set for the irqs status.
> > IRQ_MASKED gets set in the lower part of handle_level_irq after handle_IRQ_event
> > has been called.
> > handle_IRQ_event will wakeup the oneshot irqs threaded handler and if the
> > kernel has been build with preemption there is a chance that the threaded irq
> > handler will finish before execution is returned to handle_level_irq.
> > As a result irq_finalize_oneshot will not unmask the irq and handle_level_irq
> > will set the IRQ_MASKED flag. Thus the irq will stay masked and stalls.
> > 
> > In case of an race the call-graph would look like this:
> >  handle_level_irq
> >  |- mask_ack_irq
> >  |- handle_IRQ_event
> >     |- wake_up_process
> >        |- irq_thread
> >           |- action->thread_fn
> >           |- irq_finalize_oneshot # Does not unmask the irq
> > |- # Set IRQ_MASKED status flag
> 
> Errm, a thread _CANNOT_ preempt a hard interrupt handler.

What stops the thread from concurrently running on another CPU and racing
that way?  I'm an idiot, use small words. :)

--==_Exmh_1268153945_4540P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLln5ZcC3lWbTT17ARAnN9AJ9F4MHQ3I4iuJl3BpxKP1JWx8pzFgCg0W4Y
6Bs9U+ImWM8Dnk0Jwplrk7U=
=pWGc
-----END PGP SIGNATURE-----

--==_Exmh_1268153945_4540P--

