Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbZKFWZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbZKFWZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759812AbZKFWZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:25:01 -0500
Received: from kroah.org ([198.145.64.141]:57213 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728AbZKFWXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:52 2009
Message-Id: <20091106221551.845376408@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [93/99] KVM: Prevent kvm_init from corrupting debugfs structures
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=kvm-prevent-kvm_init-from-corrupting-debugfs-structures.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Darrick J. Wong <djwong@us.ibm.com>

commit: 0ea4ed8e948c30f88c824c973ee4b9529015fe65 upstream
 
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
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/kvm_main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2590,8 +2590,6 @@ int kvm_init(void *opaque, unsigned int 
 	int r;
 	int cpu;
 
-	kvm_init_debug();
-
 	r = kvm_arch_init(opaque);
 	if (r)
 		goto out_fail;
@@ -2658,6 +2656,8 @@ int kvm_init(void *opaque, unsigned int 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
+	kvm_init_debug();
+
 	return 0;
 
 out_free:
@@ -2679,7 +2679,6 @@ out_free_0:
 	__free_page(bad_page);
 out:
 	kvm_arch_exit();
-	kvm_exit_debug();
 out_fail:
 	return r;
 }
@@ -2688,6 +2687,7 @@ EXPORT_SYMBOL_GPL(kvm_init);
 void kvm_exit(void)
 {
 	kvm_trace_cleanup();
+	kvm_exit_debug();
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
 	sysdev_unregister(&kvm_sysdev);
@@ -2697,7 +2697,6 @@ void kvm_exit(void)
 	on_each_cpu(hardware_disable, NULL, 1);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-	kvm_exit_debug();
 	free_cpumask_var(cpus_hardware_enabled);
 	__free_page(bad_page);
 }


