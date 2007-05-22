Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbXEVATA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbXEVATA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXEVASw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:18:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36694 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbXEVASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:18:52 -0400
Date: Tue, 22 May 2007 01:18:51 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, kenchen@google.com, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Message-ID: <20070522001851.GE4095@ftp.linux.org.uk>
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 03:00:55PM -0700, akpm@linux-foundation.org wrote:
> +	if (register_blkdev(LOOP_MAJOR, "loop"))
> +		return -EIO;
> +	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
> +				  THIS_MODULE, loop_probe, NULL, NULL);
> +
> +	for (i = 0; i < nr; i++) {
> +		if (!loop_init_one(i))
> +			goto err;
> +	}
> +
> +	printk(KERN_INFO "loop: module loaded\n");
> +	return 0;
> +err:
> +	loop_exit();

This isn't good.  You *can't* fail once a single disk has been registered.
Anyone could've opened it by now.

IOW, you need to
	* register region *after* you are past the point of no return
	* either not fail on failing loop_init_one() here, or separate
allocations and actual add_disk().
