Return-Path: <linux-kernel-owner+w=401wt.eu-S1764441AbYHDVCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764441AbYHDVCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763465AbYHDVBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:01:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703AbYHDVBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:01:18 -0400
From: Eric Paris <eparis@redhat.com>
To: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [RFC 5/5] [TALPA] Userspace vetting of open and close access.
Date: Mon,  4 Aug 2008 17:00:40 -0400
Message-Id: <1217883640-29121-5-git-send-email-eparis@redhat.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1217883640-29121-4-git-send-email-eparis@redhat.com>
References: <1217883640-29121-1-git-send-email-eparis@redhat.com>
 <1217883640-29121-2-git-send-email-eparis@redhat.com>
 <1217883640-29121-3-git-send-email-eparis@redhat.com>
 <1217883640-29121-4-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace vetting is an evaluation filter which passes vetting request
to an userspace daemon.

Example vetting client which allows access to everything except one very
specific file can be found in Documentation/talpa/allow_most.c.

Many vetting clients can register simultaneously but only one gets
a particular request. In other words userspace vetting clients do not
operate as a chain but as a set of consumers.

To facilitate access to the actual file a file descriptor is duplicated
into the vetting client process. In this way there is no reliance on
paths and different permission issues are bypassed.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 Documentation/talpa/allow_most.c        |  138 ++++++++
 Documentation/talpa/client              |   85 +++++
 Documentation/talpa/test_deny.c         |  356 ++++++++++++++++++++
 include/linux/talpa.h                   |   83 +++++
 security/talpa/Kconfig                  |   11 +
 security/talpa/Makefile                 |    2 +-
 security/talpa/talpa_client.c           |  543 +++++++++++++++++++++++++++++++
 security/talpa/talpa_evaluation_calls.h |    8 +
 8 files changed, 1225 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/talpa/allow_most.c
 create mode 100644 Documentation/talpa/client
 create mode 100644 Documentation/talpa/test_deny.c
 create mode 100644 security/talpa/talpa_client.c

diff --git a/Documentation/talpa/allow_most.c b/Documentation/talpa/allow_most.c
new file mode 100644
index 0000000..e563ed4
--- /dev/null
+++ b/Documentation/talpa/allow_most.c
@@ -0,0 +1,138 @@
+/* This is a userspace talpa client.  It looks for a file /root/denyme and
+ * will deny access to that file if it starts with the string "bad" */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/param.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+
+#include "talpa.h"
+
+#define DENY_FILE "/root/denyme"
+
+/* read a file and return true if it contains the characters "bad" as the first 3 chars */
+int file_contains_bad(int fd)
+{
+	char buf[10];
+	int ret;
+
+	ret = read(fd, &buf[0], 10);
+
+	if (ret < 0) {
+		perror("reading test fd");
+		return -1;
+	}
+
+	buf[ret] = '\0';
+
+	if (ret < 3)
+		return 0;
+
+	if (!strncmp(&buf[0], "bad", 3))
+		return 1;
+
+	return 0;
+}
+
+int main()
+{
+	int talpa;
+	struct talpa_packet_client response;
+	size_t cnt = 0;
+
+	/* Register as a vetting client. */
+	talpa = open("/security/talpa/client/talpa-vetting", O_RDWR);
+	if (talpa < 0) {
+		fprintf(stderr, "Cannot connect to Talpa - errno %d!\n", errno);
+		return 1;
+	}
+
+	/* We will always use the same reply packet. */
+	response.header.version = TALPA_MAX_PACKET_VERSION;
+
+	for (;;) {
+		char buf[PATH_MAX];
+		char link[64];
+		char *path;
+		struct talpa_packet_kernel details;
+		ssize_t ret;
+
+
+		response.header.type = TALPA_PKT_OK;
+
+		/* Get vetting details. */
+		ret = read(talpa, &details, sizeof(details));
+		if (ret != sizeof(details)) {
+			fprintf(stderr, "RERR: %zd (expected %zd) - errno %d\n", ret, sizeof(details), errno);
+			return 2;
+		}
+
+		cnt++;
+		/* We may have got a file descriptor as well. */
+		if (details.fd >= 0) {
+			/* If so we can find out the path of the file. */
+			snprintf(link, sizeof(link), "/proc/self/fd/%d", details.fd);
+			ret = readlink(link, buf, sizeof(buf)-1);
+			if (ret > 0) {
+				path = buf;
+				path[ret] = '\0';
+			} else {
+				path = "<error>";
+			}
+		} else
+			path = "<unknown>";
+
+		if (!strcmp(path, DENY_FILE)) {
+			ret = file_contains_bad(details.fd);
+			switch (ret) {
+			case -1:
+				response.header.type = TALPA_PKT_DENY;
+				response.cache = 0;
+				break;
+			case 0:
+				response.header.type = TALPA_PKT_OK;
+				response.cache = 1;
+				break;
+			case 1:
+				response.header.type = TALPA_PKT_DENY;
+				response.cache = 1;
+				break;
+			default:
+				fprintf(stderr, "file_contains_bad returned something other than -1, 0, 1\n");
+				exit(1);
+			}
+			ret = 0;
+		}
+
+		/* Print out vetting details. */
+		fprintf(stdout,
+			"#%zd: op:%u flags:0%o mode:0%o uid:%d gid:%d tgid:%d pid:%d fd:%d path:%s",
+			cnt, details.operation, details.flags, details.mode,
+			details.uid, details.gid, details.tgid, details.pid, details.fd, path);
+
+		if (response.header.type == TALPA_PKT_DENY)
+			fprintf(stdout, " REJECTED!");
+
+		fprintf(stdout, "\n");
+
+		/* We must reply with our decision */
+		ret = write(talpa, &response, sizeof(response));
+		if (ret != sizeof(response)) {
+			fprintf(stderr, "WERR: %zd (expected %zd) - errno %d\n",
+					ret, sizeof(response), errno);
+			return 3;
+		}
+
+		/* Close the file descriptor if received. */
+		if (details.fd >= 0)
+			close(details.fd);
+	}
+
+	return 0;
+}
diff --git a/Documentation/talpa/client b/Documentation/talpa/client
new file mode 100644
index 0000000..a39aa4f
--- /dev/null
+++ b/Documentation/talpa/client
@@ -0,0 +1,85 @@
+*****************************************************************
+
+The basic explanation of operation and API between the kernel and userspace
+----------------------------------------------
+
+When a process calls open or close it will end up in talpa_vet_file().
+talpa_vet_file() will create a struct talpa_file_vetting (TFV) which contains
+the file in question and information about the process trying to access that
+file.  This TFV will be sent to the evaluation chain of filters.  In the
+initial implementation this means it will first run the cache filter and then,
+if not cached will run the client filter.  The results of a filter can be:
+
+enum talpa_action {
+	TALPA_NEXT = 0,
+	TALPA_ALLOW = 1,
+	TALPA_DENY = 2,
+	TALPA_TIMEOUT = 3,
+	TALPA_ERROR = 4,
+};
+
+The cache filter is very simple.  It compares the sequence number in the inode
+to the global sequence number.  If they are equal the cache will return
+TALPA_ALLOW or TALPA_DENY.  If they are not equal the cache filter will return
+the indifferent TALPA_NEXT.  Assuming the cache returned TALPA_NEXT the TFV
+will be passed to the client filter, talpa_client_examine().
+
+The client filter will create a structure:
+
+struct talpa_packet_kernel {
+	struct talpa_packet_header header;
+	int32_t fd;
+	uint32_t operation;
+	uint32_t flags;
+	uint32_t mode;
+	uint32_t uid;
+	uint32_t gid;
+	uint32_t tgid;
+	uint32_t pid;
+} __attribute__ ((packed));
+
+struct talpa_packet_header {
+	uint32_t version;
+	uint32_t type;
+} __attribute__ ((packed));
+
+Most of the fields in this structure are obvious.  operation is basically open
+or close (but could be expanded to read/write).  Type is mostly useless when
+send from the kernel to userspace.
+
+When a userspace client reads from the special device the kernel will create a
+new fd in its fd table which points to the file being opened or closed.  That
+fd will get written into fd of the above structure.  The kernel will then
+write this structure to the userspace client over the character device.
+
+Userspace may at that time do any magic it wants to its brand new (RO) fd.  At
+some point the userspace vetting client will need to close that fd.  Userspace
+will also need to respond over the character device with a
+
+struct talpa_packet_client {
+	struct talpa_packet_header header;
+	union {
+		int32_t code;
+		int32_t cache;
+	}
+} __attribute__ ((packed));
+
+code is the errno only used if the type is TALPA_ERROR.  cache is non-zero if
+this answer should be cached.  This is useful if userspace feels the need to
+implement their own complex fine grained cache and wishes to bypass the
+in-kernel cache or if they feel the need to allow opens for some programs but
+not others.
+
+Once the kernel gets a response from userspace that response will be used back
+in talpa_vet_file() to decide if we are going to follow the allow or deny
+chains.  The allow/deny chain in the initial implementation will only be used
+by the cache although in future patches they may be used for other purposes.
+
+*****************
+
+/security/talpa/client/*
+
+enabled: RW:	is userspace vetting enabled (0 default)
+queued: RO:	number of access decisions waiting to be sent to a userspace client
+talpa_vetting: RW: Special file which only userspace vetting clients should open
+timeout_ms: RW:	number of ms any access decision should wait for userspace before being timeing out
diff --git a/Documentation/talpa/test_deny.c b/Documentation/talpa/test_deny.c
new file mode 100644
index 0000000..1466026
--- /dev/null
+++ b/Documentation/talpa/test_deny.c
@@ -0,0 +1,356 @@
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+
+/* lens include the NULL */
+#define GOOD_STRING "good"
+#define GOOD_STRING_LEN 5
+#define BAD_STRING "bad"
+#define BAD_STRING_LEN 4
+
+#define TEST_FILE "/root/denyme"
+
+char buf[128];
+
+int open_test_file(int flags)
+{
+	int fd;
+
+	fd = open(TEST_FILE, flags);
+	if ((fd < 0) && (errno != EACCES)) {
+		int old_err = errno;
+
+		snprintf(&buf[0], sizeof(buf), "open with flags %x", flags);
+		errno = old_err;
+		perror(buf);
+		exit(1);
+	}
+	return fd;
+}
+
+int test_good_write(void)
+{
+	int fd;
+	int ret;
+
+	fprintf(stdout, "Good file write: ");
+
+	fd = open_test_file(O_WRONLY | O_CREAT | O_TRUNC);
+	if (fd < 0) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "Failed to open file to write good message\n");
+		return 1;
+	}
+
+	ret = write(fd, GOOD_STRING, GOOD_STRING_LEN);
+	if (ret < 0) {
+		fprintf(stdout, "FAIL\n");
+		perror("Failed writing good string to denyme");
+		close(fd);
+		return 1;
+	}
+
+	if (ret != GOOD_STRING_LEN) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "writing good string to denyme returned a len: %d", ret);
+		close(fd);
+		return 1;
+	}
+
+	close(fd);
+	fprintf(stdout, "PASS\n");
+	return 0;
+}
+
+int test_good_read(void)
+{
+	int fd;
+	int ret;
+
+	fprintf(stdout, "Good file read: ");
+
+	fd = open_test_file(O_RDONLY);
+	if (fd < 0) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "Failed to open file to read good message\n");
+		return 1;
+	}
+
+	ret = read(fd, &buf[0], sizeof(buf));
+	if (ret < 0) {
+		fprintf(stdout, "FAIL\n");
+		perror("Failed to read good string from denyme");
+		close(fd);
+		return 1;
+	}
+
+	if (ret != GOOD_STRING_LEN) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "reading good string to denyme returned a len: %d", ret);
+		close(fd);
+		return 1;
+	}
+
+	close(fd);
+	fprintf(stdout, "PASS\n");
+	return 0;
+}
+
+int test_good(void)
+{
+	int ret = 0;
+
+	ret |= test_good_write();
+	/* this sleep gives the asyncronous close scan enough time to cache */
+	usleep(50);
+	ret |= test_good_read();
+	ret |= test_good_read();
+
+	return ret;
+}
+
+int test_good_write_mmap(void)
+{
+	int fd;
+	int ret;
+	char *file;
+
+	fprintf(stdout, "Good file write mmap: ");
+
+	fd = open_test_file(O_RDWR | O_CREAT | O_TRUNC);
+	if (fd < 0) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "Failed to open file to write with mmap good message\n");
+		return 1;
+	}
+
+	ret = ftruncate(fd, GOOD_STRING_LEN);
+	if (ret) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "Failed to truncate file to write with good message\n");
+		return 1;
+	}
+
+	file = mmap(NULL, GOOD_STRING_LEN , PROT_WRITE, MAP_SHARED, fd, 0);
+	if (file == MAP_FAILED) {
+		fprintf(stdout, "FAIL\n");
+		perror("mmaping file for good write");
+		return 1;
+	}
+
+	strcpy(file, GOOD_STRING);
+
+	munmap(file, GOOD_STRING_LEN);
+	close(fd);
+	fprintf(stdout, "PASS\n");
+	return 0;
+}
+
+int test_good_read_mmap(void)
+{
+	int fd;
+	char *file;
+
+	fprintf(stdout, "Good file read mmap: ");
+
+	fd = open_test_file(O_RDONLY);
+	if (fd < 0) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "Failed to open file to read good message for mmaping\n");
+		return 1;
+	}
+
+	file = mmap(NULL, GOOD_STRING_LEN , PROT_READ, MAP_PRIVATE, fd, 0);
+	if (file == MAP_FAILED) {
+		fprintf(stdout, "FAIL\n");
+		perror("mmaping file for good read");
+		return 1;
+	}
+
+	if (strcmp(file, GOOD_STRING)) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "The string we read from the good file wasn't the good string!\n");
+		return 1;
+	}
+
+	munmap(file, GOOD_STRING_LEN);
+
+	close(fd);
+	fprintf(stdout, "PASS\n");
+	return 0;
+}
+
+int test_good_mmap(void)
+{
+	int ret = 0;
+
+	ret |= test_good_write_mmap();
+	/* this sleep gives the asyncronous close scan enough time to cache */
+	usleep(50);
+	ret |= test_good_read_mmap();
+	ret |= test_good_read_mmap();
+
+	return ret;
+}
+
+int test_bad_write(void)
+{
+	int fd;
+	int ret;
+
+	fprintf(stdout, "Bad file write: ");
+
+	fd = open_test_file(O_WRONLY | O_CREAT | O_TRUNC);
+	if (fd < 0) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "Failed to open file to write bad message\n");
+		return 1;
+	}
+
+	ret = write(fd, BAD_STRING, BAD_STRING_LEN);
+	if (ret < 0) {
+		fprintf(stdout, "FAIL\n");
+		perror("Failed writing bad string to denyme");
+		close(fd);
+		return 1;
+	}
+
+	if (ret != BAD_STRING_LEN) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "writing bad string to denyme returned a len: %d", ret);
+		close(fd);
+		return 1;
+	}
+
+	ret = close(fd);
+	if (ret) {
+		fprintf(stdout, "FAIL\n");
+		perror("failed to close fd to file with bad string");
+		return 1;
+	}
+
+	fprintf(stdout, "PASS\n");
+	return 0;
+}
+
+int test_bad_read(void)
+{
+	int fd;
+
+	fprintf(stdout, "Bad file read: ");
+
+	fd = open_test_file(O_RDONLY);
+	if (fd >= 0) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "we were able to open the file containing the bad string\n");
+		close(fd);
+		return 1;
+	}
+
+	fprintf(stdout, "PASS\n");
+	return 0;
+}
+
+int test_bad(void)
+{
+	int ret = 0;
+
+	ret |= test_bad_write();
+	/* this sleep gives the asyncronous close scan enough time to cache */
+	usleep(50);
+	ret |= test_bad_read();
+	ret |= test_bad_read();
+
+	return ret;
+}
+int test_bad_write_mmap(void)
+{
+	int fd;
+	int ret;
+	char *file;
+
+	fprintf(stdout, "Bad file write mmap: ");
+
+	fd = open_test_file(O_RDWR | O_CREAT | O_TRUNC);
+	if (fd < 0) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "Failed to open file to write bad message for mmap\n");
+		return 1;
+	}
+
+	ret = ftruncate(fd, BAD_STRING_LEN);
+	if (ret) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "Failed to truncate file to write with bad message\n");
+		return 1;
+	}
+
+	file = mmap(NULL, BAD_STRING_LEN , PROT_WRITE, MAP_SHARED, fd, 0);
+	if (file == MAP_FAILED) {
+		fprintf(stdout, "FAIL\n");
+		perror("mmaping file for bad write");
+		return 1;
+	}
+
+	strcpy(file, BAD_STRING);
+
+	munmap(file, BAD_STRING_LEN);
+
+	ret = close(fd);
+	if (ret) {
+		fprintf(stdout, "FAIL\n");
+		perror("failed to close fd to file with bad string");
+		return 1;
+	}
+
+	fprintf(stdout, "PASS\n");
+	return 0;
+}
+
+int test_bad_read_mmap(void)
+{
+	int fd;
+
+	fprintf(stdout, "Bad file read mmap: ");
+
+	fd = open_test_file(O_RDONLY);
+	if (fd >= 0) {
+		fprintf(stdout, "FAIL\n");
+		fprintf(stderr, "we were able to open the file containing the bad string\n");
+		close(fd);
+		return 1;
+	}
+
+	fprintf(stdout, "PASS\n");
+	return 0;
+}
+
+int test_bad_mmap(void)
+{
+	int ret = 0;
+
+	ret |= test_bad_write_mmap();
+	/* this sleep gives the asyncronous close scan enough time to cache */
+	usleep(50);
+	ret |= test_bad_read_mmap();
+	ret |= test_bad_read_mmap();
+
+	return ret;
+}
+int main(void)
+{
+	int ret = 0;
+
+	ret |= test_good();
+	ret |= test_bad();
+	ret |= test_good_mmap();
+	ret |= test_bad_mmap();
+
+	return ret;
+}
diff --git a/include/linux/talpa.h b/include/linux/talpa.h
index 52750b7..342fa02 100644
--- a/include/linux/talpa.h
+++ b/include/linux/talpa.h
@@ -39,6 +39,89 @@ enum talpa_operation {
 	TALPA_CLOSE = 1,
 };
 
+/* Communication protocol for userspace clients. */
+
+/**
+ * enum talpa_packet_type - packet type
+ *
+ * Packet header type field must be set to one of these.
+ */
+enum talpa_packet_type {
+	TALPA_PKT_OK = 0,
+	TALPA_PKT_DENY = 1,
+	TALPA_PKT_TIMEOUT = 2,
+	TALPA_PKT_ERROR = 3,
+	TALPA_PKT_DETAILS = 4,
+};
+
+/**
+ * struct talpa_packet_header - leads each packet
+ *
+ * Type field will be or must be set to one of the known packet
+ * types from the above enum.
+ */
+struct talpa_packet_header {
+	uint32_t version;
+	uint32_t type;
+} __attribute__ ((packed));
+
+/* Externally visible and usable packets */
+
+/**
+ * struct talpa_packet_error - client reply on vetting error
+ * @header:standard packet header
+ * @code:error code to return
+ *
+ * When vetting has been unsuccessful client should reply with this
+ * packet indicating that access should be denied with a specific
+ * error code.
+ */
+struct talpa_packet_client {
+	struct talpa_packet_header header;
+	union {
+		int32_t code;
+		uint32_t cache;
+	};
+} __attribute__ ((packed));
+
+/**
+ * struct talpa_packet_details - main interception packet
+ * @header:standard packet header
+ * @fd:file descriptor of the intercepted object
+ * @operation: operation enum
+ * @flags: as passed to open(2)
+ * @mode: inode mode
+ * @uid: uid of the process doing the operation
+ * @gid: gid of the process doing the operation
+ * @tgid: tgid of the process doing the operation
+ * @pid: pid of the process doing the operation
+ *
+ * On each interception registered userspace client will receive this
+ * packet describing the operation to be vetted.
+ * File content can be inspected through a file descriptor (unless -1)
+ * which must be closed(2) on completion.
+ * One of the reply packets must be sent to Talpa as a decision, unless
+ * operation was TALPA_CLOSE when no reply is expected.
+ */
+struct talpa_packet_kernel {
+	struct talpa_packet_header header;
+	int32_t fd;
+	uint32_t operation;
+	uint32_t flags;
+	uint32_t mode;
+	uint32_t uid;
+	uint32_t gid;
+	uint32_t tgid;
+	uint32_t pid;
+} __attribute__ ((packed));
+
+/* Useful sizes for allocating packet buffers */
+#define TALPA_PACKET_READ_SIZE (sizeof(struct talpa_packet_kernel))
+#define TALPA_PACKET_WRITE_SIZE (sizeof(struct talpa_packet_client))
+#define TALPA_MAX_PACKET_SIZE TALPA_PACKET_READ_SIZE
+
+#define TALPA_MAX_PACKET_VERSION 1
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/security/talpa/Kconfig b/security/talpa/Kconfig
index c5528e5..f460ec8 100644
--- a/security/talpa/Kconfig
+++ b/security/talpa/Kconfig
@@ -38,3 +38,14 @@ config TALPA_THREAD_EXCLUSION
 	  on a corresponding device node.
 
 	  If you are unsure how to answer this question, answer Y.
+
+
+config TALPA_CLIENT
+	bool "Userspace vetting support"
+	depends on TALPA
+	default y
+	help
+	  This enables userspace clients to register with Talpa and
+	  receive vetting requests for filesystem operations.
+
+	  If you are unsure how to answer this question, answer Y.
diff --git a/security/talpa/Makefile b/security/talpa/Makefile
index 16cb1d0..76a6410 100644
--- a/security/talpa/Makefile
+++ b/security/talpa/Makefile
@@ -10,4 +10,4 @@ talpa-y :=	talpa_interceptor.o \
 
 talpa-$(CONFIG_TALPA_CACHE) += talpa_cache.o
 talpa-$(CONFIG_TALPA_THREAD_EXCLUSION) += talpa_thread_exclude.o
-
+talpa-$(CONFIG_TALPA_CLIENT) += talpa_client.o
diff --git a/security/talpa/talpa_client.c b/security/talpa/talpa_client.c
new file mode 100644
index 0000000..1b18285
--- /dev/null
+++ b/security/talpa/talpa_client.c
@@ -0,0 +1,543 @@
+/*
+ *  Copyright 2008 Sophos Plc
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/talpa.h>
+#include <linux/stat.h>
+#include <linux/poll.h>
+#include <linux/major.h>
+#include <linux/miscdevice.h>
+#include <linux/mount.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/mutex.h>
+#include <linux/jiffies.h>
+#include <linux/file.h>
+#include <linux/uaccess.h>
+#include <linux/fcntl.h>
+#include <linux/security.h>
+#include <asm/atomic.h>
+
+#include "talpa.h"
+#include "talpa_cache.h"
+
+
+/* Each interception is stored in a form of this structure
+   and put in a queue until consumed by the client or expired. */
+struct vetting_details {
+	atomic_t refcnt;		/* Reference count for this structure. */
+	bool complete;			/* Whether this interception was completed by the client. */
+	enum talpa_action action;	/* What was the response. */
+	union {
+		int code;		/* Error code if applicable. */
+		unsigned int cache;	/* Should this result be cached */
+	};
+	wait_queue_head_t wait;		/* Wait queue on which the intercepted process sleeps. */
+	struct file *file;		/* filp from the open/close call */
+	long cache_seqno;		/* seqno of the cache at the time examine started */
+	struct talpa_packet_kernel k_packet;
+
+	struct list_head head;		/* List of vet_dets to be sent to userspace */
+};
+
+/* Each registered vetting client gets one of these. */
+struct vetting_client {
+	struct vetting_details *details;	/* Details currently being processed. */
+
+	size_t response;			/* Number of bytes left to read. */
+	loff_t offset;				/* Offset in packet buffer. */
+	struct talpa_packet_client c_packet;	/* Packet buffer for replies. */
+
+	struct list_head head;			/* List of all client processes */
+};
+
+/* Global data. */
+
+static unsigned long talpa_client_enabled;
+static unsigned long talpa_client_timeout = 5000; /* Time in miliseconds to wait for vetting to complete. */
+
+static atomic_t num_clients = ATOMIC_INIT(0); /* number of registered clients */
+
+static struct kmem_cache *det_cache; /* Cache for struct vetting_details */
+
+static unsigned long intercept_queue_size; /* Number of interceptions in the queue. */
+static LIST_HEAD(intercept_queue); /* List head for vetting details. */
+static DEFINE_MUTEX(intercept_queue_lock); /* Mutext protecting the queue. */
+
+static DECLARE_WAIT_QUEUE_HEAD(intercept_queue_wait); /* Wait queue for clients awaiting interceptions. */
+
+
+/* Release reference counted vetting details. */
+static inline void put_details(struct vetting_details *details)
+{
+	if (atomic_dec_and_test(&details->refcnt)) {
+		fput(details->file);
+		kmem_cache_free(det_cache, details);
+	}
+}
+
+/* Test if these should be handled async (CLOSE, someday WRITE?) */
+static inline int handle_async(struct vetting_details *details)
+{
+	if (details->k_packet.operation == TALPA_CLOSE)
+		return 1;
+	return 0;
+}
+
+/* Main examine function. */
+enum talpa_action talpa_client_examine(struct talpa_file_vetting *tfv)
+{
+	struct vetting_details *details = NULL;
+	int ret;
+	enum talpa_action action = TALPA_NEXT;
+	struct task_struct *tsk = current;
+
+	if (!talpa_client_enabled || !atomic_read(&num_clients))
+		return action;
+
+	details = kmem_cache_zalloc(det_cache, GFP_KERNEL);
+	if (!details)
+		return action;
+
+	/* Fill-in vetting details and vetting packet. */
+	atomic_set(&details->refcnt, 2);
+	details->action = TALPA_NEXT;
+	get_file(tfv->file);
+	details->file = tfv->file;
+	init_waitqueue_head(&details->wait);
+
+	details->k_packet.header.type = TALPA_PKT_DETAILS;
+	details->k_packet.header.version = TALPA_MAX_PACKET_VERSION;
+	details->k_packet.fd = -1;
+	details->k_packet.operation = tfv->operation;
+	details->k_packet.flags = tfv->flags;
+	details->k_packet.mode = tfv->file->f_dentry->d_inode->i_mode;
+	details->k_packet.uid = tsk->uid;
+	details->k_packet.gid = tsk->gid;
+	details->k_packet.tgid = tsk->tgid;
+	details->k_packet.pid = tsk->pid;
+
+	/* Put it on a queue and wake-up clients. */
+	mutex_lock(&intercept_queue_lock);
+	list_add_tail(&details->head, &intercept_queue);
+	intercept_queue_size++;
+	mutex_unlock(&intercept_queue_lock);
+	wake_up(&intercept_queue_wait);
+
+	/* Interceptions of close can immediately proceed because
+	   response is not required.  callbacks into the cache based
+	   on the results will be done in the context of the userspace
+	   client thread */
+	if (handle_async(details)) {
+		details->cache_seqno = tfv->cache_seqno;
+		put_details(details);
+		return action;
+	}
+
+	/* Wait until vetting completes in any way or all the clients disappear*/
+	do {
+		ret = wait_event_interruptible_timeout(details->wait,
+							details->complete,
+							msecs_to_jiffies(talpa_client_timeout));
+		/* Timeout or signal? */
+		if (ret == 0 || ret < 0) {
+			struct list_head *pos;
+			if (ret == 0) {
+				action = TALPA_TIMEOUT;
+				tfv->code = -ETIME;
+			} else {
+				/* do we really want to ERROR if we took a signal? */
+				action = TALPA_ERROR;
+				tfv->code = ret;
+			}
+			/* Unqueue details if still queued. */
+			mutex_lock(&intercept_queue_lock);
+			list_for_each(pos, &intercept_queue) {
+				if (pos == &details->head) {
+					list_del(&details->head);
+					intercept_queue_size--;
+					break;
+				}
+			}
+			mutex_unlock(&intercept_queue_lock);
+			break;
+		}
+	} while (!details->complete && atomic_read(&num_clients));
+
+	if (details->complete) {
+		action = details->action;
+		switch (details->action) {
+		case TALPA_ALLOW:
+		case TALPA_DENY:
+			tfv->authoritative = details->cache;
+			break;
+		case TALPA_ERROR:
+			tfv->code = details->code;
+			break;
+		case TALPA_TIMEOUT:
+			tfv->code = -ETIME;
+		default:
+			break;
+		}
+	}
+
+	put_details(details);
+	return action;
+}
+
+/* Clients register by opening our device. */
+static int client_open(struct inode *inode, struct file *file)
+{
+	struct vetting_client *client;
+
+	client = kmalloc(sizeof(struct vetting_client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	client->details = NULL;
+	client->response = 0;
+	client->offset = 0;
+	INIT_LIST_HEAD(&client->head);
+
+	current->flags |= PF_TALPA_EXCL;
+
+	/* if we ever overflow this just shoot me */
+	atomic_inc(&num_clients);
+
+	file->private_data = client;
+	return 0;
+}
+
+/* And unregister on close. */
+static int client_close(struct inode *inode, struct file *file)
+{
+	struct vetting_client *client;
+
+	client = (struct vetting_client *)file->private_data;
+	if (!client)
+		return -EBADF;
+
+	atomic_dec(&num_clients);
+
+	/* Cleanup if client has abruptly exited. */
+	if (client->details) {
+		client->details->action = TALPA_ERROR;
+		client->details->code = -EUNATCH;
+		client->details->complete = true;
+		wake_up(&client->details->wait);
+		put_details(client->details);
+	}
+
+	kfree(client);
+
+	return 0;
+}
+
+/* Helper which keeps the lock acquired if queue is not empty. */
+static inline unsigned int check_intercept_queue(void)
+{
+	mutex_lock(&intercept_queue_lock);
+	if (!list_empty(&intercept_queue))
+		return 1;
+	mutex_unlock(&intercept_queue_lock);
+	return 0;
+}
+
+/* Helper to just fill the userspace buf with the k_packet */
+static ssize_t client_read_fill_buf(struct vetting_client *client, size_t len, char *buf)
+{
+	if (len > client->response)
+		len = client->response;
+
+	if (copy_to_user(buf, (char *)&client->details->k_packet + client->offset, len))
+		return -EFAULT;
+
+	client->response -= len;
+	client->offset += len;
+
+	return len;
+}
+
+/* must hold the queue_lock and must know there is something in the list */
+static void client_fill_details(struct vetting_client *client)
+{
+	client->details = list_entry(intercept_queue.next, struct vetting_details, head);
+	list_del(&client->details->head);
+	intercept_queue_size--;
+	mutex_unlock(&intercept_queue_lock);
+}
+
+static ssize_t client_read(struct file *file, char *buf, size_t len, loff_t *ppos)
+{
+	struct vetting_client *client;
+	struct vetting_details *details;
+
+	int client_fd;
+	struct dentry *client_file_dentry;
+	struct vfsmount *client_file_vfsmnt;
+	struct file *client_file;
+
+	ssize_t ret = 0;
+
+	client = (struct vetting_client *)file->private_data;
+	if (unlikely(!client))
+		return -EBADF;
+
+	if (unlikely(!len))
+		return 0;
+
+	/* Misbehaving client - tries to read when it should respond. */
+	if (unlikely(client->details && !client->response))
+		return -EBUSY;
+
+	/* there are bytes left to read, last one was a short read */
+	if (unlikely(client->response))
+		return client_read_fill_buf(client, len, buf);
+
+	/* Clean state - try to obtain vetting details for this client. */
+	mutex_lock(&intercept_queue_lock);
+	if (!list_empty(&intercept_queue)) {
+		/* note: client_fill_details releases the lock */
+		client_fill_details(client);
+	} else {
+		mutex_unlock(&intercept_queue_lock);
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		/* Wait for something to get into the queue. */
+		ret = wait_event_interruptible(intercept_queue_wait, check_intercept_queue());
+		if (!ret)
+			client_fill_details(client);
+		/* FIXME, should we just rewait if we took a signal and handled it? */
+	}
+
+	details = client->details;
+
+	/* we won't have details if we took a signal */
+	if (!details)
+		return ret;
+
+	WARN_ON(!details->file);
+
+	client_fd = get_unused_fd();
+	if (client_fd < 0)
+		return client_fd;
+
+	client_file_dentry = dget(details->file->f_dentry);
+	client_file_vfsmnt = mntget(details->file->f_vfsmnt);
+
+	/*
+	 * we need a new file handle for the userspace program so it can read even if it was
+	 * originally opened O_WRONLY.
+	 */
+	client_file = dentry_open(client_file_dentry, client_file_vfsmnt, O_RDONLY);
+	if (IS_ERR(client_file)) {
+		printk(KERN_CRIT "dentry_open failed with reason %ld\n", PTR_ERR(client_file));
+		put_unused_fd(client_fd);
+		client_fd = -1;
+	} else {
+		fd_install(client_fd, client_file);
+	}
+
+	details->k_packet.fd = client_fd;
+	client->response = sizeof(struct talpa_packet_kernel);
+	client->offset = 0;
+	ret = client_read_fill_buf(client, len, buf);
+
+	return ret;
+}
+
+static int process_async_response(struct vetting_details *details)
+{
+	struct talpa_file_vetting tfv;
+
+	tfv.file = details->file;
+	tfv.operation = details->k_packet.operation;
+	tfv.flags = details->k_packet.flags;
+	tfv.cache_seqno = details->cache_seqno;
+
+	switch (details->action) {
+	case TALPA_ALLOW:
+		tfv.authoritative = 1;
+		talpa_cache_allow(&tfv);
+		break;
+	case TALPA_DENY:
+		tfv.authoritative = 1;
+		talpa_cache_deny(&tfv);
+		break;
+	default:
+		talpa_invalidate_inode(details->file->f_dentry->d_inode);
+		break;
+	}
+
+	return 0;
+}
+
+static int process_packet(struct vetting_client *client)
+{
+	if (unlikely(!client->details))
+		return -EPROTO;
+
+	client->details->cache = 0;
+
+	switch (client->c_packet.header.type) {
+	case TALPA_PKT_OK:
+		client->details->action = TALPA_ALLOW;
+		client->details->cache = client->c_packet.cache;
+		break;
+	case TALPA_PKT_DENY:
+		client->details->action = TALPA_DENY;
+		break;
+	case TALPA_PKT_TIMEOUT:
+		client->details->action = TALPA_TIMEOUT;
+		break;
+	case TALPA_PKT_ERROR:
+		client->details->action = TALPA_ERROR;
+		client->details->code = client->c_packet.code;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	client->details->complete = true;
+	wake_up(&client->details->wait);
+
+	if (handle_async(client->details))
+		process_async_response(client->details);
+
+	put_details(client->details);
+	client->details = NULL;
+	return 0;
+}
+
+static ssize_t client_write(struct file *file, const char *buf, size_t len, loff_t *ppos)
+{
+	struct vetting_client *client;
+	int ret;
+
+	client = (struct vetting_client *)file->private_data;
+	if (unlikely(!client))
+		return -EBADF;
+
+	if (unlikely(client->response))
+		return -EPROTO;
+
+	/* reject short and long writes, its only 96 bits for crying out loud */
+	if (unlikely(len != TALPA_PACKET_WRITE_SIZE))
+		return -EPROTO;
+
+	if (unlikely(copy_from_user(&client->c_packet, buf, len)))
+		return -EFAULT;
+
+	ret = process_packet(client);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static unsigned int client_poll(struct file *file, struct poll_table_struct *polltbl)
+{
+	struct vetting_client *client;
+	int ret = 0;
+
+	client = (struct vetting_client *)file->private_data;
+	if (!client)
+		return -EBADF;
+	poll_wait(file, &intercept_queue_wait, polltbl);
+	mutex_lock(&intercept_queue_lock);
+	if (!list_empty(&intercept_queue))
+		ret = POLLIN | POLLRDNORM;
+	mutex_lock(&intercept_queue_lock);
+
+	return ret;
+}
+
+/* Don't enable the client filter if we failed to create the kmem_cache */
+ssize_t set_enabled(struct talpa_configuration *cfg, char *buf, size_t len)
+{
+	if (det_cache)
+		return talpa_generic_set_ulong(cfg, buf, len);
+	return -ENOMEM;
+}
+
+static struct talpa_configuration talpa_client_cfg[] = {
+	{
+		.name = "enabled",
+		.mode = S_IRUSR|S_IWUSR|S_IRGRP,
+		.data = &talpa_client_enabled,
+		.get = talpa_generic_get_ulong,
+		.set = set_enabled,
+	},
+	{
+		.name = "timeout_ms",
+		.mode = S_IRUSR|S_IWUSR|S_IRGRP,
+		.data = &talpa_client_timeout,
+		.get = talpa_generic_get_ulong,
+		.set = talpa_generic_set_ulong,
+	},
+	{
+		.name = "queued",
+		.mode = S_IRUSR|S_IRGRP,
+		.data = &intercept_queue_size,
+		.get = talpa_generic_get_ulong,
+	},
+	{
+	},
+};
+
+static struct file_operations client_fops = {
+	.open =		client_open,
+	.release =	client_close,
+	.read =		client_read,
+	.write =	client_write,
+	.poll =		client_poll
+};
+
+static __init int talpa_client_init(void)
+{
+	struct dentry *dentry;
+
+	mutex_init(&intercept_queue_lock);
+
+	dentry = talpa_register_configuration("client", talpa_client_cfg);
+	if (IS_ERR(dentry)) {
+		pr_err("talpa: Failed to register userspace client filter!\n");
+		return PTR_ERR(dentry);
+	}
+
+	/* Register the 'special' file */
+	dentry = securityfs_create_file("talpa-vetting", S_IRUSR|S_IWUSR, dentry, NULL, &client_fops);
+	if (IS_ERR(dentry)) {
+		pr_err("talpa: Failed to register userspace client filter special file!\n");
+		return PTR_ERR(dentry);
+	}
+
+	det_cache = kmem_cache_create("talpa_vetting_details", sizeof(struct vetting_details), 0, 0, NULL);
+	if (!det_cache) {
+		pr_err("talpa: Failed to create vetting details cache!\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+__initcall(talpa_client_init);
diff --git a/security/talpa/talpa_evaluation_calls.h b/security/talpa/talpa_evaluation_calls.h
index 24d0955..1aaa08c 100644
--- a/security/talpa/talpa_evaluation_calls.h
+++ b/security/talpa/talpa_evaluation_calls.h
@@ -3,6 +3,8 @@
 #include "talpa.h"
 #include "talpa_cache.h"
 
+extern enum talpa_action talpa_client_examine(struct talpa_file_vetting *tfv);
+
 static inline int talpa_evaluation_calls(struct talpa_file_vetting *tfv)
 {
 	enum talpa_action ret = TALPA_NEXT;
@@ -26,5 +28,11 @@ static inline int talpa_evaluation_calls(struct talpa_file_vetting *tfv)
 		return ret;
 #endif /* CONFIG_TALPA_CACHE */
 
+#ifdef CONFIG_TALPA_CLIENT
+	ret = talpa_client_examine(tfv);
+	if (ret != TALPA_NEXT)
+		return ret;
+#endif /* CONFIG_TALPA_CLIENT */
+
 	return ret;
 }
-- 
1.5.2.1

