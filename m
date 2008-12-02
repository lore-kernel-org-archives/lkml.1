Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbYLBT7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbYLBT7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYLBT7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:59:38 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:37262 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYLBT7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:59:37 -0500
Date: Tue, 2 Dec 2008 11:59:04 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>, oleg@redhat.com,
       ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: Re: [RFC][PATCH 3/5] Determine if sender is from ancestor ns
Message-ID: <20081202195904.GA20077@us.ibm.com>
References: <20081126034242.GA23120@us.ibm.com> <20081126034611.GC23238@us.ibm.com> <20081127010101.GA13545@wavehammer.waldi.eu.org> <20081201201506.GB12493@us.ibm.com> <20081202114833.GA1132@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202114833.GA1132@wavehammer.waldi.eu.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastian Blank [bastian@waldi.eu.org] wrote:
| On Mon, Dec 01, 2008 at 12:15:06PM -0800, Sukadev Bhattiprolu wrote:
| > Bastian Blank [bastian@waldi.eu.org] wrote:
| > | If I see this correctly this information is already covered in si_code
| > | with SI_USER and SI_TKILL. SI_KERNEL is used for explicit kernel
| > | generated signals.
| > 
| > Yes, but si_code from sys_rt_sigqueueinfo() cannot be trusted.
| 
| sys_rt_sigqueueinfo disallows setting si_code to any value which
| describes kernel signals from userspace. So using SI_FROMUSER should be
| sufficient.

Hmm, unless I am missing something, sys_rt_sigqueuinfo() does this:

        if (info.si_code >= 0)
                return -EPERM;

This does not prevent user from setting si_code to SI_ASYNCIO, which,
from include/asm-generic/siginfo.h is:

#define SI_ASYNCIO      -4              /* sent by AIO completion */

Also,

#define SI_FROMUSER(siptr)      ((siptr)->si_code <= 0)

SI_ASYNCIO qualifies as SI_FROMUSER() even when it originates from
kernel (usb/core/devio.c async_completed())...

| 
| > IOW, we need to find the namespace of the sender only if the sender is
| > a user process. If signal is originating from kernel, safely checking
| > namespace becomes more complex.
| 
| Where does this imply checking sender for kernel generated signals?

... so what I meant is that in send_signal(), it will be harder to
determine in the SI_ASYNCIO case whether the signal is from driver or
rt_sigqueueinfo().

If we know that it came from rt_sigqueueinfo(), we can safely check
the namespace. If it came from driver we should skip the ns check.

| 
| > Yes, current approach is somewhat hacky. We tried other approaches
| > before and they were either intrusive or required non-trivial changes
| > to semantics of signals to global init or both.
| 
| Message-IDs?

Yes, (Eric Biederman, Dec 2007)
	https://lists.linux-foundation.org/pipermail/containers/2007-December/009152.html

Oleg Nesterov, Aug 2007:
	http://marc.info/?l=linux-kernel&m=118753610515859

I had sent out a summary of the above attempts to Containers list recently:
	https://lists.linux-foundation.org/pipermail/containers/2008-November/013991.html



| 
| > | > +static inline int siginfo_from_ancestor_ns(struct task_struct *t,
| > | > +			siginfo_t *info)
| > | > +{
| > | > +	if (!is_si_special(info) && (info->si_signo & SIG_FROM_USER)) {
| > | > +		/* if t can't see us we are from parent ns */
| > | What?
| > I assume your question is about the comment :-)
| 
| Yes.
| 
| > Yes, a process can see all its descendants and processes in descendant
| > namespaces. But it can only see its ancestors upto the most recent
| > CLONE_NEWPID. (kind of like chroot in filesystems). So if receiver
| > can't see sender, sender must be an ancestor.
| 
| Please add a complete comment to the function which describes the
| function. And don't us "it" for not defined entities.

Ah, I see the problem now. The 't' refers to the task parameter - how
about changing comment to:

	/* If receiver can't see us, we are from parent ns */


| 
| Bastian
| 
| -- 
| I have never understood the female capacity to avoid a direct answer to
| any question.
| 		-- Spock, "This Side of Paradise", stardate 3417.3
