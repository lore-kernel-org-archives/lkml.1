Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYKXRCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYKXRCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYKXRCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:02:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51994 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbYKXRCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:02:41 -0500
Date: Mon, 24 Nov 2008 15:02:02 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org, Jan Kiszka <jan.kiszka@web.de>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: hrtimer_forward() semantics when using non-high-res timers
Message-ID: <20081124170202.GD16862@blackpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121170642.GH30825@blackpad>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas,

I've been looking at a timer problem on KVM recently[1] and I've got a
question about the expected semantics of hrtimer_forward().

The problem I am looking at is related to having proper accouting of
missed ticks on the KVM timer code when it the host has lost timer
ticks because of high CPU load, or because it doesn't have hrtimers
enabled. hrtimer_forward_now() overrun accounting looked perfect for
the task of checking how many ticks we have lost.

However hrtimer_forward() limits the interval parameter to the timer
resolution, making it useless for calculating how many timer periods we've
lost because of too-low timer resolution. I am even a bit surprised no
other code needs a hrtimer_forward-like function for that, yet.

For example: if we want to account for a tick every 1 ms and the host
has HZ=250 and no high-resolution timers, calling hrtimer_forward_now()
on every timer tick will normally return 1 because it will count how
many 4 ms periods were added to the timer expiration time. However,
I would like to calculate how many 1 ms periods I've lost, no matter
what the real timer resolution is.

I could do my own missed-ticks calculation, but the hrtimer_forward()
logic would be perfect for my needs if it didn't have the resolution check
code, and I don't feel like duplicating part of hrtimer_forward(). Do you
think it would make sense to have on the timers API a hrtimer_forward-like
function that doesn't have the interval lower-limit?


[1] http://marc.info/?l=kvm&m=122728725028262&w=2

-- 
Eduardo
