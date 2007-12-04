Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXLDPLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXLDPLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbXLDPLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:11:25 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:64495 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbXLDPLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aaTjpRBePj4VbcM5JjWQukjjjPQZpSUcptCjlOyGPCIRFkC+0lgvKUu/X58pExuA3/9XfpIIQS0X7mfRCfAGzBKHcePN5oM4DTd9EgxGQqNZID+fMknjDwDVmSKkoiFdpmmec6UzfkQL92/8Y4048/Rc2WxDibsxTIgS/43Kxk4=
Date: Tue, 4 Dec 2007 23:07:34 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
Message-ID: <20071204150734.GE6113@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <47555AF1.8090304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47555AF1.8090304@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


{snip}

Comments on your C code below.

>--- /dev/null
>+++ b/scripts/remove-dup.c
>@@ -0,0 +1,98 @@
>+/*
>+ * remove-dup - Drop duplicate lines from unsorted input files
>+ *
>+ * Dec 2007 Tejun Heo <teheo@suse.de>
>+ *
>+ * This software is released under GPLv2.
>+ */
>+
>+#include <stdio.h>
>+#include <string.h>
>+#include <stdlib.h>
>+
>+struct hash_ent {
>+	struct hash_ent *next;
>+	char str[];
>+};
>+
>+#define fatal(fmt, args...)	do {		\
>+		fprintf(stderr, fmt , ##args);	\
>+		exit(1);			\
>+	} while (0)
>+
>+static inline unsigned int sdb_hash(const char *str)
>+{
>+        unsigned int hash = 0;
>+        int c;
>+
>+        while ((c = *str++))

Maybe ` while ((c = *str++) != '\0') ` is better. ;)


>+		hash = c + (hash << 6) + (hash << 16) - hash;
>+
>+        return hash;
>+}
>+
>+int main(int argc, char **argv)
>+{
>+	unsigned int nr_entries = 0;
>+	struct hash_ent **hash_tbl;
>+	char line[10240];

Needs to #define the magic number?


>+	int i;
>+
>+	/* first pass, count lines */
>+	for (i = 1; i < argc; i++) {
>+		FILE *fp = fopen(argv[i], "r");
>+
>+		if (!fp)
>+			fatal("failed to open %s for reading\n", argv[i]);
>+
>+		while (fgets(line, sizeof(line), fp))
>+			nr_entries++;
>+
>+		fclose(fp);
>+	}
>+
>+	nr_entries = nr_entries * 10 / 8;
>+	hash_tbl = calloc(nr_entries, sizeof(struct hash_ent *));
>+	if (!hash_tbl)
>+		fatal("failed to allocate hash table for %u entries\n",
>+		      nr_entries);
>+
>+	/* second pass, hash and print unique lines */
>+	for (i = 1; i < argc; i++) {
>+		FILE *fp = fopen(argv[i], "r");
>+
>+		if (!fp)
>+			fatal("failed to open %s for reading\n", argv[i]);
>+
>+		while (fgets(line, sizeof(line), fp)) {
>+			int len = strlen(line);

strlen returns 'size_t', which is unsigned.


>+			struct hash_ent **ppos, *new_ent;
>+
>+			if (line[len - 1] == '\n')
>+				line[--len] = '\0';
>+
>+			ppos = hash_tbl + (sdb_hash(line) % nr_entries);
>+			while (*ppos) {
>+				if (strcmp((*ppos)->str, line) == 0)
>+					break;
>+				ppos = &(*ppos)->next;
>+			}
>+			if (*ppos)
>+				continue;
>+
>+			new_ent = malloc(sizeof(struct hash_ent) + len + 1);
>+			if (!new_ent)
>+				fatal("failed to allocate hash entry\n");
>+			new_ent->next = NULL;
>+			memcpy(new_ent->str, line, len + 1);
>+
>+			*ppos = new_ent;
>+
>+			printf("%s\n", line);
>+		}
>+
>+		fclose(fp);
>+	}
>+

I think, you forgot to free(3) the memory you calloc(3)'ed and
malloc(3)'ed above.

>+	return 0;
>+}


Thanks!


 Cong

