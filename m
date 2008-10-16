Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbYJPRpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbYJPRpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYJPRoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:44:20 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:20082 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892AbYJPRoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=S7ZYV9QCgPOGRdczTd+QMh9VF2PblIYf7K2KT/oj2919k1al1uOQf5lJe7VPxEiiGU
         BjHghQ2ktG/pmWIWr0AwJEITSkkG4Z613VVywf718B9cAcnmQFJB38YRLc9sxESlL7HS
         W2iRxF8wBEaLhJ0/CsDW3S7kFPrnJlrQFa5uk=
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/9] Blackfin Serial Driver: use barrier instead of cpu_relax for Blackfin SMP like patch
Date: Fri, 17 Oct 2008 01:44:01 +0800
Message-Id: <1224179047-13073-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
References: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
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
index 16b891e..aea3a53 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1107,7 +1107,8 @@ static __init void early_serial_putc(struct uart_port *port, int ch)
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 
 	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
-		cpu_relax();
+		barrier();
+
 	UART_PUT_CHAR(uart, ch);
 }
 
-- 
1.5.6

