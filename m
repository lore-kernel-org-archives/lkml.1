Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYLWEtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYLWEtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYLWEtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:49:12 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57908 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbYLWEtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:49:12 -0500
Date: Mon, 22 Dec 2008 20:47:45 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 4/6][v3] Define siginfo_from_ancestor_ns()
Message-ID: <20081223044745.GA16832@us.ibm.com>
References: <20081221005106.GA4912@us.ibm.com> <20081221005424.GD5025@us.ibm.com> <20081222222604.GA1536@redhat.com> <20081222230133.GD1536@redhat.com> <20081222235837.GC13079@us.ibm.com> <20081223002215.GA7984@redhat.com> <m13agf68a7.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13agf68a7.fsf@frodo.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| Oleg Nesterov <oleg@redhat.com> writes:
| 
| >> I was going through the ->si_pid assignments to try and fix them at
| >> source (like the mqueue patch I sent last week).
| >
| > OK.
| 
| Note.  When a signal goes to a process group (or similar) we can't fix
| si_pid at the source.  We have to fix it when only a single destination
| process is known.  It doesn't mean that fixing it at the source
| is hopeless but...  

Right. Most calls to kill_pgrp_info() and __kill_pgrp_info() use
SEND_SIG_PRIV or SEND_SIG_NOINFO, so their ->si_pid is set.
The only place seems to be the sys_kill()/sys_tkill().

| 
| >> The two cases that don't fit the model are sys_kill() and sys_tkill().
| >> For that I was hoping we could use siginfo_from_user() again. i.e
| >>
| >> 	if (siginfo_from_user())
| >> 		masquerade_si_pid()
| >>
| >> in the default: case of send_signal(). To be safe, masquerade_si_pid()
| >> could do it only iff si_code is either SI_USER or SI_TKILL.
| >>
| >> IOW, with some tweaks, I am trying to see if we can use siginfo_from_user()
| >> in place of the SIG_FROM_USER.
| >
| > sys_rt_sigqueueinfo().
| >
| > But, perhaps we can just ignore the problems with sigqueueinfo() (and
| > document them). 

Yes, thats one reason I was thinking of checking si_code == SI_USER or
SI_TKILL, but rt_sigqueueinfo() could still use those values too.

In fact it could use SI_ASYNCIO :-) and mess with sig_from_user() (i.e
if rt_sigqueueinfo() sets si_code to SI_ASYNCIO and sends SIGKILL/SIGSTOP
to a descendant cinit, SIGKILL/SIGSTOP will be ignored).

We could/should warn if rt_sigqueueinfo() sets si_code to SI_ASYNCIO.

One more reason to make SI_ASYNCIO a kernel signal I guess.

| 
| Yes.  I don't think si_pid is valid in that case anyway.  It is the
| kernel signals where si_pid is a reliable field that are important.
| 
| Eric

Sukadev
