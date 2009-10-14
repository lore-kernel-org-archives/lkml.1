Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbZJNXVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbZJNXVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761080AbZJNXVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:21:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56624 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZJNXVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:21:44 -0400
Date: Wed, 14 Oct 2009 16:21:00 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm: Prevent kvm_init from corrupting debugfs structures
Message-ID: <20091014232100.GE26149@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing an oops condition when kvm-intel and kvm-amd are modprobe'd
during boot (say on an Intel system) and then rmmod'd:

   # modprobe kvm-intel
     kvm_init()
     kvm_init_debug()
     kvm_arch_init()  <-- stores debugfs dentries internally
     (success, etc)

   # modprobe kvm-amd
     kvm_init()
     kvm_init_debug() <-- second initialization clobbers kvm's
                          internal pointers to dentries
     kvm_arch_init()
     kvm_exit_debug() <-- and frees them

   # rmmod kvm-intel
     kvm_exit()
     kvm_exit_debug() <-- double free of debugfs files!

     *BOOM*

If execution gets to the end of kvm_init(), then the calling module has been
established as the kvm provider.  Move the debugfs initialization to the end of
the function, and remove the now-unnecessary call to kvm_exit_debug() from the
error path.  That way we avoid trampling on the debugfs entries and freeing
them twice.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 virt/kvm/kvm_main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b7c78a4..7495ce3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2717,8 +2717,6 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 	int r;
 	int cpu;
 
-	kvm_init_debug();
-
 	r = kvm_arch_init(opaque);
 	if (r)
 		goto out_fail;
@@ -2785,6 +2783,8 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_debug();
+
 	return 0;
 
 out_free:
@@ -2807,7 +2807,6 @@ out_free_0:
 out:
 	kvm_arch_exit();
 out_fail:
-	kvm_exit_debug();
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
@@ -2815,6 +2814,7 @@ EXPORT_SYMBOL_GPL(kvm_init);
 void kvm_exit(void)
 {
 	tracepoint_synchronize_unregister();
+	kvm_exit_debug();
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
 	sysdev_unregister(&kvm_sysdev);
@@ -2824,7 +2824,6 @@ void kvm_exit(void)
 	on_each_cpu(hardware_disable, NULL, 1);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-	kvm_exit_debug();
 	free_cpumask_var(cpus_hardware_enabled);
 	__free_page(bad_page);
 }
