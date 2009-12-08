Return-Path: <linux-kernel-owner+w=401wt.eu-S935765AbZLHBvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935765AbZLHBvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965328AbZLHBvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:51:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32812 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935744AbZLHBvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:51:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH v2] [RFC] tracepoint: Add signal coredump tracepoint
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>
In-Reply-To: <4B1D1E7C.8000806@redhat.com>
References: <2f11576a0912042318u4c9c90cetb4ce136e977c2596@mail.gmail.com> <4B1D1E7C.8000806@redhat.com>
Message-Id: <20091208104324.B589.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 10:51:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > 2009/12/3 Masami Hiramatsu<mhiramat@redhat.com>:
> >> Add signal coredump tracepoint which shows signal number,
> >> mm->flags, limits, pointer to file structure and core
> >> file name.
> >>
> >> This tracepoint requirement comes mainly from the viewpoint of
> >> administrators. Since now we have introduced many coredump
> >> configurations (e.g. dumpable, coredump_filter, core_pattern,
> >> etc) and some of them can be modified by users, it will be hard
> >> to know what was actually dumped (or not dumped) after some
> >> problem happened on the system. For example, a process didn't
> >> generated core, coredump doesn't have some sections, etc.
> >> In those cases, the coredump tracepoint can help us to know
> >> why the core file is so big or small, or not generated, by
> >> recording all configurations for all processes on the system.
> >> That will reduce system-administration cost.
> >
> > AFAIK, not-dumped case is important than dump successful case.
> > IOW, admin need to know why the crashed process was not dumped.
> 
> Certainly, failure cases are important, but also, the cases
> that dumped-core doesn't or does include some sections
> are also important.

correct.

> > This tracepoint doesn't cover all failure case. especially
> > binfmt->core_dump() et.al.
> > IOW, this tracepoint seems too specialized piped-coredump feature.
> 
> Hmm, so would you mean that after calling binfmt->core_dump()
> is better place?

I think your following use-case desired so. if you have unwritten reason, please correct me.

	For example, a process didn't generated core, coredump doesn't have
	some sections, etc.


> > What do you think this tracepoint's use case?
> 
> Frankly to say, our first attempt was tracing mm->flags because
> it can be changed by users without asking, and they sometimes
> ask why core is not perfect or why core file is so big.
> 
> Perhaps, covering all of those failure cases and succeed cases,
> gives better information for them. In that case, we might better
> tweak execution(goto) path to leave some error code on retval.

This is enough acceptable to me.

> 
> e.g.
>          if (IS_ERR(file))
>                  goto fail_dropcount;
> +	retval = -EBADF;
>          inode = file->f_path.dentry->d_inode;
>          if (inode->i_nlink > 1)
>                  goto close_fail;        /* multiple links - don't dump */
>          if (!ispipe && d_unhashed(file->f_path.dentry))
>                  goto close_fail;
> 
>          /* AK: actually i see no reason to not allow this for named pipes etc.,
>             but keep the previous behaviour for now. */
>          if (!ispipe && !S_ISREG(inode->i_mode))
>                  goto close_fail;
>          /*
>           * Dont allow local users get cute and trick others to coredump
>           * into their pre-created files:
>           */
> +	retval = -EPERM;
>          if (inode->i_uid != current_fsuid())
>                  goto close_fail;
> +	retval = -EINVAL;
>          if (!file->f_op)
>                  goto close_fail;
>          if (!file->f_op->write)
>                  goto close_fail;
> +	retval = -EEXIST;
>          if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
>                  goto close_fail;
> 
> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 



