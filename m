Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbXKYAmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbXKYAmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 19:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXKYAmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 19:42:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45607 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752693AbXKYAmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 19:42:12 -0500
Date: Sun, 25 Nov 2007 00:39:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3, 4GB RAM, swiotlb, r8169, out of space
Message-ID: <20071125003910.3e58e3b3@the-village.bc.nu>
In-Reply-To: <200711242344.49958.alistair@devzero.co.uk>
References: <200711242344.49958.alistair@devzero.co.uk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> when these messages appear, removing r8169 would appear to be key. Indeed, if 
> there is no significant libata activity, the problem still occurs on the NIC 
> within approximately the same amount of transfer.

You seem to have a leak, which actually isn't suprising

	rtl8169_xmit_frags allocates a set of maps for a fragmented packet

	rtl8169_start_xmit allocates a buffer

When we finish the transit we free the main buffer (always using skb->len
when sometimes its skb->headlne. We don't seem to free the fragment
buffers at all.

Looks like the unmap path for fragmented packets is broken with any kind
of iommu

Alan
