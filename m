Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZERQEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZERQEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZERQEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:04:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47941 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZERQEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:04:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] IMA: Minimal IMA policy and boot param for TCB IMA policy
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       eparis@redhat.com
Date: Mon, 18 May 2009 12:01:44 -0400
Message-ID: <20090518160144.31953.95567.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA TCB policy is dangerous.  A normal use can use all of a system's
memory (which cannot be freed) simply by building and running lots of
executables.  The TCB policy is also nearly useless because logging in as root
often causes a policy violation when dealing with utmp, thus rendering the
measurements meaningless.

There is no good fix for this in the kernel.  A full TCB policy would need to
be loaded in userspace using LSM rule matching to get both a protected and
useful system.  But, if too little is measured before userspace can load a real
policy one again ends up with a meaningless set of measurements.  One option
would be to put the policy load inside the initrd in order to get it early
enough in the boot sequence to be useful, but this runs into trouble with the
LSM.  For IMA to measure the LSM policy and the LSM policy loading mechanism
it needs rules to do so, but we already talked about problems with defaulting
to such broad rules....

The solution propsed here is to default IMA to use a very minimal set of
rules.  That set of rules is to only measure programs exec'ed (or files mmap'd
for exec) by root.  This should allow for future interesting uses of IMA such
as verfication of the binaries and libraries in question before asking for
encrypted disk passwords and such, while not opening the system up to easy DoS
attacks by normal users.

To allow for a more thorough set of measurements by IMA before a customized
policy is loaded by userspace I add the kernel command line option "ima_tcb".
This option will load the originally propsed IMA policy during kernel init.
Thus one gets the broad measurement coverage required before userspace can
load the customized policy if a user is so inclined.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 Documentation/kernel-parameters.txt |    6 ++++
 security/integrity/ima/ima_policy.c |   47 ++++++++++++++++++++++++++++++++---
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 95c523a..6a90c27 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -914,6 +914,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Formt: { "sha1" | "md5" }
 			default: "sha1"
 
+	ima_tcb		[IMA]
+			Load a policy which meets the needs of the Trusted
+			Computing Base.  This means IMA will measure all
+			programs exec'd, files mmap'd for exec, and all files
+			opened for read by uid=0.
+
 	in2000=		[HW,SCSI]
 			See header of drivers/scsi/in2000.c.
 
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index fd72d77..de0910a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -45,10 +45,30 @@ struct ima_measure_rule_entry {
 	} lsm[MAX_LSM_RULES];
 };
 
-/* Without LSM specific knowledge, the default policy can only be
+/*
+ * Without LSM specific knowledge, the default policy can only be
  * written in terms of .action, .func, .mask, .fsmagic, and .uid
  */
+
+/*
+ * Default for a 'normal' kernel with IMA enabled.  This measures only those
+ * files which are exec'd (or mmap for exec) by uid=0.  This attempts to be
+ * a minimal performance impact configuration while still being useful to some
+ * people.
+ */
 static struct ima_measure_rule_entry default_rules[] = {
+	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,.uid = 0,
+	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
+	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,.uid = 0,
+	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
+};
+
+/*
+ * The minimum rule set to allow for full TCB coverage.  Different than above
+ * because it measures all things exec'd by all users and everything read by
+ * root.
+ */
+static struct ima_measure_rule_entry tcb_default_rules[] = {
 	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
@@ -59,6 +79,8 @@ static struct ima_measure_rule_entry default_rules[] = {
 	 .flags = IMA_FUNC | IMA_MASK},
 	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
 	 .flags = IMA_FUNC | IMA_MASK},
+	{.action = MEASURE,.func = PATH_CHECK,.mask = MAY_READ,.uid = 0,
+	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
 };
 
 static LIST_HEAD(measure_default_rules);
@@ -67,6 +89,14 @@ static struct list_head *ima_measure;
 
 static DEFINE_MUTEX(ima_measure_mutex);
 
+static bool ima_use_tcb __initdata;
+static int __init default_policy_setup(char *str)
+{
+	ima_use_tcb = 1;
+	return 1;
+}
+__setup("ima_tcb", default_policy_setup);
+
 /**
  * ima_match_rules - determine whether an inode matches the measure rule.
  * @rule: a pointer to a rule
@@ -162,10 +192,19 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
  */
 void __init ima_init_policy(void)
 {
-	int i;
+	int i, entries;
+	struct ima_measure_rule_entry *rules;
+
+	if (ima_use_tcb) {
+		rules = tcb_default_rules;
+		entries = ARRAY_SIZE(tcb_default_rules);
+	} else {
+		rules = default_rules;
+		entries = ARRAY_SIZE(default_rules);
+	}
 
-	for (i = 0; i < ARRAY_SIZE(default_rules); i++)
-		list_add_tail(&default_rules[i].list, &measure_default_rules);
+	for (i = 0; i < entries; i++)
+		list_add_tail(&rules[i].list, &measure_default_rules);
 	ima_measure = &measure_default_rules;
 }
 

