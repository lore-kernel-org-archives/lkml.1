Return-Path: <linux-kernel-owner+w=401wt.eu-S1763691AbXLOMnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763691AbXLOMnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 07:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXLOMmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 07:42:53 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35503 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbXLOMmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 07:42:52 -0500
Date: Sat, 15 Dec 2007 13:42:51 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] dynamic pipe resizing
In-Reply-To: <20070824085221.GA23758@kernel.dk>
Message-ID: <Pine.LNX.4.64.0712151336230.22877@fbirervta.pbzchgretzou.qr>
References: <20070824085221.GA23758@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 24 2007 10:52, Jens Axboe wrote:
>Subject: [PATCH][RFC] dynamic pipe resizing
>
>Hi,
>
>Dabbling around with splice a bit, I added some code to change the size
>of a pipe. Currently it's hardcoded as 16 pages, with this patch you can
>shrink (if you wanted) or grow (the likely scenario) if you want to
>increase the size of your in-kernel buffer for splice operations.
>
>Like with my original splice patches from 2005, I used fcntl()
>F_GETPIPE_SZ and F_SETPIPE_SZ to change the size of the pipe. I'm not
>particularly fond of that interface, so suggestions on how to improve it
>would be appreciated. Even if fcntl() should be the preferred approach,
>I think it would be better to pass in a byte based value instead of a
>number of pages.
>
Could this patch still make it in?
Yes, I think its set() and get() parts should use bytes and convert 
to/from pages.

> /*
>+ * Allocate a new array of pipe buffers and copy the info over. Returns the
>+ * pipe size if successful, or return -ERROR on error.
>+ */
>+static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
>+{
>+	struct pipe_buffer *bufs;
>+
>+	/*
>+	 * Must be a power-of-2 current
>+	 */
>+	if (arg & (arg - 1))
>+		return -EINVAL;
>+

Perhaps just round up, and mention the rounding in the manpage, so that 
noone gets a shock when the pipe is not exactly as small as requested.

>+	/*
>+	 * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
>+	 * expect a lot of shrink+grow operations, just free and allocate
>+	 * again like we would do for growing. If the pipe currently
>+	 * contains more buffers than arg, then return busy.
>+	 */
>+	if (arg < pipe->nrbufs)
>+		return -EBUSY;

How big can a pipe become? k*alloc has a certain limit, so should 
perhaps vmalloc be used for when kalloc fails?

