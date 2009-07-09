Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbZGIQOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbZGIQOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760610AbZGIQOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:14:37 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:53927 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760476AbZGIQOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:14:37 -0400
X-Greylist: delayed 1664 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2009 12:14:37 EDT
Date: Thu, 09 Jul 2009 17:46:39 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 0/3] Fix sysrq caused USB performance regressions and
 leak
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090709123301.15654.4698.stgit@localhost.localdomain> (from
	alan@lxorguk.ukuu.org.uk on Thu Jul  9 14:35:17 2009)
X-Mailer: Balsa 2.3.14
Message-Id: <1247154399l.14017l.2l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <20090709123301.15654.4698.stgit@localhost.localdomain>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from very similar code being added differently,
here this way around...

>  drivers/usb/serial/generic.c |   15 +++++++++++----
> 
> +	if (!port->console || !port->sysrq)
> +		tty_insert_flip_string(tty, ch, urb->actual_length);
> +	else {	
> +		/* Push data to tty */
> +		for (i = 0; i < urb->actual_length; i++, ch++) {
> +			if (!usb_serial_handle_sysrq_char(port, *ch))
> +				tty_insert_flip_char(tty, *ch, TTY_NORMAL);
> +		}

...and there the other way around,

>  drivers/usb/serial/pl2303.c |   58 ++++++++++++++++++++++++-------------------
> 
> +	if (port->console && port->sysrq) {
> +		int i;
> +		for (i = 0; i < urb->actual_length; ++i)
> +			if (!usb_serial_handle_sysrq_char(tty, port, data[i]))
> +				tty_insert_flip_char(tty, data[i], tty_flag);
> +	} else
> +		tty_insert_flip_string(tty, data, urb->actual_length);

shouldn't it be
+	if (likely(!port->console || !port->sysrq))
respectively
+	if (unlikely(port->console && port->sysrq)) {

at least for clarity?

Cheers
Anders
