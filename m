Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXEFIhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXEFIhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 04:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbXEFIhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 04:37:00 -0400
Received: from 1wt.eu ([62.212.114.60]:2511 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbXEFIg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 04:36:59 -0400
Date: Sun, 6 May 2007 10:36:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Esben Nielsen <nielsen.esben@googlemail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070506083600.GA16043@1wt.eu>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire> <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org> <20070506082911.GA32644@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506082911.GA32644@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, May 06, 2007 at 10:29:11AM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > So the _only_ valid way to handle timers is to
> >  - either not allow wrapping at all (in which case "unsigned" is better, 
> >    since it is bigger)
> >  - or use wrapping explicitly, and use unsigned arithmetic (which is 
> >    well-defined in C) and do something like "(long)(a-b) > 0".
> 
> hm, there is a corner-case in CFS where a fix like this is necessary.
> 
> CFS uses 64-bit values for almost everything, and the majority of values 
> are of 'relative' nature with no danger of overflow. (They are signed 
> because they are relative values that center around zero and can be 
> negative or positive.)

(...)

> -		if (key < entry->fair_key) {
> +		if ((s64)(entry->fair_key - key) > 0) {

Just a hint: while your code here is correct, it is a good practise to
check against < 0 instead, so that if for any reason you sometimes forget
to cast to signed, the compiler will emit a warning stating that the
condition is always false. This would simply become :

-		if (key < entry->fair_key) {
+		if ((s64)(key - entry->fair_key) < 0) {

Just my .02 euros :-)
Willy

