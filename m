Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYLVWRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYLVWRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYLVWQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:16:49 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55113 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYLVWQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:16:47 -0500
Date: Mon, 22 Dec 2008 14:15:22 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org, gregkh@suse.de
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC][PATCH] SI_ASYNCIO: should be a kernel signal ?
Message-ID: <20081222221522.GC10183@us.ibm.com>
References: <20081221010414.GA5284@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221010414.GA5284@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| 
| From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| Date: Fri, 19 Dec 2008 20:45:49 -0800
| Subject: [RFC][PATCH] SI_ASYNCIO: should be a kernel signal ?
| 
| SI_ASYNCIO is currently defined as -4 in the kernel. This makes it appear
| like a "user" signal (i.e SI_FROMUSER() is true). SI_ASYNCIO is generated
| by the kernel for async events like SI_MESGQ and SI_POLL, but unlike
| SI_ASYNCIO, SI_MESGQ and SI_POLL are "kernel" signals (i.e SI_FROMKERNEL()
| is true).
| 
| Shouldn't SI_ASYNCIO be a "kernel" signal too ? It is currently generated
| from USB core code.
| 
| This quick/untested RFC patch changes the in-kernel value of SI_ASYNCIO
| as follows so that it becomes a "kernel" signal.
| 
| 	(7 << 16)|(-4 & 0xffff) = 0x7fffc which is SI_FROMKERNEL().
| 
| The user-space value of SI_ASYNCIO continues to be -4.
| 
| Known side-effects:
| 
| 	Is this required to be SI_FROMUSER() to enable the uid checks in
| 	kill_pid_info_as_uid() ? Also, changing to "kernel" signal would skip
| 	the permission checks in check_kill_permission().  Would that be a
| 	problem ?
| 
| Why bother now ? (Sigh. Condensed long story)
| 
| 	Besides the consistency with SI_POLL and SI_MESGQ this could simplify
| 	implementation of special signal semantics for container-init.  When a
| 	signal is sent to container-init from user-space, we need to check the
| 	pid namespace of the sender in send_signal(). But since send_signal()
| 	can also be called from interrupt context,  we have no way of knowing
| 	if it is safe to check the pid namespace of the caller.
| 
| 	If SI_ASYNCIO signal appears as a kernel signal, we could possibly use
| 	SI_FROMUSER() to check if it safe to reference the pid namespace of
| 	the sender.
| 
| 	If this change has no other side-effects/breakage we will explore this
| 	path further for the signal semantics for container-init. (There could
| 	be other hurdles along the way...) 
| 
| 	See also http://lkml.org/lkml/2008/12/20/183
| 
| Appreciate any comments on this.
| 
| TODO:
| 	If this makes sense, make corresponding change to the SI_ASYNCIO
| 	in arch/mips/siginfo.h.

Grr. Importantly, we would also need to update the copy_siginfo*() and
friends for this to be complete.
