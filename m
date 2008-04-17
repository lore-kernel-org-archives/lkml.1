Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYDQE2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYDQE2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYDQE2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:28:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38774 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYDQE2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:28:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=EH8OOchPltuuTUv/w/s8z1289OVlYHQvwnnCI94v3hnon2CsuJ3xn6SqmvFsHMSs4
	6rVY0rcpv4NQfCyxHuJmQ==
Message-ID: <6599ad830804162128g3d383bc6v606fcd14964bd21e@mail.gmail.com>
Date: Wed, 16 Apr 2008 21:28:33 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: fix a race condition in manipulating tsk->cg_list
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <6599ad830804162118g6b24d8ebq26b0d72133b0e19e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4806C5EB.3040102@cn.fujitsu.com>
	 <6599ad830804162118g6b24d8ebq26b0d72133b0e19e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 9:18 PM, Paul Menage <menage@google.com> wrote:
>
>  My only thought about the downside of this is that an exiting task
>  that gets stuck somewhere  between setting PF_EXITING and calling
>  cgroup_exit() won't show up in its cgroup's tasks file, since we'll
>  enable cgroup links but skip it. I guess that's not a big deal.
>

How about this as an alternative approach? We can take advantage of
the indirection in tsk->cgroups to create an additional distinguished
css_set that indicates the task has passed the point of checking
tsk->cg_list:

- create a new css_set, called exit_css_set; it has the same cgroup
pointer set as init_css_set.

- in cgroup_exit(), set current->cgroups to &exit_css_set rather than
&init_css_set

- in cgroup_enable_task_cg_list(), ignore any task where p->cgroups ==
&exit_css_set

That way we're synchronizing directly with the task_lock()-protected
section in cgroup_exit(), rather than with the setting of PF_EXITING
at the beginning of do_exit().

Paul
