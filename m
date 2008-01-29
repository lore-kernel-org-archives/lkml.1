Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbYA2NjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbYA2NjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932811AbYA2Niy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:38:54 -0500
Received: from sacred.ru ([62.205.161.221]:49607 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932637AbYA2Nir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:38:47 -0500
Message-ID: <479F2C5C.1050303@openvz.org>
Date: Tue, 29 Jan 2008 16:38:36 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 0/12] Schedule find_task_by_pid() for removal
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 16:38:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function in question finds the task by its pid_t in an
initial pid namespace (init_pid_ns). This is no longer safe to
simply call it, since the current task may be in a pid namespace 
and it may return the wrong task.

The proper behavior is to call the find_task_by_vpid() if the 
caller is sure, that the target task lives in the same namespace 
as he is, or the find_task_by_pid_ns() and specify the namespace 
to find a task in.

Since the find_task_by_pid() is a well-known API call, and its
semantics changes, I think that it's better to mark it as 
deprecated to warn people, that the result may differ from what 
they expect and force them to use proper call.

Another case is to store the pointer to the struct pid of a desired
task and later call the pid_task() to get the task itself.

So this set just fixes the existing users of find_task_by_pid().
The only one will be left - the UML mconsole, but I'm completely
lost in this code, finding out what kind of pid is passed in
the mconsole_stack() call :(

Singed-off-by: Pavel Emelyanov <xemul@openvz.org>
