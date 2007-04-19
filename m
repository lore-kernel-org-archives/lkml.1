Return-Path: <linux-kernel-owner+w=401wt.eu-S1031126AbXDSFJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031126AbXDSFJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 01:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031123AbXDSFJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 01:09:00 -0400
Received: from smtp1.osdl.org ([65.172.181.25]:43846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031126AbXDSFI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 01:08:59 -0400
Date: Wed, 18 Apr 2007 22:08:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: izumi <izumi2005@soft.fujitsu.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH][BUG] Fix possible NULL pointer access in 8250 serial
 driver
Message-Id: <20070418220812.b809c8fb.akpm@linux-foundation.org>
In-Reply-To: <4626D3D5.2060408@soft.fujitsu.com>
References: <46242DD2.7030207@soft.fujitsu.com>
	<20070416225206.cf7d8cd2.akpm@linux-foundation.org>
	<1176884513.3945.54.camel@kane-linux>
	<20070418191812.GA21211@flint.arm.linux.org.uk>
	<4626D3D5.2060408@soft.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 11:28:37 +0900 izumi <izumi2005@soft.fujitsu.com> wrote:

> Russell King wrote:
> 
> > NAK.  This means that you change the list of ports available on the
> > machine to be limited to only those which are currently open.  Utterly
> > useless for debugging, where you normally want people to dump the
> > contents of /proc/tty/driver/*.
> > 
> > The original patch was better.
> > 
> 
>    Is the original patch sufficient?  or is there anything we should 
> correct?
> 

Would it be better to do something like

--- a/drivers/serial/serial_core.c~a
+++ a/drivers/serial/serial_core.c
@@ -1686,9 +1686,12 @@ static int uart_line_info(char *buf, str
 		pm_state = state->pm_state;
 		if (pm_state)
 			uart_change_pm(state, 0);
-		spin_lock_irq(&port->lock);
-		status = port->ops->get_mctrl(port);
-		spin_unlock_irq(&port->lock);
+		status = 0;
+		if (port->info) {
+			spin_lock_irq(&port->lock);
+			status = port->ops->get_mctrl(port);
+			spin_unlock_irq(&port->lock);
+		}
 		if (pm_state)
 			uart_change_pm(state, pm_state);
 		mutex_unlock(&state->mutex);
_

so that a) we treat all uart types in the same way and b) the same problem
doesn't occur later with some other driver which is assuming an opened
device in its ->get_mctrl() handler?

