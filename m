Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZHMJFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZHMJFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZHMJFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:05:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48579 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZHMJFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:05:43 -0400
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com, Oleg Nesterov <oleg@redhat.com>
References: <20090807061103.GA19343@us.ibm.com>
	<m1vdks5qc8.fsf@fess.ebiederm.org> <20090813080049.GA16639@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 13 Aug 2009 02:05:33 -0700
In-Reply-To: <20090813080049.GA16639@us.ibm.com> (Sukadev Bhattiprolu's message of "Thu\, 13 Aug 2009 01\:00\:49 -0700")
Message-ID: <m1vdks2iea.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: sukadev@linux.vnet.ibm.com, oleg@redhat.com, sukadev@us.ibm.com, containers@lists.linux-foundation.org, hpa@zytor.com, mingo@elte.hu, mikew@google.com, torvalds@linux-foundation.org, akpm@osdl.org, xemul@openvz.org, adobriyan@gmail.com, serue@us.ibm.com, orenl@cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC][v4][PATCH 0/7] clone_with_pids() system call
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> Eric W. Biederman [ebiederm@xmission.com] wrote:
> | Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
> | 
> | > === NEW CLONE() SYSTEM CALL:
> | >
> | > To support application checkpoint/restart, a task must have the same pid it
> | > had when it was checkpointed.  When containers are nested, the tasks within
> | > the containers exist in multiple pid namespaces and hence have multiple pids
> | > to specify during restart.
> | >
> | > This patchset implements a new system call, clone_with_pids() that lets a
> | > process specify the pids of the child process.
> | >
> | > Patches 1 through 5 are helpers and we believe they are needed for application
> | > restart, regardless of the kernel implementation of application restart.
> | 
> | I'm not very impressed.
> | 
> | - static int alloc_pidmap(struct pid_namespace *pid_ns)
> | + static int alloc_pidmap(struct pid_namespace *pid_ns, int pid_max, int last_pid)
> | 
> | Do that.
> | 
> | That is pass in pid_max and last_pid, and you don't have to do weird
> | things in alloc_pidmap, and no set_pidmap is needed.
>
> But last_pid is from the pid_ns. Do you mean to have alloc_pidmap()
> take a pid_min and pid_max and when choosing a specific pid, have
> pid_min == pid_max == target_pid ?

Yes. It already takes a pid_min and a pid_max from the environment.
I guess the pid_min is RESERVED_PIDS by default.

> | No changes to copy_process are needed it already takes a struct pid
> | argument.
>
>
> I see your point about passing in both 'struct pid*' and target_pids[].
> But in the common case the struct pid passed into copy_process() is
> NULL - allocating pid in do_fork() would significantly alter the
> existing control flow - no ? alloc_pid() assumes any new pid namespace
> has been created - in copy_namespaces(). Moving the alloc_pid() to
> do_fork() would require parsing clone_flags in do_fork() and pulling
> pid namespace code out of copy_namespaces().

Why change do_fork?

> | I haven't been following closely what is gained by having a clone_with_pids
> | syscall?  
>
> When restarting an application from a checkpoint, the application must get
> the same pid it had at the time of checkpoint. clone_with_pids() would be
> used during restart so the child can be created with a specific set of pids.

That part I understand.  What I don't understand is why have that one part be
special and have user space do the work?

> | As for new namespaces that don't need to happen at process creation time
> | (which is just about anything that is left) we can create a new syscall that
> | unshares just that one.
> | 
>
> Ok. If all new namespaces can be handled with a variant of unshare(), we can
> decouple clone_with_pids() from the clone-flags issue.

What I mean is we should be able to get away things like:
sys_new_timens();

Very very simple syscalls.  One per each kind of namespace we want new
instances of.

Eric


