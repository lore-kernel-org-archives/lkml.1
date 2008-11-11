Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYKKOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYKKOwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYKKOwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:52:04 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:40880 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbYKKOwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s6UOwblJytHIX8Vw2zw04TVuiDcsTnViGWmy6ZxYbXioR7HJjIpZpxRzTCQjED60MA
         2t+VImrPYaP0E9uvyM0/dZmZDXK7jmvhLvZLwE6rcZ0W3cGjwv0HfceFb6fXHKpkeIJH
         Id22Vi6rRI47szjPMQyE4EVCypFCVxXvUAwEE=
Date: Tue, 11 Nov 2008 09:51:56 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] atkbd: cancel delayed work before freeing its structure
Message-ID: <20081111145155.GA24881@anvil.corenet.prv>
References: <20081105153140.25132ca1@psychotron.englab.brq.redhat.com> <20081107154325.GD9368@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107154325.GD9368@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 04:43:25PM +0100, Oleg Nesterov wrote:
> On 11/05, Jiri Pirko wrote:
> >
> > diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> > index 22016ca..f3bbf49 100644
> > --- a/drivers/input/keyboard/atkbd.c
> > +++ b/drivers/input/keyboard/atkbd.c
> > @@ -824,7 +824,7 @@ static void atkbd_disconnect(struct serio *serio)
> >  	atkbd_disable(atkbd);
> >
> >  	/* make sure we don't have a command in flight */
> > -	flush_scheduled_work();
> > +	cancel_delayed_work_sync(&atkbd->event_work);
> 
> Ping. Dmitry, could you take a look?
> 

Applied, thank you.

> 
> While we are here, what is the reason for atkbd_schedule_event_work()->wmb() ?
> It looks absolutely bogus. Is it for atkbd_event_work() ? In that case it
> is not needed, it must see all previous STOREs because both queue_work() and
> run_workqueue() take cwq->lock. And in any case,
> test_and_set_bit(WORK_STRUCT_PENDING) implies mb().

I wanted to be sure that event_mask is set before we schedule event_work
and I don't want to rely on details of queue_delayed_work
implementation. If the fact that queue_delayed_work acts as a barrier
would be listed part of its published spec I would gladly remove wmb()
from atkbd.

> If schedule_delayed_work()
> fails we can race with the soon-to-be-executed atkbd_event_work(), in that
> case that test_and_set_bit() + test_and_clear_bit(->event_mask) save us,
> but wmb() can't help again.
> 
> Another question is why do we need ->event_mutex? OK, it can serialize
> multiple instances of atkbd_event_work() running on the different CPUs,
> but in that case atkbd_reconnect() needs this lock too? It also calls
> atkbd_set_repeat_rate/atkbd_set_leds.

Probably, I will need to thiknk about it a bit more.

-- 
Dmitry
