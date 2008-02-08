Return-Path: <linux-kernel-owner+w=401wt.eu-S935602AbYBHUGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935602AbYBHUGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935115AbYBHUEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:04:45 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:49489 "EHLO
	outbound8-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935086AbYBHUEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:04:41 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Message-ID: <47ACB571.8070507@amd.com>
Date: Fri, 08 Feb 2008 15:02:57 -0500
From: "Barry Kasindorf" <barry.kasindorf@amd.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
cc: barry.kasindorf@amd.com
Subject: [PATCH 1/3] AMD Family10h IBS support for oProfile driver
X-OriginalArrivalTime: 08 Feb 2008 20:02:57.0750 (UTC)
 FILETIME=[9973DF60:01C86A8D]
X-WSS-ID: 6BB26AF32IW10897557-06-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
  nmi_int.c    |   43 +++++++++++++++++++++++++++++++++++++++++--
  op_counter.h |    9 +++++++++
  2 files changed, 50 insertions(+), 2 deletions(-)
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 9510b08..f47b614 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -31,6 +31,7 @@ static void nmi_stop(void);

  /* 0 == registered but off, 1 == registered and on */
  static int nmi_enabled = 0;
+int ibs_allowed;	/* AMD Family 10h+ */

  #ifdef CONFIG_PM

@@ -214,6 +215,11 @@ static int nmi_setup(void)
  		}

  	}
+
+	/*setup AMD Family10h IBS irq if needed */
+	if (ibs_allowed)
+		setup_ibs_nmi();
+
  	on_each_cpu(nmi_save_registers, NULL, 0, 1);
  	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
  	nmi_enabled = 1;
@@ -270,6 +276,10 @@ static void nmi_shutdown(void)
  	unregister_die_notifier(&profile_exceptions_nb);
  	model->shutdown(cpu_msrs);
  	free_msrs();
+
+	/*clear AMD Family 10h IBS irq if needed */
+	if (ibs_allowed)
+		clear_ibs_nmi();
  }

  static void nmi_cpu_start(void *dummy)
@@ -296,13 +306,15 @@ static void nmi_stop(void)
  }

  struct op_counter_config counter_config[OP_MAX_COUNTER];
+struct op_ibs_config ibs_config;

  static int nmi_create_files(struct super_block *sb, struct dentry *root)
  {
  	unsigned int i;
+	struct dentry *dir;

  	for (i = 0; i < model->num_counters; ++i) {
-		struct dentry *dir;
+
  		char buf[4];

  		/* quick little hack to _not_ expose a counter if it is not
@@ -323,6 +335,31 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
  		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
  	}

+	/* Setup AMD Family 10h IBS control if needed */
+	if (ibs_allowed) {
+		char buf[12];
+
+		/* setup some reasonable defaults */
+		ibs_config.max_cnt_fetch = 250000;
+		ibs_config.FETCH_enabled = 0;
+		ibs_config.max_cnt_op = 250000;
+		ibs_config.OP_enabled = 0;
+		snprintf(buf,  sizeof(buf), "ibs_fetch");
+		dir = oprofilefs_mkdir(sb, root, buf);
+		oprofilefs_create_ulong(sb, dir, "ran_enable",
+					&ibs_config.rand_en);
+		oprofilefs_create_ulong(sb, dir, "enable",
+					&ibs_config.FETCH_enabled);
+		oprofilefs_create_ulong(sb, dir, "max_count",
+					&ibs_config.max_cnt_fetch);
+		snprintf(buf,  sizeof(buf), "ibs_uops");
+		dir = oprofilefs_mkdir(sb, root, buf);
+		oprofilefs_create_ulong(sb, dir, "enable",
+					&ibs_config.OP_enabled);
+		oprofilefs_create_ulong(sb, dir, "max_count",
+					&ibs_config.max_cnt_op);
+	}
+
  	return 0;
  }

@@ -391,6 +428,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
  	__u8 vendor = boot_cpu_data.x86_vendor;
  	__u8 family = boot_cpu_data.x86;
  	char *cpu_type;
+	uint32_t eax, ebx, ecx, edx;

  	if (!cpu_has_apic)
  		return -ENODEV;
@@ -414,9 +452,17 @@ int __init op_nmi_init(struct oprofile_operations *ops)
  			break;
  		case 0x10:
  			model = &op_athlon_spec;
-			cpu_type = "x86-64/family10";
+			cpu_type = "x86-64/family10h";
+			/* This CPU has IBS capability */
+			ibs_allowed = 1;
  			break;
  		}
+		/* see if IBS is available */
+		if (family >= 0x10) {
+			cpuid(0x80000001, &eax, &ebx, &ecx, &edx);
+			if (ecx & 0x40)
+				ibs_allowed = 1;
+		}
  		break;

  	case X86_VENDOR_INTEL:
diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
index 2880b15..5681445 100644
--- a/arch/x86/oprofile/op_counter.h
+++ b/arch/x86/oprofile/op_counter.h
@@ -26,4 +26,13 @@ struct op_counter_config {

  extern struct op_counter_config counter_config[];

+struct op_ibs_config {
+	unsigned long OP_enabled;
+	unsigned long FETCH_enabled;
+	unsigned long max_cnt_fetch;
+	unsigned long max_cnt_op;
+	unsigned long rand_en;
+};
+
+extern struct op_ibs_config ibs_config;
  #endif /* OP_COUNTER_H */


