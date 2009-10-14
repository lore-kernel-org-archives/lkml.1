Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbZJNWvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbZJNWvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759689AbZJNWvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:51:55 -0400
Received: from aglcosbs01.cos.agilent.com ([192.25.218.35]:45401 "EHLO
	aglcosbs01.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756946AbZJNWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:51:54 -0400
Message-ID: <4AD655C0.2030202@agilent.com>
Date: Wed, 14 Oct 2009 15:50:40 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: fs/pipe.c null pointer dereference
References: <4AD5D476.6010103@agilent.com> <200910141653.03611.elendil@planet.nl>
In-Reply-To: <200910141653.03611.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2009 22:50:51.0288 (UTC) FILETIME=[C7624980:01CA4D20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> 2.6.21 is really rather ancient for the kernel community and I doubt anyone 
> here will really want to look into issues with it, given that there's a 
> realistic chance it has already been fixed since then. The current stable 
> version is 2.6.31 after all.
> 
> Can you reproduce the oops with a current kernel? Have you checked if there 
> have been any changes in the code you identified since 2.6.21?

I was mostly after some guidance. I'm happy to dig around to figure
out what the problem is and log a bug if indeed I find one.


Yes, I have searched for obvious patches but didn't turn up anything.

I have looked at the code for more recent 2.6.31 kernel on
lxr.linux.no and haven't turned up any appreciable difference.

I have given the matter more thought, and I believe it is unlikely
that the problem is in fs/fifo.c. As outlined in my previous
email, the code looks ok.


I'm a little confused about the switch between the fifo_open()
and the subsequent call to pipe_rdwr_open(). My understanding
is fifo_open() is called during open("/fifo", O_RDWR) which
fills in filp->f_op to point at rdwr_fifo_fops.

Thereafter, a call to close() will vector through filp->f_op
to pipe_rdwr_release().

I'm still puzzled as to how pipe_rdwr_open() is called. The
stack trace says:

Call Trace:
  [<ffffffff8028125c>] __dentry_open+0x13c/0x230
  [<ffffffff8028143d>] do_filp_open+0x2d/0x40
  [<ffffffff802814aa>] do_sys_open+0x5a/0x100
  [<ffffffff8021faf3>] sysenter_do_call+0x1b/0x67

I figure that the fileoperation for the fifo inode must be
revectored to rdwr_fifo_fops --- but I can't see that's
done exactly.

Any hints as to where to look for this ?


In any case, my current guess as to how this happens is that
there might be window of time between do_sys_open() ... pipe_rdwr_open()
where the inode is obtained and the fileoperation pointer is
followed to get to pipe_rdwr_open().

During that window of time, might it be possible for the fifo
to be closed and the underlying pipe released?


Where can I look to see if this is possible?

Earl


