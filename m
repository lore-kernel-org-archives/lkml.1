Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbXINP43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbXINP43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 11:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXINP4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 11:56:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36142 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXINP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 11:56:21 -0400
Date: Fri, 14 Sep 2007 16:56:01 +0100 (BST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Luca Risolia <luca.risolia@studio.unibo.it>
cc: aherrman@arcor.de, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l: fix build error for et61x251 driver
In-Reply-To: <200709141557.56514.luca.risolia@studio.unibo.it>
Message-ID: <Pine.LNX.4.64.0709141514400.16359@pentafluge.infradead.org>
References: <20070913123627.GD10348@devil> <20070914074852.GA5598@devil>
 <1189774211.5292.44.camel@gaivota> <200709141557.56514.luca.risolia@studio.unibo.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> through ioctl()? It's not as immediate and safe as controlling the device
> registers through /sysfs (not /proc). However, the sysfs interface in those
> drivers appeared before V4L2 had its own ioctls and we agreed to keep and
> export the interface to the only users selecting CONFIG_VIDEO_ADV_DEBUG (ok,
> this is actually valid for the sn9c102, I'll submit a patch for the et61x251
> in the future).

Direct register access for debug ok, but not this is not ok for 
normal usage.
>
>
>> From my POV, a driver that is creating its own userspace API is not
>> fully compliant with V4L2 API.
>
> Isn't Video4Linux2 ioctl() supersedeing sysfs in this case?

It should be. However, things like direct register access (for non-debug 
mode) may allow some controls that weren't visible via ioctl. That's why 
the sysfs usage may be evil: a driver may have some parts accessible only 
via sysfs interface, on a non-standard way, without offering the official 
API support. So, some device functionalities may be hidden from userspace 
apps that are compliant with V4L2.

Summarizing:

Linus patch seems to be the better solution to solve the V4L1_COMPAT bug.

I would also convert the other container_of stuff to to_video_device (to 
have code uniformity).

et61x251 direct register interfaces should be available only if 
CONFIG_VIDEO_ADV_DEBUG is selected to avoid its miss-usage. If there are 
other device configurations that needs specific register settings not yet 
provided, this should be provided via V4L2 standard ioctls.

This way, et61x251 will be compliant with V4L2.

I still think that we should work at the remaining sysfs classes to make 
them coherent on all V4L devices.

Cheers,
Mauro.
