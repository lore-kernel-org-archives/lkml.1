Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYHGUEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYHGUEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYHGUEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:04:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57883 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750701AbYHGUEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:04:22 -0400
Date: Thu, 7 Aug 2008 20:44:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Olaf Schnapper <os@de.ibm.com>
Subject: Re: [PATCH] Fix race/oops in tty layer after BKL pushdown
Message-ID: <20080807204439.1f8de826@lxorguk.ukuu.org.uk>
In-Reply-To: <200808071433.06885.borntraeger@de.ibm.com>
References: <200808071433.06885.borntraeger@de.ibm.com>
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

> It seems that tty was already free in disassocate_ctty when it tries
> to dereference tty->driver.
> 
> After moving the lock_kernel before the mutex_unlock, I can no longer
> reproduce the problem.
> 
> Please review and consider to apply:

This doesn't help as the BKL doesn't protect tty here - we don't have
refcounting on the ttys yet so this bug (which goes back forever) simply
becomes a different sized race if you swap the lock ordering.

Given tty_vhangup just fires off a wait queue which is killed on the tty
destruction you should be able for now at least to move the mutex_unlock
to after the call to tty_vhangup().

Does that also fix the problem ?

Alan
