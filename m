Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbYAYFTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbYAYFTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYAYFTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:19:09 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55696 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYAYFTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:19:05 -0500
Message-ID: <47997125.4060006@ak.jp.nec.com>
Date: Fri, 25 Jan 2008 14:18:29 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: morgan@kernel.org
CC: akpm@osdl.org, serue@us.ibm.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 2/3] exporting capability code/name pairs (try 2nd)
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can apply this patch to libcap.
It enables to obtain the list of capabilities running kernel
supported dynamically, from /sys/kernel/capability.

When we use libcap with this patch on the previous kernel,
it apply static list of capabilities instead.

Thanks,
----
Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>

diff --git a/libcap/_makenames.c b/libcap/_makenames.c
index 212f0b4..c57e940 100644
--- a/libcap/_makenames.c
+++ b/libcap/_makenames.c
@@ -43,7 +43,7 @@ int main(void)
 	   "#define __CAP_BITS   %d\n"
 	   "\n"
 	   "#ifdef LIBCAP_PLEASE_INCLUDE_ARRAY\n"
-	   "  char const *_cap_names[__CAP_BITS] = {\n", maxcaps);
+	   "  static const char *_cap_names_fallback[__CAP_BITS] = {\n", maxcaps);

     for (i=0; i<maxcaps; ++i) {
 	if (pointers[i])
diff --git a/libcap/cap_flag.c b/libcap/cap_flag.c
index e521fcd..f490b29 100644
--- a/libcap/cap_flag.c
+++ b/libcap/cap_flag.c
@@ -21,7 +21,7 @@ int cap_get_flag(cap_t cap_d, cap_value_t value, cap_flag_t set,
      * Is it a known capability?
      */

-    if (raised && good_cap_t(cap_d) && value >= 0 && value < __CAP_BITS
+    if (raised && good_cap_t(cap_d) && value >= 0 && value < _cap_names_num
 	&& set >= 0 && set < NUMBER_OF_CAP_SETS) {
 	*raised = isset_cap(cap_d,value,set) ? CAP_SET:CAP_CLEAR;
 	return 0;
@@ -45,12 +45,12 @@ int cap_set_flag(cap_t cap_d, cap_flag_t set,
      * Is it a known capability?
      */

-    if (good_cap_t(cap_d) && no_values > 0 && no_values <= __CAP_BITS
+    if (good_cap_t(cap_d) && no_values > 0 && no_values <= _cap_names_num
 	&& (set >= 0) && (set < NUMBER_OF_CAP_SETS)
 	&& (raise == CAP_SET || raise == CAP_CLEAR) ) {
 	int i;
 	for (i=0; i<no_values; ++i) {
-	    if (array_values[i] < 0 || array_values[i] >= __CAP_BITS) {
+	    if (array_values[i] < 0 || array_values[i] >= _cap_names_num) {
 		_cap_debug("weird capability (%d) - skipped", array_values[i]);
 	    } else {
 		int value = array_values[i];
diff --git a/libcap/cap_text.c b/libcap/cap_text.c
index 06f61d9..7337bca 100644
--- a/libcap/cap_text.c
+++ b/libcap/cap_text.c
@@ -8,9 +8,11 @@

 #define LIBCAP_PLEASE_INCLUDE_ARRAY
 #include "libcap.h"
+#include "cap_names.h"

 #include <ctype.h>
 #include <stdio.h>
+#include <dirent.h>

 /* Maximum output text length (16 per cap) */
 #define CAP_TEXT_SIZE    (16*__CAP_BITS)
@@ -19,6 +21,10 @@
 #define LIBCAP_INH   02
 #define LIBCAP_PER   04

+/* array of capability names initialized at _init() */
+int _cap_names_num = __CAP_BITS;
+char **_cap_names = _cap_names_fallback;
+
 /*
  * Parse a textual representation of capabilities, returning an internal
  * representation.
@@ -71,14 +77,14 @@ static int lookupname(char const **strp)
     str.constp = *strp;
     if (isdigit(*str.constp)) {
 	unsigned long n = strtoul(str.constp, &str.p, 0);
-	if (n >= __CAP_BITS)
+	if (n >= _cap_names_num)
 	    return -1;
 	*strp = str.constp;
 	return n;
     } else {
 	char const *s;
 	int n;
-	for (n = __CAP_BITS; n--; )
+	for (n = _cap_names_num; n--; )
 	    if (_cap_names[n] && (s = namcmp(str.constp, _cap_names[n]))) {
 		*strp = s;
 		return n;
@@ -270,7 +276,7 @@ char *cap_to_text(cap_t caps, ssize_t *length_p)
     _cap_debugcap("i = ", *caps, CAP_INHERITABLE);
     _cap_debugcap("p = ", *caps, CAP_PERMITTED);

-    for (n = __CAP_BITS; n--; )
+    for (n = _cap_names_num; n--; )
 	histo[getstateflags(caps, n)]++;

     for (m=t=7; t--; )
@@ -286,7 +292,7 @@ char *cap_to_text(cap_t caps, ssize_t *length_p)
     for (t = 8; t--; )
 	if (t != m && histo[t]) {
 	    *p++ = ' ';
-	    for (n = 0; n != __CAP_BITS; n++)
+	    for (n = 0; n != _cap_names_num; n++)
 		if (getstateflags(caps, n) == t) {
 		    if (_cap_names[n])
 			p += sprintf(p, "%s,", _cap_names[n]);
@@ -323,3 +329,66 @@ char *cap_to_text(cap_t caps, ssize_t *length_p)

     return (_libcap_strdup(buf));
 }
+
+#define SYSFS_CAP_BASE	"/sys/kernel/capability"
+void __cap_names_init(void);
+void __attribute__ ((constructor)) __cap_names_init(void)
+{
+    DIR *dirp;
+    FILE *filp;
+    struct dirent *dent;
+    char pathname[256];
+    char **local_cap_names;
+    unsigned int i, code, local_cap_names_num;
+
+    /* compute size of array */
+    filp = fopen(SYSFS_CAP_BASE "/index", "rb");
+    if (!filp)
+	return;
+    if (fscanf(filp, "%u", &local_cap_names_num) != 1) {
+	fclose(filp);
+	return;
+    }
+    fclose(filp);
+
+    local_cap_names_num++;
+    local_cap_names = malloc(sizeof(char *) * local_cap_names_num);
+    if (!local_cap_names)
+	return;
+    memset(local_cap_names, 0, sizeof(char *) * local_cap_names_num);
+
+    /* scan /sys/kernel/capability */
+    dirp = opendir(SYSFS_CAP_BASE);
+    if (!dirp)
+	goto error1;
+
+    while (!!(dent = readdir(dirp))) {
+	if (!!strncmp("cap_", dent->d_name, 4))
+	    continue;
+
+	snprintf(pathname, sizeof(pathname), SYSFS_CAP_BASE "/%s", dent->d_name);
+	filp = fopen(pathname, "rb");
+	if (!filp)
+	    goto error2;
+	if (fscanf(filp, "%u", &code) != 1 || code >= local_cap_names_num) {
+	    fclose(filp);
+	    goto error2;
+	}
+	fclose(filp);
+
+	local_cap_names[code] = strdup(dent->d_name);
+	if (!local_cap_names[code])
+	    goto error2;
+    }
+    _cap_names = local_cap_names;
+    _cap_names_num = local_cap_names_num;
+
+  error2:
+    for (i=0; i < local_cap_names_num; i++)
+	free(local_cap_names[i]);
+    closedir(dirp);
+  error1:
+    free(local_cap_names);
+
+    return;
+}
diff --git a/libcap/libcap.h b/libcap/libcap.h
index 0e4a167..b5a5deb 100644
--- a/libcap/libcap.h
+++ b/libcap/libcap.h
@@ -22,8 +22,8 @@
 #define __u32   unsigned int
 #endif /* __u32 */

-/* include the names for the caps and a definition of __CAP_BITS */
-#include "cap_names.h"
+extern char **_cap_names;
+extern int _cap_names_num;

 /*
  * Do we match the local kernel?

-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
