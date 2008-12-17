Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758321AbYLQBwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbYLQBwE (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYLQBvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:51:51 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36426 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYLQBvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:51:50 -0500
Date: Tue, 16 Dec 2008 17:50:50 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>, bastian@waldi.eu.org,
        sukadev@us.ibm.com, Albert Cahalan <acahalan@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix si_pid in send_signal() for SEND_SIG_NOINFO
Message-ID: <20081217015050.GA1850@us.ibm.com>
References: <20081213024129.GB4256@us.ibm.com> <20081215143723.GA22386@redhat.com> <20081215203715.GC11958@us.ibm.com> <20081216101621.GA2784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216101621.GA2784@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| > Ok. so should I change it to task_pid_nr_ns() ?
| 
| I don't know. I vote for your patch as is. (but please update
| the changelog).

Well, to keep the patch descriptions simple, how about I split the
two changes into two patches. First one masquerades ->si_pid with
task_pid_nr_ns() and second one uses task_tgid_nr_ns(). They
do look like unrelated changes.

| 
| > Would that still
| > be correct for say the SIGPIPE from pipe_write() ?
| 
| Again, I don't know.
| 
| But. Let's suppose we have the user-space application which
| uses .si_pid to figure out which thread hits SIGPIPE. Yes,
| this is ugly because the signal is thread-specific, but this
| works until this patch.

I have highlighted this and the the reparent-thread behavior
changes in the patch description.

| 
| Actually, I don't understand most of (all?) users of
| send_signal(SIGXXX, current, 0), SEND_SIG_PRIV looks more
| logical to me. Or, _perhaps_, we need yet another SEND_SIG_SELF
| which sets .si_pid = task_pid_vnr(target).

Ok. We have to change the __si_special() indirection or how about
removing it altogether and change uses of __si_special() to one of:

	{ SEND_SIG_NOINFO, SEND_SIG_PRIV, SEND_SIG_SELF, &info }

It would add a condition check in places like:

	disassociate_ctty(): kill_pgrp(old_pgrp, SIGHUP, on_exit);

but there aren't too many of those.
