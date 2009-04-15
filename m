Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZDOUgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZDOUgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZDOUgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:36:00 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36470 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZDOUf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:35:59 -0400
Date: Wed, 15 Apr 2009 21:34:41 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, viro@ZenIV.linux.org.uk,
       jmorris@namei.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
In-Reply-To: <200904150328.n3F3S0F9083222@www262.sakura.ne.jp>
Message-ID: <Pine.LNX.4.64.0904152036150.27354@blonde.anvils>
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp>
 <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk>
 <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
 <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk>
 <200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904141801300.24679@blonde.anvils>
 <200904150328.n3F3S0F9083222@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009, Tetsuo Handa wrote:
> Hugh Dickins wrote:
> > But my compiler on your config gives quite different function
> > sizes: please would you post to the list or send me privately
> > the output of "objdump -trd fs/exec.o", so we can check that.
> I uploaded it to http://I-love.SAKURA.ne.jp/tmp/dump-2.6.30-rc1-fs-exec.txt

Thanks, that confirmed that the problem indeed strikes in fs/exec.c's
count() function, where it's counting how many entries in the argv.

I've not worked out precisely why it gets stuck in that loop: apparently
the usual fixup_exception() isn't working here, so it just keeps retrying
the same instruction - I'm assuming it's an unwanted side-effect of your
CONFIG_DEBUG_PAGEALLOC=y, and I'm not going to worry too much about it.

I think I was quite wrong to dismiss the commit which you bisected to,
f520360d93cdc37de5d972dac4bf3bdef6a7f6a7 "kobject: don't block for
each kobject_uevent", as merely changing the timings: I now think
it's very much responsible for the problem.  call_usermodehelper
with UMH_NO_WAIT, but with argv[3] on the local stack, seems risky
to me, and your CONFIG_DEBUG_PAGEALLOC has caught it.

Patch below attempts to fix that, but I wouldn't be a bit surprised
if it's inadequate, that the "argv[1] = subsystem" is also vulnerable
to subsystem getting freed before we're ready - Greg?  If that's so,
then the best fix will probably be just to revert using UMH_NO_WAIT
there (other uses appear safe).  As Greg noted in the commit log, you
probably want CONFIG_UEVENT_HELPER_PATH="" rather than "/sbin/hotplug"
anyway, in which case this bug would not occur and this speedup would
not be needed.

(I don't see an "/sbin/hotplug" on my systems, but if I recall, it was
impossible to remove that default using "make oldconfig", and I ended
up editing the .config to put "" instead - but now I notice some of
my configs have "\"\"" in there, which probably isn't what I want!)

But I'm glad you had CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug" and
CONFIG_DEBUG_PAGEALLOC=y, they've shown us some bugs.  Though it
should be separated out to a separate patch later, I've flung in
below what I believe is the right fix to your NULL mm warnings.

Alan was absolutely right to ask us to look deeper into those than
just undoing his work - acct_stack_growth()'s overcommit check
should be applied to the mm it's expanding, not to the current
task's mm (which in this UMH_NO_WAIT case ends up as the NULL
mm of a separate kernel helper thread).

Please let us know if this patch does indeed fix the bugs you've
found - the question of "subsystem" getting freed is, I imagine,
a case too unlikely to come up in your testing, so I'd expect the
patch to appear to work, even if Greg and Arjan decide that it's
really better just to revert UMH_NO_WAIT there.

Not-yet-signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/kobject.h |    2 ++
 lib/kobject_uevent.c    |   10 ++++------
 mm/mmap.c               |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- 2.6.30-rc1/include/linux/kobject.h	2009-04-08 18:20:17.000000000 +0100
+++ linux/include/linux/kobject.h	2009-04-15 19:56:42.000000000 +0100
@@ -27,6 +27,7 @@
 #include <asm/atomic.h>
 
 #define UEVENT_HELPER_PATH_LEN		256
+#define UEVENT_NUM_ARGV			3	/* if inside kobj_uevent_env */
 #define UEVENT_NUM_ENVP			32	/* number of env pointers */
 #define UEVENT_BUFFER_SIZE		2048	/* buffer for the variables */
 
@@ -111,6 +112,7 @@ struct kobj_type {
 };
 
 struct kobj_uevent_env {
+	char *argv[UEVENT_NUM_ARGV];	/* sometimes useful for UMH_NO_WAIT */
 	char *envp[UEVENT_NUM_ENVP];
 	int envp_idx;
 	char buf[UEVENT_BUFFER_SIZE];
--- 2.6.30-rc1/lib/kobject_uevent.c	2009-04-08 18:20:24.000000000 +0100
+++ linux/lib/kobject_uevent.c	2009-04-15 19:59:33.000000000 +0100
@@ -244,11 +244,9 @@ int kobject_uevent_env(struct kobject *k
 
 	/* call uevent_helper, usually only enabled during early boot */
 	if (uevent_helper[0]) {
-		char *argv [3];
-
-		argv [0] = uevent_helper;
-		argv [1] = (char *)subsystem;
-		argv [2] = NULL;
+		env->argv[0] = uevent_helper;
+		env->argv[1] = (char *)subsystem;
+		env->argv[2] = NULL;
 		retval = add_uevent_var(env, "HOME=/");
 		if (retval)
 			goto exit;
@@ -257,7 +255,7 @@ int kobject_uevent_env(struct kobject *k
 		if (retval)
 			goto exit;
 
-		retval = call_usermodehelper(argv[0], argv,
+		retval = call_usermodehelper(env->argv[0], env->argv,
 					     env->envp, UMH_NO_WAIT);
 	}
 
--- 2.6.30-rc1/mm/mmap.c	2009-04-08 18:20:25.000000000 +0100
+++ linux/mm/mmap.c	2009-04-15 20:28:33.000000000 +0100
@@ -1575,7 +1575,7 @@ static int acct_stack_growth(struct vm_a
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory(grow))
+	if (security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */
