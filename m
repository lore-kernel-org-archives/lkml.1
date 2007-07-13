Return-Path: <linux-kernel-owner+w=401wt.eu-S1763413AbXGMTyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763413AbXGMTyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbXGMTyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:54:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50287 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXGMTyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:54:33 -0400
Subject: Re: [PATCH] Simplify /proc/<pid|self>/exe symlink code
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Al Viro <viro@ftp.linux.org.uk>,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, "Hallyn, Serge" <serue@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20070712192114.bb357ce4.akpm@linux-foundation.org>
References: <1184292012.13479.14.camel@localhost.localdomain>
	 <20070712192114.bb357ce4.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 13 Jul 2007 12:54:20 -0700
Message-Id: <1184356460.16131.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 19:21 -0700, Andrew Morton wrote:
> On Thu, 12 Jul 2007 19:00:12 -0700 Matt Helsley <matthltc@us.ibm.com> wrote:
> 
> > This patch avoids holding the mmap semaphore while walking VMAs in response to
> > programs which read or follow the /proc/<pid|self>/exe symlink. This also allows
> > us to merge mmu and nommu proc_exe_link() functions. The costs are holding the
> > task lock, a separate reference to the executable file stored in the task
> > struct, and increased code in fork, exec, and exit paths.
> > 
> > Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> > ---
> > 
> > Changelog:
> > 
> > Hold task_lock() while using task->exe_file. With this change I haven't
> > 	been able to reproduce Chris Wright's Oops report:
> > 		http://lkml.org/lkml/2007/5/31/34 
> > 	I used a 4-way, x86 system running kernbench. I also tried a 4-way x86_64
> > 	system running pidof. I used oprofile during all runs but I could not
> > 	reproduce Chris' Oops with the new patch.
> > 
> > Compiled and passed simple tests for regressions when patched against a 2.6.20
> > and a 2.6.22 kernel. Regression tests included a variety of file operations on
> > /proc/<pid|self>/exe such as stat, lstat, open, close, readlink, and unlink. All
> > produced the expected, baseline output results.
> > 
> > Andrew, please consider this patch for inclusion in -mm.
> 
> I wish we had a description of the bug which this fixes.  That email of
> Chris's is referencing code which diddles with task_struct.exe_file, but
> your patch _adds_ task_struct.exe_file, so I am all confused.

Chris was testing the patch. The patch isn't a bug fix so much as a
failed attempt to remove one use of the mm's mmap lock.

> Your patch does lots of fput()s under task_lock(), but fput() can sleep.

Ack, you're right.

> Plus what Al said.

Yup.

Thanks,
	-Matt Helsley

