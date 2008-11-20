Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYKTPM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYKTPM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYKTPMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:12:47 -0500
Received: from mail.pcs.de ([145.253.69.50]:51889 "EHLO mail.pcs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbYKTPMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:12:47 -0500
Date: Thu, 20 Nov 2008 16:12:45 +0100 (CET)
From: Thomas Pfaff <tpfaff@pcs.com>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Question about TTY_DO_WRITE_WAKEUP
In-Reply-To: <20081120143147.5e8d6c20@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0811201536150.23073@lxtpfaff.pcs.ditec.de>
References: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
 <20081120131726.2636b559@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811201446380.21561@lxtpfaff.pcs.ditec.de>
 <20081120143147.5e8d6c20@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 20 Nov 2008 15:12:45.0155 (UTC) FILETIME=[70E13B30:01C94B22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Nov 2008, Alan Cox wrote:

> > Is the TTY_DO_WRITE_WAKEUP bit some kind of cruft that can be removed entirely 
> > or should i generate a patch for serial devices only ?
> 
> It shouldn't happen at the serial level. The line discipline sets the
> flag as and when it has data for the process above.
> 
> The expected flow in normal use is
> 
> 	app writes to tty
> 		data goes to n_tty ldisc
> 			goes to tty
> 		n_tty ldisc seems tty blocked
> 		n_tty ldisc sets DO_WRITE_WAKEUP
> 
> 	tty gets ucongested
> 		calls n_tty write_wakeup
> 			SIGIO sent
> 			Flag set again
> 
> The important part of the logic is in n_tty.c and tty_io.c

Following the source the TTY_DO_WRITE_WAKEUP flag is set in n_tty_write_wakeup. 

But n_tty_write_wakeup is only called from tty_wakeup when this bit is already 
set, therefore it makes no sense to set this bit in n_tty_write_wakeup again.

The flow looks to me as

If the tty driver sets TTY_DO_WRITE_WAKEUP a SIGIO is generated on every 
tty_wakeup.

If it is not set then n_tty_write_wakeup is never called and a SIGIO is not 
generated.

Thomas

