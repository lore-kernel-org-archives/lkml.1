Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbYCXQez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbYCXQez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYCXQeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:34:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYCXQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:34:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Ac7EhDgQsrTurVp5iOZBeXzSlD9Z0+7flGk67hohNVoJ9ZnZgQmexc7sHU3EvUAit
	9UL2roUutEBlpKr3Hr4aA==
Message-ID: <6599ad830803240934g2a70d904m1ca5548f8644c906@mail.gmail.com>
Date: Mon, 24 Mar 2008 09:34:39 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] Memory controller add mm->owner
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47E7D51E.4050304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain>
	 <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com>
	 <47E7D51E.4050304@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 9:21 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  > Also, if mm->owner exits but mm is still alive (unlikely, but could
>  > happen with weird custom threading libraries?) then we need to
>  > reassign mm->owner to one of the other users of the mm (by looking
>  > first in the thread group, then among the parents/siblings/children,
>  > and then among all processes as a last resort?)
>  >
>
>  The comment in __exit_signal states that
>
>  "The group leader stays around as a zombie as long
>   as there are other threads.  When it gets reaped,
>   the exit.c code will add its counts into these totals."

Ah, that's useful to know.

>
>  Given that the thread group leader stays around, do we need to reassign
>  mm->owner? Do you do anything special in cgroups like cleanup the
>  task_struct->css->subsys_state on exit?
>

OK, so we don't need to handle this for NPTL apps - but for anything
still using LinuxThreads or manually constructed clone() calls that
use CLONE_VM without CLONE_PID, this could still be an issue. (Also I
guess there's the case of someone holding a reference to the mm via a
/proc file?)

>
>  >>  -       rcu_read_lock();
>  >>  -       mem = rcu_dereference(mm->mem_cgroup);
>  >>  +       mem = mem_cgroup_from_task(mm->owner);
>  >
>  > I think we still need the rcu_read_lock(), since mm->owner can move
>  > cgroups any time.
>  >
>
>  OK, so cgroup task movement is protected by RCU, right? I'll check for all
>  mm->owner uses.
>

Yes - cgroup_attach() uses synchronize_rcu() before release the cgroup
mutex. So although you can't guarantee that the cgroup set won't
change if you're just using RCU, you can't guarantee that you're
addressing a still-valid non-destroyed (and of course non-freed)
cgroup set.

Paul
