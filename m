Return-Path: <linux-kernel-owner+w=401wt.eu-S1762379AbZE0Xsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762379AbZE0Xsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761222AbZE0Xsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:48:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46949 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761133AbZE0Xsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:48:32 -0400
Date: Thu, 28 May 2009 01:43:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090527234330.GA12216@redhat.com>
References: <20090525185502.GA20781@redhat.com> <20090526210514.C1C91FC2BD@magilla.sf.frob.com> <20090527213222.GA6770@redhat.com> <20090527222337.0507EFC36B@magilla.sf.frob.com> <20090527231248.GB10032@redhat.com> <20090527232617.2FE48FC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527232617.2FE48FC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Roland McGrath wrote:
>
> > No, task_pid_vnr(current) in ptrace_notify() is not right. If the tracer
> > does PTRACE_GETSIGINFO it gets the wrong .si_pid.
>
> I don't follow.  PTRACE_GETSIGINFO gets the tracee's siginfo_t data--modulo
> 32/64 conversions it's the data structure the tracee process sees on its
> stack when running a handler.  It's not like a signal sent into the
> tracer's queue (like SIGCHLD in do_notify_*), where the kernel doing
> translation to the tracer's context makes sense.  It's more like some
> memory you read from the tracee.

Yes, but the (minor and low priority) problem is that .si_pid recorded
in ->last_siginfo does not match the tracee's pid from the tracer pov
(if they run in different namespaces).

Suppose that that we trace the task from the sub-namespace. We see its
pid == 100, but when this tracee calls ptrace_notify() it does
info.si_pid = task_pid_vnr(current), and task_pid_vnr() returns (say) 10.

Oleg.	

