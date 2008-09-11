Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYIKPWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYIKPWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYIKPW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:22:28 -0400
Received: from vena.lwn.net ([206.168.112.25]:46765 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYIKPW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:22:28 -0400
Date: Thu, 11 Sep 2008 09:22:26 -0600
From: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 09/18] lirc driver for the Streamzap PC Receiver
Message-ID: <20080911092226.2605a96a@bike.lwn.net>
In-Reply-To: <1220933164-10160-10-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
	<1220933164-10160-3-git-send-email-jwilson@redhat.com>
	<1220933164-10160-4-git-send-email-jwilson@redhat.com>
	<1220933164-10160-5-git-send-email-jwilson@redhat.com>
	<1220933164-10160-6-git-send-email-jwilson@redhat.com>
	<1220933164-10160-7-git-send-email-jwilson@redhat.com>
	<1220933164-10160-8-git-send-email-jwilson@redhat.com>
	<1220933164-10160-9-git-send-email-jwilson@redhat.com>
	<1220933164-10160-10-git-send-email-jwilson@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yes, you said I shouldn't do more reviews of the posted code, but the
following was already pretty much written.  I really only found one thing
in this driver, and I suspect it may not have been addressed yet.  

This was set to be the last anyway, I'm pretty much out of time for now.]

jon

I'm curious about the following function:

> +static void stop_timer(struct usb_streamzap *sz)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sz->timer_lock, flags);
> +	if (sz->timer_running) {

What happens if the timer fires right here?  

> +		sz->timer_running = 0;
> +		del_timer_sync(&sz->delay_timer);
> +	}
> +	spin_unlock_irqrestore(&sz->timer_lock, flags);
> +}

The timer acquires the lock too, so this looks a bit like a deadlock to
me.  Probably del_timer_sync() should be called without the lock?
