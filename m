Return-Path: <linux-kernel-owner+w=401wt.eu-S1764308AbXEXEWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764308AbXEXEWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762005AbXEXEVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:21:49 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:48685 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761737AbXEXEVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FVz9z9n+d3DnReK6fKk5RxbZoN7tT83kwUU0E2txQJF1mTo6iKOX+G0eam4QR8Z/D8GakZugRnAiHYuXpWN4CowvaS35TZTx5BWOvQX6+EJFx6kq4/KpgqAtKeLwoNJoYXwg7sG9yCJ0U575VHUvqowWrMq/kpboSrdKuKk+jN0=
Message-ID: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
Date: Thu, 24 May 2007 00:21:47 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: how to allow board writers to customize driver behavior (watchdog here)
Cc: "Bryan Wu" <Bryan.Wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the Blackfin on-chip watchdog has controllable behavior ... it can be
configured to reset the processor (like a normal watchdog), or it can
be configured to simply generate an interrupt.

i can see embedded systems where simply resetting the system is not
desirable ... perhaps it's the control system for some machinery and
resetting the system will force it to reinitialize itself which could
cause problems if a guy is servicing the insides at the time ;)

the Blackfin watchdog driver has a module parameter, "action" ... the
default will have the watchdog act like every other watchdog out there
-- it reboots after a timeout.  however, by setting the action param
appropriately, the watchdog goes into simple interrupt generation.
the question then becomes, how do people developing their
board-specific version customize what happens when the timeout occurs
and the interrupt is fired ?  making every customer who wishes to
customize the watchdog behavior edit the watchdog driver is
troublesome as they're now blurring the distinct parts: the
watchdog-specific piece and their board-specific piece.

what i'm doing now is weak symbols:
...
extern irqreturn_t bfin_board_watchdog_interrupt(void) __attribute__((weak));
static irqreturn_t bfin_wdt_interrupt(int irq, void *dev_id)
{
    if (bfin_board_watchdog_interrupt) {
        return bfin_board_watchdog_interrupt();
    } else {
        bfin_wdt_stop();
        bfin_wdt_keepalive();
        bfin_wdt_start();
        return IRQ_HANDLED;
    }
}
...

is this completely bad mojo ?  is there some other mechanism that
provides what i want and i just dont know about it ?  or do i just
make people change the driver to fit their application, thus throwing
out the idea of keeping all board-specific details in just the boards
file ...
-mike
