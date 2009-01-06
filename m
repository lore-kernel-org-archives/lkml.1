Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZAFOb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZAFOb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZAFObQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:31:16 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:64263 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZAFObP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:31:15 -0500
Date: Tue, 06 Jan 2009 23:31:10 +0900 (JST)
Message-Id: <20090106.233110.106262211.anemo@mba.ocn.ne.jp>
To: haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com
Subject: Re: dw_dmac driver questions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090106111403.2bdc0f83@hskinnemoen-d830>
References: <20090105164847.6fbca375@hskinnemoen-d830>
	<20090106.103344.134344452.nemoto@toshiba-tops.co.jp>
	<20090106111403.2bdc0f83@hskinnemoen-d830>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009 11:14:03 +0100, Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > 1) driver enqueue desc A to active list and start DMA engine
> > 2) driver enqueue desc B to queue list
> > 3) driver enqueue desc C to queue list  (desc C contains bad address)
> > 4) DMA engine finish desc A and raise interrupt
> > 5) tasklet remove desc A from active list and move desc B and C to active list
> > 6) DMA engine finish desc B and raise interrupt
> > 7) DMA engine abort desc C and raise interrupt
> > 8) tasklet detect error
> > 
> > The point is the order of (7) and (8) cannot be expected.  If (7)
> > comes first, the head of the active list contains desc B at (8) and
> > that is not a bad descriptor.
> 
> The tasklet won't detect any errors unless the DMA controller flags it,
> so (7) must happen before (8). That does not necessarily mean that the
> interrupts from (6) and (7) get handled before (8), but I don't think
> it matters because dwc_handle_error() calls dwc_scan_descriptors(),
> which will remove desc B from the active list if it is finished. And it
> must be finished if desc C has failed, so the failed descriptor will
> always be at the head of the queue after dwc_scan_descriptors() returns.

Oh I understand.  I overlooked dwc_scan_descriptors() call at
beginning of dwc_handle_error().  Thank you for explanation.

---
Atsushi Nemoto
