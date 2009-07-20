Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZGTVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZGTVRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZGTVRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:17:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57841 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZGTVRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:17:18 -0400
Date: Mon, 20 Jul 2009 17:16:44 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, Brayan Arraes <brayan@yack.com.br>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
	handler"
Message-ID: <20090720211644.GD9060@hmsreliant.think-freely.org>
References: <4A64672E.8020005@cn.fujitsu.com> <m1d47vnoq6.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d47vnoq6.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 12:22:57PM -0700, Eric W. Biederman wrote:
> Lai Jiangshan <laijs@cn.fujitsu.com> writes:
> 
> > 1) This fix breaks our tools.
> >       This fix changes the ABI. panic_on_oops is default 0,
> >    and a lots system do not specify the boot option "panic",
> >    thus, Sysrq-c will not cause CrashDump(Kdump) as expected.
> 
> How does it break your tools?
> 
Well, upstream doesn't really care about ABI stability, particularly in the
sysrq space.  That aside however, it seems like sysrq-c is doing the right thing
with my patch in place, namely, attempting to crash the system.  If the
panic_on_oops sysctl isn't set, then a crash fails, as expected (unlike the
prior behavior, which forced a kexec reboot of the system while ignoring the
sysctl, which seems like it would be labeled the unexpected behavior to me.
Regardless, it seems like the right thing to do if you want sysrq-c to do the
right thing from the start is set panic on the kernel command line.  Not sure
what the problem is there. 

> > 2) When CONFIG_KEXEC=n, Sysrq-c should become an invalid
> >    command like Sysrq-D(CONFIG_LOCKDEP, show-all-locks).
> >    But this fix makes it a valid command and let it do a
> >    hazard thing: cause a page fault(NULL dereference) in kernel.
> >
> > So, we revert this fix.
> 
> The idea was to extend sysrq-d to also be a way of testing NULL
> pointer dereferences.  How is that a bad idea?
> 
Agreed, about the only thing that I see as wrong with my change is that I
neglected to change the documentation.  Prior to my change, the behavior was
completely muddled.  Sysrq-c would do one of 3 things:

1) If kexec wasn't built into the kernel, it would do nothing
2) If kexec was built into the kernel but not enabled, it would try and fail to
execute a kdump
3) if kdump was enabled and configured, it would crash

Under the current implementation, you can always crash the kernel (assuming
you've enabled sysrq, and have permission to use it), which will trigger a kdump
(or just crash the system, which is usefull for development in and of its own
right), or will simply record and oops (if panic_on_oops is clear).  The only
case that left open is booting a kdump kernel without handling a bad page fault,
which you can do from user space anyway via the kexec -e command.  I fail to see
how the previous implementation is superior.
Neil

> Eric
> 
