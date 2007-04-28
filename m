Return-Path: <linux-kernel-owner+w=401wt.eu-S1161291AbXD1Hwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161291AbXD1Hwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030413AbXD1Hwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:52:49 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2693 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030990AbXD1Hws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:52:48 -0400
Date: Sat, 28 Apr 2007 08:52:41 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Giridhar Pemmasani <pgiri@yahoo.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow __vmalloc with GFP_ATOMIC
Message-ID: <20070428075240.GA8256@flint.arm.linux.org.uk>
Mail-Followup-To: Giridhar Pemmasani <pgiri@yahoo.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <539764.53941.qm@web32409.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539764.53941.qm@web32409.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 09:03:33PM -0700, Giridhar Pemmasani wrote:
> Until 2.6.19, __vmalloc with GFP_ATOMIC was possible, but __get_vm_area_node
> would allocate the node itself with GFP_KERNEL, causing a warning. In 2.6.19,
> this was "fixed" by using the same flags that were passed to __vmalloc also
> in __get_vm_area_node. However, __get_vm_area_node does
> BUG_ON(in_interrupt()) now, since vmlist_lock is obtained without disabling
> bottom-half's. The patch below uses bh disabled lock for vmlist_lock, so that
> __vmalloc can be used in interrupt context.

It's worse than that.  If vmalloc has to allocate a page table, the
allocation will be done as a non-atomic allocation.  So, even if you
do fix __get_vm_area_node and all the other cases, if you hit a page
table allocation you'll still get a warning.

Folk need to accept that using vmalloc from atomic contexts is a
complete nono.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
