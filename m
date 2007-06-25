Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbXFYTwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbXFYTwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXFYTwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:52:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbXFYTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:52:17 -0400
Date: Mon, 25 Jun 2007 12:52:03 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070625125203.5719952c@freepuppy.localdomain.hemminger.net>
In-Reply-To: <467FF23B.30509@imap.cc>
References: <10876.1182698167@lwn.net>
	<467FF23B.30509@imap.cc>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 18:50:03 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> > so how about the following, different approach: anyone who has a tasklet 
> > in any performance-sensitive codepath, please yell now.


Getting rid of tasklet's may seem like a good idea. But doing it by changing
them all to workqueue's would have bad consequences for networking.

The first issue is that it would change the semantic assumptions in the
places where tasklets are used. Many places "know" that a tasklet runs in soft
irq context so extra locking is not needed.

The performance overhead of changing to workqueue's could also be disastrous for
some devices. There are 10G device drivers that use tasklets to handle transmit
completion.


Here is a more detailed list how network devices are using tasklet's

Receive packet handling: ifb, ppp, ipw2200, ipw2100
Receive buffer refill: acenic, s2io
Receive & Transmit: sc9031, sundance
Transmit buffer allocation: smc91x
Phy handling: skge

Sorry, if you are going to get rid of tasklets, you need to fix all the
network drivers first.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
