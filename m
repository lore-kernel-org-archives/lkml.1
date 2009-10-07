Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbZJGNNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbZJGNNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933429AbZJGNNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:13:16 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:42778 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933311AbZJGNNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:13:15 -0400
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] isicom.c sleeping function called from invalid context
Date: Wed, 7 Oct 2009 17:15:14 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910071715.14853.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
Driver drivers/char/isicom.c might sleep in atomic  context, because it calls 
tty_port_xmit_buf under spin_lock.

./drivers/char/isicom.c:
1307 static void isicom_hangup(struct tty_struct *tty)
1308 {
...
1315         spin_lock_irqsave(&port->card->card_lock, flags);
1316         isicom_shutdown_port(port);
...

Path to might_sleep macro from isicom_hangup:
1. isicom_hangup calls spin_lock_irqsave (drivers/char/isicom.c:1315) and then 
calls isicom_shutdown_port.
2. isiscom_shutdown_port calls tty_port_free_xmit_buf at 
drivers/char/isicom.c:906
3. tty_port_free_xmit_buf calls mutex_lock at srivers/char/tty_port:48

Found by Linux Driver Verification Project.
