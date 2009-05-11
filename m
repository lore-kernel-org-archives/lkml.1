Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZEKGiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZEKGiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZEKGiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:38:10 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:50160 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbZEKGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:38:09 -0400
Date: Mon, 11 May 2009 08:38:06 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: benh@kernel.crashing.org, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       jim@jtan.com
Subject: Re: [PATCH 04/15] ps3vram: Replace mutex by spinlock + list
In-Reply-To: <20090508160544.28189203.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.0905110836500.14263@vixen.sonytel.be>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090508160544.28189203.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Andrew Morton wrote:
> On Fri,  8 May 2009 16:01:13 +0200
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> > +static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
> > +{
> > +	struct ps3_system_bus_device *dev = q->queuedata;
> > +	struct ps3vram_priv *priv = dev->core.driver_data;
> > +
> > +	dev_dbg(&dev->core, "%s\n", __func__);
> > +
> > +	spin_lock_irq(&priv->lock);
> > +	if (priv->tail) {
> > +		priv->tail->bi_next = bio;
> > +		priv->tail = bio;
> > +		spin_unlock_irq(&priv->lock);
> > +		return 0;
                ^^^^^^^^
> > +	}
> > +
> > +	priv->tail = bio;
> > +	spin_unlock_irq(&priv->lock);
> > +
> > +	do {
> > +		bio = ps3vram_do_bio(dev, bio);
> > +	} while (bio);
> 
> Is there something which prevents two threads of control from walking
> the same list at the same time?

Sure: only the thread who adds the first request to the empty list will walk
the list later.

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
