Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbXKGN1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbXKGN1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbXKGN11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:27:27 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:59137 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755892AbXKGN1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:27:25 -0500
Date: Wed, 7 Nov 2007 22:27:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 1/2] libata: Support PIO polling-only hosts.
Message-ID: <20071107132702.GA27488@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxsh-dev@lists.sourceforge.net
References: <20071107081052.GA25913@linux-sh.org> <20071107130940.16b5ea86@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107130940.16b5ea86@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 01:09:40PM +0000, Alan Cox wrote:
> On Wed, 7 Nov 2007 17:10:52 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> > By default ata_host_activate() expects a valid IRQ in order to
> > successfully register the host. This patch enables a special case
> > for registering polling-only hosts that either don't have IRQs
> > or have buggy IRQ generation (either in terms of handling or
> > sensing), which otherwise work fine.
> > 
> > Hosts that want to use polling mode can simply set ATA_FLAG_PIO_POLLING
> > and pass in a NULL IRQ handler or invalid (< 0) IRQ.
> 
> NAK
> 
> Zero is "no IRQ", please use that for polling not "< 0"
> 
However, platform_get_irq() will happily return IRQ#0, and it's a valid
vector on plenty of machines. NO_IRQ is also < 0 on at least FR-V, ARM,
blackin, PA-RISC, some PowerPC, and even IDE.

We do have some devices that are physically on IRQ#0 that otherwise work
fine, they aren't ATA devices mind you, but to claim that IRQ#0 isn't a
valid vector is not in line with what hardware actually does, whether
it's a good idea or not. In our case the IRQ vector maps to an exception
offset, which we bump down to zero. We could force an off-by-1 there so
that the math that indexes IRQ#0 is bumped up one, but that entails
fixing up every one of our IRQ numbers for no obvious gain.

I don't really see any value in purposely crippling the range of
allowable vectors for these machines. Though I don't mind switching to a
NO_IRQ comparison instead of the < 0 case, so both can be handled.
