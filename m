Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbXKOIoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbXKOIoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbXKOIoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:44:04 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57924 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755980AbXKOIoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:44:03 -0500
Date: Thu, 15 Nov 2007 09:43:00 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Message-ID: <20071115094300.31752b54@dhcp-255-175.norway.atmel.com>
In-Reply-To: <200711142250.18392.david-b@pacbell.net>
References: <200711091136.20051.david-b@pacbell.net>
	<200711140037.58049.david-b@pacbell.net>
	<20071114105441.2d01018f@dhcp-255-175.norway.atmel.com>
	<200711142250.18392.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 22:50:17 -0800
David Brownell <david-b@pacbell.net> wrote:

> > Since this is the code that runs under the lock  
> 
> No, there's more than that.  This is what runs under it in
> the hot paths, yes, but the gpio request/free paths do
> more work than this.  (That includes direction setting,
> since that can be an implicit request.)

Yeah, I was talking about the hot paths. That's the only place where
raw vs. non-raw performance matters.

> The get/set bit calls are the hot paths.  Locking on those paths
> buys us a consistent locking policy, which is obviously correct.
> It's consistent with the request/free paths.
> 
> But I think what you're suggesting is that the "requested" flag
> is effectively a long-term lock, so grabbing the spinlock on
> those paths is not necessary.  Right?

Exactly. If we add two (quite reasonable) restrictions:
  * The GPIO framework must ensure that GPIO chips cannot be removed
    when one or more pins have been assigned to a client.
  * The client must ensure that it never calls gpio_free()
    simultaneously with gpio_[sg]et_value(), adding locking of its own if
    necessary.

this should be safe.

Håvard
