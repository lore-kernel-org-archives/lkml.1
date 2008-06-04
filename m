Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbYFDWc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbYFDWc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbYFDWcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:32:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923AbYFDWcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:32:18 -0400
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
From: Jon Masters <jcm@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.55.0806042243080.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de>
	 <m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de>
	 <m1ve0pqy06.fsf@frodo.ebiederm.org>  <48467DA7.9030309@suse.de>
	 <1212605859.8410.22.camel@londonpacket.bos.redhat.com>
	 <Pine.LNX.4.55.0806042014110.28685@cliff.in.clinika.pl>
	 <1212609577.8410.32.camel@londonpacket.bos.redhat.com>
	 <Pine.LNX.4.55.0806042243080.28685@cliff.in.clinika.pl>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 18:27:42 -0400
Message-Id: <1212618462.8410.46.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-04 at 23:07 +0100, Maciej W. Rozycki wrote:
> On Wed, 4 Jun 2008, Jon Masters wrote:
> 
> > I disagree. I think it's now actually the *inverse*. It /used/ to be
> > harder, because you didn't have a context in which you could do many
> > things (so you need to schedule some kind of deferred work), but
> > actually, it'll become a lot more attractive with device threads.
> 
>  Well, I mean it's easier to do all the handling sequentially in the
> hardirq context than split the thing and deal with all the communication,
> locking, possible races, etc. so people avoid it unless really forced to.  
> In principle all the interrupt handlers could be split like this except
> those really, really tiny ones or where latency is absolutely critical.  
> Yet it often does not happen.

I'm really not proposing a return to top/bottom halves...

*). Top level handler is *tiny*. It's job is to get called (along with
every other such function registered for a particular IRQ line) and
determine if its device generated the interrupt, and to acknowledge,
preventing the device from asserting the IRQ line any longer.

The top part is called in hard IRQ context, even on RT.

*). Bottom level is automatically scheduled by the kernel in response to
the top part acknowledging that its device caused the interrupt.

The bottom part is run inside a dedicated kernel thread.

So pretty much everything is in the thread.

Jon.


