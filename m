Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZKMXXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZKMXXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbZKMXXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:23:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbZKMXXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:23:21 -0500
Date: Sat, 14 Nov 2009 00:23:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -tip 1/3] Pass mm->flags to binfmt core_dump for bitflag
 consistency
Message-ID: <20091113232307.GB21666@elte.hu>
References: <20091113225226.15079.90813.stgit@harusame>
 <20091113231602.2DD2C100E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113231602.2DD2C100E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> To clarify, proc_coredump_filter_write() is the one place that can 
> change mm->flags during a core dump.  I don't think any other is 
> possible while all the other tasks sharing that mm are prevented from 
> running.  Is there any other way that mm->flags might change during 
> do_coredump()?
> 
> I don't see anything wrong with this change.  But (assuming that is 
> the only case), there is another approach we could take instead.  That 
> is, have proc_coredump_filter_write() do:
> 
> 	down_read(&mm->mmap_sem);
> 	ret = mm->core_state ? -EBUSY : 0;
> 	up_read(&mm->mmap_sem);

this would fix the (probably harmless) race too, but isnt the whole 
approach taken by the patch more robust, i.e. to take a snapshot of 
mm->flags value and pass it along coredump processing?

That makes it evidently immutable in the future too. It also makes the 
code a bit easier to read IMO - instead of get_dumpable() we use the 
mm_flags.

The only other observation i have is that for this parameter set:

  long signr, struct pt_regs *regs, struct file *file,
  unsigned long limit, unsigned long mm_flags)

we should probably introduce a coredump parameter struct, and pass that 
along:

struct coredump_params {
	long signr;
	struct pt_regs *regs;
	struct file *file;
	unsigned long limit;
	unsigned long mm_flags;
}

Had this been done in the past this present patch would be a lot simpler 
as well: we could have added mm_flags to coredump_params, instead of 
having to propagate it through ~6 function interface surfaces.

Thanks,

	Ingo
