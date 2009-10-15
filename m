Return-Path: <linux-kernel-owner+w=401wt.eu-S1762883AbZJOQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762883AbZJOQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbZJOQ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:29:24 -0400
Received: from www.tglx.de ([62.245.132.106]:56013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbZJOQ3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:29:24 -0400
Date: Thu, 15 Oct 2009 18:28:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
In-Reply-To: <20091015164906.5b2c03db@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0910151756350.9428@localhost.localdomain>
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain> <4AD711BC.2030409@garzik.org> <20091015160109.6d9353e8@lxorguk.ukuu.org.uk> <4AD73E40.1010501@garzik.org> <20091015163103.5e42fabe@lxorguk.ukuu.org.uk> <4AD74151.7020306@garzik.org>
 <20091015164906.5b2c03db@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Alan Cox wrote:
> Anyway the case discussed which is ".unlocked_ioctl = NULL" should return
> -ENOTTY, and there isn't any argument about the driver authors intentions.

I think we got some confusion finally. :)

If both unlocked_ioctl and ioctl are NULL the return code is -ENOTTY.

We have locked ioctl functions which return -ENOIOCTLCMD. vfs_ioctl()
returns that to user space, but for unlocked_ioctl it is translated to
-EINVAL. I guess we need to fix that either in the ioctl
implementations or let vfs_ioctl() translate it for locked ioctls as
well.

The other category of ioctls (both locked and unlocked) are the stub
functions which simply return -EINVAL or -ENOIOCTLCMD.

The spec says:
    EINVAL: The request or arg argument is not valid for this device.

    ENOTTY: The fildes argument is not associated with a STREAMS
    	    device that accepts control functions.

So for the stub ioctl functions EINVAL is a correct return value
because the driver has an ioctl function, but does not handle the
request.

But I completely agree, that we should remove those stubs simply
because they handle no request at all which is basically the same as
no ioctl function.

Thanks,

	tglx
