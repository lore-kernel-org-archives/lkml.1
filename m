Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbXJXOcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbXJXOcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbXJXOcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:32:15 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:50523 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669AbXJXOcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:32:13 -0400
Date: Wed, 24 Oct 2007 16:34:45 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20071024143444.GF9748@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: PCMCIA insert on resume
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I don't understand why, on resume, the function socket_resume() (in
drivers/pcmcia/cs.c) do:

       if (!(skt->state & SOCKET_PRESENT)) {
               skt->state &= ~SOCKET_SUSPEND;
               return socket_insert(skt);
       }

This cause a powered off socket before suspend to be powered on during
resume.

To avoid such (erroneous?) behaviour I propose this patch:

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 729e37d..d69de74 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -562,10 +562,8 @@ static int socket_resume(struct pcmcia_socket *skt)
        skt->ops->init(skt);
        skt->ops->set_socket(skt, &skt->socket);
 
-       if (!(skt->state & SOCKET_PRESENT)) {
-               skt->state &= ~SOCKET_SUSPEND;
-               return socket_insert(skt);
-       }
+       if (!(skt->state & SOCKET_PRESENT))
+               goto resume_exit;
 
        ret = socket_setup(skt, SS_COMA, resume_delay);
        if (ret == CS_SUCCESS) {
@@ -599,6 +597,7 @@ static int socket_resume(struct pcmcia_socket *skt)
                socket_shutdown(skt);
        }
 
+resume_exit:
        skt->state &= ~SOCKET_SUSPEND;
 
        return CS_SUCCESS;

With this patch if the socket was powered down before the suspend, at
resume time it's not powered on and you need a "pccardctl insert" to
activate the socket.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
