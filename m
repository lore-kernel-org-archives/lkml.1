Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYCaWn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYCaWn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYCaWns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:43:48 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47254 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYCaWnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:43:47 -0400
Date: Mon, 31 Mar 2008 16:43:44 -0600
From: Alex Chiang <achiang@hp.com>
To: David Miller <davem@davemloft.net>
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.13
Message-ID: <20080331224344.GB2362@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	David Miller <davem@davemloft.net>, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com> <20080331202633.GA341@ldl.fc.hp.com> <20080331.134510.126138884.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331.134510.126138884.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net>:
> From: Alex Chiang <achiang@hp.com>
> Date: Mon, 31 Mar 2008 14:26:33 -0600
> 
> > I've gotten as far as successfully creating a btrfs filesystem
> > (at least that's what btrfsck tells me), but haven't been able to
> > mount it yet, probably because of the sector size issue.
> 
> You should be able to make a filesystem with a sector
> size >= PAGE_SIZE and it should work just fine.  Please
> give it a try.

Hrm, I'm having issues still. First, here's a patch for
mkfs.btrfs to allow the user to pass in a different sector size.
Bug report follows...

/ac

>From f955af8deb68a00d92326a283491ea088f996a53 Mon Sep 17 00:00:00 2001
From: Alex Chiang <achiang@hp.com>
Date: Mon, 31 Mar 2008 16:41:21 -0600
Subject: [PATCH] Teach mkfs.btrfs about configurable sectorsizes

Currently, btrfs assumes PAGE_SIZE <= sectorsize, and sectorsize
is hardcoded to 4K in mkfs.btrfs.

Give mkfs.btrfs a new command line option to specify a different
sector size. The syntax follows mke2fs's -E extended-options syntax,
and the code is taken from mke2fs.
---
 mkfs.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 49f7308..9073209 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -137,15 +137,76 @@ err:
 	return ret;
 }
 
+struct btrfs_params {
+	u32 sectorsize;
+};
+
+/*
+ * Shameless ripped from mke2fs
+ */
+static void parse_extended_opts(struct btrfs_params *param, const char *opts)
+{
+	char    *buf, *token, *next, *p, *arg;
+	int     len;
+	int     r_usage = 0;
+
+	len = strlen(opts);
+	buf = malloc(len+1);
+	if (!buf) {
+		fprintf(stderr, "Couldn't allocate memory to parse options!\n");
+		exit(1);
+	}
+	strcpy(buf, opts);
+	for (token = buf; token && *token; token = next) {
+		p = strchr(token, ',');
+		next = 0;
+		if (p) {
+			*p = 0;
+			next = p+1;
+		}
+		arg = strchr(token, '=');
+		if (arg) {
+			*arg = 0;
+			arg++;
+		}
+		if (strcmp(token, "sectorsize") == 0) {
+			if (!arg) {
+				r_usage++;
+				continue;
+			}
+			param->sectorsize = strtoul(arg, &p, 0);
+			if (*p || (param->sectorsize == 0)) {
+				fprintf(stderr,
+					"Invalid sectorsize parameter: %s\n",
+					arg);
+				r_usage++;
+				continue;
+			}
+			} else {
+				r_usage++;
+			}
+		}
+	if (r_usage) {
+		fprintf(stderr, "\nBad options specified.\n\n"
+			"Extended options are separated by commas, "
+			"and may take an argument which\n"
+			"\tis set off by an equals ('=') sign.\n\n"
+			"Valid extended options are:\n"
+			"\tsectorsize=<sector size in bytes>\n\n");
+		exit(1);
+	}
+}
+
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: mkfs.btrfs [ -l leafsize ] [ -n nodesize] dev [ blocks ]\n");
+	fprintf(stderr, "usage: mkfs.btrfs [ -l leafsize ] [ -n nodesize] [ -E sectorsize=<sectorsize> ] dev [ blocks ]\n");
 	exit(1);
 }
 
 int main(int ac, char **av)
 {
 	char *file;
+	char *extended_opts = 0;
 	u64 block_count = 0;
 	u64 dev_block_count = 0;
 	int fd;
@@ -160,10 +221,11 @@ int main(int ac, char **av)
 	int zero_end = 1;
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_params fs_params;
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "b:l:n:s:");
+		c = getopt(ac, av, "b:l:n:s:E:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -180,10 +242,19 @@ int main(int ac, char **av)
 				block_count = parse_size(optarg);
 				zero_end = 0;
 				break;
+			case 'E':
+				memset(&fs_params, 0,
+					sizeof(struct btrfs_params));
+				extended_opts = optarg;
+				break;
 			default:
 				print_usage();
 		}
 	}
+	if (extended_opts) {
+		parse_extended_opts(&fs_params, extended_opts);
+		sectorsize = fs_params.sectorsize;
+	}
 	if (leafsize < sectorsize || (leafsize & (sectorsize - 1))) {
 		fprintf(stderr, "Illegal leafsize %u\n", leafsize);
 		exit(1);
@@ -192,6 +263,7 @@ int main(int ac, char **av)
 		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
 		exit(1);
 	}
+
 	ac = ac - optind;
 	if (ac == 0)
 		print_usage();
-- 
1.5.3.1.g1e61

