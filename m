Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbZGNUik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbZGNUik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbZGNUik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:38:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45241 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZGNUij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:38:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=BwFBOyyty9ukBgLJYNRsMq89sqLPypVtf7rH4r553z58FCJ3u4TNDDJvk5ERe69wp
	ryFA//VYiUCOS+hOE1m7Q==
MIME-Version: 1.0
In-Reply-To: <6599ad830907141043s1c16d5c9saad9118c210ecef4@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090705063850.GX11273@balbir.in.ibm.com>
	 <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com>
	 <20090713121138.GC5051@balbir.in.ibm.com>
	 <6599ad830907130926v7788af12hdcd76e4ccb3ab6de@mail.gmail.com>
	 <20090714055638.GI5051@balbir.in.ibm.com>
	 <6599ad830907132349u6cf52060t4fafb6637cbe4ed1@mail.gmail.com>
	 <20090714071617.GK5051@balbir.in.ibm.com>
	 <2f86c2480907141034r5a985cfue9e8fdf64ad28465@mail.gmail.com>
	 <6599ad830907141043s1c16d5c9saad9118c210ecef4@mail.gmail.com>
Date: Tue, 14 Jul 2009 13:38:30 -0700
Message-ID: <6599ad830907141338t794e60admf81807b381c46e41@mail.gmail.com>
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
From: Paul Menage <menage@google.com>
To: Benjamin Blum <bblum@google.com>, Matt Helsley <matthltc@us.ibm.com>
Cc: balbir@linux.vnet.ibm.com, lizf@cn.fujitzu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 10:43 AM, Paul Menage<menage@google.com> wrote:
>
> I've been trying to think of a way to do that. AFAICS the only way to
> do that reliably would be to move the call to cgroup_fork() that hooks
> into the parent's cgroup inside the lock on the group leader's thread
> list, and move the fork callbacks into cgroup_fork(). (Which would
> mean that they'd not be able to sleep/fail, etc).

Currently the only user of the cgroup fork callbacks is the freezer cgroup.

Matt, if this callback was moved inside tasklist_lock, would that
present any problems? Given that in other places you call
freeze_task() from inside other low-level locks like css_set_lock
(within a cgroup iteration) then hopefully it would be OK.

The only question then would be whether anything between the point
where cgroup_fork() is currently called, and the point where the new
thread is added to its thread group list, cares about p->cgroups being
valid. We can probably flush out any such assumptions by clearing
tsk->cgroups in dup_task_struct, so that any attempts to reference it
would immediately oops.

Then (assuming this doesn't expose any such dependencies) we can move
the cgroup_fork() call inside the write_lock_irq(&tasklist_lock) in
do_fork(). The "procs" handler can (once it has done any necessary
allocations) take a read_lock on tasklist_lock, and atomically move
all threads to the new cgroup.

Paul
