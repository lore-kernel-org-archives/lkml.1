Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbXHHKiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbXHHKiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXHHKiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:38:05 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:39505 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbXHHKiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:38:02 -0400
Date: Wed, 8 Aug 2007 12:37:59 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] sdio: extend sdio_readsb() and friends to handle
 any length of buffer
Message-ID: <20070808123759.26a74b2a@poseidon.drzeus.cx>
In-Reply-To: <46B998B5.9040203@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
	<20070806220145.66b97559@poseidon.drzeus.cx>
	<46B86ADB.90000@csr.com>
	<46B86BB0.4000100@csr.com>
	<20070807221719.7c89e5b6@poseidon.drzeus.cx>
	<46B998B5.9040203@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007 11:19:33 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> 
> We need to know the block size in use /before/ the start of the
> transfer as we would like drivers to be able to perform transfers
> with single commands as this can result in significantly better
> performance[1].  The drivers for our (CSR's) WiFi chips should do
> this.  This isn't some (as you suggested in a previous post) 'rare'
> requirement.
> 

Well, there are more ways that can be achieved.

First, the driver could lock down the block size using
sdio_force_block_size(). Then it knows what it gets.

Second, we could try to make it possible for the driver to indicate
"feel free to pad this transfer". Then we could also remove the need
for drivers to mess with buffers and keep such stuff in the core. We
could even magically remove a memcpy() by setting up two sg entries,
one for the data and one for the padding.

> 
> [1] Consider a chip with a block size of 64 that regularly does short
> transfers of between 64 - 128 bytes.  Without padding, this would
> require two commands per transfer instead of just one, cutting
> performance by 50%!  This scenario could be a WiFi chip doing VoIP.

Provided block size < 128. Otherwise it'll jump straight to the byte
transfer.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
