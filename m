Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbYBWT6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbYBWT6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYBWT6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:58:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35522 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYBWT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:58:05 -0500
Subject: Re: [PATCH 3/8] sched: rt-group: interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tong.n.li@intel.com
In-Reply-To: <6599ad830802231148w518d937cyd75d1d0a35702d9d@mail.gmail.com>
References: <20080204210258.118479000@chello.nl>
	 <20080204211836.968632000@chello.nl>
	 <6599ad830802231148w518d937cyd75d1d0a35702d9d@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 20:57:47 +0100
Message-Id: <1203796668.6242.82.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 11:48 -0800, Paul Menage wrote:
> On Mon, Feb 4, 2008 at 1:03 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >  +static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
> >  +                               struct file *file,
> >  +                               const char __user *userbuf,
> >  +                               size_t nbytes, loff_t *unused_ppos)
> >  +{
> >  +       char buffer[64];
> >  +       int retval = 0;
> >  +       s64 val;
> >  +       char *end;
> >  +
> >  +       if (!nbytes)
> >  +               return -EINVAL;
> >  +       if (nbytes >= sizeof(buffer))
> >  +               return -E2BIG;
> >  +       if (copy_from_user(buffer, userbuf, nbytes))
> >  +               return -EFAULT;
> >  +
> >  +       buffer[nbytes] = 0;     /* nul-terminate */
> >  +
> >  +       /* strip newline if necessary */
> >  +       if (nbytes && (buffer[nbytes-1] == '\n'))
> >  +               buffer[nbytes-1] = 0;
> >  +       val = simple_strtoll(buffer, &end, 0);
> >  +       if (*end)
> >  +               return -EINVAL;
> >  +
> >  +       /* Pass to subsystem */
> >  +       retval = sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
> >  +       if (!retval)
> >  +               retval = nbytes;
> >  +       return retval;
> >   }
> >
> >  -static u64 cpu_rt_ratio_read_uint(struct cgroup *cgrp, struct cftype *cft)
> >  -{
> >  -       struct task_group *tg = cgroup_tg(cgrp);
> >  +static ssize_t cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft,
> >  +                                  struct file *file,
> >  +                                  char __user *buf, size_t nbytes,
> >  +                                  loff_t *ppos)
> >  +{
> >  +       char tmp[64];
> >  +       long val = sched_group_rt_runtime(cgroup_tg(cgrp));
> >  +       int len = sprintf(tmp, "%ld\n", val);
> >
> >  -       return (u64) tg->rt_ratio;
> >  +       return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
> >   }
> 
> What's the reason that you can't use the cgroup read_uint/write_uint
> methods for this? Is it just because you have -1 as your "unlimited"
> value.

Yes.

> If so, could we avoid that problem by using 0 rather than -1 as the
> "unlimited" value? It looks from what I've read in the Documentation
> changes as though 0 isn't really a meaningful value.

0 means no time, quite useful and clearly distinct from inf. time.


