Return-Path: <linux-kernel-owner+w=401wt.eu-S934382AbXJPRw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934382AbXJPRw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbXJPRwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:52:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbXJPRwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:52:49 -0400
Date: Tue, 16 Oct 2007 10:52:23 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: vitalivanov@gmail.com
Cc: Willy Tarreau <w@1wt.eu>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       zaitcev@redhat.com
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-Id: <20071016105223.a0a8fe8c.zaitcev@redhat.com>
In-Reply-To: <1192542889.29039.66.camel@dell1.softservecom.com>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	<20071014182542.GA2832@1wt.eu>
	<35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	<20071014223921.GA4677@1wt.eu>
	<1192542889.29039.66.camel@dell1.softservecom.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 16:54:49 +0300, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:

> Again, comments are welcomed.

It looks like you misunderstood why a static lock protects open counts.
This is done so you do not need to worry about in-structure lock which
can be freed together with the structure. Look at this:

> +static int adu_release_internal(struct adu_device *dev)
> +{
> +	/* lock this device */
> +	down(&dev->sem);
> +	/* decrement our usage count for the device */
> +	--dev->open_count;
> +	if (dev->open_count <= 0) {
> +		adu_abort_transfers(dev);
> +		dev->open_count = 0;
> +	}
> +	/* unlock this device */
> +	up(&dev->sem);

The dev->sem is entirely unnecessary here. Every time you use
open_count, it's protected by minor_table_mutex. The name is a litte
unfortunate, feel free to rename it.

This is probably a problem in 2.6 as well. I don't know why people keep
writing these things. Someone at Ontrak needs to look into it.

-- Pete
