Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbXJZKtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbXJZKtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXJZKsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:48:53 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:44296 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXJZKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:48:52 -0400
Date: Fri, 26 Oct 2007 12:51:25 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <20071026105125.GA28769@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] PCMCIA: prevent auto insert during resume.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a socket has been ejected before sleeping, at resume time it
shouldn't be awaked.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pcmcia/cs.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 729e37d..d69de74 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -562,10 +562,8 @@ static int socket_resume(struct pcmcia_socket *skt)
 	skt->ops->init(skt);
 	skt->ops->set_socket(skt, &skt->socket);
 
-	if (!(skt->state & SOCKET_PRESENT)) {
-		skt->state &= ~SOCKET_SUSPEND;
-		return socket_insert(skt);
-	}
+	if (!(skt->state & SOCKET_PRESENT))
+		goto resume_exit;
 
 	ret = socket_setup(skt, SS_COMA, resume_delay);
 	if (ret == CS_SUCCESS) {
@@ -599,6 +597,7 @@ static int socket_resume(struct pcmcia_socket *skt)
 		socket_shutdown(skt);
 	}
 
+resume_exit:
 	skt->state &= ~SOCKET_SUSPEND;
 
 	return CS_SUCCESS;
-- 
1.5.2.5

