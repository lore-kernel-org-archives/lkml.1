Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbYGKTcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbYGKTcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYGKTcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:32:08 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45599 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYGKTcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:32:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-serial@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Fri, 11 Jul 2008 12:30:42 -0700
Message-ID: <m1wsjsdxr1.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0113]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] serial8250: Sanity check nr_uarts on all paths.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I had 8250.nr_uarts=16 in the boot line of a test kernel and I had a
weird mysterious crash in sysfs.  After an taking in depth look I realized
that CONFIG_SERIAL_8250_NR_UARTS was set to 4 and I was walking off
the end of the serial8250_ports array.

Ouch!!!

Don't let this happen to someone else.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/serial/8250.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 1bc00b7..be95e55 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2623,6 +2623,9 @@ static struct console serial8250_console = {
 
 static int __init serial8250_console_init(void)
 {
+	if (nr_uarts > UART_NR)
+		nr_uarts = UART_NR;
+
 	serial8250_isa_init_ports();
 	register_console(&serial8250_console);
 	return 0;
-- 
1.5.3.rc6.17.g1911

