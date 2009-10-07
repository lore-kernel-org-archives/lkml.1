Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZJGNa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZJGNa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZJGNa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:30:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36950 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbZJGNa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:30:56 -0400
Date: Wed, 7 Oct 2009 14:31:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Strakh <strakh@ispras.ru>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] isicom.c sleeping function called from invalid context
Message-ID: <20091007143132.63cd5c16@lxorguk.ukuu.org.uk>
In-Reply-To: <200910071715.14853.strakh@ispras.ru>
References: <200910071715.14853.strakh@ispras.ru>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 17:15:14 +0000
Alexander Strakh <strakh@ispras.ru> wrote:

> 	KERNEL_VERSION: 2.6.31
> 	DESCRIBE:
> Driver drivers/char/isicom.c might sleep in atomic  context, because it calls 
> tty_port_xmit_buf under spin_lock.
> 
> ./drivers/char/isicom.c:
> 1307 static void isicom_hangup(struct tty_struct *tty)
> 1308 {
> ...
> 1315         spin_lock_irqsave(&port->card->card_lock, flags);
> 1316         isicom_shutdown_port(port);
> ...
> 
> Path to might_sleep macro from isicom_hangup:
> 1. isicom_hangup calls spin_lock_irqsave (drivers/char/isicom.c:1315) and then 
> calls isicom_shutdown_port.
> 2. isiscom_shutdown_port calls tty_port_free_xmit_buf at 
> drivers/char/isicom.c:906
> 3. tty_port_free_xmit_buf calls mutex_lock at srivers/char/tty_port:48
> 
> Found by Linux Driver Verification Project

Diagnosis is correct. I'll take a quick look at that one
