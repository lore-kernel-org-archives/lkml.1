Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXLVKM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXLVKM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXLVKMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:12:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXLVKMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:12:17 -0500
Date: Sat, 22 Dec 2007 02:11:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Masters <jcm@redhat.com>
Cc: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
Message-Id: <20071222021135.68becd45.akpm@linux-foundation.org>
In-Reply-To: <1198317171.24423.47.camel@perihelion>
References: <20071217234314.540b59bd@hammerfall>
	<20071222013021.db2528cb.akpm@linux-foundation.org>
	<1198317171.24423.47.camel@perihelion>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 04:52:50 -0500 Jon Masters <jcm@redhat.com> wrote:

> > The general approach we've taken to this is "don't do that".  Yes, we could
> > boost lots of kernel threads in the way which this patch does but this
> > actually takes control *away* from userspace.  Userspace no longer has the
> > ability to guarantee itself minimum possible latency without getting
> > preempted by kernel threads.
> > 
> > And yes, giving userspace this minimum-latency capability does imply that
> > userspace has a responsibility to not 100% starve kernel threads.  It's a
> > reasonable compromise, I think?
> 
> So, user tasks running with SCHED_FIFO should be able to lock a system?

yup.  root can damage the system in all sorts of ways.

> I guess I see both sides of this argument - yes, it's userspace at
> fault, but in other cases when userspace is at fault, we take action
> (OOM, segfault, others). Isn't this situation just another case where
> the kernel needs to avoid the evils of userland going awry?

Well...  the problem is that if we add a safety net to catch run-away
SCHED_FIFO processes, we've permanently degraded the service which we
provide to well-behaved programs.

Should there be a watchdog which checks for a process which has run
realtime for a certain period and which then takes some action?  Such as
descheduling it for a while, generating warnings, demoting its policy,
killing it etc?
