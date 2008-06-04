Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbYFDUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbYFDUET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYFDUEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:04:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbYFDUEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:04:09 -0400
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
From: Jon Masters <jcm@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.55.0806042014110.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de>
	 <m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de>
	 <m1ve0pqy06.fsf@frodo.ebiederm.org>  <48467DA7.9030309@suse.de>
	 <1212605859.8410.22.camel@londonpacket.bos.redhat.com>
	 <Pine.LNX.4.55.0806042014110.28685@cliff.in.clinika.pl>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 15:59:37 -0400
Message-Id: <1212609577.8410.32.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-04 at 20:19 +0100, Maciej W. Rozycki wrote:
> On Wed, 4 Jun 2008, Jon Masters wrote:
> 
> > Meanwhile, I think this really shows that a couple of us who've been
> > meaning to poke at per-device IRQs should do so once again. This is the
> > real solution - kill off all those per-IRQ threads, have one per device
> > and split each IRQ into a "top" and "bottom" (just kidding on the names)
> > half. Have the first part be *incredibly* small and just return if the
> > device actually was responsible for the IRQ (and quiesse it), and have
> > the second part do the heavyweight handling. Since the second part can
> > run as a thread (and actually sleep for however long, because it's now
> > per device) - and since we have threaded tasklets and all this on RT
> > anyway - we can just kill off most of the extra logic in many Linux
> > interrupt handlers and have just the interrupt thread do the work. 
> 
>  This is how a lot of our drivers used to work in the old days -- modulo
> implementation details.  It is still a good idea, but it requires more
> care and effort to implement, so people tend to avoid it unless forced by
> the design of hardware involved (cf. phylib in the interrupt mode).

I disagree. I think it's now actually the *inverse*. It /used/ to be
harder, because you didn't have a context in which you could do many
things (so you need to schedule some kind of deferred work), but
actually, it'll become a lot more attractive with device threads.

The only real caveat is for performance critical cases (the reasons we
have special softirqs and the like right now) but there will always be
special cases. Still, I'd like it if writing a Linux interrupt handler
came down to registering two functions - one lightweight tiny one, and
one that's just a thread. Much less room for making mistakes.

Jon.


