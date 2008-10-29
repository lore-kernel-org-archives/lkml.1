Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYJ2N77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYJ2N77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYJ2N7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:59:48 -0400
Received: from exchange07.timesys.com ([209.114.137.35]:18013 "EHLO
	exchange07.timesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYJ2N7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:59:47 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2008 09:59:47 EDT
From: "Sally, Gene" <Gene.Sally@timesys.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Oct 2008 09:54:17 -0400
Subject: [PATCH 2.6.28-rc2] gen_init_cpio expands shell variables in file
 names
Thread-Topic: [PATCH 2.6.28-rc2] gen_init_cpio expands shell variables in
 file names
Thread-Index: Ack5zdWygissXaLuS/aMjd3qy1KYyA==
Message-ID: <CFEB29247FA6A94796A15592E348E7B90D2706EE30@exchange07.timesys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch modifies gen_init_cpio so that lines that specify files can contain what looks like a shell variable that's expanded during processing.

For example:

file /sbin/kinit ${RFS_BASE}/usr/src/klibc/kinit/kinit 0755 0 0

given RFS_BASE is "/some/directory" in the environment

would be expanded to

file /sbin/kinit /some/directory/usr/src/klibc/kinit/kinit 0755 0 0

If several environment variables appear in a line, they are all expanded with processing happening from left to right.  Undefined variables expand to a null string.  Syntax errors stop processing, letting the existing error handling show the user offending line.

This patch helps embedded folks who frequently create several RFS directories and then switch between them as they're tuning an initramfs.  Having just been such an embedded folk, this seems the most efficient solution.

I didn't see a maintainer for this area (forgive me if I overlooked) so I don't know who I should CC for this patch.

Regards,
gene

--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -370,6 +370,30 @@ error:
        return rc;
 }

+static char *cpio_replace_env(char *new_location)
+{
+       char expanded[PATH_MAX + 1];
+       char env_var[PATH_MAX + 1];
+       char *start;
+       char *end;
+
+       for (start = NULL; (start = strstr(new_location, "${")); ) {
+               end = strchr(start, '}');
+               if (start < end) {
+                       *env_var = *expanded = '\0';
+                       strncat(env_var, start + 2, end - start - 2);
+                       strncat(expanded, new_location, start - new_location);
+                       strncat(expanded, getenv(env_var), PATH_MAX);
+                       strncat(expanded, end + 1, PATH_MAX);
+                       strncpy(new_location, expanded, PATH_MAX);
+               } else
+                       break;
+       }
+
+       return new_location;
+}
+
+
 static int cpio_mkfile_line(const char *line)
 {
        char name[PATH_MAX + 1];
@@ -415,7 +439,8 @@ static int cpio_mkfile_line(const char *line)
        } else {
                dname = name;
        }
-       rc = cpio_mkfile(dname, location, mode, uid, gid, nlinks);
+       rc = cpio_mkfile(dname, cpio_replace_env(location),
+                        mode, uid, gid, nlinks);
  fail:
        if (dname_len) free(dname);
        return rc;
@@ -439,6 +464,7 @@ void usage(const char *prog)
                "\n"
                "<name>       name of the file/dir/nod/etc in the archive\n"
                "<location>   location of the file in the current filesystem\n"
+               "             expands shell variables quoted with ${}\n"
                "<target>     link target\n"
                "<mode>       mode/permissions of the file\n"
                "<uid>        user id (0=root)\n"

Signed-off-by: gene.sally@timesys.com


