Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXKSSGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXKSSGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbXKSSGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:06:11 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54499 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbXKSSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:06:10 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_task_stat: don't use task_pid_nr_ns() lockless
References: <20071117183109.GA2605@tv-sign.ru>
	<m1fxz4ws2z.fsf@ebiederm.dsl.xmission.com>
	<474157A7.1060504@openvz.org>
Date: Mon, 19 Nov 2007 11:04:55 -0700
In-Reply-To: <474157A7.1060504@openvz.org> (Pavel Emelyanov's message of "Mon,
	19 Nov 2007 12:30:15 +0300")
Message-ID: <m1zlxaun5k.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:

> Eric W. Biederman wrote:
>> We only get detached in release_task so it is a pretty small window
>> where we can return pid == 0.  Usually get_task_pid will fail first
>> and we will return -ESRCH.  Still the distance from open to 
>> 
>> There is another bug in here as well.  current->nsproxy->pid_ns is wrong.
>> What we want is: ns = dentry->d_sb->s_fs_info;
>
> Actually I thought about this recently - if we produce the list
> of tasks based on the sb's namespace, then we should fill the
> tasks' files according to the sb's namespace as well, not according
> to the current namespace.

Exactly.  That is the problem I was pointing out.  Patch in a bit.
In do_proc_stat we are currently referencing current->nsproxy->pid_ns;

>> Otherwise we will have file descriptor passing races and the like.
>
> Can you elaborate?

Just the classic problem that if you use current at other then open
time the contents of the file descriptor may depend on who is reading
it which is problematic.

Eric
