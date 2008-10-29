Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbYJ2FIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbYJ2FIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 01:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYJ2FIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 01:08:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbYJ2FIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 01:08:18 -0400
Date: Tue, 28 Oct 2008 22:07:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-wireless@vger.kernel.org,
       Mark Fasheh <mfasheh@suse.com>, Joel Becker <Joel.Becker@oracle.com>
Subject: Re: linux-next: Tree for October 28
Message-Id: <20081028220741.f5d331ba.akpm@linux-foundation.org>
In-Reply-To: <20081028183055.fbcf5420.sfr@canb.auug.org.au>
References: <20081028183055.fbcf5420.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 18:30:55 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (patches at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

ia64 allmodconfig:

arch/ia64/kernel/iosapic.c: In function `get_target_cpu':
arch/ia64/kernel/iosapic.c:723: error: `nr_cpus_ids' undeclared (first use in this function)
arch/ia64/kernel/iosapic.c:723: error: (Each undeclared identifier is reported only once
arch/ia64/kernel/iosapic.c:723: error: for each function it appears in.)

Fixed by:

From: Andrew Morton <akpm@linux-foundation.org>

- someone can't type (or test)

- nr_cpu_ids is declared in cpumask.h.  Include it.

--- a/arch/ia64/kernel/iosapic.c~ia64-fix-arch-ia64-kernel-iosapicc-build
+++ a/arch/ia64/kernel/iosapic.c
@@ -85,6 +85,7 @@
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/cpumask.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
 #include <linux/string.h>
@@ -720,7 +721,7 @@ get_target_cpu (unsigned int gsi, int ir
 		for (numa_cpu = first_cpu(cpu_mask) ; i < cpu_index ; i++)
 			numa_cpu = next_cpu(numa_cpu, cpu_mask);
 
-		if (numa_cpu < nr_cpus_ids)
+		if (numa_cpu < nr_cpu_ids)
 			return cpu_physical_id(numa_cpu);
 	}
 skip_numa_setup:
_



also rather a lot of these:


In file included from drivers/misc/sgi-gru/gruhandles.h:25,
                 from drivers/misc/sgi-gru/grutables.h:151,
                 from drivers/misc/sgi-gru/grufile.c:41:
drivers/misc/sgi-gru/gru_instructions.h: In function `gru_flush_cache':
drivers/misc/sgi-gru/gru_instructions.h:292: warning: passing arg 1 of pointer to function makes integer from pointer without a cast
In file included from drivers/misc/sgi-gru/gruhandles.h:25,
                 from drivers/misc/sgi-gru/grutables.h:151,
                 from drivers/misc/sgi-gru/grumain.c:22:
drivers/misc/sgi-gru/gru_instructions.h: In function `gru_flush_cache':
drivers/misc/sgi-gru/gru_instructions.h:292: warning: passing arg 1 of pointer to function makes integer from pointer without a cast



and this:


kernel/trace/trace.c: In function `tracing_generic_entry_update':
kernel/trace/trace.c:681: error: implicit declaration of function `irqs_disabled_flags'
kernel/trace/trace.c: In function `kretprobed':
kernel/trace/trace.c:1112: error: `kretprobe_trampoline' undeclared (first use in this function)
kernel/trace/trace.c:1112: error: (Each undeclared identifier is reported only once
kernel/trace/trace.c:1112: error: for each function it appears in.)


and wireless needs some Kconfig help.  Please don't just break other
architecture's build like this.

drivers/staging/wlan-ng/wlan_compat.h:136:3: #error "No CPU identified!"
drivers/staging/wlan-ng/wlan_compat.h:695:6: warning: "WLAN_CPU_FAMILY" is not defined
drivers/staging/wlan-ng/wlan_compat.h:699:6: warning: "WLAN_CPU_FAMILY" is not defined



plus of course enough compile warnings to start a small war.   ocfs2 is prominent.

fs/ocfs2/xattr.c: In function `ocfs2_xattr_index_block_find':
fs/ocfs2/xattr.c:2338: warning: long long unsigned int format, u64 arg (arg 7)
fs/ocfs2/xattr.c:2338: warning: long long unsigned int format, u64 arg (arg 7)
fs/ocfs2/xattr.c:2338: warning: long long unsigned int format, u64 arg (arg 7)
fs/ocfs2/xattr.c: In function `ocfs2_iterate_xattr_buckets':
fs/ocfs2/xattr.c:2362: warning: long long unsigned int format, u64 arg (arg 7)
fs/ocfs2/xattr.c:2362: warning: long long unsigned int format, u64 arg (arg 7)
fs/ocfs2/xattr.c:2362: warning: long long unsigned int format, u64 arg (arg 7)
fs/ocfs2/xattr.c:2381: warning: long long unsigned int format, u64 arg (arg 6)
fs/ocfs2/xattr.c:2381: warning: long long unsigned int format, u64 arg (arg 6)
fs/ocfs2/xattr.c:2381: warning: long long unsigned int format, u64 arg (arg 6)
fs/ocfs2/xattr.c: In function `ocfs2_xattr_create_index_block':
fs/ocfs2/xattr.c:2717: warning: long long unsigned int format, u64 arg (arg 6)
fs/ocfs2/xattr.c:2717: warning: long long unsigned int format, u64 arg (arg 6)

