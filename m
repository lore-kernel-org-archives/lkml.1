Return-Path: <linux-kernel-owner+w=401wt.eu-S1765965AbZA2AfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765965AbZA2AfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbZA2Abi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:31:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765418AbZA2Abh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:31:37 -0500
Date: Wed, 28 Jan 2009 16:30:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Simon Horman <horms@verge.net.au>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: mmotm 2009-01-28-02-17 uploaded (i386 build errors: cpusets &
 kexec)
Message-Id: <20090128163040.88b05b3d.akpm@linux-foundation.org>
In-Reply-To: <49808E3F.1090805@oracle.com>
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
	<49808E3F.1090805@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 08:56:31 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> 10 randconfigs on i386, 1 good build.
> 
> The other 9 ended with either of these build errors:
> 
> init/main.c:876: error: 'struct task_struct' has no member named 'mems_allowed'
> CONFIG_CPUSETS=n

Well that sucks a bit.

--- a/init/main.c~cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix
+++ a/init/main.c
@@ -873,7 +873,9 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
+#ifdef CONFIG_CPUSETS
 	current->mems_allowed = node_possible_map;
+#endif
 
 	cad_pid = task_pid(current);
 
_

> 
> or
> 
> kernel/printk.c:142: error: implicit declaration of function 'VMCOREINFO_SYMBOL'
> # CONFIG_KEXEC is not set
> 

So does that.

--- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix
+++ a/kernel/printk.c
@@ -137,11 +137,13 @@ static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
+#ifdef CONFIG_KEXEC
 void log_buf_kexec_setup(void)
 {
 	VMCOREINFO_SYMBOL(log_buf);
 	VMCOREINFO_SYMBOL(log_end);
 }
+#endif
 
 static int __init log_buf_len_setup(char *str)
 {
_

