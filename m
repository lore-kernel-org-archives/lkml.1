Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYGNRE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYGNRE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYGNRES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:04:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbYGNRES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:04:18 -0400
Date: Mon, 14 Jul 2008 10:04:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Michael H. Warfield" <mhw@wittsend.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ip2: avoid add_timer() with pending timer
Message-Id: <20080714100402.b72e2b1e.akpm@linux-foundation.org>
In-Reply-To: <20080714024955.GB30952@sssvn.sssvn>
References: <20080714024955.GB30952@sssvn.sssvn>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 11:49:55 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> @@ -746,10 +742,8 @@ ip2_loadmain(int *iop, int *irqp)
>  			}
>  			if ( ip2config.irq[i] == CIR_POLL ) {
>  retry:
> -				if (!TimerOn) {
> -					PollTimer.expires = POLL_TIMEOUT;
> -					add_timer ( &PollTimer );
> -					TimerOn = 1;
> +				if (!timer_pending(&PollTimer)) {
> +					mod_timer(&PollTimer, POLL_TIMEOUT);
>  					printk( KERN_INFO "IP2: polling\n");

This change to ip2_loadmain() might be racy if it actually did
anything.  But afaict timer_pending() can never be true here (we're
only called from module_init()) so it can and should be removed.

