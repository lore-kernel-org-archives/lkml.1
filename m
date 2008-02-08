Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYBHRwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYBHRwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759744AbYBHRwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:52:33 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:48008 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759114AbYBHRwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:52:31 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Markus Armbruster <armbru@redhat.com>
Subject: [PATCH] Handle memory allocation failure.
Date: Fri, 08 Feb 2008 18:52:29 +0100
Message-ID: <878x1vqqsi.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I spotted a few unchecked memory allocation failures early this week
(here's the one that hasn't been taken yet)
  http://article.gmane.org/gmane.linux.kernel/634811
and went looking for more.  I found and fixed seven more:
[Thanks to Markus Armbruster for a rigorous review. ]

FYI, my first crack at cleaning up v9fs_parse_options
removed the match_strdup call altogether, but was more
invasive in that it added a new function, match_strcmp and
made the existing match_number function public.
The patch below just handles the match_strdup failure.

Also, with a new match_strlcpy function, one could avoid the
match_strdup call in fs/affs/super.c, and with a new
match_simple_strtoll function, one could avoid a few more
memory allocations.  That's for another day...

Here's the patch:

-----------------------

>From c029d65e38ca25b4a0677d0434689240618430b4 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Fri, 8 Feb 2008 15:23:35 +0100
Subject: [PATCH] Handle memory allocation failure.

* arch/alpha/kernel/module.c (module_frob_arch_sections): Handle kcalloc failure.
* fs/9p/v9fs.c (v9fs_parse_options): Handle kstrdup and match_strdup failure.
Now that this function can fail, return an int, diagnose other option-parsing
failures, and adjust the sole caller:
(v9fs_session_init): Handle kstrdup failure.  Propagate any new
v9fs_parse_options failure "up".
* fs/affs/super.c (parse_options): Handle match_strdup failure.
* fs/hfs/super.c (parse_options): Likewise, twice.
* fs/hfsplus/options.c (hfsplus_parse_options): Likewise.
* sound/usb/usbaudio.c (check_hw_params_convention): Handle kcalloc failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 arch/alpha/kernel/module.c |    6 ++++++
 fs/9p/v9fs.c               |   40 ++++++++++++++++++++++++++++++++++------
 fs/affs/super.c            |    3 ++-
 fs/hfs/super.c             |    6 ++++--
 fs/hfsplus/options.c       |    3 ++-
 sound/usb/usbaudio.c       |    2 ++
 6 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/kernel/module.c b/arch/alpha/kernel/module.c
index 026ba9a..ebc3c89 100644
--- a/arch/alpha/kernel/module.c
+++ b/arch/alpha/kernel/module.c
@@ -120,6 +120,12 @@ module_frob_arch_sections(Elf64_Ehdr *hdr, Elf64_Shdr *sechdrs,

 	nsyms = symtab->sh_size / sizeof(Elf64_Sym);
 	chains = kcalloc(nsyms, sizeof(struct got_entry), GFP_KERNEL);
+	if (!chains) {
+		printk(KERN_ERR
+		       "module %s: no memory for symbol chain buffer\n",
+		       me->name);
+		return -ENOMEM;
+	}

 	got->sh_size = 0;
 	got->sh_addralign = 8;
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 9b0f022..8ca142c 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -74,16 +74,17 @@ static match_table_t tokens = {
  * @options: options string passed from mount
  * @v9ses: existing v9fs session information
  *
+ * Return 0 upon success, -ERRNO upon failure.
  */

-static void v9fs_parse_options(struct v9fs_session_info *v9ses)
+static int v9fs_parse_options(struct v9fs_session_info *v9ses)
 {
 	char *options;
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option = 0;
 	char *s, *e;
-	int ret;
+	int ret = 0;

 	/* setup defaults */
 	v9ses->afid = ~0;
@@ -91,19 +92,26 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 	v9ses->cache = 0;

 	if (!v9ses->options)
-		return;
+		return 0;

 	options = kstrdup(v9ses->options, GFP_KERNEL);
+	if (!options) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+			   "failed to allocate copy of option string\n");
+		return -ENOMEM;
+	}
+
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 		if (!*p)
 			continue;
 		token = match_token(p, tokens, args);
 		if (token < Opt_uname) {
-			ret = match_int(&args[0], &option);
-			if (ret < 0) {
+			int r = match_int(&args[0], &option);
+			if (r < 0) {
 				P9_DPRINTK(P9_DEBUG_ERROR,
 					"integer field, but no integer?\n");
+				ret = r;
 				continue;
 			}
 		}
@@ -139,6 +147,13 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)

 		case Opt_access:
 			s = match_strdup(&args[0]);
+			if (!s) {
+				P9_DPRINTK(P9_DEBUG_ERROR,
+					   "failed to allocate copy"
+					   " of option argument\n");
+				ret = -ENOMEM;
+				break;
+			}
 			v9ses->flags &= ~V9FS_ACCESS_MASK;
 			if (strcmp(s, "user") == 0)
 				v9ses->flags |= V9FS_ACCESS_USER;
@@ -158,6 +173,7 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 		}
 	}
 	kfree(options);
+	return ret;
 }

 /**
@@ -173,6 +189,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 {
 	int retval = -EINVAL;
 	struct p9_fid *fid;
+	int rc;

 	v9ses->uname = __getname();
 	if (!v9ses->uname)
@@ -191,7 +208,18 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	v9ses->dfltuid = V9FS_DEFUID;
 	v9ses->dfltgid = V9FS_DEFGID;
 	v9ses->options = kstrdup(data, GFP_KERNEL);
-	v9fs_parse_options(v9ses);
+	if (!v9ses->options) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+			   "failed to allocate copy of option string\n");
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	rc = v9fs_parse_options(v9ses);
+	if (rc < 0) {
+		retval = rc;
+		goto error;
+	}

 	v9ses->clnt = p9_client_create(dev_name, v9ses->options);

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 3c45d49..2c2b69e 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -198,7 +198,6 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 		case Opt_prefix:
 			/* Free any previous prefix */
 			kfree(*prefix);
-			*prefix = NULL;
 			*prefix = match_strdup(&args[0]);
 			if (!*prefix)
 				return 0;
@@ -232,6 +231,8 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 			break;
 		case Opt_volume: {
 			char *vol = match_strdup(&args[0]);
+			if (!vol)
+				return 0;
 			strlcpy(volume, vol, 32);
 			kfree(vol);
 			break;
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 32de44e..8cf6797 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -297,7 +297,8 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			hsb->nls_disk = load_nls(p);
+			if (p)
+				hsb->nls_disk = load_nls(p);
 			if (!hsb->nls_disk) {
 				printk(KERN_ERR "hfs: unable to load codepage \"%s\"\n", p);
 				kfree(p);
@@ -311,7 +312,8 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			hsb->nls_io = load_nls(p);
+			if (p)
+				hsb->nls_io = load_nls(p);
 			if (!hsb->nls_io) {
 				printk(KERN_ERR "hfs: unable to load iocharset \"%s\"\n", p);
 				kfree(p);
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index dc64fac..9997cbf 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -132,7 +132,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			sbi->nls = load_nls(p);
+			if (p)
+				sbi->nls = load_nls(p);
 			if (!sbi->nls) {
 				printk(KERN_ERR "hfs: unable to load nls mapping \"%s\"\n", p);
 				kfree(p);
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 8fa9356..b61533d 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -1735,6 +1735,8 @@ static int check_hw_params_convention(struct snd_usb_substream *subs)

 	channels = kcalloc(MAX_MASK, sizeof(u32), GFP_KERNEL);
 	rates = kcalloc(MAX_MASK, sizeof(u32), GFP_KERNEL);
+	if (!channels || !rates)
+		goto __out;

 	list_for_each(p, &subs->fmt_list) {
 		struct audioformat *f;
--
1.5.4.35.g3cfc
