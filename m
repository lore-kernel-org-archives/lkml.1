Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZHFM6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZHFM6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZHFM6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:58:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:48670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbZHFM6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:58:07 -0400
Date: Thu, 6 Aug 2009 12:57:36 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf symbol: Fix symbol parsing in certain cases: use the build-id as a symlink
Message-ID: <tip-98b31af14e0a42030563e3f360fe5a214d589131@git.kernel.org>
Git-Commit-ID: 98b31af14e0a42030563e3f360fe5a214d589131
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 12:57:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98b31af14e0a42030563e3f360fe5a214d589131
Gitweb:     http://git.kernel.org/tip/98b31af14e0a42030563e3f360fe5a214d589131
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 5 Aug 2009 19:02:49 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 6 Aug 2009 14:52:10 +0200

perf symbol: Fix symbol parsing in certain cases: use the build-id as a symlink

In some cases...

[root@doppio tuna]# ls -la /usr/lib64/{xulrunner-1.9.1/xulrunner-stub,firefox-3.5.2/firefox}
-rwxr-xr-x 1 root root 90024 2009-08-03 19:45 /usr/lib64/firefox-3.5.2/firefox
-rwxr-xr-x 1 root root 90024 2009-08-03 18:23 /usr/lib64/xulrunner-1.9.1/xulrunner-stub
[root@doppio tuna]# sha1sum /usr/lib64/{xulrunner-1.9.1/xulrunner-stub,firefox-3.5.2/firefox}
19a858077d263d5de22c9c5da250d3e4396ae739  /usr/lib64/xulrunner-1.9.1/xulrunner-stub
19a858077d263d5de22c9c5da250d3e4396ae739  /usr/lib64/firefox-3.5.2/firefox
[root@doppio tuna]# rpm -qf /usr/lib64/{xulrunner-1.9.1/xulrunner-stub,firefox-3.5.2/firefox}
xulrunner-1.9.1.2-1.fc11.x86_64
firefox-3.5.2-2.fc11.x86_64
[root@doppio tuna]# ls -la /usr/lib/debug/{usr/lib64/xulrunner-1.9.1/xulrunner-stub,usr/lib64/firefox-3.5.2/firefox}.debug
ls: cannot access /usr/lib/debug/usr/lib64/firefox-3.5.2/firefox.debug: No such file or directory
-rwxr-xr-x 1 root root 403608 2009-08-03 18:22 /usr/lib/debug/usr/lib64/xulrunner-1.9.1/xulrunner-stub.debug

Seemingly we don't have a .symtab when we actually can find it
if we use the .note.gnu.build-id ELF section put in place by
some distros. Use it and find the symbols we need.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/symbol.c |   74 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0580b94..80fa3e4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -661,10 +661,67 @@ out_close:
 	return err;
 }
 
+static char *dso__read_build_id(struct dso *self, int verbose)
+{
+	int i;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	Elf_Data *build_id_data;
+	Elf_Scn *sec;
+	char *build_id = NULL, *bid;
+	unsigned char *raw;
+	Elf *elf;
+	int fd = open(self->name, O_RDONLY);
+
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		if (verbose)
+			fprintf(stderr, "%s: cannot read %s ELF file.\n",
+				__func__, self->name);
+		goto out_close;
+	}
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		if (verbose)
+			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
+		goto out_elf_end;
+	}
+
+	sec = elf_section_by_name(elf, &ehdr, &shdr, ".note.gnu.build-id", NULL);
+	if (sec == NULL)
+		goto out_elf_end;
+
+	build_id_data = elf_getdata(sec, NULL);
+	if (build_id_data == NULL)
+		goto out_elf_end;
+	build_id = malloc(128);
+	if (build_id == NULL)
+		goto out_elf_end;
+	raw = build_id_data->d_buf + 16;
+	bid = build_id;
+
+	for (i = 0; i < 20; ++i) {
+		sprintf(bid, "%02x", *raw);
+		++raw;
+		bid += 2;
+	}
+	if (verbose)
+		printf("%s(%s): %s\n", __func__, self->name, build_id);
+out_elf_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+out:
+	return build_id;
+}
+
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 {
-	int size = strlen(self->name) + sizeof("/usr/lib/debug%s.debug");
-	char *name = malloc(size);
+	int size = PATH_MAX;
+	char *name = malloc(size), *build_id = NULL;
 	int variant = 0;
 	int ret = -1;
 	int fd;
@@ -686,7 +743,18 @@ more:
 		case 1: /* Ubuntu */
 			snprintf(name, size, "/usr/lib/debug%s", self->name);
 			break;
-		case 2: /* Sane people */
+		case 2:
+			build_id = dso__read_build_id(self, verbose);
+			if (build_id != NULL) {
+				snprintf(name, size,
+					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
+					build_id, build_id + 2);
+				free(build_id);
+				break;
+			}
+			variant++;
+			/* Fall thru */
+		case 3: /* Sane people */
 			snprintf(name, size, "%s", self->name);
 			break;
 
