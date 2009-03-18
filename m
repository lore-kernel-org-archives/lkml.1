Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZCRSbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZCRSbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZCRSb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:31:26 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:44757 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755816AbZCRSbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:31:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dKYBgkbFn5o0cwU64Fy72l6+TvT2cMdZlllNXXoRhrEOwN4uUw3V+TTnRC8fKpibYuhlslWHKWKuGtPde6glXw89qTE7VYWN/ba71mggA9R5MQWjx5Kz3drSFTfDcK0Mlxjrsij2C0xg9HNTD2hqruk9nv0E7PcYq4s/igJ3sJU=  ;
X-YMail-OSG: CSshIrgVM1mUP6vtwyqrusoyb4BzI6xsfLhAvHSpdmzmWlA5DMMXomlmX8s7xEjcDjY3OdoRh5ep7aLAzlfLHIiydWV05hgvakmbKihknMwYbc.8mRYmvDUH7mPqViuEfI8sg1MVL3eozGO513qK035Q
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [patch/rfc 1/2] GENIRQ: add handle_threaded_irq() flow handler
Date: Wed, 18 Mar 2009 11:31:22 -0700
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
       "sameo@openedhand.com" <sameo@openedhand.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903171919.48030.david-b@pacbell.net> <20090318120056.GG24947@scadufax.research.nokia.com>
In-Reply-To: <20090318120056.GG24947@scadufax.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903181131.22504.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, Felipe Balbi wrote:
> > +     action = desc->action;
> > +     if (unlikely(!action || (desc->status & IRQ_DISABLED)))
> > +             goto out_unlock;
> 
> you say below irqs are always enabled

Right here they're always disabled by spin_lock_irq().
The "below" follows spin_unlock_irq(), which re-enables
them to traverse that (locked) action list.


> so this branch is something we 
> never want to happen. How about adding a WARN() then ?

When some one says "irqs are enabled" they mean that,
local_irq_disable() or friends have not been called,
so for example a timer or other IRQ could arrive.

The IRQ_DISABLED flag in an IRQ descriptor means
something different:  "don't try *handling* this".

That particular check is used in *ALL* flow handlers.
It guards against things like races in disable_irq()
paths, which could allow an IRQ that was in flight
to arrive "after" the IRQ was disabled.

In the case of an IRQ enable/disable mask sitting
across an I2C bus boundary, it's particularly easy
to see how such a race might happen ... since both
the thread masking the IRQ, and the one handling it,
are subject to preemption and scheduling.
