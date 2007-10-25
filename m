Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbXJYRCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbXJYRCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXJYRCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:02:14 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1053 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751588AbXJYRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:02:13 -0400
Date: Thu, 25 Oct 2007 13:02:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: linux-kernel@vger.kernel.org, <netdev@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] QUESTION: How to fix race between .suspend routine
 and watchdog timer
In-Reply-To: <200710250612.44296.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0710251259230.7029-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Maxim Levitsky wrote:

> Hi,
> 
> Recently, trying to fix saa7134 suspend/resume problems I found that there 
> is a race between IRQ handler and .suspend , and that I cant let driver access the device
> while its in D3 since it can lock up some systems.
> 
> Now I am looking to fix those issues in two drivers that have my .suspend/.resume routines.
> the saa7134 capture chip and dmfe, the davicom network driver.
> 
> Looking through the dmfe code, I noticed yet another possible race.
> A race between the .suspend, and a timer that serves both as a watchdog, and link state detector.
> Again I need to prevent it from running during the suspend/resume, but how?
> 
> I can use del_timer in .suspend, and mod_timer in .resume, but that doesn't protect against
> race with already running timer.
> I can use del_timer_sync, but it states that it is useless if timer re-enables itself, and I agree with that.
> In dmfe case the timer does re-enable itself.

That comment isn't right.  del_timer_sync works perfectly well even if
the timer routine re-enables itself, provided it stops doing so after a
small number of iterations.

> I can put checks in the timer for ->insuspend, and don't re enable it if set,
> but that opens a new can of worms with memory barriers, etc...

You don't have to worry about any of that stuff.  Just check the 
insuspend flag and don't re-enable the timer if it is set.  Even 
without any memory barriers, the timer routine won't iterate more than 
once or twice.

Alan Stern

