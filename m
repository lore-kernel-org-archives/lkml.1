Return-Path: <linux-kernel-owner+w=401wt.eu-S1030211AbXAXF7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030211AbXAXF7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 00:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030214AbXAXF7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 00:59:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53678
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030211AbXAXF7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 00:59:37 -0500
Date: Tue, 23 Jan 2007 21:59:26 -0800 (PST)
Message-Id: <20070123.215926.85409740.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.com, torvalds@osdl.com
Subject: Re: [PATCH] select: fix sys_select to not leak ERESTARTNOHAND to
 userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070116201332.GA28523@hmsreliant.homelinux.net>
References: <20070116201332.GA28523@hmsreliant.homelinux.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 16 Jan 2007 15:13:32 -0500

> As it is currently written, sys_select checks its return code to convert
> ERESTARTNOHAND to EINTR.  However, the check is within an if (tvp) clause, and
> so if select is called from userspace with a NULL timeval, then it is possible
> for the ERESTARTNOHAND errno to leak into userspace, which is incorrect.  This
> patch moves that check outside of the conditional, and prevents the errno leak.
> 
> Signed-Off-By: Neil Horman <nhorman@tuxdriver.com>

As has been probably mentioned, this change is bogus.

core_sys_select() returns -ERESTARTNOHAND in exactly the
case where that return value is legal, when a signal is
pending, so that the signal dispatch code (on return from
the system call) will "fixup" the -ERESTARTNOHAND return
value so that userspace does not see it.

What could be happening is that, somehow, we see the signal
pending in core_sys_select(), but for some reason by the time
the signal dispatch code would run, the signal is cleared.

I always found this scheme a little fishy, relying on signal
pending state to guarentee the fixup of the syscall restart
error return values.

For example, I see nothing that prevents another thread sharing
this signal state from clearing the signal between the syscall
checking in the other thread and the signal dispatch check running
in that other thread.

	cpu 1			cpu 2
	check sigpending
				clear signal
	syscall return
	no signal panding
	get -ERESTARTNOHAND

Perhaps something makes this no happen, but I don't see it :)
