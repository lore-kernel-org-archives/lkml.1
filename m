Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYJ3RXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYJ3RXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYJ3RXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:23:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52053 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756875AbYJ3RXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:23:20 -0400
Date: Thu, 30 Oct 2008 17:22:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc2 i/o error on /dev/ttyUSB0
Message-ID: <20081030172251.2298b404@lxorguk.ukuu.org.uk>
In-Reply-To: <4909EA24.2020701@aitel.hist.no>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
	<4906F54A.7020909@aitel.hist.no>
	<alpine.LFD.2.00.0810280928320.3386@nehalem.linux-foundation.org>
	<20081028170605.611c7759@lxorguk.ukuu.org.uk>
	<490856FA.20609@aitel.hist.no>
	<20081030155412.33d57ca0@lxorguk.ukuu.org.uk>
	<4909EA24.2020701@aitel.hist.no>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks partially fixed.
> No more I/O errors, and the gps unit works fine.
> 
> But look at the attached dmesg file - there are WARNINGs still.

Thats an unrelated and long long standing bug - the USB serial close paths
are all racy versus the received URB handlers. The only reason you now
will occasionally get a warning message is that we bother to actually trap
the case rather than praying silently it doesn't blow up.

What actually occurs is that you enter usb-serial:usb_serial_close which
then drops port->port.count and calls type->close. Somewhere in there new
data arrives and the ldisc path gets to run. The n_tty path tries to echo
back bytes to the (closed) port and the WARN triggers.

Changing the order to clear the port->tty first requires auditing each and
every USB serial driver close method so isn't planned for this release -
but its not caused major disasters in the past few years the race has been
there.

I can push patches this release for it if Linus particularly wants
however.

Alan
