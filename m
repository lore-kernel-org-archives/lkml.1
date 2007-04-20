Return-Path: <linux-kernel-owner+w=401wt.eu-S1767069AbXDTMI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767069AbXDTMI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767071AbXDTMI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:08:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34050 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767069AbXDTMIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:08:55 -0400
Date: Fri, 20 Apr 2007 13:12:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Subject: Re: [PATCH 1/3] Char: mxser_new, fix recursive locking
Message-ID: <20070420131210.166fcd40@the-village.bc.nu>
In-Reply-To: <20225157853131727049@wsc.cz>
References: <20225157853131727049@wsc.cz>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Acquire a port lock only if not in_interrupt in some places, because ISR
> holds the lock yet (and ldisc calls some of driver's routines which tries to
> acquire it again due to tty->low_latency).

NAK

This is the wrong way to do it. If you don't support recursive entry then
don't use ->low_latency. If you do then ensure you drop the lock before
you call tty_flip_buffer_push().

The other way this could be tackled which has some merit is to require
that line discipline responses coming from a received frame call a new
tty method so drivers can tell callbacks from arriving data apart from
other events.

Alan
