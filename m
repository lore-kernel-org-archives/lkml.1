Return-Path: <linux-kernel-owner+w=401wt.eu-S1423102AbXD3HNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423102AbXD3HNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423101AbXD3HNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:13:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423102AbXD3HNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:13:14 -0400
Date: Mon, 30 Apr 2007 00:13:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
 time?
Message-Id: <20070430001311.84d0291f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
References: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 09:40:39 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
>   i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
> were mutually exclusive when it came to calling kmalloc(), at least
> based on everything i'd read.  so i'm not sure how to interpret the
> following:
> 
> drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
> 
>   clarification?

GFP_ATOMIC implies that the memory comes from the zones which GFP_KERNEL
also uses.  So the above usage of GFP_KERNEL is redundant and should be
removed.

The way to understand this is to look at the definitions:

#define GFP_ATOMIC	(__GFP_HIGH)
#define GFP_NOIO	(__GFP_WAIT)
#define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
#define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
#define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
#define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
			 __GFP_HIGHMEM)


GFP_KERNEL: can sleep, can do IO, can enter filesystems

GFP_ATOMIC: cannot sleep, cannot do IO, cannot enter filesystems

Neither of them contains __GFP_DMA or __GFP_HIGHMEM, so both of them refer
to ZONE_NORMAL and any lower zones (ie: ZONE_DMA)
