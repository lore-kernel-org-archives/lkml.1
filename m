Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab0CJSIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:08:25 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51183 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab0CJSIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:08:24 -0500
Date: Wed, 10 Mar 2010 13:07:50 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait_for_helper: SIGCHLD from user-space can lead to
 use-after-free
Message-ID: <20100310180750.GA3770@hmsreliant.think-freely.org>
References: <20100310171634.GA1039@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310171634.GA1039@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 06:16:34PM +0100, Oleg Nesterov wrote:
> (this patch is orthogonal to other umh changes in -mm)
> 
> 1. wait_for_helper() does allow_signal(SIGCHLD) to ensure the child can't
>    autoreap itself.
> 
>    However, this means that a spurious SIGCHILD from user-space can
>    set TIF_SIGPENDING and:
> 
>    	- kernel_thread() or sys_wait4() can fail due to signal_pending()
> 
>    	- worse, wait4() can fail before ____call_usermodehelper() execs
>    	  or exits. In this case the caller may kfree(subprocess_info)
>    	  while the child still uses this memory.
> 
>    Change the code to use SIG_DFL instead of magic "(void __user *)2"
>    set by allow_signal(). This means that SIGCHLD won't be delivered,
>    yet the child won't autoreap itsefl.
> 
>    The problem is minor, only root can send a signal to this kthread.
> 
> 2. If sys_wait4(&ret) fails it doesn't populate "ret", in this case
>    wait_for_helper() reports a random value from uninitialized var.
> 
>    With this patch sys_wait4() should never fail, but still it makes
>    sense to initialize ret = -ECHILD so that the caller can notice
>    the problem.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
