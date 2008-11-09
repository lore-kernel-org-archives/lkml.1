Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYKIV3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYKIV3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbYKIV2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:28:52 -0500
Received: from isilmar.linta.de ([213.133.102.198]:55683 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755862AbYKIV2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:28:52 -0500
Date: Sun, 9 Nov 2008 22:28:49 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: ensure correct logging in do_io_probe [v2]
Message-ID: <20081109212849.GA12584@isilmar.linta.de>
Mail-Followup-To: Frans Pop <elendil@planet.nl>,
	linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
	linux-pcmcia@lists.infradead.org
References: <200811071522.43618.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811071522.43618.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 07, 2008 at 03:22:42PM +0100, Frans Pop wrote:
> I've added parens around the conditions. Maybe not strictly needed,
> but better readable and consistent with similar usage in cs.c.
>
> From: Frans Pop <elendil@planet.nl>
> 
> pcmcia: ensure correct logging in do_io_probe
>     
> During early probing of the parent PCI bridge I/O window no socket
> has been allocated yet.
> In that case print &s->cb_dev->dev instead of &s->dev as device.

similar to the other patch, this won't work: &skt->cb_dev is only available
and set if the parent device is a PCI device; therefore, &skt->dev is the
only thing we can use.

An alternative approach would be to move this initialization code only after
we've set dev_name. Could you test whether this approach works for you,
please?

Thanks,
	Dominik


>From b1769450da0eeae2d95aae5496acbdf4c6ba89b2 Mon Sep 17 00:00:00 2001
From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Sun, 9 Nov 2008 21:47:47 +0100
Subject: [PATCH] pcmcia: ensure correct logging in do_io_probe

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 5d0e60e..0660ad1 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -186,12 +186,6 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
 
 	spin_lock_init(&socket->lock);
 
-	if (socket->resource_ops->init) {
-		ret = socket->resource_ops->init(socket);
-		if (ret)
-			return (ret);
-	}
-
 	/* try to obtain a socket number [yes, it gets ugly if we
 	 * register more than 2^sizeof(unsigned int) pcmcia
 	 * sockets... but the socket number is deprecated
@@ -239,6 +233,12 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
 	mutex_init(&socket->skt_mutex);
 	spin_lock_init(&socket->thread_lock);
 
+	if (socket->resource_ops->init) {
+		ret = socket->resource_ops->init(socket);
+		if (ret)
+			goto err;
+	}
+
 	tsk = kthread_run(pccardd, socket, "pccardd");
 	if (IS_ERR(tsk)) {
 		ret = PTR_ERR(tsk);
