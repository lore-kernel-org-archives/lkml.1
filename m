Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYDQERw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYDQERw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYDQERo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:17:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYDQERn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:17:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PeEzpkv3GykVD5IY/dfjf0qB33gFLFUMB81w7gQaB4sVXss4iRQQ7+1X4321FZVUt
	YbEQX6zROprgSJrMb397A==
Message-ID: <6599ad830804162117w14364b7cg20d3694ffdfeb867@mail.gmail.com>
Date: Wed, 16 Apr 2008 21:17:34 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup: fix a race condition in manipulating tsk->cg_list
Cc: "Li Zefan" <lizf@cn.fujitsu.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20080416211144.a38f6fc0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4806C5EB.3040102@cn.fujitsu.com>
	 <20080416211144.a38f6fc0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 9:11 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  I don't fully understand the race.  Both paths hold css_set_lock.
>
>  Can you describe it in more detail please?

Task A starts exiting, passes the check for unlinking current->cg_list.

Before it completely exits task B does the very first
cgroup_iter_begin() call (via reading a cgroups tasks file) which
links all tasks in to their css_set objects via tsk->cg_list.

Then task A finishes exiting and is freed, but doesn't unlink from the cg_list.

>
>  afacit the task at *p could set PF_EXITING immediately after this code has
>  tested PF_EXITING and then the task at *p could proceed until we hit the
>  same race (whatever that is).

The important fact there is that the task sets PF_EXITING *before* it
checks whether it needs to unlink from current->cg_list.

Paul
