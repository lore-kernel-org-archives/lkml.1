Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbXAXHot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbXAXHot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933194AbXAXHot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:44:49 -0500
Received: from gw.exalead.com ([193.47.80.25]:18401 "EHLO exalead.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933195AbXAXHos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:44:48 -0500
Message-ID: <45B70E6B.40104@exalead.com>
Date: Wed, 24 Jan 2007 08:44:43 +0100
From: Xavier Roche <roche+kml2@exalead.com>
Organization: Exalead
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1b2) Gecko/20060821 SeaMonkey/1.1a
MIME-Version: 1.0
To: Nicholas Miell <nmiell@comcast.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: sigaction's ucontext_t with incorrect stack reference when	SA_SIGINFO
 is being used ?
References: <45B47C68.2000903@exalead.com> <1169530677.2995.8.camel@entropy>
In-Reply-To: <1169530677.2995.8.camel@entropy>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Miell wrote:
> so if uc_stack doesn't point to the stack in use immediately prior to
> signal generation, this is a bug.

Looking at arch/i386/kernel/signal.c (and others) inside
setup_rt_frame(), the problem is pretty obvious:

err |= __put_user(current->sas_ss_sp, &frame_user->uc.uc_stack.ss_sp);
err |= __put_user(sas_ss_flags(regs->esp),
	&frame->uc.uc_stack.ss_flags);
err |= __put_user(current->sas_ss_size, &frame_user->uc.uc_stack.ss_size);

And of course, the ss_sp is NULL when no alternative stack is used.
Seems definitively a bug.

However, my reading of include/linux/sched.h and thread_info.h did not
enlighten me on the way to get the original thread's stack base and size.

