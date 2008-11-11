Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbYKKW0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbYKKW0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYKKWZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:25:32 -0500
Received: from vena.lwn.net ([206.168.112.25]:37013 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbYKKWZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:25:30 -0500
Date: Tue, 11 Nov 2008 15:25:27 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver
Message-ID: <20081111152527.3c55bd6d@bike.lwn.net>
In-Reply-To: <491A0483.3010504@redhat.com>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
	<1226409701-14831-2-git-send-email-ieidus@redhat.com>
	<1226409701-14831-3-git-send-email-ieidus@redhat.com>
	<1226409701-14831-4-git-send-email-ieidus@redhat.com>
	<20081111150345.7fff8ff2@bike.lwn.net>
	<491A0483.3010504@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 00:17:39 +0200
Izik Eidus <ieidus@redhat.com> wrote:

> >> +static int ksm_dev_open(struct inode *inode, struct file *filp)
> >> +{
> >> +	try_module_get(THIS_MODULE);
> >> +	return 0;
> >> +}
> >> +
> >> +static int ksm_dev_release(struct inode *inode, struct file *filp)
> >> +{
> >> +	module_put(THIS_MODULE);
> >> +	return 0;
> >> +}
> >> +
> >> +static struct file_operations ksm_chardev_ops = {
> >> +	.open           = ksm_dev_open,
> >> +	.release        = ksm_dev_release,
> >> +	.unlocked_ioctl = ksm_dev_ioctl,
> >> +	.compat_ioctl   = ksm_dev_ioctl,
> >> +};
> >>       
> >
> > Why do you roll your own module reference counting?  Is there a
> > reason you don't just set .owner and let the VFS handle it?
> >     
> 
> Yes, I am taking get_task_mm() if the module will be removed before i 
> free the mms, things will go wrong

But...if you set .owner, the VFS will do the try_module_get() *before*
calling into your module (as an added bonus, it will actually check the
return value too).  All you've succeeded in doing here is adding a
microscopic race to the module reference counting; otherwise the end
result is the same.

jon
