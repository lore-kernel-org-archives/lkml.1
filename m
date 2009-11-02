Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZKBGiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZKBGiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 01:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZKBGiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 01:38:21 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33187 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZKBGiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jawIFR2tnzbs5ul9px3zw9tirdySfD8ONMrRpo3ArzmBIW4utYi3CQW0zUjEFKsFqB
         L4iPTPdyDWya7FeQOjOlrMky9/9DBheBDlXi2nadnHFggXAe+biXTaA4aDU6zBYaetPg
         DHWOOF2I2ieIaG4vglupwvoYS0+TIDhNxM0Fo=
Date: Sun, 1 Nov 2009 22:38:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: fix locking context in ml_ff_set_gain
Message-ID: <20091102063818.GB3354@core.coreip.homeip.net>
References: <20091031141925.149c9874@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091031141925.149c9874@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Sat, Oct 31, 2009 at 02:19:25PM -0700, Arjan van de Ven wrote:
> From 177c4e7a84c40925605d485f6d5367deb44a84c8 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 31 Oct 2009 14:13:40 -0700
> Subject: [PATCH] input: fix locking context in ml_ff_set_gain
> 
> the ml_ff_set_gain() function uses spin_lock_bh/spin_unlock_bh
> for locking. Unfortunately, this function can be called with irqs
> off:
> vfs_write ->
> evdev_write ->
> input_inject_event (disables interrupts) ->
> input_handle_event ->
> input_ff_event ->
> ml_ff_set_gain
> 
> and doing spin_unlock_bh() with interrupts off is not allowed
> (and causes a nice warning as a result).
> 
> This patch fixes this by turning the locking into the _irqsave variant.

Thank you for the patch but it seems that the rest of the locking in
ff-memless.c is screwqed up ever since locking (dev->event_lock) was
added to the input core and this change plugs one hole but exposes
others.  I think I need to convert ff-memless.c over to rely on
event_lock instead of the private timer_lock, but I will need a couple
of days.

-- 
Dmitry
