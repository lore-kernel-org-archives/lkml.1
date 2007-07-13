Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbXGMCWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbXGMCWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbXGMCVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:21:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755545AbXGMCVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:21:51 -0400
Date: Thu, 12 Jul 2007 19:21:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       "Hallyn, Serge" <serue@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Simplify /proc/<pid|self>/exe symlink code
Message-Id: <20070712192114.bb357ce4.akpm@linux-foundation.org>
In-Reply-To: <1184292012.13479.14.camel@localhost.localdomain>
References: <1184292012.13479.14.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 19:00:12 -0700 Matt Helsley <matthltc@us.ibm.com> wrote:

> This patch avoids holding the mmap semaphore while walking VMAs in response to
> programs which read or follow the /proc/<pid|self>/exe symlink. This also allows
> us to merge mmu and nommu proc_exe_link() functions. The costs are holding the
> task lock, a separate reference to the executable file stored in the task
> struct, and increased code in fork, exec, and exit paths.
> 
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> ---
> 
> Changelog:
> 
> Hold task_lock() while using task->exe_file. With this change I haven't
> 	been able to reproduce Chris Wright's Oops report:
> 		http://lkml.org/lkml/2007/5/31/34 
> 	I used a 4-way, x86 system running kernbench. I also tried a 4-way x86_64
> 	system running pidof. I used oprofile during all runs but I could not
> 	reproduce Chris' Oops with the new patch.
> 
> Compiled and passed simple tests for regressions when patched against a 2.6.20
> and a 2.6.22 kernel. Regression tests included a variety of file operations on
> /proc/<pid|self>/exe such as stat, lstat, open, close, readlink, and unlink. All
> produced the expected, baseline output results.
> 
> Andrew, please consider this patch for inclusion in -mm.

I wish we had a description of the bug which this fixes.  That email of
Chris's is referencing code which diddles with task_struct.exe_file, but
your patch _adds_ task_struct.exe_file, so I am all confused.

Your patch does lots of fput()s under task_lock(), but fput() can sleep.

Plus what Al said.
