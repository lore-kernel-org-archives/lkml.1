Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXAXNWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXAXNWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXAXNWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:22:00 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3778 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXAXNV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:21:59 -0500
Date: Wed, 24 Jan 2007 08:21:03 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.com, torvalds@osdl.com
Subject: Re: [PATCH] select: fix sys_select to not leak ERESTARTNOHAND to userspace
Message-ID: <20070124132103.GA4795@hmsreliant.homelinux.net>
References: <20070116201332.GA28523@hmsreliant.homelinux.net> <20070123.215926.85409740.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123.215926.85409740.davem@davemloft.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 09:59:26PM -0800, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Tue, 16 Jan 2007 15:13:32 -0500
> 
> > As it is currently written, sys_select checks its return code to convert
> > ERESTARTNOHAND to EINTR.  However, the check is within an if (tvp) clause, and
> > so if select is called from userspace with a NULL timeval, then it is possible
> > for the ERESTARTNOHAND errno to leak into userspace, which is incorrect.  This
> > patch moves that check outside of the conditional, and prevents the errno leak.
> > 
> > Signed-Off-By: Neil Horman <nhorman@tuxdriver.com>
> 
> As has been probably mentioned, this change is bogus.
> 
> core_sys_select() returns -ERESTARTNOHAND in exactly the
> case where that return value is legal, when a signal is
> pending, so that the signal dispatch code (on return from
> the system call) will "fixup" the -ERESTARTNOHAND return
> value so that userspace does not see it.
> 
> What could be happening is that, somehow, we see the signal
> pending in core_sys_select(), but for some reason by the time
> the signal dispatch code would run, the signal is cleared.
> 
> I always found this scheme a little fishy, relying on signal
> pending state to guarentee the fixup of the syscall restart
> error return values.
> 
> For example, I see nothing that prevents another thread sharing
> this signal state from clearing the signal between the syscall
> checking in the other thread and the signal dispatch check running
> in that other thread.
> 
> 	cpu 1			cpu 2
> 	check sigpending
> 				clear signal
> 	syscall return
> 	no signal panding
> 	get -ERESTARTNOHAND
> 
> Perhaps something makes this no happen, but I don't see it :)
This is exactly the theory that I've been tossing around with the person that
reported it to me.  We're still witing on a reproduer, but I'm currently working
on a multithreaded test case to try and trigger user space leaks of
ERESTARTNOHAND to user space.

Neil

