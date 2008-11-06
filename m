Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYKFJUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYKFJUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYKFJUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:20:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYKFJUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:20:02 -0500
Date: Thu, 6 Nov 2008 10:19:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081106091929.GF4890@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu> <1225805399.25337.1282903253@webmail.messagingengine.com> <20081104140030.GA16178@elte.hu> <1225815789.30706.1282936457@webmail.messagingengine.com> <20081104164717.GD21470@localhost> <20081104165811.GA1664@elte.hu> <20081104171346.GF21470@localhost> <1225819765.13069.1282952549@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225819765.13069.1282952549@webmail.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> > | > | Opteron    (cycles): 1024 / 1157 / 3527
> > | > | Xeon E5345 (cycles): 1092 / 1085 / 6622
> > | > | Athlon XP  (cycles): 1028 / 1166 / 5192
> > | > 
> > | > Xeon is defenitely out of luck :-)
> > | 
> > | it's still OK - i.e. no outrageous showstopper overhead anywhere in 
> > | that instruction sequence. The total round-trip overhead is what will 
> > | matter most.
> > | 
> > | 	Ingo
> > | 
> > 
> > Don't get me wrong please, I really like what Alexander have done!
> > But frankly six time slower is a bit scarying me.

the cost is 6 cycles instead of 1 cycles. In a codepath that takes 
thousands of cycles and is often cache-limited.

> Thanks again ;). Now it _is_ six times slower to do this tiny piece 
> of code... But please keep in mind all the activity that follows to 
> save the current data segment registers (the stack segment and code 
> segment are saved automatically), the general purpose registers and 
> to load most of the data segments with kernel-space values. And 
> looking at it now... do_IRQ is also not exactly trivial.
> 
> Also, I kept the information that is saved on the stack exactly the 
> same. If this is not a requirement, "push %cs" is what is left of 
> this expensive (6 cycle!) sequence. Even that could be unnecessary 
> if the stack layout can be changed... But I'ld like to consider that 
> separately.

we really want to keep the stack frame consistent between all the 
context types. We can do things like return-to-userspace-from-irq or 
schedule-from-irq-initiated-event, etc. - so crossing between these 
context frames has to be standard and straightforward.

	Ingo
