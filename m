Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYJUWrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYJUWrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYJUWrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:47:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37532 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751352AbYJUWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:47:40 -0400
Date: Tue, 21 Oct 2008 23:47:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 5/7] kgdboc, tty: use tty open to start low level
 drivers
Message-ID: <20081021234728.6853beee@lxorguk.ukuu.org.uk>
In-Reply-To: <1224616493-23237-6-git-send-email-jason.wessel@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
	<1224616493-23237-2-git-send-email-jason.wessel@windriver.com>
	<1224616493-23237-3-git-send-email-jason.wessel@windriver.com>
	<1224616493-23237-4-git-send-email-jason.wessel@windriver.com>
	<1224616493-23237-5-git-send-email-jason.wessel@windriver.com>
	<1224616493-23237-6-git-send-email-jason.wessel@windriver.com>
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

On Tue, 21 Oct 2008 14:14:51 -0500
Jason Wessel <jason.wessel@windriver.com> wrote:

> This patch adds two new hooks to the tty layer in tty_io.c to allow

Gak

> A few minor changes were needed in tty_io.c to deal with the fact that
> the inode and fpath.dentry were NULL with the generic flip structure.

Gak and more gak

> +		tty = tty_driver_lookup_tty(driver, NULL, tty_line);
> +		if (!tty) {
> +			tty = tty_init_dev(driver, tty_line, 0);
> +			inc_tty = 0;
> +		}
> +		(*filp)->private_data = tty;
> +		ret = tty->ops->open(tty, *filp);

Digging deep into tty innards (some of which btw are going to change)

> +		unlock_kernel();
> +	} else {
> +		tty = tty_driver_lookup_tty(driver, NULL, tty_line);
> +		if (!tty) {
> +			tty = tty_init_dev(driver, tty_line, 0);
> +			inc_tty = 0;
> +		}
> +		(*filp)->private_data = tty;
> +		ret = tty->ops->open(tty, *filp);

and with the error paths wrong


This is to put it bluntly just horrible.

Really kgdb, console and other boot processes need an abstraction for tty
device ports at the device (not ldisc) level and until that work is done
there is no acceptable way to sort this out. Merging gunk like this will
simply make the existing mess worse and provide more crap that will make
it harder to fix properly.

All this stuff needs revisiting when every tty device side object in the
kernel contains a struct tty_port, until then it's a nasty (perhaps
neccessary for the moment) hack that belongs out of tree.

Alan
