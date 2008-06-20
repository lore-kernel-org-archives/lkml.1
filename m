Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbYFTFiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbYFTFiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 01:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYFTFh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 01:37:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYFTFh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 01:37:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DBWRQDOu3pncvNAplGKMQgmNJ9OabmODfObSN8tKngplbSYgkj+6JfYOleY0BQCQH
	mIxmOhWX9LU5srW5fBhzg==
Message-ID: <6599ad830806192237y8b10c4ao923375074aff56c5@mail.gmail.com>
Date: Thu, 19 Jun 2008 22:37:47 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC] [PATCH] cgroup: add "procs" control file
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <4858C111.8050806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4858C111.8050806@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 1:02 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> - What to do if the attaching of a thread failed? continue to attach
>  other threads, or stop and return error?

I think this is something that will have to be handled in the design
of transactional cgroup attach.

> - When a sub-thread of a process is in the cgroup, but not its thread
>  cgroup leader, what to do when 'cat procs'? just skip those threads?

Sounds reasonable. I think that in general the procs file is more
useful as a write API than a read API anyway, for the reasons you
indicate there.


> +       tsk = attach_get_task(cgrp, pidbuf);
> +       if (IS_ERR(tsk))
> +               return PTR_ERR(tsk);
> +
> +       /* attach thread group leader */

Should we check that this is in fact a thread group leader?

> +
> +       /* attach all sub-threads */
> +       rcu_read_lock();

cgroup_attach_task() calls synchronize_rcu(), so it doesn't seem
likely that rcu_read_lock() is useful here, and might even deadlock?

What are you trying to protect against with the RCU lock?

>        {
> +               .name = "procs",

Maybe call it "cgroup.procs" to avoid name clashes in future? We had a
debate a while back where I tried to get the cgroup files like "tasks"
and "notify_on_release" prefixed with "cgroup." , which were argued
against on grounds of backwards compatibility. But there's no
compatibility issue here. The only question is whether it's too ugly
to have the legacy filenames without a prefix and the new ones with a
prefix.

Paul
