Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYKDRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYKDRhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYKDRhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:37:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57388 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754510AbYKDRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:37:18 -0500
Date: Tue, 4 Nov 2008 17:37:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Fix close races in USB serial
Message-ID: <20081104173726.0271939d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081104171128.GB630@kroah.com>
References: <20081104152916.30344.68193.stgit@localhost.localdomain>
	<20081104171128.GB630@kroah.com>
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

> > -	if (port->port.count == (port->console? 1 : 0)) {
> > +	if (port->port.count == (port->console ? 2 : 1)) {
> 
> Why are you testing for 2 here?

At the point we enter this routine port->port.count is the number of
users of the port. If this is the final close then this is 1 (us), except
if it is the USB console (in which case there will be two references).

The old code dropped the reference count first, the new code drops the
kref and port->tty first, then shuts down the port and then drops the
refcount. That avoids the race where we get the usb serial drivers trying
to stuff bytes into a closed port and the ldisc layer in turn trying to
echo them
- which causes the warnings.

Alan
