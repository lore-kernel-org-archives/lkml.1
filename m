Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXC1Qjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXC1Qjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbXC1Qjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:39:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36352 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXC1Qjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:39:44 -0400
Subject: [Patch -mm] integrity: ima identifiers
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, sailer@us.ibm.com, zohar@us.ibm.com,
       akpm@osdl.org
Content-Type: text/plain
Date: Wed, 28 Mar 2007 12:38:33 -0400
Message-Id: <1175099913.16382.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the naming of global and other identifiers.

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
signed-off-by: Kylene Hall <kjhall@us.ibm.com>
---

---
 security/evm/ima/ima.h       |   24 ++++++++++++------------
 security/evm/ima/ima_fs.c    |   18 +++++++++---------
 security/evm/ima/ima_init.c  |   10 +++++-----
 security/evm/ima/ima_main.c  |    8 ++++----
 security/evm/ima/ima_queue.c |   24 ++++++++++++------------
 5 files changed, 42 insertions(+), 42 deletions(-)

Index: linux-2.6.21-rc5-mm2/security/evm/ima/ima.h
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/ima/ima.h
+++ linux-2.6.21-rc5-mm2/security/evm/ima/ima.h
@@ -34,26 +34,26 @@
 
 /* digest size for IMA, fits SHA1 or MD5 */
 #define IMA_DIGEST_SIZE		20
-#define TCG_EVENT_NAME_LEN_MAX	255
+#define IMA_EVENT_NAME_LEN_MAX	255
 
 #define IMA_HASH_BITS 9
-#define MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
-#define HASH_KEY(digest) (hash_long( \
+#define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
+#define IMA_HASH_KEY(digest) (hash_long( \
 	(unsigned long)(*digest), IMA_HASH_BITS));
 
 /* set during initialization */
 extern int ima_used_chip;
 
-struct measure_entry {
+struct ima_measure_entry {
 	u32 measure_flags;
 	u8 digest[IMA_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
-	char file_name[TCG_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
+	char file_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
 };
 
-struct queue_entry {
+struct ima_queue_entry {
 	struct hlist_node hnext;	/* place in hash collision list */
 	struct list_head later;	/* place in ima_measurements list */
-	struct measure_entry *entry;
+	struct ima_measure_entry *entry;
 };
 
 extern struct list_head ima_measurements;	/* list of all measurements */
@@ -61,10 +61,10 @@ extern struct list_head ima_measurements
 /* declarations */
 int ima_fs_init(void);
 void ima_fs_cleanup(void);
-void create_htable(void);
+void ima_create_htable(void);
 void ima_invalidate_pcr(char *);
-int ima_add_measure_entry(struct measure_entry *entry);
-struct queue_entry *ima_lookup_digest_entry(u8 * digest);
+int ima_add_measure_entry(struct ima_measure_entry *entry);
+struct ima_queue_entry *ima_lookup_digest_entry(u8 * digest);
 
 /*
  * used to protect h_table and sha_table
@@ -75,8 +75,8 @@ struct ima_h_table {
 	atomic_t len;	/* number of stored measurements in the list */
 	atomic_t violations;
 	unsigned int max_htable_size;
-	struct hlist_head queue[MEASURE_HTABLE_SIZE];
-	atomic_t queue_len[MEASURE_HTABLE_SIZE];
+	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
+	atomic_t queue_len[IMA_MEASURE_HTABLE_SIZE];
 };
 extern struct ima_h_table ima_htable;
 
Index: linux-2.6.21-rc5-mm2/security/evm/ima/ima_fs.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/ima/ima_fs.c
+++ linux-2.6.21-rc5-mm2/security/evm/ima/ima_fs.c
@@ -105,15 +105,15 @@ static int ima_measurements_show(struct 
 {
 	/* the list never shrinks, so we don't need a lock here */
 	struct list_head *lpos = v;
-	struct queue_entry *qe;
-	struct measure_entry *e;
+	struct ima_queue_entry *qe;
+	struct ima_measure_entry *e;
 	int filename_len;
 	int i;
 	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
 	char data[4];
 
 	/* get entry */
-	qe = list_entry(lpos, struct queue_entry, later);
+	qe = list_entry(lpos, struct ima_queue_entry, later);
 	e = qe->entry;
 	if (e == NULL)
 		return -1;
@@ -138,8 +138,8 @@ static int ima_measurements_show(struct 
 
 	/* 4th: eventDataSize */
 	filename_len = strlen(e->file_name);
-	if (filename_len > TCG_EVENT_NAME_LEN_MAX)
-		filename_len = TCG_EVENT_NAME_LEN_MAX;
+	if (filename_len > IMA_EVENT_NAME_LEN_MAX)
+		filename_len = IMA_EVENT_NAME_LEN_MAX;
 
 	memcpy(data, &filename_len, 4);
 	for (i = 0; i < 4; i++)
@@ -177,12 +177,12 @@ static int ima_ascii_measurements_show(s
 {
 	/* the list never shrinks, so we don't need a lock here */
 	struct list_head *lpos = v;
-	struct queue_entry *qe;
-	struct measure_entry *e;
+	struct ima_queue_entry *qe;
+	struct ima_measure_entry *e;
 	int i;
 
 	/* get entry */
-	qe = list_entry(lpos, struct queue_entry, later);
+	qe = list_entry(lpos, struct ima_queue_entry, later);
 	e = qe->entry;
 	if (e == NULL)
 		return -1;
@@ -269,7 +269,7 @@ out:
 	return -1;
 }
 
-void ima_fs_cleanup(void)
+void __exit ima_fs_cleanup(void)
 {
 	securityfs_remove(violations);
 	securityfs_remove(runtime_measurements_count);
Index: linux-2.6.21-rc5-mm2/security/evm/ima/ima_init.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/ima/ima_init.c
+++ linux-2.6.21-rc5-mm2/security/evm/ima/ima_init.c
@@ -28,18 +28,18 @@ int ima_used_chip;
 static void ima_add_boot_aggregate(void)
 {
 	/* cumulative sha1 over tpm registers 0-7 */
-	struct measure_entry *entry;
+	struct ima_measure_entry *entry;
 	size_t count;
 	int err;
 
 	/* create new entry for boot aggregate */
-	entry = kzalloc(sizeof(struct measure_entry), GFP_ATOMIC);
+	entry = kzalloc(sizeof(struct ima_measure_entry), GFP_ATOMIC);
 	if (entry == NULL) {
 		ima_invalidate_pcr("error allocating new measurement entry");
 		return;
 	}
-	if ((count = strlen(boot_aggregate_name)) > TCG_EVENT_NAME_LEN_MAX)
-		count = TCG_EVENT_NAME_LEN_MAX;
+	if ((count = strlen(boot_aggregate_name)) > IMA_EVENT_NAME_LEN_MAX)
+		count = IMA_EVENT_NAME_LEN_MAX;
 	memcpy(entry->file_name, boot_aggregate_name, count);
 	entry->file_name[count] = '\0';
 	if (ima_used_chip) {
@@ -103,7 +103,7 @@ int ima_init(void)
 		ima_info("No TPM chip found(rc = %d), activating TPM-bypass!\n",
 			rc);
 
-	create_htable();	/* for measurements */
+	ima_create_htable();	/* for measurements */
 
 	/* boot aggregate must be very first entry */
 	ima_add_boot_aggregate();
Index: linux-2.6.21-rc5-mm2/security/evm/ima/ima_main.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/ima/ima_main.c
+++ linux-2.6.21-rc5-mm2/security/evm/ima/ima_main.c
@@ -41,7 +41,7 @@
  */
 void ima_measure(const unsigned char *name, int hash_len, char *hash)
 {
-	struct measure_entry *entry;
+	struct ima_measure_entry *entry;
 	u8 digest[IMA_DIGEST_SIZE];
 	int err = 0, count;
 
@@ -64,15 +64,15 @@ void ima_measure(const unsigned char *na
 		return;
 
 	/* create new entry and add to measurement list */
-	entry = kzalloc(sizeof(struct measure_entry), GFP_ATOMIC);
+	entry = kzalloc(sizeof(struct ima_measure_entry), GFP_ATOMIC);
 	if (!entry) {
 		ima_error("Error allocating new measurement entry");
 		return;		/* invalidate pcr */
 	}
 
 	entry->measure_flags = 0;
-	if ((count = strlen(name)) > TCG_EVENT_NAME_LEN_MAX)
-		count = TCG_EVENT_NAME_LEN_MAX;
+	if ((count = strlen(name)) > IMA_EVENT_NAME_LEN_MAX)
+		count = IMA_EVENT_NAME_LEN_MAX;
 
 	memcpy(entry->file_name, name, count);
 	entry->file_name[count] = '\0';
Index: linux-2.6.21-rc5-mm2/security/evm/ima/ima_queue.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/ima/ima_queue.c
+++ linux-2.6.21-rc5-mm2/security/evm/ima/ima_queue.c
@@ -34,7 +34,7 @@ DEFINE_SPINLOCK(ima_queue_lock);
  */
 static DEFINE_MUTEX(ima_extend_list_mutex);
 
-void create_htable(void)
+void ima_create_htable(void)
 {
 	int i;
 
@@ -42,7 +42,7 @@ void create_htable(void)
 	INIT_LIST_HEAD(&ima_measurements);
 	atomic_set(&ima_htable.len, 0);
 	atomic_set(&ima_htable.violations, 0);
-	ima_htable.max_htable_size = MEASURE_HTABLE_SIZE;
+	ima_htable.max_htable_size = IMA_MEASURE_HTABLE_SIZE;
 
 	for (i = 0; i < ima_htable.max_htable_size; i++) {
 		INIT_HLIST_HEAD(&ima_htable.queue[i]);
@@ -53,13 +53,13 @@ void create_htable(void)
 	spin_unlock(&ima_queue_lock);
 }
 
-struct queue_entry *ima_lookup_digest_entry(u8 * digest_value)
+struct ima_queue_entry *ima_lookup_digest_entry(u8 * digest_value)
 {
-	struct queue_entry *qe, *ret = NULL;
+	struct ima_queue_entry *qe, *ret = NULL;
 	unsigned int key;
 	struct hlist_node *pos;
 
-	key = HASH_KEY(digest_value);
+	key = IMA_HASH_KEY(digest_value);
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(qe, pos, &ima_htable.queue[key], hnext) {
 		if (memcmp(qe->entry->digest, digest_value, 20) == 0) {
@@ -72,13 +72,13 @@ struct queue_entry *ima_lookup_digest_en
 }
 
 /* Called with ima_queue_lock held */
-static int ima_add_digest_entry(struct measure_entry *entry)
+static int ima_add_digest_entry(struct ima_measure_entry *entry)
 {
-	struct queue_entry *qe;
+	struct ima_queue_entry *qe;
 	unsigned int key;
 
-	key = HASH_KEY(entry->digest);
-	qe = kmalloc(sizeof(struct queue_entry), GFP_ATOMIC);
+	key = IMA_HASH_KEY(entry->digest);
+	qe = kmalloc(sizeof(struct ima_queue_entry), GFP_ATOMIC);
 	if (qe == NULL) {
 		ima_error("OUT OF MEMORY ERROR creating queue entry.\n");
 		return -ENOMEM;
@@ -90,9 +90,9 @@ static int ima_add_digest_entry(struct m
 	return 0;
 }
 
-int ima_add_measure_entry(struct measure_entry *entry)
+int ima_add_measure_entry(struct ima_measure_entry *entry)
 {
-	struct queue_entry *qe;
+	struct ima_queue_entry *qe;
 	int error = 0;
 
 	mutex_lock(&ima_extend_list_mutex);
@@ -102,7 +102,7 @@ int ima_add_measure_entry(struct measure
 		spin_unlock(&ima_queue_lock);
 		goto out;
 	}
-	qe = kmalloc(sizeof(struct queue_entry), GFP_ATOMIC);
+	qe = kmalloc(sizeof(struct ima_queue_entry), GFP_ATOMIC);
 	if (qe == NULL) {
 		ima_error("OUT OF MEMORY in %s.\n", __func__);
 		error = -ENOMEM;


