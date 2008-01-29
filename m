Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYA2Uzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYA2Uzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765123AbYA2Uy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:54:57 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60149 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765085AbYA2Uyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:54:55 -0500
Date: Tue, 29 Jan 2008 21:54:53 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 0/5] dmaengine: Slave DMA interface and example users
Message-ID: <20080129215453.1e3758ab@siona>
In-Reply-To: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 19:10:08 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> This patch series adds the necessary interfaces to the DMA Engine
> framework to use functionality found on most embedded DMA controllers:
> DMA from and to I/O registers with hardware handshaking.

Btw, there's one issue I forgot to mention: I believe the DMA Engine
framework is currently misusing the DMA mapping API, and this patchset
makes things worse.

Currently, the async_tx bits of the API do the required calls to
dma_map_single() and/or dma_map_page(), but they rely on the driver to
do the unmapping. This is problematic since the driver doesn't have a
clue about whether it should use dma_unmap_single(), dma_unmap_page()
or something else.

The MMC driver I posted as a part of this series gets a scatterlist
from the MMC core, so it needs to use dma_map_sg() / dma_unmap_sg(). To
make this work, I decided not to do any unmapping in the DMA driver and
do the necessary dma_unmap_sg() from the DMA completion callback in the
MMC driver. Thus, for the normal async_tx operations, the buffers
aren't unmapped at all when using the dw_dmac driver. Since the
dma_unmap calls are no-ops on avr32, this doesn't have any consequences
for me in practice, but I want to use the DMA mapping API correctly
somehow.

Also, clients may want to just sync the buffer and reuse it. They can't
do that if the DMA engine driver unmaps the buffer on completion.

How do we solve this?

Haavard
