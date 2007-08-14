Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbXHNUNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbXHNUNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXHNUMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:12:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491AbXHNUMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:12:44 -0400
Date: Tue, 14 Aug 2007 13:12:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: xemul@openvz.org
Cc: devel@openvz.org, linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       oleg@tv-sign.ru, sukadev@us.ibm.com
Subject: Re: [PATCH 19/20] Changes to show virtual ids to user
Message-Id: <20070814131202.73b7d559.akpm@linux-foundation.org>
In-Reply-To: <46BC508C.mailGLJ118R5H@openvz.org>
References: <46BC508C.mailGLJ118R5H@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 15:48:28 +0400
xemul@openvz.org wrote:

> This is the largest patch in the set. Make all (I hope) the places where
> the pid is shown to or get from user operate on the virtual pids.
> 
> The idea is:
>  - all in-kernel data structures must store either struct pid itself
>    or the pid's global nr, obtained with pid_nr() call;
>  - when seeking the task from kernel code with the stored id one
>    should use find_task_by_pid() call that works with global pids;
>  - when showing pid's numerical value to the user the virtual one
>    should be used, but however when one shows task's pid outside this
>    task's namespace the global one is to be used;
>  - when getting the pid from userspace one need to consider this as
>    the virtual one and use appropriate task/pid-searching functions.
> 
> ...
>
> -	si.si_pid = current->pid;
> +	si.si_pid = task_pid_vnr(current);

This is going to be an ongoing maintenance problem: people will sneak
new references to current->pid into the tree and nobody will notice.

It'd be best to rename task_struct.pid to something else to catch such
problems and to force people to use the right accessors.  Is that feasible?

Generally this is a tactic which should be used whenever things like this
are virtualised.
