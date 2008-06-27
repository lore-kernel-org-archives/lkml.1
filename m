Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbYF0QZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbYF0QZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760655AbYF0QXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:23:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57612 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761656AbYF0QXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:23:48 -0400
Subject: LTP IMA patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Reiner Sailer <sailer@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Subrata Modak <tosubrata@gmail.com>
References: <20080627131946.225566613@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 12:23:38 -0400
Message-Id: <1214583818.28077.19.camel@new-host.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This LTP patch tests the LIM/IMA functionality.

Index: ltp-base-20080531/testcases/kernel/integrity/ima/ima_test.sh
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/ima_test.sh
@@ -0,0 +1,135 @@
+#!/bin/bash
+# Copyright (C) 2008 IBM Corporation
+# Author: Mimi Zohar <zohar@us.ibm.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation, version 2 of the
+# License.
+
+# The default policy on boot measures all executables, all
+# mmapped executable files, and all files open for read.
+#
+# test 0: verify running as root.
+# test 1: verify TPM is enabled.
+# test 2: verify creating and reading a new file causes a new
+# 	  measurement to be added to the IMA measurement list.
+# test 3: verify modifying and reading the new file causes a new
+# 	  measurement to be added to the IMA measurement list.
+# test 4: verify ability to load a new measurement policy
+# test 5: verify new policy does not add a measurement to the
+#	  IMA measurement list for files open for read.
+# test 6: verify inability to load subsequent measurement policy.
+# test 7: verify template hash value for ima entry is correct.
+# test 8: verify ima calculated aggregate pcr value or matches actual pcr value.
+# test 9: verify kmem-template hash
+
+# test 0:
+id=`id -u`
+if [ $id -eq 0 ]; then
+	echo "test 0: success - running as root "
+else
+	echo "test 0: failed - must be running as root"
+	exit 1
+fi
+
+# test 1:
+PCRS_PATH=`find /sys/devices/ | grep pcrs`
+if [ $? -eq 0 ]; then
+	if [ ! -f $PCRS_PATH ]; then
+		echo "test 1: failed - TPM not enabled"
+		echo "(Assuming securityfs is mounted as /sys.)"
+	else
+		echo "test 1: succeeded - TPM enabled"
+	fi
+else
+	echo "test 1: failed - TPM not enabled"
+	echo "(Assuming securityfs is mounted as /sys.)"
+fi
+
+# test 2:
+chmod a+x ./measure/read_measure.sh
+./measure/read_measure.sh
+if [ $? -eq 0 ]; then
+	echo "test 2: success - file measured"
+else
+	echo "test 2: failed - file not measured"
+fi
+
+# test 3:
+chmod a+x ./measure/re-measure.sh
+./measure/re-measure.sh
+if [ $? -eq 0 ]; then
+	echo "test 3: success - modified file measured"
+else
+	echo "test 3: failed - modified file not measured. "
+	echo "(Make sure filesystem is mounted with iversion.)"
+fi
+
+# test 4:
+cd loadpolicy
+chmod a+x ./load_policy.sh
+./load_policy.sh
+if [ $? -eq 0 ]; then
+	echo "test 4: success - loaded policy"
+else
+	echo "test 4: failed - loading policy(permitted once per boot)"
+	echo "(Assuming securityfs is mounted as /sys.)"
+fi
+
+# test 5:
+cd ../measure
+# make sure that date has changed for measurement test
+sleep 1
+./read_measure.sh
+if [ $? -eq 0 ]; then
+	echo "test 5: failed - shouldn't have measured the file"
+	echo "(Verify loaded correct ima measurement policy.)"
+else
+	echo "test 5: succeeded - didn't measure the file"
+fi
+
+# test 6:
+cd ../loadpolicy
+./load_policy.sh
+if [ $? -eq 0 ]; then
+	echo "test 6: failed - shouldn't have loaded a policy"
+else
+	echo "test 6: succeeded - didn't load a policy"
+fi
+
+# test 7:
+cd ../tpm
+chmod a+x ./ima_measure
+./ima_measure --validate > /dev/null
+if [ $? -eq 0 ]; then
+	echo "test 7: succeeded - verified ima template hash values."
+else
+	echo "test 7: failed - errors in verifying ima template hash values."
+fi
+
+# test 8:
+aggregate_pcr=`./ima_measure --validate` > /dev/null
+cat $PCRS_PATH | while read line ; do
+	if [ "${line:0:6}" == "PCR-10" ] ; then
+		if [ "${line:8:67}" == "${aggregate_pcr:0:59}" ] ; then
+			echo "test 8: succeeded - aggregate pcr value"\
+				"matches real pcr value."
+		else
+			echo "test 8: failed - aggregate pcr value does"\
+				"not match real pcr value."
+			echo 'aggregate_pcr: ' $aggregate_pcr
+			echo 'real pcr: ' $line
+		fi
+	fi
+done
+
+# test 9:
+cd ../kmem
+chmod a+x ./kmem-test.sh
+./kmem-test.sh
+if [ $? -eq 0 ]; then
+	echo "test 9: succeeded - verified kmem template measurement"
+else
+	echo "test 9: failed - kmem template measurement "
+fi
Index: ltp-base-20080531/testcases/kernel/integrity/ima/loadpolicy/load_policy.sh
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/loadpolicy/load_policy.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+
+# Copyright (C) 2008 IBM Corporation
+# Author: Mimi Zohar <zohar@us.ibm.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation, version 2 of the
+# License.
+
+# Load a policy into security/ima/policy by opening the file,
+# writing the rules one at a time and then closing the file.
+# The new policy takes effect after the security/ima/policy
+# is closed.
+
+mkdir -p tmp
+
+# depends on where securityfs is mounted
+IMA_POLICY=/sys/kernel/security/ima/policy
+
+# LSM specific policy
+LSM_POLICY=./measure.selinux
+#LSM_POLICY=./measure.smack
+
+if [ ! -f $LSM_POLICY ]; then
+	echo "        LSM specific policy does not exist"
+	exit -1
+fi
+
+if [ ! -f $IMA_POLICY ]; then
+	echo "        security/ima/policy does not exist"
+	exit -1
+fi
+
+exec 4>$IMA_POLICY
+if [ $? != 0 ]; then
+	echo "        open failed: security/ima/policy"
+	exit -1
+else
+	cat $LSM_POLICY | while read line ; do
+		if [ "${line:0:1}" != "#" ] ; then
+			echo $line >&4
+		fi
+	done
+	echo "        security/ima/policy updated"
+fi
Index: ltp-base-20080531/testcases/kernel/integrity/ima/loadpolicy/measure.selinux
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/loadpolicy/measure.selinux
@@ -0,0 +1,18 @@
+#
+# Integrity measure policy
+#
+# PROC_SUPER_MAGIC
+dont_measure fsmagic=0x9fa0
+# SYSFS_MAGIC
+dont_measure fsmagic=0x62656572
+# DEBUGFS_MAGIC
+dont_measure fsmagic=0x64626720
+# TMPFS_MAGIC
+dont_measure fsmagic=0x01021994
+# SECURITYFS_MAGIC
+dont_measure fsmagic=0x73636673
+measure func=BPRM_CHECK
+measure func=FILE_MMAP mask=MAY_EXEC
+#measure subj=system_u func=INODE_PERMISSION mask=MAY_READ
+measure obj=user_u func=INODE_PERMISSION mask=MAY_READ
+#measure func=INODE_PERMISSION mask=MAY_READ
Index: ltp-base-20080531/testcases/kernel/integrity/ima/measure/read_measure.sh
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/measure/read_measure.sh
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+# Copyright (C) 2008 IBM Corporation
+# Author: Mimi Zohar <zohar@us.ibm.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation, version 2 of the
+# License.
+
+# Create and read a file
+# Check if the file was measured (i.e. contained in the ascii measurement list.)
+
+mkdir -p tmp
+echo `date` '- changing date causes changing hash value' > tmp/test.txt
+cat tmp/test.txt > /dev/null
+cat /sys/kernel/security/ima/ascii_runtime_measurements > tmp/imalog
+
+# calculate and search for sha1sum of tmp/test.txt in tmp/imalog
+hash=`cat tmp/test.txt | sha1sum | sed 's/  -//'`
+echo '        hash: ' $hash
+`grep $hash tmp/imalog > /dev/null`
+if [ $? == 0 ]; then
+	echo "        TPM ascii measurement list contains sha1sum"
+	exit 0
+else
+	echo "        TPM ascii measurement list does not contain sha1sum"
+	exit -1
+fi
Index: ltp-base-20080531/testcases/kernel/integrity/ima/tpm/ima_measure.c
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/tpm/ima_measure.c
@@ -0,0 +1,261 @@
+/*
+ * Copyright (c) International Business Machines  Corp., 2008
+ *
+ * Authors:
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_measure.c
+ *
+ * Calculate the aggregate-pcr value based on the IMA runtime binary
+ * measurements.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+#include <openssl/sha.h>
+
+#define TCG_EVENT_NAME_LEN_MAX	255
+#define MAX_EVENT_SIZE 500
+
+static int failed_count = 0;	/* number of template verifications failed */
+static int verify_template_hash = 1;
+static int verbose = 0;
+static int validate = 0;
+
+#define print_info(format, arg...) \
+	if (verbose) \
+		printf(format, ##arg)
+
+static u_int8_t pcr[SHA_DIGEST_LENGTH];	/* simulates the PCR aggregate */
+static u_int8_t zero[SHA_DIGEST_LENGTH];
+static u_int8_t fox[SHA_DIGEST_LENGTH];
+struct template {
+	u_int32_t pcr;
+	u_int8_t tdigest[SHA_DIGEST_LENGTH];	/* template digest */
+	u_int32_t tlen;				/* template name size */
+};
+
+struct ima_inode_measure_entry {
+        u_int8_t digest[SHA_DIGEST_LENGTH];	/* sha1 measurement hash */
+       	char file_name[TCG_EVENT_NAME_LEN_MAX + 1];	/*name + \0*/
+};
+
+/* print sha1 aggregate over the template measurements */
+static int display_pcr()
+{
+	int i;
+
+	print_info("PCRAggr (re-calculated):");
+	for (i = 0; i < 20; i++)
+		printf("%02X ", pcr[i] & 0xff);
+	print_info(".\n");
+}
+
+static void print_digest(u_int8_t *digest)
+{
+	int i;
+
+	for (i = 0; i < 20; i++)
+		print_info("%02X", (*(digest + i) & 0xff));
+}
+
+/*
+ * Calculate the template hash of an ima entry
+ * and compare it with the actual template hash value.
+ */
+static int verify_ima_tdigest(struct template *tdata,
+			struct ima_inode_measure_entry *ima)
+{
+	int rc;
+	SHA_CTX tmp;
+	u_int8_t digest[SHA_DIGEST_LENGTH];
+
+	/* Calc template hash for an ima entry */
+	SHA1_Init(&tmp);
+	SHA1_Update(&tmp, ima, sizeof *ima);
+	SHA1_Final(digest, &tmp);
+
+	rc = memcmp(digest, tdata->tdigest, sizeof digest);
+	if (rc) {
+		int i;
+
+		print_info("%s: template hash not valid\n", ima->file_name);
+		print_info("\t should be:");
+		print_digest(digest);
+		print_info("\n\t        is:");
+		print_digest(tdata->tdigest);
+		print_info("\n");
+	}
+	return rc;
+}
+
+int process_event(int num, unsigned char *event, int len)
+{
+	int i;
+	char tname[TCG_EVENT_NAME_LEN_MAX + 1];	/* template_name */
+	u_int32_t tname_len;	/* template name length */
+	struct template *tdata;
+
+	tdata = (struct template *)event;
+
+	print_info("%3d %03u %d", num, tdata->pcr, tdata->tlen);
+	if (tdata->tlen > TCG_EVENT_NAME_LEN_MAX) {
+		printf("ERROR: event name too long!\n");
+		exit(1);
+	}
+	memset(tname, 0, TCG_EVENT_NAME_LEN_MAX);
+	memcpy(&tname, &tdata->tlen +1, tdata->tlen);
+	print_digest(tdata->tdigest);
+	print_info(" %s ", (char *)(tname));
+
+	if (strcmp(tname, "boot_aggregate") == 0) {
+		print_info("\n");
+		return (sizeof *tdata + tdata->tlen + 2) /* separator */ ;
+	} else if (strcmp(tname, "ima") == 0) {
+		struct event_data {
+			u_int8_t digest[SHA_DIGEST_LENGTH];
+			int len;		/* file_name length */
+        		char file_name[TCG_EVENT_NAME_LEN_MAX + 1];/*name + \0*/
+		} *data;
+
+		data = (struct event_data *)((void *)tdata
+				+ sizeof *tdata + tdata->tlen);
+		print_digest(data->digest);
+		data->file_name[data->len] = 0x00;
+		print_info(" %s\n", data->file_name);
+
+		if (validate && (memcmp(fox, tdata->tdigest, sizeof fox) != 0)){
+			struct ima_inode_measure_entry entry;
+
+			memset(&entry, 0, sizeof entry);
+			memcpy(&entry.digest, data->digest, 20);
+			strncpy(entry.file_name, data->file_name, data->len);
+			failed_count += verify_ima_tdigest(tdata, &entry);
+		}
+		return (sizeof *tdata  + tdata->tlen + sizeof data->digest
+				+ data->len + 4); /* null separator */
+	} else if (strcmp(tname, "kmem") == 0) {
+		struct event_data {
+			u_int8_t digest[SHA_DIGEST_LENGTH];
+			int len;		/* file_name length */
+        		char file_name[TCG_EVENT_NAME_LEN_MAX + 1];/*name + \0*/
+		} *data;
+
+		data = (struct event_data *)((void *)tdata
+				+ sizeof *tdata + tdata->tlen);
+		print_digest(data->digest);
+		return (sizeof *tdata  + tdata->tlen + sizeof data->digest
+				+ data->len + 4); /* null separator */
+	}
+}
+
+int simulate_extend_pcr(u_int8_t digest[SHA_DIGEST_LENGTH])
+{
+	SHA_CTX c;
+
+	/* Extend simulated PCR with new template digest */
+	SHA1_Init(&c);
+	SHA1_Update(&c, pcr, SHA_DIGEST_LENGTH);
+	if (validate) {
+		if (memcmp(digest, zero, 20) == 0)
+			memset(digest, 0xFF, 20);
+	}
+	SHA1_Update(&c, digest, 20);
+	SHA1_Final(pcr, &c);
+}
+
+/*
+ * ima_measurements.c - calculate the aggregate-pcr value based on
+ * the IMA runtime binary measurements.
+ *
+ * format: ima_measurement [--validate] [--verify] [--verbose]
+ *
+ * --validate: forces validation of the aggregrate pcr value
+ * 	     for an invalidated PCR. Replace all entries in the
+ * 	     runtime binary measurement list with 0x00 hash values,
+ * 	     which indicate the PCR was invalidated, either for
+ * 	     "a time of measure, time of use"(ToMToU) error, or a
+ *	     file open for read was already open for write, with
+ * 	     0xFF's hash value, when calculating the aggregate
+ *	     pcr value.
+ *
+ * --verify: for all IMA template entries in the runtime binary
+ * 	     measurement list, calculate the template hash value
+ * 	     and compare it with the actual template hash value.
+ *	     Return the number of incorrect hash measurements.
+ *
+ * --verbose: For all entries in the runtime binary measurement
+ *	     list, display the generic template information. In
+ * 	     addition, for IMA and KMEM templates, display template
+ * 	     specific information.
+ *
+ * template info:  list #, PCR-register #, template hash, template name
+ *	IMA info:  IMA hash, filename hint
+ * 	KMEM info: memory hash, reference name
+ *
+ * Ouput: displays the aggregate-pcr value
+ * Return code: if verification enabled, returns number of verification
+ * 		errors.
+ */
+int main(int argc, char *argv[])
+{
+	int i, fd, count = 0, len;
+	unsigned char event[MAX_EVENT_SIZE];
+	SHA_CTX c;
+	int remaining = 0;
+	struct template *tdata;
+
+	memset(pcr, 0, SHA_DIGEST_LENGTH);	/* initial PCR content 0..0 */
+	memset(zero, 0, SHA_DIGEST_LENGTH);
+	memset(fox, 0xff, SHA_DIGEST_LENGTH);
+
+	for (i = 1; i < argc; i++) {
+		if (strncmp(argv[i], "--validate", 5) == 0)
+			validate = 1;
+		if (strncmp(argv[i], "--verbose", 6) == 0)
+			verbose = 1;
+		if (strncmp(argv[i], "--verify", 6) == 0)
+			verify_template_hash = 1;
+	}
+
+
+	fd = open("/sys/kernel/security/ima/binary_runtime_measurements",
+		  O_RDONLY);
+	if (fd < 0) {
+		perror("Unable to open file\n");
+		return 1;
+	}
+	print_info( "### PCR HASH                                  " \
+		 	"TEMPLATE-NAME\n");
+
+	while ((len = read(fd, event + remaining, MAX_EVENT_SIZE - remaining))
+			|| remaining) {
+		if (len < 0) {
+			perror("Error reading from file.\n");
+			break;
+		}
+		len += remaining;
+		tdata = (struct template *)event;
+
+		simulate_extend_pcr(tdata->tdigest);
+		remaining = len - process_event(count++, event, len);
+
+		/* copy rest to buffer start */
+		memcpy(event, event + len - remaining, remaining);
+
+	}
+	close(fd);
+
+	display_pcr();
+	return failed_count;
+}
Index: ltp-base-20080531/testcases/kernel/integrity/ima/Makefile
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/Makefile
@@ -0,0 +1,11 @@
+SUBDIRS = tpm kmem tools
+
+all:
+	@set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i ; done
+
+install:
+	@set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i install ; done
+
+clean:
+	@set -e; for i in $(SUBDIRS); do $(MAKE) -C $$i clean ; done
+
Index: ltp-base-20080531/testcases/kernel/integrity/ima/tpm/Makefile
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/tpm/Makefile
@@ -0,0 +1,9 @@
+TARGETS := ima_measure
+
+all: $(TARGETS)
+
+ima_measure: ima_measure.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -o ima_measure ima_measure.c -lcrypto
+
+clean:
+	rm -f ima_measure ima_measure.o
Index: ltp-base-20080531/testcases/kernel/integrity/ima/kmem/kmem-template.c
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/kmem/kmem-template.c
@@ -0,0 +1,254 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * kmem-template.c
+ * 	- defines a kernel memory template
+ * 	- reads from security/kmem-template "name length address"
+ * 	- collects and stores measurement from address for length bytes
+ *	- security/kmem-template returns last memory read
+ */
+
+#include <asm/uaccess.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <linux/notifier.h>
+#include <linux/security.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+#include <linux/proc_fs.h>
+#include <linux/security.h>
+#include <linux/integrity.h>
+#include <linux/ima.h>
+
+#define MY_NAME THIS_MODULE->name
+#define IMA_DIGEST_SIZE		20
+
+static int __init init_kmem_template(void);
+static void __exit cleanup_kmem_template(void);
+
+static unsigned char *lastbuf;
+static int lastbuf_len;
+
+struct kmem_data {
+	char name[25];
+	char *buf;
+	int buflen;
+	u8 digest[IMA_DIGEST_SIZE];
+};
+
+int calc_hash(int buflen, char *buf, char *digest)
+{
+	struct crypto_hash *tfm;
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	int error, result = 0;
+
+	tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm)) {
+		printk(KERN_INFO "%s: failed to load %s transform: %ld\n",
+		       __func__, "sha1", PTR_ERR(tfm));
+		return -ENOSYS;
+	}
+	desc.tfm = tfm;
+	desc.flags = 0;
+	error = crypto_hash_init(&desc);
+	if (error) {
+		result = -EINVAL;
+		goto out;
+	}
+
+	sg_set_buf(sg, buf, buflen);
+	result = crypto_hash_update(&desc, sg, buflen);
+	if (!result) {
+		error = crypto_hash_final(&desc, digest);
+		if (error)
+			result = -EINVAL;
+	}
+
+out:
+	crypto_free_hash(tfm);
+	return result;
+}
+
+static int kmem_collect_measurement(void *d)
+{
+	struct kmem_data *data = (struct kmem_data *)d;
+
+	memset(data->digest, 0, sizeof data->digest);
+	calc_hash(data->buflen, data->buf, data->digest);
+	return 0;
+}
+
+/* Transform local kmem data to store data */
+void kmem_store_measurement(void *d)
+{
+	struct kmem_data *data = (struct kmem_data *)d;
+	struct ima_data idata;
+	struct ima_store_data *template = &idata.data.template;
+
+	idata.type = IMA_TEMPLATE;
+	template->name = "kmem";
+	template->len = sizeof *data;
+	template->data = (char *)data;
+	template->violation = 0;
+	integrity_store_measurement("ima", (void *)&idata);
+	return;
+}
+
+static void kmem_template_show(struct seq_file *m, void *e,
+			       enum integrity_show_type show)
+{
+	struct kmem_data *data = (struct kmem_data *)e;
+	int filename_len;
+	char len[4];
+	int i;
+
+	for (i = 0; i < 20; i++) {
+		switch (show) {
+		case INTEGRITY_SHOW_ASCII:
+			seq_printf(m, "%02x", data->digest[i]);
+			break;
+		case INTEGRITY_SHOW_BINARY:
+			seq_putc(m, data->digest[i]);
+		default:
+			break;
+		}
+	}
+
+	switch (show) {
+	case INTEGRITY_SHOW_ASCII:
+		seq_printf(m, " %s %d \n", data->name, data->buflen);
+		break;
+	case INTEGRITY_SHOW_BINARY:
+		filename_len = strlen(data->name);
+		memcpy(len, &filename_len, 4);
+		for (i = 0; i < 4; i++)
+			seq_putc(m, len[i]);
+		for (i = 0; i < strlen(data->name); i++)
+			seq_putc(m, data->name[i]);
+	default:
+		break;
+	}
+}
+
+static struct template_operations kmem_ops = {
+	.collect_measurement = kmem_collect_measurement,
+	.store_measurement = kmem_store_measurement,
+	.display_template = kmem_template_show
+};
+
+static int kmem_add_measure(char *name, unsigned int buflen, unsigned int addr)
+{
+	struct kmem_data data;
+	int rc;
+
+	strncpy(data.name, name, sizeof data.name);
+	data.buflen = buflen;
+	data.buf = (char *)addr;
+	rc = integrity_collect_measurement("kmem", &data);
+	if (!rc) {
+		integrity_store_measurement("kmem", &data);
+		if (data.buflen > lastbuf_len)
+			kfree(lastbuf);
+		lastbuf = kzalloc(data.buflen, GFP_KERNEL);
+		if (lastbuf) {
+			lastbuf_len = data.buflen;
+			memcpy(lastbuf, data.buf, lastbuf_len);
+		}
+	}
+	return rc;
+}
+
+static ssize_t kmem_write_template(struct file *file, const char __user *buf,
+				   size_t buflen, loff_t *ppos)
+{
+	char *data;
+	char name[26];
+	size_t result = 0, datalen;
+	int rc;
+	unsigned int addr, len;
+
+	datalen = buflen > 256 ? 256 : buflen;
+	data = kzalloc(datalen + 1, GFP_KERNEL);
+	if (!data)
+		result = -ENOMEM;
+
+	if (copy_from_user(data, buf, datalen)) {
+		result = -EFAULT;
+		goto out;
+	}
+	result = datalen;
+
+	rc = sscanf(data, "%25s %d %x ", name, &len, &addr);
+	if (rc == 3)
+		kmem_add_measure(name, len, addr);
+	else {
+		printk(KERN_INFO "kmem: error parsing request."
+		       "(format: name length address)\n");
+		result = -EINVAL;
+	}
+out:
+	if (!data)
+		kfree(data);
+	return result;
+}
+
+static ssize_t kmem_read_template(struct file *filp, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	unsigned char *tmp_buf;
+	int len;
+
+	if (!lastbuf)
+		return -EINVAL;
+
+	tmp_buf = kzalloc(2 * lastbuf_len, GFP_KERNEL);
+	if (!tmp_buf)
+		return -ENOMEM;
+
+	for (len = 0; len < lastbuf_len; len++)
+		sprintf((tmp_buf + len + len), "%02x", *(lastbuf + len));
+	return simple_read_from_buffer(buf, count, ppos, tmp_buf, len + len);
+}
+
+const static struct file_operations kmem_template_ops = {
+	.write = kmem_write_template,
+	.read = kmem_read_template
+};
+
+static struct dentry *kmem_template;
+
+static int __init init_kmem_template(void)
+{
+
+	printk(KERN_INFO "%s: \n", __func__);
+	integrity_register_template("kmem", &kmem_ops);
+
+	kmem_template = securityfs_create_file("kmem-template",
+					       S_IRUSR | S_IRGRP | S_IWUSR,
+					       NULL, NULL, &kmem_template_ops);
+	return 0;
+}
+
+static void __exit cleanup_kmem_template(void)
+{
+	printk(KERN_INFO "%s\n", __FUNCTION__);
+	integrity_unregister_template("kmem");
+
+	securityfs_remove(kmem_template);
+}
+
+module_init(init_kmem_template);
+module_exit(cleanup_kmem_template);
+
+MODULE_LICENSE("GPL");
Index: ltp-base-20080531/testcases/kernel/integrity/ima/kmem/Makefile
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/kmem/Makefile
@@ -0,0 +1,25 @@
+#
+# Makefile for kernel module
+#
+ifneq ($(KERNELRELEASE),)
+obj-m	+= kmem-template.o
+EXTRA_CFLAGS += -I$(PWD) -O
+
+else
+KDIR		 := /lib/modules/$(shell uname -r)/build
+PWD		 := $(shell pwd)
+
+default:
+		 $(MAKE) -C $(KDIR) M=$(PWD) modules
+endif
+
+
+clean :
+	rm -rf .tmp_versions
+	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
+		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
+		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \) \
+		-type f -print | xargs rm -f
+
+install:
+
Index: ltp-base-20080531/testcases/kernel/integrity/ima/tools/hex2bin.c
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/tools/hex2bin.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * hex2bin.c
+ *	- convert a hex string to binary
+ */
+#include <stdio.h>
+#include <stdlib.h>
+
+main()
+{
+	char *line = NULL;
+	ssize_t len, line_len = 0;
+	int h, i = 0;
+
+	len = getline(&line, &line_len, stdin);
+	for (i = 0; i < len; i += 2)  {
+		sscanf(line + i, "%2x", &h);
+		putchar(h);
+	}
+	free(line);
+}
Index: ltp-base-20080531/testcases/kernel/integrity/ima/kmem/kmem-test.sh
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/kmem/kmem-test.sh
@@ -0,0 +1,29 @@
+#!/bin/bash
+# Copyright (C) 2008 IBM Corporation
+# Author: Mimi Zohar <zohar@us.ibm.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation, version 2 of the
+# License.
+
+# Load kmem-template, if not already loaded
+# Collect and store memory measurement
+# Verify the memory measurement contained in the ascii measurement list.
+
+lsmod | grep kmem_template > /dev/null
+if [ $? != 0 ]; then
+	insmod ./kmem-template.ko
+fi
+
+if [ ! -f /proc/kallsyms ]; then
+	echo 'kernel built without CONFIG_KALLSYMS'
+	exit 1
+fi
+proc_root=`cat /proc/kallsyms | grep 'D proc_root' | sed 's/ .*//'`
+echo 'proc_root 84' $proc_root > /sys/kernel/security/kmem-template
+
+# calculate and search for kmem hash in the ascii measurement list
+hash=`cat /sys/kernel/security/kmem-template | ../tools/hex2bin | sha1sum | sed 's/  -//'`
+`grep $hash /sys/kernel/security/ima/ascii_runtime_measurements > /dev/null`
+exit $?
Index: ltp-base-20080531/testcases/kernel/integrity/ima/tools/Makefile
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/tools/Makefile
@@ -0,0 +1,9 @@
+TARGETS := hex2bin
+
+all: $(TARGETS)
+
+hex2bin: hex2bin.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -o hex2bin hex2bin.c
+
+clean:
+	rm -f hex2bin hex2bin.o
Index: ltp-base-20080531/testcases/kernel/integrity/ima/measure/re-measure.sh
===================================================================
--- /dev/null
+++ ltp-base-20080531/testcases/kernel/integrity/ima/measure/re-measure.sh
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+# Copyright (C) 2008 IBM Corporation
+# Author: Mimi Zohar <zohar@us.ibm.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation, version 2 of the
+# License.
+
+# Create and read a file
+# Check if the file was measured (i.e. contained in the ascii measurement list.)
+
+mkdir -p tmp
+echo `date` '- modifying file causes hash to change' >> tmp/test.txt
+cat tmp/test.txt > /dev/null
+cat /sys/kernel/security/ima/ascii_runtime_measurements > tmp/imalog
+
+# calculate and search for sha1sum of tmp/test.txt in tmp/imalog
+hash=`cat tmp/test.txt | sha1sum | sed 's/  -//'`
+echo '        hash: ' $hash
+`grep $hash tmp/imalog > /dev/null`
+if [ $? == 0 ]; then
+	echo "        TPM ascii measurement list contains sha1sum"
+	exit 0
+else
+	echo "        TPM ascii measurement list does not contain sha1sum"
+	exit -1
+fi

-- 

