Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYKLNxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYKLNxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYKLNww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:52:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39058 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYKLNww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:52:52 -0500
Date: Wed, 12 Nov 2008 15:52:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: sukadev@linux.vnet.ibm.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, daniel@hozac.com,
       Nadia Derbey <Nadia.Derbey@bull.net>, serue@us.ibm.com, clg@fr.ibm.com,
       Containers <containers@lists.osdl.org>, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Signals to cinit
Message-ID: <20081112145226.GA13269@redhat.com>
References: <20081101180505.GA24268@us.ibm.com> <20081110173839.GA11121@redhat.com> <20081110193228.GA15519@redhat.com> <20081110232735.GA20891@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110232735.GA20891@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, sukadev@linux.vnet.ibm.com wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> | (lkml cced because containers list's archive is not useable)
>
> Hmm. what do you mean by not usable ? I see your email here:
> https://lists.linux-foundation.org/pipermail/containers/2008-November/014152.html

Yes, but I failed to find our previous discussions via google, and actually
I prefer to see them all on marc.info, so I can quickly find them...

> | > Or something. yes, sys_rt_sigqueueinfo() is problematic...
>
> Yes, if user-space sets si_pid to 0.
>
> Can we change sys_rt_sigqueueinfo() to:
>
> 	if (!info->si_pid)
> 		info->si_pid = getpid();

I doubt very much we can do this. This can break the existing applications
which can overload ->si_pid. I think it is better to pass ->si_pid as is.
If user-space sends siginfo_t so sub-namespace, it must know what it does.
I don't think the kernel can help, it just can't know what ->si_pid actually
means. Unless this is documented somewhere, but I don't know.

> | But how can send_signal() know that the signal comes from the upper ns?
> | This is not trivial, we can't blindly use current to check. The signal
> | can be sent from irq/workqueue/etc.
>
> You mean the in_interrupt() check we had in earlier patchset would
> not be enough ?

I don't think we can rely on in_interrupt() check. Thnk about some device
drivers which can send the notification from workqueue, or from kernel
thread... Say, can you see when drivers/usb/core/devio.c does
async_completed() ? And note that SI_ASYNCIO is SI_FROMUSER.

Even _if_ it is safe to use in_interrupt() right now, I don't think we
can rely on this fact.

> | Perhaps we can start with something like the patch below. Not that I like
> | it very much though. We should really place this code under
> | CONFIG_I_DO_CARE_ABOUT_NAMESPACES ;)
>
> CONFIG_PID_NS ?

Ah yes, we have it ;)

Oleg.

