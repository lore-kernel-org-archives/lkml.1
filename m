Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbXJORa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbXJORa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbXJORar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:30:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbXJORaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:30:46 -0400
Date: Mon, 15 Oct 2007 10:30:33 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Vitaliy Ivanov" <vitalivanov@gmail.com>
Cc: "Willy Tarreau" <w@1wt.eu>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       zaitcev@redhat.com
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-Id: <20071015103033.65b47dea.zaitcev@redhat.com>
In-Reply-To: <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	<20071014182542.GA2832@1wt.eu>
	<35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007 23:45:36 +0300, "Vitaliy Ivanov" <vitalivanov@gmail.com> wrote:

> Also IMHO the more drivers are in the tree the more users will use it.
> Once it will be merged in the mainline then it will be backported to
> enterprise kernels and would gain wide usage.

At least in case of RHEL, such backports never were automatic. In any
case, RHEL 2.1 and 3 do not receive new drivers anymore. We only do
bugfixes if something comes up. Realistically speaking, 2.4 kernels
are just too old for anyone to use. So, I think it would be best for
you to think in terms of Willy's tree only.

> +	in_end_size = le16_to_cpu(dev->interrupt_in_endpoint->wMaxPacketSize);
> +	out_end_size = le16_to_cpu(dev->interrupt_out_endpoint->wMaxPacketSize);

Did you verify if this works? We use pre-swapped descriptors in 2.4.
I suspect you allocate 256 times more memory than necessary.

> +static void adu_delete(struct adu_device *dev)
> +	kfree(dev);

> +static int adu_release_internal(struct adu_device *dev)
> +	if (dev->udev == NULL) {
> +		adu_delete(dev);

> +static int adu_open(struct inode *inode, struct file *file)
> +	retval = adu_release_internal(dev);
> +	up(&dev->sem);

The above very clearly is a use-after-free, in case the device was
open across a disconnect. Solution: Use minor_table_mutex to lock
dev->open_count instead of dev->sem. There's no rule that the lock
has to live inside the same structure with members it locks.

-- Pete
