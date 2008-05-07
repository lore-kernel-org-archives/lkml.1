Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYEGDai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYEGDai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYEGDa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:30:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9377 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYEGDa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:30:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=F2Mj1QIY0R571GMqDm09qZMwWuVUzJnZ8MEt/2WQIQvgpF0D/4aaa7359tmwTlRTg
	Kb4SO9MshCxyF46V3IAsg==
Message-ID: <6599ad830805062029m37b507dcue737e1affddeb120@mail.gmail.com>
Date: Tue, 6 May 2008 20:29:49 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm][PATCH 3/4] Add rlimit controller accounting and control
Cc: linux-mm@kvack.org, "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080503213814.3140.66080.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
	 <20080503213814.3140.66080.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2008 at 2:38 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>
>  This patch adds support for accounting and control of virtual address space
>  limits. The accounting is done via the rlimit_cgroup_(un)charge_as functions.
>  The core of the accounting takes place during fork time in copy_process(),
>  may_expand_vm(), remove_vma_list() and exit_mmap(). There are some special
>  cases that are handled here as well (arch/ia64/kernel/perform.c,
>  arch/x86/kernel/ptrace.c, insert_special_mapping())
>

The basic idea of the patches looks fine (apart from some
synchronization issues) but Is calling this the "rlimit" controller a
great idea? That implies that it handles all (or at least many) of the
things that setrlimit()/getrlimit() handle.

While some of the other rlimit things definitely do make sense as
cgroup controllers, putting them all in the same controller doesn't
really - paying for the address-space tracking overhead just to get,
say, the equivalent of RLIMIT_NPROC (max tasks) isn't a great idea.

Can you instead give this a name that somehow refers to virtual
address space limits, e.g. "va" or "as". That would still fit if you
expanded it to deal with locked virtual address space limits too.

I think that an "rlimit" controller would probably be best for
representing just those limits that don't really make sense when
aggregated across different tasks, but apply separately to each task
(e.g. RLIMIT_FSIZE, RLIMIT_CORE, RLIMIT_NICE, RLIMIT_NOFILE,
RLIMIT_RTPRIO, RLIMIT_STACK, RLIMIT_SIGPENDING, and maybe RLIMIT_CPU),
in order to provide an easy way to change these limits on a group of
running tasks.

On a separate note for the address-space tracking, ideally the
subsystem would track whether or not it was bound to a hierarchy, and
skip charging/uncharging if not. That way there's no (noticeable)
overhead for compiling in the subsystem but not using it. At the point
when the subsystem was bound to a hierarchy, it could at that point
run through all mms and charge each one's existing address space to
the appropriate cgroup. (Currently that would only be the root cgroup
in the hierarchy).

Paul
