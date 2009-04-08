Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbZDHB7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbZDHB7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZDHB7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:59:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:27668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757935AbZDHB7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:59:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,340,1235980800"; 
   d="asc'?scan'208";a="401285307"
Subject: [PATH 2/2] kvm userspace: Add MCE simulation to kvm
From: Huang Ying <ying.huang@intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4T6BwCzRKLp300A1vmXi"
Date: Wed, 08 Apr 2009 09:59:30 +0800
Message-Id: <1239155970.6384.9.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4T6BwCzRKLp300A1vmXi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

- MCE features is initialized when VCPU is initialized according to CPUID.
- A monitor command "mce" is added to inject a MCE.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 libkvm/libkvm-x86.c    |   10 ++++++++++
 libkvm/libkvm.h        |    2 ++
 qemu/monitor.c         |   26 ++++++++++++++++++++++++++
 qemu/qemu-kvm-x86.c    |   22 +++++++++++++++++++++-
 qemu/qemu-kvm.c        |   26 ++++++++++++++++++++++++++
 qemu/qemu-kvm.h        |    4 ++++
 qemu/target-i386/cpu.h |    3 +++
 7 files changed, 92 insertions(+), 1 deletion(-)

--- a/qemu/monitor.c
+++ b/qemu/monitor.c
@@ -1556,6 +1556,31 @@ static void do_info_status(Monitor *mon)
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
+	CPUState *env;
+	struct kvm_x86_mce mce =3D {
+		.bank =3D bank,
+		.status =3D ((uint64_t)status_hi << 32) | status_lo,
+		.mcg_status =3D ((uint64_t)mcg_status_hi << 32) | mcg_status_lo,
+		.addr =3D ((uint64_t)addr_hi << 32) | addr_lo,
+		.misc =3D ((uint64_t)misc_hi << 32) | misc_lo,
+	};
+
+	for (env =3D first_cpu; env !=3D NULL; env =3D env->next_cpu)
+		if (env->cpu_index =3D=3D cpu_index && env->mcg_cap) {
+			kvm_inject_x86_mce(env, &mce);
+			break;
+		}
+}
+#endif
+
 static void do_balloon(Monitor *mon, int value)
 {
     ram_addr_t target =3D value;
@@ -1757,6 +1782,7 @@ static const mon_cmd_t mon_cmds[] =3D {
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
@@ -379,6 +379,16 @@ int kvm_set_msrs(kvm_context_t kvm, int=20
     return r;
 }
=20
+int kvm_setup_mce(kvm_context_t kvm, int vcpu, uint64_t *mcg_cap)
+{
+    return ioctl(kvm->vcpu_fd[vcpu], KVM_X86_SETUP_MCE, mcg_cap);
+}
+
+int kvm_set_mce(kvm_context_t kvm, int vcpu, struct kvm_x86_mce *m)
+{
+    return ioctl(kvm->vcpu_fd[vcpu], KVM_X86_SET_MCE, m);
+}
+
 static void print_seg(FILE *file, const char *name, struct kvm_segment *se=
g)
 {
     	fprintf(stderr,
--- a/libkvm/libkvm.h
+++ b/libkvm/libkvm.h
@@ -27,6 +27,8 @@ typedef struct kvm_context *kvm_context_
 struct kvm_msr_list *kvm_get_msr_list(kvm_context_t);
 int kvm_get_msrs(kvm_context_t, int vcpu, struct kvm_msr_entry *msrs, int =
n);
 int kvm_set_msrs(kvm_context_t, int vcpu, struct kvm_msr_entry *msrs, int =
n);
+int kvm_setup_mce(kvm_context_t, int vcpu, uint64_t *mcg_cap);
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
+    if (rc =3D=3D -1)
+	perror("kvm_set_mce FAILED");
+}
+
 static void do_cpuid_ent(struct kvm_cpuid_entry2 *e, uint32_t function,
                          uint32_t count, CPUState *env)
 {
@@ -510,7 +519,7 @@ int kvm_arch_qemu_init_env(CPUState *cen
     struct kvm_cpuid_entry2 *pv_ent;
     uint32_t signature[3];
 #endif
-    int cpuid_nent =3D 0;
+    int cpuid_nent =3D 0, family;
     CPUState copy;
     uint32_t i, j, limit;
=20
@@ -566,6 +575,17 @@ int kvm_arch_qemu_init_env(CPUState *cen
 	do_cpuid_ent(&cpuid_ent[cpuid_nent++], i, 0, &copy);
=20
     kvm_setup_cpuid2(kvm_context, cenv->cpu_index, cpuid_nent, cpuid_ent);
+
+#define MCG_CAP_DEF	0x904
+
+    if (((cenv->cpuid_version >> 8)&0xF) >=3D 6 &&
+	(cenv->cpuid_features&(CPUID_MCE|CPUID_MCA)) =3D=3D (CPUID_MCE|CPUID_MCA)=
) {
+	    uint64_t mcg_cap =3D MCG_CAP_DEF;
+	    if (kvm_setup_mce(kvm_context, cenv->cpu_index, &mcg_cap))
+		    perror("kvm_setup_mce FAILED");
+	    cenv->mcg_cap =3D mcg_cap;
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
+	CPUState *env;
+	struct kvm_x86_mce *mce;
+};
+
+static void kvm_do_inject_x86_mce(void *_data)
+{
+	struct kvm_x86_mce_data *data =3D _data;
+
+	kvm_arch_inject_x86_mce(data->env, data->mce);
+}
+
+void kvm_inject_x86_mce(CPUState *env, struct kvm_x86_mce *mce)
+{
+	struct kvm_x86_mce_data data;
+
+	if (kvm_enabled()) {
+		data.env =3D env;
+		data.mce =3D mce;
+		on_vcpu(env, kvm_do_inject_x86_mce, &data);
+	}
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


--=-4T6BwCzRKLp300A1vmXi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkncBP4ACgkQKhFGF+eHlpghCQCgotwqtPd2Ovrd291ng5GACLaP
6XQAn0RUvQV1i67yEzqax1J7ZrUsMTtN
=3vqq
-----END PGP SIGNATURE-----

--=-4T6BwCzRKLp300A1vmXi--

