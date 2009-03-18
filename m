Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbZCRSvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbZCRSvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZCRSuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:50:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:40178 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbZCRSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:50:49 -0400
Date: Wed, 18 Mar 2009 20:32:19 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
       "sameo@openedhand.com" <sameo@openedhand.com>
Subject: Re: [patch/rfc 1/2] GENIRQ: add handle_threaded_irq() flow handler
Message-ID: <20090318183219.GA20105@scadufax.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903171919.48030.david-b@pacbell.net> <20090318120056.GG24947@scadufax.research.nokia.com> <200903181131.22504.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903181131.22504.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 Mar 2009 18:49:15.0294 (UTC) FILETIME=[3C59A3E0:01C9A7FA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 07:31:22PM +0100, David Brownell wrote:
> On Wednesday 18 March 2009, Felipe Balbi wrote:
> > > +     action = desc->action;
> > > +     if (unlikely(!action || (desc->status & IRQ_DISABLED)))
> > > +             goto out_unlock;
> > 
> > you say below irqs are always enabled
> 
> Right here they're always disabled by spin_lock_irq().
> The "below" follows spin_unlock_irq(), which re-enables
> them to traverse that (locked) action list.
> 
> 
> > so this branch is something we 
> > never want to happen. How about adding a WARN() then ?
> 
> When some one says "irqs are enabled" they mean that,
> local_irq_disable() or friends have not been called,
> so for example a timer or other IRQ could arrive.
> 
> The IRQ_DISABLED flag in an IRQ descriptor means
> something different:  "don't try *handling* this".
> 
> That particular check is used in *ALL* flow handlers.
> It guards against things like races in disable_irq()
> paths, which could allow an IRQ that was in flight
> to arrive "after" the IRQ was disabled.
> 
> In the case of an IRQ enable/disable mask sitting
> across an I2C bus boundary, it's particularly easy
> to see how such a race might happen ... since both
> the thread masking the IRQ, and the one handling it,
> are subject to preemption and scheduling.

aha, I see. Thanks for the explanation ;-)

-- 
balbi
