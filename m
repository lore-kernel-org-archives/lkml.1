Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbZJHNMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbZJHNMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbZJHNMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:12:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37840 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758064AbZJHNMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:12:07 -0400
Date: Thu, 8 Oct 2009 14:12:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Thomas Chou <thomas@wytron.com.tw>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Abbott <ian.abbott@mev.co.uk>
Subject: Re: [PATCH v2] ata: New PATA driver for Altera CompactFlash.
Message-ID: <20091008141241.550a09bd@lxorguk.ukuu.org.uk>
In-Reply-To: <4ACDCB6E.4040905@mev.co.uk>
References: <1254967110-3495-1-git-send-email-thomas@wytron.com.tw>
	<20091008105503.6ce414f5@lxorguk.ukuu.org.uk>
	<4ACDCB6E.4040905@mev.co.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009 12:22:22 +0100
Ian Abbott <abbotti@mev.co.uk> wrote:

> On 08/10/09 10:55, Alan Cox wrote:
> > On Thu,  8 Oct 2009 09:58:30 +0800
> > Thomas Chou <thomas@wytron.com.tw> wrote:
> > 
> >> This patch adds a new PATA driver to support the Altera SOPC Builder
> >> CompactFlash component as a PATA device with support for insertion
> >> and removal of CF cards.  It uses the platform driver model.
> > 
> > Can you explain why you remove the interface rather than the device on
> > the interface when you detect a card removal ?
> 
> As the originator of the driver, the only answer I have is "I don't know
> how."  I was hoping for inspiration from some of the other PATA CF
> drivers, but alas, I couldn't find it.  I admit that removing the whole
> ATA host is a bit on the extreme side.

I think the bit you want is something like:

	struct ata_eh_info *ehi = &ap->link->eh_info;
	if (mumblemumble & whatever) {
		ata_ehi_clear_desc(ehi);
		ata_ehi_hotplugged(ehi);
		ata_ehi_push_desc(ehi, "CF connection changed");
		ata_port_freeze(ap);
	}

The core code also assumes your freeze method will mask any further
connection change reports until the port is unfrozen (so you don't get
multiple parallel "in/out/in/out" events at once)

Alan
