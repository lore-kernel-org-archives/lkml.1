Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZIDTpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZIDTpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbZIDTpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:45:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757258AbZIDTpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:45:03 -0400
Date: Fri, 4 Sep 2009 12:42:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, dhowells@redhat.com, roland@redhat.com,
       jmorris@namei.org, tom.horsley@att.net, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH v3] exec: do not sleep in TASK_TRACED under
 ->cred_guard_mutex
Message-Id: <20090904124230.5b7258c9.akpm@linux-foundation.org>
In-Reply-To: <20090904172648.GA25841@redhat.com>
References: <20090904133956.GA9232@redhat.com>
	<20090903160514.GA23646@redhat.com>
	<20090903200924.E46DF47C94@magilla.sf.frob.com>
	<32710.1252075656@redhat.com>
	<20090904154947.GA17048@redhat.com>
	<20090904172648.GA25841@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 19:26:48 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Tom Horsley reports that his debugger hangs when it tries to read
> /proc/pid_of_tracee/maps, this happens since
> 
> 	"mm_for_maps: take ->cred_guard_mutex to fix the race with exec"
> 	04b836cbf19e885f8366bccb2e4b0474346c02d
> 
> commit in 2.6.31.
> 
> But the root of the problem lies in the fact that do_execve() path calls
> tracehook_report_exec() which can stop if the tracer sets PT_TRACE_EXEC.
> 
> The tracee must not sleep in TASK_TRACED holding this mutex. Even if we
> remove ->cred_guard_mutex from mm_for_maps() and proc_pid_attr_write(),
> another task doing PTRACE_ATTACH should not hang until it is killed or
> the tracee resumes.
> 
> With this patch do_execve() does not use ->cred_guard_mutex directly and
> we do not hold it throughout, instead:
> 
> 	- introduce prepare_bprm_creds() helper, it locks the mutex
> 	  and calls prepare_exec_creds() to initialize bprm->cred.
> 
> 	- install_exec_creds() drops the mutex after commit_creds(),
> 	  and thus before tracehook_report_exec()->ptrace_stop().
> 
> 	  or, if exec fails,
> 
> 	  free_bprm() drops this mutex when bprm->cred != NULL which
> 	  indicates install_exec_creds() was not called.
> 
> Reported-by: Tom Horsley <tom.horsley@att.net>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: David Howells <dhowells@redhat.com>

I get a reject in binfmts.h because your kernel has `extern void
set_binfmt' and mine has `extern int set_binfmt'.

Hopefully this patch works OK in mainline as well as in whatever kernel
you tested against!

I see a Cc:stable in the mail headers, but not in the changelog.  I
don't think the patch is applicable to -stable unless we miss 2.6.31.

