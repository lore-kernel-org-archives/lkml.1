Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZGWRXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZGWRXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZGWRXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:23:36 -0400
Received: from mail.vyatta.com ([76.74.103.46]:36130 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbZGWRXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:23:35 -0400
Date: Thu, 23 Jul 2009 10:23:29 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Kalpesh Rathod <kalpeshrathod@gmail.com>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [query] skb alignment in tx path of driver
Message-ID: <20090723102329.54906366@nehalam>
In-Reply-To: <4A689B01.3010007@gmail.com>
References: <cee4bbc90907230955s558123dpe021fa1e7b384068@mail.gmail.com>
	<4A689B01.3010007@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 19:16:49 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Kalpesh Rathod a écrit :
> > Hi,
> > 
> > I am writing n/w device driver for sdio wifi card. I am testing it on
> > embedded platform.
> > DMA controller on the platform is able to xfer data to sdio only if
> > source data buf address is 4 byte aligned.
> > 
> > The firmware on the card understands 802.3 frames with snap headers.
> > So, I convert it to the required format in my driver.
> > 4 byte additional header is also attached to this frame and sent over sdio.
> > This all conversion effectively adds 12 byes to the frame received in
> > hard_xmit method.
> > 
> > Problem is, frame received in hard_xmit method is 2 byte aligned.
> > (skb->data is 2 byte aligned). As a result,
> > after addition of 12 bytes header, skb->data remains 2 byte aligned
> > instead of 4 byte aligned. And DMA controller refuses
> > to transfer it.
> > 
> > So, how can I request IP stack so that frame received in hard_xmit is
> > on 4 byte aligned boundry?
> 
> You cannot.
> 
> Search for skb_copy_and_csum_dev() use in drivers.
> 
> drivers/net/via-rhine.c is a good example of a driver dealing with same
> alignment requirement.
> 
>         if ((rp->quirks & rqRhineI) &&
>             (((unsigned long)skb->data & 3) || skb_shinfo(skb)->nr_frags != 0 || skb->ip_summed == CHECKSUM_PARTIAL)) {
There are wrappers for two of those tests
	      (!IS_ALIGNED(skb->data, 4) || skb_has_frags(skb) || skb->ip_summed == CHECKSUM_PARTIAL)
