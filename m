Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbZDQHjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbZDQHjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbZDQHiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:38:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:65410 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbZDQHit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:38:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="asc'?scan'208";a="507244876"
Subject: [PATCH -v2 2/2] kvm userspace: Add MCE simulation to kvm
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bC0ArzzE50XybePK+X3T"
Date: Fri, 17 Apr 2009 15:38:45 +0800
Message-Id: <1239953925.6842.21.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bC0ArzzE50XybePK+X3T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

- MCE features are initialized when VCPU is initialized according to CPUID.
- A monitor command "mce" is added to inject a MCE.


ChangeLog:

v2:

- Use new kernel MCE capability exportion interface.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 libkvm/libkvm-x86.c    |   33 +++++++++++++++++++++++++++++++++
 libkvm/libkvm.h        |    4 ++++
 qemu/monitor.c         |   26 ++++++++++++++++++++++++++
 qemu/qemu-kvm-x86.c    |   33 +++++++++++++++++++++++++++++++++
 qemu/qemu-kvm.c        |   26 ++++++++++++++++++++++++++
 qemu/qemu-kvm.h        |    4 ++++
 qemu/target-i386/cpu.h |    3 +++
 7 files changed, 129 insertions(+)

--- a/qemu/monitor.c
+++ b/qemu/monitor.c
@@ -1557,6 +1557,31 @@ static void do_info_status(Monitor *mon)
 }
=20
=20
+#if defined(TARGET_I386) || defined(TARGET_X86_64)
+static void do_inject_mce(Monitor *mon,
+			  int cpu_index, int bank,
+			  unsigned status_hi, unsigned status_lo,
+			  unsigned mcg_status_hi, unsigned mcg_status_lo,
+			  unsigned addr_hi, unsigned addr_lo,
+			  unsigned misc_hi, unsigned misc_lo)
+{
+    CPUState *env;
+    struct kvm_x86_mce mce =3D {
+	.bank =3D bank,
+	.status =3D ((uint64_t)status_hi << 32) | status_lo,
+	.mcg_status =3D ((uint64_t)mcg_status_hi << 32) | mcg_status_lo,
+	.addr =3D ((uint64_t)addr_hi << 32) | addr_lo,
+	.misc =3D ((uint64_t)misc_hi << 32) | misc_lo,
+    };
+
+    for (env =3D first_cpu; env !=3D NULL; env =3D env->next_cpu)
+	if (env->cpu_index =3D=3D cpu_index && env->mcg_cap) {
+	    kvm_inject_x86_mce(env, &mce);
+	    break;
+	}
+}
+#endif
+
 static void do_balloon(Monitor *mon, int value)
 {
     ram_addr_t target =3D value;
@@ -1758,6 +1783,7 @@ static const mon_cmd_t mon_cmds[] =3D {
       "[tap,user,socket,vde] options", "add host VLAN client" },
     { "host_net_remove", "is", net_host_device_remove,
       "vlan_id name", "remove host VLAN client" },
+    { "mce", "iillll", do_inject_mce, "cpu bank status mcgstatus addr misc=
", "inject a MCE on the given CPU"},
 #endif
     { "balloon", "i", do_balloon,
       "target", "request VM to change it's memory allocation (in MB)" },
--- a/libkvm/libkvm-x86.c
+++ b/libkvm/libkvm-x86.c
@@ -379,6 +379,39 @@ int kvm_set_msrs(kvm_context_t kvm, int=20
     return r;
 }
=20
+int kvm_get_mce_cap_supported(kvm_context_t kvm, uint64_t *mce_cap,
+			      int *max_banks)
+{
+    int r;
+
+    r =3D ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
+    if (r > 0) {
+	*max_banks =3D r;
+	return ioctl(kvm->fd, KVM_X86_GET_MCE_CAP_SUPPORTED, mce_cap);
+    }
+    return -ENOSYS;
+}
+
+int kvm_setup_mce(kvm_context_t kvm, int vcpu, uint64_t *mcg_cap)
+{
+    int r;
+
+    r =3D ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
+    if (r > 0)
+	return ioctl(kvm->vcpu_fd[vcpu], KVM_X86_SETUP_MCE, mcg_cap);
+    return -ENOSYS;
+}
+
+int kvm_set_mce(kvm_context_t kvm, int vcpu, struct kvm_x86_mce *m)
+{
+    int r;
+
+    r =3D ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
+    if (r > 0)
+	return ioctl(kvm->vcpu_fd[vcpu], KVM_X86_SET_MCE, m);
+    return -ENOSYS;
+}
+
 static void print_seg(FILE *file, const char *name, struct kvm_segment *se=
g)
 {
     	fprintf(stderr,
--- a/libkvm/libkvm.h
+++ b/libkvm/libkvm.h
@@ -27,6 +27,10 @@ typedef struct kvm_context *kvm_context_
 struct kvm_msr_list *kvm_get_msr_list(kvm_context_t);
 int kvm_get_msrs(kvm_context_t, int vcpu, struct kvm_msr_entry *msrs, int =
n);
 int kvm_set_msrs(kvm_context_t, int vcpu, struct kvm_msr_entry *msrs, int =
n);
+int kvm_get_mce_cap_supported(kvm_context_t, uint64_t *mce_cap, int *max_b=
anks);
+int kvm_setup_mce(kvm_context_t, int vcpu, uint64_t *mcg_cap);
+struct kvm_x86_mce;
+int kvm_set_mce(kvm_context_t, int vcpu, struct kvm_x86_mce *mce);
 #endif
=20
 /*!
--- a/qemu/qemu-kvm-x86.c
+++ b/qemu/qemu-kvm-x86.c
@@ -457,6 +457,15 @@ void kvm_arch_save_regs(CPUState *env)
     }
 }
=20
+void kvm_arch_inject_x86_mce(CPUState *env, struct kvm_x86_mce *mce)
+{
+    int rc;
+
+    rc =3D kvm_set_mce(kvm_context, env->cpu_index, mce);
+    if (rc < 0)
+	perror("kvm_set_mce FAILED");
+}
+
 static void do_cpuid_ent(struct kvm_cpuid_entry2 *e, uint32_t function,
                          uint32_t count, CPUState *env)
 {
@@ -566,6 +575,30 @@ int kvm_arch_qemu_init_env(CPUState *cen
 	do_cpuid_ent(&cpuid_ent[cpuid_nent++], i, 0, &copy);
=20
     kvm_setup_cpuid2(kvm_context, cenv->cpu_index, cpuid_nent, cpuid_ent);
+
+    if (((cenv->cpuid_version >> 8)&0xF) >=3D 6
+	&& (cenv->cpuid_features&(CPUID_MCE|CPUID_MCA)) =3D=3D (CPUID_MCE|CPUID_M=
CA)
+	&& kvm_check_extension(kvm_context, KVM_CAP_MCE) > 0) {
+	uint64_t mcg_cap;
+	int banks;
+
+#define MCE_CAP_DEF	0x100
+#define MCE_BANKS_DEF	4
+
+	if (kvm_get_mce_cap_supported(kvm_context, &mcg_cap, &banks))
+	    perror("kvm_get_mce_cap_supported FAILED");
+	else {
+	    if (banks > MCE_BANKS_DEF)
+		banks =3D MCE_BANKS_DEF;
+	    mcg_cap &=3D MCE_CAP_DEF;
+	    mcg_cap |=3D banks;
+	    if (kvm_setup_mce(kvm_context, cenv->cpu_index, &mcg_cap))
+		perror("kvm_setup_mce FAILED");
+	    else
+		cenv->mcg_cap =3D mcg_cap;
+	}
+    }
+
     return 0;
 }
=20
--- a/qemu/qemu-kvm.h
+++ b/qemu/qemu-kvm.h
@@ -74,6 +74,8 @@ int kvm_arch_try_push_interrupts(void *o
 void kvm_arch_push_nmi(void *opaque);
 void kvm_arch_update_regs_for_sipi(CPUState *env);
 void kvm_arch_cpu_reset(CPUState *env);
+struct kvm_x86_mce;
+void kvm_arch_inject_x86_mce(CPUState *env, struct kvm_x86_mce *mce);
=20
 struct kvm_guest_debug;
 struct kvm_debug_exit_arch;
@@ -233,4 +235,6 @@ static inline void cpu_synchronize_state
     }
 }
=20
+void kvm_inject_x86_mce(CPUState *env, struct kvm_x86_mce *mce);
+
 #endif
--- a/qemu/qemu-kvm.c
+++ b/qemu/qemu-kvm.c
@@ -198,6 +198,32 @@ void kvm_save_registers(CPUState *env)
         on_vcpu(env, kvm_do_save_registers, env);
 }
=20
+#if defined(TARGET_I386) || defined(TARGET_X86_64)
+struct kvm_x86_mce_data
+{
+    CPUState *env;
+    struct kvm_x86_mce *mce;
+};
+
+static void kvm_do_inject_x86_mce(void *_data)
+{
+    struct kvm_x86_mce_data *data =3D _data;
+
+    kvm_arch_inject_x86_mce(data->env, data->mce);
+}
+
+void kvm_inject_x86_mce(CPUState *env, struct kvm_x86_mce *mce)
+{
+    struct kvm_x86_mce_data data;
+
+    if (kvm_enabled()) {
+	data.env =3D env;
+	data.mce =3D mce;
+	on_vcpu(env, kvm_do_inject_x86_mce, &data);
+    }
+}
+#endif
+
 int kvm_cpu_exec(CPUState *env)
 {
     int r;
--- a/qemu/target-i386/cpu.h
+++ b/qemu/target-i386/cpu.h
@@ -661,6 +661,9 @@ typedef struct CPUX86State {
         uint64_t mask;
     } mtrr_var[8];
=20
+    /* MCE capability */
+    uint64_t mcg_cap;
+
 #ifdef USE_KQEMU
     int kqemu_enabled;
     int last_io_time;


--=-bC0ArzzE50XybePK+X3T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknoMgAACgkQKhFGF+eHlpjXCQCgnvlBHPCIUfAROKL35YNhdgJ5
s8UAoKplg98SxM165rqO9w9ex1193F1Q
=6Ijr
-----END PGP SIGNATURE-----

--=-bC0ArzzE50XybePK+X3T--

