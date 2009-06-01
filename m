Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZFAXqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZFAXqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZFAXp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:45:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbZFAXp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:45:56 -0400
Date: Mon, 1 Jun 2009 16:45:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix floppy hibernation
Message-Id: <20090601164520.281cc4c8.akpm@linux-foundation.org>
In-Reply-To: <200905301804.26762.linux@rainbow-software.org>
References: <200905301804.26762.linux@rainbow-software.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 18:04:25 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> Hello,
> floppy driver was always missing hibernation support. After resume, floppy did
> not work (until a couple of disk reinserts and retries), producing errors like
> this:
> end_request: I/O error, dev fd0, sector 0
> 
> Ingo Molnar tried to fix it in 2006: http://lkml.org/lkml/2006/11/12/92
> 
> 
> 
> 
> Based on Ingo Molnar's patch from 2006, this makes the floppy work after
> resume from hibernation, at least on my machine.
> 
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.29.4-orig/drivers/block/floppy.c	2009-05-30 14:38:29.000000000 +0200
> +++ linux/drivers/block/floppy.c	2009-05-30 17:50:32.000000000 +0200
> @@ -4148,6 +4148,24 @@
>  {
>  }
>  
> +static int floppy_resume(struct platform_device *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < N_FDC; i++)
> +		if (FDCS->address != -1)
> +			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
> +
> +	return 0;
> +}

hm, how does this work?

FDCS is a revolting should-not-exist macro which assumes the presence
of a local variable called `fdc'.

So I think the loop control variable here should be called `fdc', not `i'.

It's pretty amazing that something like this still exists in a core
driver.  Someone please save us!

