Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYGNGXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYGNGXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYGNGXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:23:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:55288 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYGNGXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kQ6K2b43pNq+xCc+47mGpTjy4u7Q36GTUjDOwq6t9F3emqNqRRnxxYsF4vOeZ45XEB
         QTIKSYyQOp+YrS1jRpR3eEe+aSc4zlTKI8KhRGu4b9B5eA1bfbRPESFUu1mG2CnuEm6p
         paszVe088SgNIjkWBS42wWknWMIU5TwV825fM=
Message-ID: <19f34abd0807132323r3c919aq88ecaf572da765cb@mail.gmail.com>
Date: Mon, 14 Jul 2008 08:23:40 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [RFC][-rc9 PATCH] Bluetooth: fix oops in rfcomm
Cc: "Soeren Sonnenburg" <kernel@nn7.de>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <a8e1da0807131941n4697cb14g1cfbb0bb3ad74f50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080713172318.GA6180@damson.getinternet.no>
	 <a8e1da0807131941n4697cb14g1cfbb0bb3ad74f50@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 4:41 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> This patch attempts to correct this by only removing the device from the
>> internal rfcomm list of devices at the final unregister, so that the id
>> won't get reused until the device has been completely destructed.
>
> It looks good, I agree with your change.

Thanks for looking!

>        if (IS_ERR(dev->tty_dev)) {
>                err = PTR_ERR(dev->tty_dev);
>                list_del(&dev->list);
>                kfree(dev);
>                return err;
>        }
>
> The list_del need to be protected as well.

After looking at the code once again I wonder if we should not extend
the protection even a bit further. Just below, we have this:

        if (device_create_file(dev->tty_dev, &dev_attr_address) < 0)

..which means that we could theoretically get here, be preempted by
another process which 1. releases the device id, and 2. recreates the
same device id. When we resume execution of the first task,
device_create_file() would be called for a file that already exists.

Should the rfcomm_dev_lock be extended to include protecting these
things as well? It seems somehow wrong, but I am not sure how it
should be done correctly either.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
