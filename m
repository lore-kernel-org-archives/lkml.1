Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXAaQBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXAaQBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030210AbXAaQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:01:16 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:21947 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190AbXAaQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:01:15 -0500
Subject: Re: [PATCH 11/23] clocksource: atomic signals
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
In-Reply-To: <20070131110722.GA1847@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033806.468210824@mvista.com>  <20070131110722.GA1847@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 07:59:45 -0800
Message-Id: <1170259185.9781.66.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 12:07 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Modifies the way clocks are switched to in the timekeeping code. The 
> > original code would constantly monitor the clocksource list checking 
> > for newly added clocksources. I modified this by using atomic types to 
> > signal when a new clock is added. This allows the operation to be used 
> > only when it's needed.
> 
> I see little difference between your and John's code: both poll 
> something - you poll an atomic "did a new clocksource arrive" flag in 
> the timer interrupt, John takes the clocksource_lock spinlock and checks 
> a "did a new clocksource arrive" variable. Both are global atomic 
> variables in essence.

The original version has more operations on every timer interrupt. Also
changing the spinlock to an atomic eliminates the possibility of
contention in the timer interrupt ..

> what i'd see as a real cleanup here would be to get away from this 'poll 
> whether there's any clocksource update' model, and to just ensure that a 
> running timer irq will always see the latest clocksource. I.e. to run 
> the change_clocksource() logic (and the following updates) when a new 
> clock source is selected - not when the next timer interrupt runs. That 
> would propagate all effects of a new clock source immediately.

You could reduce the code in the interrupt handler (which is good), but
I think you'll end up with a polling model regardless.. If you add some
locking between the interrupt handler and something else you may as well
add the run time of that new critical section to the timer latency . So
I'm not sure it would be a outright win ..

Daniel

