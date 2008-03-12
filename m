Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbYCLKIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbYCLKIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYCLKIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:08:44 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:47268 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751369AbYCLKIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:08:43 -0400
Date: Wed, 12 Mar 2008 19:08:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ben Nizette <bn@niasdigital.com>
Cc: gregkh@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       hjk@linutronix.de
Subject: Re: [PATCH] UIO: Implement a UIO interface for the SMX Cryptengine
Message-ID: <20080312100831.GB21854@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ben Nizette <bn@niasdigital.com>, gregkh@suse.de,
	linux-kernel <linux-kernel@vger.kernel.org>, hjk@linutronix.de
References: <1205211430.3817.15.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205211430.3817.15.camel@moss.renham>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 03:57:10PM +1100, Ben Nizette wrote:
> +	regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (!regs)
> +		goto out_free;
> +
> +	info->mem[0].addr = regs->start;
> +	if (!info->mem[0].addr)
> +		goto out_free;
> +	info->mem[0].internal_addr = ioremap(regs->start, regs->end -
> regs->start);
> +	if (!info->mem[0].internal_addr)
> +		goto out_free;
> +
> +	info->mem[0].size = regs->end - regs->start;
> +	info->mem[0].memtype = UIO_MEM_PHYS;
> +
You have an off-by-1 in the resource size. ioremap and struct resource
are not equal in their expectations. You probably want to do something
like:

	info->mem[0].size = regs->end - regs->start + 1;
	info->mem[0].internal_addr = ioremap(regs->start, info->mem[0].size);
	...

and make sure that your resource end doesn't overlap with a start address
of an unrelated resource in your definition. /proc/iomem tends to be
useful for this.
