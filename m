Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYLXLp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYLXLp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 06:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYLXLpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 06:45:47 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37881 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYLXLpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 06:45:46 -0500
Date: Wed, 24 Dec 2008 03:44:14 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/7][v4] Container-init signal semantics
Message-ID: <20081224114414.GA7879@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Container-init must behave like global-init to processes within the
container and hence it must be immune to unhandled fatal signals from
within the container (i.e SIG_DFL signals that terminate the process).

But the same container-init must behave like a normal process to 
processes in ancestor namespaces and so if it receives the same fatal
signal from a process in ancestor namespace, the signal must be
processed.

Implementing these semantics requires that send_signal() determine pid
namespace of the sender but since signals can originate from workqueues/
interrupt-handlers, determining pid namespace of sender may not always
be possible or safe.

This patchset implements the design/simplified semantics suggested by
Oleg Nesterov.  The simplified semantics for container-init are:

	- container-init must never be terminated by a signal from a
	  descendant process.

	- container-init must never be immune to SIGKILL from an ancestor
	  namespace (so a process in parent namespace must always be able
	  to terminate a descendant container).

	- container-init may be immune to unhandled fatal signals (like
	  SIGUSR1) even if they are from ancestor namespace (SIGKILL is
	  the only reliable signal from ancestor namespace).

Patches in this set:

	[PATCH 1/7] Remove 'handler' parameter to tracehook functions
	[PATCH 2/7] Protect init from unwanted signals more
	[PATCH 3/7] Define siginfo_from_ancestor_ns()
	[PATCH 4/7] Protect cinit from unblocked SIG_DFL signals
	[PATCH 5/7] Protect cinit from blocked fatal signals
	[PATCH 6/7] SI_USER: Masquerade si_pid when crossing pid ns boundary
	[PATCH 7/7] SI_TKILL: Masquerade si_pid when crossing pid ns boundary

Changelog[v4]:
	- Remove SIGNAL_UNKILLABLE_FROM_NS flag and simplify logic as
	  suggested by Oleg Nesterov.
	- Check ns == NULL in siginfo_from_ancestor_ns() (Patch 3/7). 
	  Although http://lkml.org/lkml/2008/12/16/502 makes it less likely
	  that ns == NULL, looks like an explicit check won't hurt ?
	- Dropped patch that set SIGNAL_UNKILLABLE_FROM_NS and set
	  SIGNAL_UNKILLABLE in patch 5/7 to be bisect-safe.
	- Add a warning in rt_sigqueueinfo() if SI_ASYNCIO is used
	  (patch 3/7)
	- Added two patches (6/7 and 7/7) to masquerade si_pid for
	  SI_USER and SI_TKILL


Changelog[v3]:
	Changes based on discussions of previous version:
		http://lkml.org/lkml/2008/11/25/458

	Major changes:

	- Define SIGNAL_UNKILLABLE_FROM_NS and use in container-inits to
	  skip fatal signals from same namespace but process SIGKILL/SIGSTOP
	  from ancestor namespace.
	- Use SI_FROMUSER() and si_code != SI_ASYNCIO to determine if
	  it is safe to dereference pid-namespace of caller. Highly
	  experimental :-)
	- Masquerading si_pid when crossing namespace boundary: relevant
	  patches merged in -mm and dropped from this set.

	Minor changes:

	- Remove 'handler' parameter to tracehook functions
	- Update sig_ignored() to drop SIG_DFL signals to global init early
	  (tried to address Roland's  and Oleg's comments)
	- Use 'same_ns' flag to drop SIGKILL/SIGSTOP to cinit from same
	  namespace


TODO:
	- Use sig_task_unkillable() in fs/proc/array.c:task_sig()
	  to correctly report ignored signals for container/global
	  init.


Limitations/side-effects of current design

	- Container-init is immune to suicide - kill(getpid(), SIGKILL) is
	  ignored. Use exit() :-)
