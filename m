Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbXKOWuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbXKOWuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759096AbXKOWul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:50:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913AbXKOWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:50:40 -0500
Date: Thu, 15 Nov 2007 14:50:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, hjlipp@web.de, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 3/4] bas_gigaset: suspend support (v2)
Message-Id: <20071115145022.99f9abbc.akpm@linux-foundation.org>
In-Reply-To: <20071112-patch3@xenon.ts.pxnet.com>
References: <20071112-patch0@xenon.ts.pxnet.com>
	<20071112-patch3@xenon.ts.pxnet.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 18:30:30 +0100 (CET)
Tilman Schmidt <tilman@imap.cc> wrote:

> From: Tilman Schmidt <tilman@imap.cc>
> 
> This patch adds basic suspend/resume support to the bas_gigaset ISDN
> driver for the Siemens Gigaset SX255 series of ISDN DECT bases.
> 
> Only the USB aspects are handled so far; the ISDN subsystem is not
> notified  in any way, for lack of information about how to do that.
> The driver will refuse to suspend if a connection is active.
> 
> ...
>
> +	if (atomic_read(&cs->hw.bas->basstate) & BS_SUSPEND) {

that's pretty peculiar.  We'd only expect to see atomics being used in
conjunction with atomic_add/sub/inc/etc.  Here the driver is using an
atomic_t as a state variable.  And here's the magic bit:

	spin_lock_irqsave(&ucs->lock, flags);
	state = atomic_read(&ucs->basstate);
	atomic_set(&ucs->basstate, (state & ~clear) | set);
	spin_unlock_irqrestore(&ucs->lock, flags);

I'm suspecting that a plain old `int' would be more appropriate here.
