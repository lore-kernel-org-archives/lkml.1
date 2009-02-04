Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZBDUPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZBDUPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZBDUPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:15:21 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38596 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbZBDUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:15:20 -0500
Date: Wed, 4 Feb 2009 15:15:18 -0500
To: linux-kernel@vger.kernel.org
Subject: Fix support for console port other than ttyS0 on mcf.c
Message-ID: <20090204201518.GH26064@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a case of backwards logic, mfc.c always makes the console port be
ttyS0 even when you ask for another port.

This patch fixes this issue.

Only when the requested port is NOT in the range 0 to MAXPORTS-1 do we
force it to be treated as if port 0 was requested.  Forcing the port to
0 when it is in fact in the range 0 to MAXPORTS is not helpful.

Tested with working console on ttyS2 on a 5271evb.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/drivers/serial/mcf.c b/drivers/serial/mcf.c
index 56841fe..0eefb07 100644
--- a/drivers/serial/mcf.c
+++ b/drivers/serial/mcf.c
@@ -513,7 +513,7 @@ static int __init mcf_console_setup(struct console *co, char *options)
        int parity = 'n';
        int flow = 'n';

-       if ((co->index >= 0) && (co->index <= MCF_MAXPORTS))
+       if ((co->index < 0) || (co->index >= MCF_MAXPORTS))
                co->index = 0;
        port = &mcf_ports[co->index].port;
        if (port->membase == 0)
