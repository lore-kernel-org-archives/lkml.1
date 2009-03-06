Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZCFGlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZCFGlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZCFGk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:40:56 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33492 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZCFGky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:54 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883645"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 02/18] Blackfin Serial Driver: use barrier instead of cpu_relax for Blackfin SMP like patch
Date: Fri,  6 Mar 2009 14:42:44 +0800
Message-Id: <1236321780-28718-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
data cache flush function which will count it to a per-cpu counter.
If this serial function is called too early, the per-cpu data area have
not been initialized, this call will cause crash.
So we'd like to use barrier() instead of cpu_relax().

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 52ccc27..350bfc4 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1129,7 +1129,8 @@ static __init void early_serial_putc(struct uart_port *port, int ch)
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 
 	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
-		cpu_relax();
+		barrier();
+
 	UART_PUT_CHAR(uart, ch);
 }
 
-- 
1.5.6.3
