Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYEWN5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYEWN5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYEWN4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:56:55 -0400
Received: from vena.lwn.net ([206.168.112.25]:39355 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYEWN4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:56:54 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [PATCH] video4linux: Push down the BKL 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Thu, 22 May 2008 22:37:00 BST."
             <20080522223700.2f103a14@core> 
Date: Fri, 23 May 2008 07:56:54 -0600
Message-ID: <9027.1211551014@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
> [...]
> -	.ioctl = video_ioctl2,
> +	.unlocked_ioctl = video_ioctl2,

Weird, that was always intended to be that way, I'm not sure what
happened.  In any case, consider this part to be

	Acked-by: Jonathan Corbet <corbet@lwn.net>

However, in this part:

> diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
> [...]

> +	lock_kernel();
>  	err = __video_do_ioctl(inode, file, cmd, parg);
> +	unlock_kernel();

This forces the BKL on all V4L2 drivers whether or not they need it.
Given that this code can, in fact, be a path where latency matters
(consider VIDIOC_DQBUF), I'm not sure that's the best way to do it.

On the other hand, the next level of BKL pushdown would be painful as
all hell, given the massive number of callbacks in the V4L2 API.  So I'm
thinking it might be justified to create a video_ioctl2_locked() for
V4L2 drivers which are not yet known to be safe in the absence of the
BKL.  The amount of extra code would be quite small, and it would let
safe drivers operate BKL-free.

jon
