Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbZJVQn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbZJVQn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZJVQn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:43:27 -0400
Received: from mail-yx0-f153.google.com ([209.85.210.153]:64490 "EHLO
	mail-yx0-f153.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZJVQn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:43:26 -0400
X-Greylist: delayed 728 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2009 12:43:26 EDT
MIME-Version: 1.0
Date: Thu, 22 Oct 2009 09:31:52 -0700 (PDT)
In-Reply-To: <cc845bea-0a4c-4958-b317-6b95120031a3@w37g2000prg.googlegroups.com>
X-IP: 64.126.182.14
References: <cc845bea-0a4c-4958-b317-6b95120031a3@w37g2000prg.googlegroups.com>
User-Agent: G2/1.0
X-HTTP-Via: 1.1 webwasher (Webwasher 6.8.5.5330)
X-HTTP-UserAgent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.3) 
	Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729),gzip(gfe),gzip(gfe)
Message-ID: <fa2adfc3-986a-4db4-ad31-2613c478c097@g1g2000pra.googlegroups.com>
Subject: Ordering problem in serial_core.c
From: Eugene Bordenkircher <eugebo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




---------- Forwarded message ----------
From: Eugene Bordenkircher <eug...@gmail.com>
Date: Oct 22, 9:19 am
Subject: Ordering problem in serial_core.c
To: fa.linux.kernel


There is an ordering problem with closing a UART in the serial core.
If the line discipline is throttling the port when close is called, it
tries to unthrottle the port which, in the case of soft flow, tries to
send the XON character.  This doesn't work well since at this point
the uart has been shutdown.

The simple reordering shown below will seems to fix the problem, but
please comment if there are other side effects I am not seeing.

Eugene T. Bordenkircher

--- linux_kernel/drivers/serial/serial_core.c.orig      2009-08-13
14:58:04.000000000 -0700
+++ linux_kernel/drivers/serial/serial_core.c   2009-08-13
15:29:02.000000000 -0700
@@ -1317,11 +1317,11 @@
                uart_wait_until_sent(tty, port->timeout);
        }

+       tty_ldisc_flush(tty);
+
        uart_shutdown(state);
        uart_flush_buffer(tty);

-       tty_ldisc_flush(tty);
-
        tty->closing = 0;
        state->info.port.tty = NULL;
