Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbZAUGDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbZAUGDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 01:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZAUGDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 01:03:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58841 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZAUGDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 01:03:12 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20090118073453.GA714@redhat.com>
	<20090121050311.GD15771@cs.cmu.edu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 20 Jan 2009 22:03:03 -0800
In-Reply-To: <20090121050311.GD15771@cs.cmu.edu> (Jan Harkes's message of "Wed\, 21 Jan 2009 00\:03\:11 -0500")
Message-ID: <m1vds9urfs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com, xemul@openvz.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] coda: alloc_upcall: s/task_pgrp_nr/task_pgrp_vnr/
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Harkes <jaharkes@cs.cmu.edu> writes:

> On Sun, Jan 18, 2009 at 08:34:53AM +0100, Oleg Nesterov wrote:
>> Needs an ack from maintaner, I do not know where coda_in_hdr->pgid is used.
>
> It is used to uniquely identify a process and any of it children during
> conflict resolution.
>
> When a conflict is detected, all accesses to the inconsistent object are
> blocked. A special resolver process is forked off by the cache manager
> and this is run in a new process group and only accesses from processes
> in this group are allowed. The resolver process (or any of it's children)
> compare the conflicting replicas, and ideally resolve the inconsistency
> after which normal accesses are unblocked.
>
> So yes this should not a per namespace thing, but also not a process
> specific pid, the resolver forks off different helper processes
> depending on the type of files that are involved in the conflict, i.e.
> mbox files require different merge strategy compared to opendocument
> files.
>
> I'm not sure what you are trying to do.

We currently have two pid data types in the kernel.
pid_t and struct pid *.

pid_t's are the tokens we pass to user space to talk about a 
process, a process group or a session.

struct pid pointers are used internally to the kernel, are
reference counted, are not susceptible to pid wrap around,
and are generally faster to use for sending signals or other
tasks that require looking up a process.

With the introduction of the pid namespaces the difference between
pid_t's and struct pid has become even more important.  Because
based on the pid namespace you are in a given struct pid will have
a different pid_t value.  So internally we are moving as much
as possible to using struct pid pointers.


Oleg is in the process of cleaning up some of the transition code
and we just need to convert the last couple of pieces of code
so we can do that.


In the case of coda I'm assuming it is the user space daemon that
decides if the access is from the resolver process group or not?

That the user space filesystem code does the blocking based on which
process group you are in.

In that case it looks like what needs to happen is that alloc_upcall
needs to know which pid namespace your user space daemon is in.
Probably grab the pid namespace at either mount or connect time (is
there a difference).

Then since I believe the values in the upcall go straight to the user
space daemon we should do roughly:

inp->in.pid  = task_pid_nr_ns(&fs_daemon_pidns, current);
inp->in.pgid = task_pgrp_nr_ns(&fs_daemon_pidns, current);

Does that make sense?

Eric
