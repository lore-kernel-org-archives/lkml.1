Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYKRWZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYKRWZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYKRWYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:24:31 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12087 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYKRWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:24:29 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 22/26] 8250: Allow port type to specify bugs that are not probed for.
Date: Tue, 18 Nov 2008 14:24:16 -0800
Message-Id: <1227047057-4911-4-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <49233FDE.3010404@caviumnetworks.com>
References: <49233FDE.3010404@caviumnetworks.com>
X-OriginalArrivalTime: 18 Nov 2008 22:24:20.0853 (UTC) FILETIME=[6717AA50:01C949CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bugs field to the serial8250_config and propagate it to the
port's bugs field when the port is registered and configured.

This is a follow on to the previous patch.  Now that we can specify
the port type and don't have to probe for it, we can avoid probing for
bugs if they are known with certainty to exist.

The alternative is to load up 8250.c with a bunch of OCTEON specific
special cases in the probing code.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/serial/8250.c |    2 ++
 drivers/serial/8250.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 37a6f4c..4a8796f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1212,6 +1212,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	up->port.fifosize = uart_config[up->port.type].fifo_size;
 	up->capabilities = uart_config[up->port.type].flags;
 	up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
+	up->bugs |= uart_config[up->port.type].bugs;
 
 	if (up->port.type == PORT_UNKNOWN)
 		goto out;
@@ -3065,6 +3066,7 @@ int serial8250_register_port(struct uart_port *port)
 			uart->port.fifosize = uart_config[port->type].fifo_size;
 			uart->capabilities = uart_config[port->type].flags;
 			uart->tx_loadsz = uart_config[port->type].tx_loadsz;
+			uart->bugs = uart_config[port->type].bugs;
 		}
 
 		set_io_fns_from_upio(&uart->port);
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index 5202603..c9b3002 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -34,6 +34,7 @@ struct serial8250_config {
 	const char	*name;
 	unsigned short	fifo_size;
 	unsigned short	tx_loadsz;
+	unsigned short	bugs;
 	unsigned char	fcr;
 	unsigned int	flags;
 };
-- 
1.5.6.5

