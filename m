Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYINCyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYINCyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 22:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYINCy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 22:54:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:42698 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYINCy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 22:54:27 -0400
Date: Sat, 13 Sep 2008 19:54:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: proc: more debugging for "already registered" case
Message-ID: <20080913195424.2609fac2@infradead.org>
In-Reply-To: <200809132159.m8DLx2sN023436@hera.kernel.org>
References: <200809132159.m8DLx2sN023436@hera.kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 21:59:02 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=665020c35e89a9e0643e21561e4f8f967f4f2c4b
> Commit:     665020c35e89a9e0643e21561e4f8f967f4f2c4b Parent:
> a551b98d5f6fce5897d497abd8bfb262efb33d2a Author:     Alexey Dobriyan
> <adobriyan@gmail.com> AuthorDate: Sat Sep 13 02:33:06 2008 -0700
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Sat Sep 13 14:41:50 2008 -0700

>  		if (strcmp(tmp->name, dp->name) == 0) {
> -			printk(KERN_WARNING "proc_dir_entry '%s'
> already "
> -					"registered\n", dp->name);
> +			printk(KERN_WARNING "proc_dir_entry '%s/%s'
> already registered\n",
> +				dir->name, dp->name);
>  			dump_stack();
>  			break;

Hi Linus, Alexey,

when doing this change, might as well turn it into a WARN() instead;
that way kerneloops.org can collect these, and in addition, it uses then
a more standard form of reporting (including filename/line number etc)

so how about this:

>From 7b907eb010b308c1a41871ea1b6ffb79d2538f01 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 13 Sep 2008 19:51:30 -0700
Subject: [PATCH] procfs: use WARN() rather than printk+backtrace

Use WARN() rather than a printk() + backtrace();
this gives a more standard format message as well as complete
information (including line numbers etc) that will be collected
by kerneloops.org

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/proc/generic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 7821589..60a359b 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -547,9 +547,8 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 
 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			printk(KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
+			WARN(1, KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
 				dir->name, dp->name);
-			dump_stack();
 			break;
 		}
 
-- 
1.5.5.1



--
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
