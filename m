Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbYF0Sky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbYF0Sky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYF0Sko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:40:44 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4226 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYF0Sko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:40:44 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2008 14:40:43 EDT
Date: Fri, 27 Jun 2008 20:30:45 +0200
From: Joris van Rantwijk <jorispubl@xs4all.nl>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thorsten Knabe <linux@thorsten-knabe.de>
Subject: BUG: Linux 2.6.25 ptrace leaks struct_task
Message-ID: <20080627183045.GA18801@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think sys32_ptrace() is leaking struct_task.

In arch/x86/kernel/ptrace.c, function sys32_ptrace(), there
is a call to ptrace_get_task_struct(). In some cases (such as
PTRACE_GETREGS), there is no matching call to put_task_struct().

Test case: fork many childs, calling PTRACE_GETREGS on each child.
Indeed this causes unbounded growth of the task_struct allocation
in /proc/slabinfo, and it also causes physical memory to disappear
from /proc/meminfo.

I have tested this on Linux 2.6.25.4 for x86_64, but the
relevant code has not been changed in 2.6.25.9.
This bug appears to be fixed in 2.6.26-rc8: the code looks
different and I can't reproduce the issue there.

Oops, just discovered this problem has already been reported
in http://lkml.org/lkml/2008/5/29/266 although not much
seems to have been done about it.

Should this be fixed for 2.6.25.10 ?

Is it likely that this bug is related to the mysterious
disappearance of memory from /proc/meminfo as reported in
http://lkml.org/lkml/2008/6/24/15 ?

Even so, how is it possible that memory just disappears
from /proc/meminfo? It can't be the task_struct cache itself,
because that is all covered under Slab, right ?

Greetings, Joris.
