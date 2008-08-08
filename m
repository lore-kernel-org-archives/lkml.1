Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbYHHVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbYHHVoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbYHHVoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:44:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55562 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756358AbYHHVoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:44:09 -0400
Date: Fri, 8 Aug 2008 22:26:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] vt: kill tty->count usage
Message-ID: <20080808222635.4fe52b51@lxorguk.ukuu.org.uk>
In-Reply-To: <20080808213625.GK20355@redhat.com>
References: <20080808213625.GK20355@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> each driver can keep the number of the references itself. Holding tty_mutex
> before calling driver's close() and updating tty->count is not possible
> because some drivers sleep waiting until the tx buffer is empty.

Agreed.

> This patch was tested under normal usage and using the stress application I
> wrote that triggers the problem more easily.
>
> +			if (vc->vc_tty != NULL) {
> +				/* we're still releasing this console entry */
> +				release_console_sem();
> +				return -EBUSY;

That isn't valid behaviour according to the POSIX tty rules. An open of a
closing tty blocks until the close completes. Most drivers using the
TTY_CLOSING flag to handle this.

So NAK the patch but basically agree with the approach - the EBUSY needs
to become a 'wait for close to complete, goto retry'

Alan

