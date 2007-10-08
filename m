Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbXJHOZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbXJHOZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 10:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXJHOZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 10:25:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59174 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbXJHOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:25:03 -0400
Subject: Re: [PATCH 0/2] [RFC] RT: Optionally allow IRQF_NODELAY on serial
	console
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0710081005320.4846@gandalf.stny.rr.com>
References: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
	 <alpine.LRH.0.999.0710051831000.10191@www.tglx.de>
	 <Pine.LNX.4.58.0710081005320.4846@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 10:22:41 -0400
Message-Id: <1191853361.4281.5.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-08 at 10:10 -0400, Steven Rostedt wrote:

> This issue has hit me enough times where I've played with a few other
> ideas. I just haven't had the time to finish them. The main problem is if
> the system locks up somewhere we have a lock held that keeps us from
> scheduling. Once that happens in -rt, we are as good as dead. Since you
> can't get much info out without a JTAG or some other mechanism.
> 
> One thought I had was to create a small handler that could read the serial
> and place data into a buffer. This handler would be a IRQ_NODELAY, and it
> would wake up a serial thread to handle the data just like it would for
> normal serial output. But the serial thread would just read from the
> buffer instead of the serial itself.  In the case of a sysrq key coming
> in, the IRQ_NODELAY handler would handle it.
> 

Hi Steve,
  What you describe is exactly what I did.  The IRQF_NODELAY handler
just minimally checks to see if the character is a sysrq related one (or
KDB, if you have the KDB patches applied).  If it is not, it puts the
character into a ring-buffer and wakes a (kthread-based) tasklet to do
the normal serial/tty rx path by processing the ring.

Hope that helps to clarify.

Regards,
-Greg



