Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZA0IM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZA0IM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZA0IMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:12:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbZA0IMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:12:48 -0500
Date: Tue, 27 Jan 2009 00:12:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, kexec@lists.infradead.org, horms@verge.net.au
Subject: Re: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
Message-Id: <20090127001211.f847ea5a.akpm@linux-foundation.org>
In-Reply-To: <20090120152255.GB5125@redhat.com>
References: <20090119212127.GA13157@hmsreliant.think-freely.org>
	<20090120141551.GA5125@redhat.com>
	<20090120150958.GB18207@hmsreliant.think-freely.org>
	<20090120152255.GB5125@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 10:22:56 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Jan 20, 2009 at 10:09:58AM -0500, Neil Horman wrote:
> > On Tue, Jan 20, 2009 at 09:15:51AM -0500, Vivek Goyal wrote:
> > > On Mon, Jan 19, 2009 at 04:21:27PM -0500, Neil Horman wrote:
> > > > Hey all-
> > > > 	It would be nice to be able to extract the dmesg log from a vmcore file
> > > > without needing to keep the debug symbols for the running kernel handy all the
> > > > time.  We have a facility to do this in /proc/vmcore.  This patch adds the
> > > > log_buf and log_end symbols to the vmcoreinfo area so that tools (like
> > > > makedumpfile) can easily extract the dmesg logs from a vmcore image.
> > > > 
> > > 
> > > It would be nice to get dmesg log if debug symbols are not around. Can't
> > > we use System.map for getting symbol addresses? vmcoreinfo had started
> > > small and seems to be growing now. I am thinking down the line will making
> > > use of System.map for such cases make sense?
> > > 
> > 
> > System.map only include exported and public symbols.  log_buf and log_end are
> > static, and not reported in the System.map.  Its a nice idea, but not
> > comprehensive for everything in the kernel.
> > 
> > ><snip>
> > > 
> > > Will it be an issue if we make log_buf and log_end non static and directly
> > > access these in kexec.c?
> > > 
> > I had considered that, but was a bit hesitant to do so, since it exposes the
> > internal implementation of the dmesg buffer.  In the event someone disables
> > CONFIG_PRINTK, thats just more code we need to ifdef.  With this implementation
> > we just stub out the log_buf_setup function, and let that be that.  It seems
> > more consice to me this way.
> > 
> 
> Makes sense to me.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 

I rewrote the title to

	kexec: add dmesg log symbols to /proc/vmcoreinfo lists

it's nice to identify which subsystem is responsible for a patch.

I also did all the below.  Please check it.  (Is anyone else reading all
this stuff??)


From: Andrew Morton <akpm@linux-foundation.org>

- switch didnt-need-to-be-a-macro to inline

- Remove unneeded ifdefs (we already did that in the header)

- repair bouncy enter key

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 ++++-
 kernel/kexec.c         |    2 --
 kernel/printk.c        |    1 -
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/kernel.h~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix include/linux/kernel.h
--- a/include/linux/kernel.h~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix
+++ a/include/linux/kernel.h
@@ -254,7 +254,10 @@ static inline int printk_ratelimit(void)
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
-#define log_buf_kexec_setup() do {} while(0)
+
+static inline void log_buf_kexec_setup(void)
+{
+}
 #endif
 
 extern int printk_needs_cpu(int cpu);
diff -puN kernel/kexec.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix kernel/kexec.c
--- a/kernel/kexec.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix
+++ a/kernel/kexec.c
@@ -1409,9 +1409,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(list_head, prev);
 	VMCOREINFO_OFFSET(vm_struct, addr);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
-#ifdef CONFIG_PRINTK
 	log_buf_kexec_setup();
-#endif
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
diff -puN kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix kernel/printk.c
--- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix
+++ a/kernel/printk.c
@@ -143,7 +143,6 @@ void log_buf_kexec_setup(void)
 	VMCOREINFO_SYMBOL(log_end);
 }
 
-
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
_

