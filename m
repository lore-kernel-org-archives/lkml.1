Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZGLU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZGLU4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZGLUzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:55:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38675
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbZGLUzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:55:51 -0400
Date: Sun, 12 Jul 2009 13:55:55 -0700 (PDT)
Message-Id: <20090712.135555.207096388.davem@davemloft.net>
To: tglx@linutronix.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
       peterz@infradead.org
Subject: Re: [patch 1/3] net: serialize hrtimer callback in sched_cbq
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090709215606.526259917@linutronix.de>
References: <20090709215455.703939259@linutronix.de>
	<20090709215606.526259917@linutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 09 Jul 2009 21:59:22 -0000

> The hrtimer callback cbq_undelay() is not serialized against
> cbq_ovl_delay(). That affects at least q->pmask and q->delay_timer.
> 
> Lock it proper.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

The problems here are even much deeper than it appears.

First of all, I am to understand that hrtimers run from hardware
interrupt context, right?  If so, all of these datastructures are
softirq safe only.

And it is not merely the immediate things you see being modified in
this hrtimer, such as ->pmask etc., it is also the q->active[]
pointers, the list state for the classes, just about everything in the
qdisc state is referenced in this hrtimer code path.

I wonder how many queer unexplainable bugs we see because of this.

What should probably happen is that the hrtimer merely fires off work
at software interrupt context (perhaps a tasklet or similar), and that
software interrupt code take the qdisc's root lock throughout it's
execution.
