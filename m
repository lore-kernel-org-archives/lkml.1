Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab0CJVVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:21:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab0CJVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:21:03 -0500
Date: Wed, 10 Mar 2010 22:19:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait_for_helper: SIGCHLD from user-space can lead to
	use-after-free
Message-ID: <20100310211923.GA6485@redhat.com>
References: <20100310171634.GA1039@redhat.com> <20100310203209.54168BCCD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310203209.54168BCCD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Roland McGrath wrote:
>
> SIGCHLD being blocked doesn't affect reaping, so SIG_IGN or sa_flags &
> SA_NOCLDWAIT is the only thing that would do this.  How does that come
> about here in this kthread?  Is it inherited from the instigating user
> process?  If so, then SA_NOCLDWAIT is as much a problem as SIG_IGN.
> Or I guess maybe it's from ignore_signals() in kthreadd()?
> In that case SIG_IGN is indeed all that matters.  (I don't really
> know all the kthread/kmod/userhelper code organization.)

Yes. kthreads run with all signal ignored, this is inherited from
kthreadd() which does ignore_signal().

> Perhaps it would be cleaner to do:
>
> 	flush_signal_handlers(current, 1);
>
> in wait_for_helper

I don't think this can work. SIG_DFL for SIGCHLD is OK because it is
sig_kernel_ignore(). But, say, SIGHUP and other signals still should
be ignored, otherwise we have the same problems with the unwanted
signal_pending() this patch tries to avoid.

But even if we could do this,

> That should make it redundant in ____call_usermodehelper,
> so it could be removed from there.

Please note that __call_usermodehelper() forks ____call_usermodehelper() too.

Oleg.

