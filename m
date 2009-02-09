Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZBIBbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZBIBbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZBIBbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:31:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38994 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZBIBbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:31:04 -0500
Date: Mon, 9 Feb 2009 02:28:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Message-ID: <20090209012824.GA26461@redhat.com>
References: <20090209010233.GA26444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209010233.GA26444@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, Oleg Nesterov wrote:
>
> I noticed by pure accident we have ptrace_fork() and friends. This was
> added by "x86, bts: add fork and exit handling", commit
> bf53de907dfdaac178c92d774aae7370d7b97d20

Hmm. Looks like we have more problems here...

"x86, bts: memory accounting", commit c5dee6177f4bd2095aab7d9be9f6ebdddd6deee9.

PTRACE_BTS_CONFIG allocates ->bts_buffer via alloc_locked_buffer()
which updates mm->total_vm/locked_vm.

ptrace_detach() does free_locked_buffer() which "restores" mm->xxx_vm.

But if the tracer exits we are doing __ptrace_unlink()->ptrace_bts_untrace()
which uses a plain kfree(), in that case we don't update mm->xxx_vm ?

Note that the exiting tracer can have sub-threads, so the whole process
does not necessary dies.

Or, the tracer can reap a zombie tracee without PTRACE_DETACH, in that
case we don't update ->mm too.

Oh, and afaics ptrace_detach()->ptrace_bts_detach() can race with the
tracer's sub-thread which does do_wait()->release_task() (if the tracee
was killed before detach takes tasklist), the kernel can crash in this
case.

Unless I missed something, This all looks rather wrong, and I wasn't
aware about these changes :(

Oleg.

