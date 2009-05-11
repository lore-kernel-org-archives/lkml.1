Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbZEKWPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbZEKWPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbZEKWPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:15:16 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43828 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443AbZEKWPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:15:14 -0400
Date: Mon, 11 May 2009 15:15:02 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, serue@us.ibm.com, hpa@zytor.com,
       sukadev@us.ibm.com, linux-kernel@vger.kernel.org, jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for single
	andmultiple-instancemounts
Message-ID: <20090511221502.GA32530@linux.vnet.ibm.com>
References: <20090307180816.GA30072@us.ibm.com> <20090307181232.GF30072@us.ibm.com> <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com> <20090507212429.GA24064@linux.vnet.ibm.com> <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com> <20090507231844.GA27609@linux.vnet.ibm.com> <20090507232110.GB27609@linux.vnet.ibm.com> <4A04F5D7.2050909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A04F5D7.2050909@gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Dionne [marc.c.dionne@gmail.com] wrote:
> On 05/07/2009 07:21 PM, Sukadev Bhattiprolu wrote:
>> Er. I meant add following lines after the memset().
>>
>> |         opts->mode    = DEVPTS_DEFAULT_MODE;
>> |         opts->ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;
>
> Adding those two lines (with . instead of ->) does fix the issue for me, 
> thanks.
>
> | > Of course we would still need to understand if/
> | > why this patch changes the settings.
>
> That particular patch changed things because the original memcpy in 
> new_pts_mount() did this:
>
> memcpy(&fsi->mount_opts, opts, sizeof(opts));
>
> where opts was a pointer, not a structure.  So only the first few bytes of 
> the blank opts actually got copied over.  The patch moved this memcpy to 
> devpts_get_sb() and in the process fixed the sizeof error.

Here is a cleaner fix - When user space (/etc/rc.sysinit on RHEL5) mounts
devpts, this problem might be masked since the mount system call could pass
a non-NULL 'data' parmeter to devpts_get_sb().

I tested this patch by directly calling the system call mount() with a NULL
data parameter. If you/Eric/Peter can confirm that this works for you, I will
send this patch to Andrew.

Thanks,
---
>From 2f7746f4df78ff57125c4714f0cd64e739ccf804 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Mon, 11 May 2009 13:11:11 -0700
Subject: [PATCH] devpts: Correctly set default options

devpts_get_sb() calls memset(0) to clear mount options and calls
parse_mount_options() if user specified any mount options. The memset(0) is
bogus since the 'mode' and 'ptmxmode' options are non-zero by default.
parse_mount_options() restores options to default anyway and can properly deal
with NULL mount options.

So in devpts_get_sb() remove memset(0) and call parse_mount_options() even for
NULL mount options.

Bug reported by Eric Paris: http://lkml.org/lkml/2009/5/7/448.

Signed-off-by: Sukadev Bhattiprolu (sukadev@us.ibm.com)
---
 fs/devpts/inode.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 63a4a59..b7a954e 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -90,6 +90,15 @@ static inline struct super_block *pts_sb_from_inode(struct inode *inode)
 #define PARSE_MOUNT	0
 #define PARSE_REMOUNT	1
 
+/*
+ * parse_mount_options():
+ * 	Set @opts to mount options specified in @data. If an option is not
+ * 	specified in @data, set it to its default value. The exception is
+ * 	'newinstance' option which can only be set/cleared on a mount (i.e.
+ * 	cannot be changed during remount).
+ *
+ * Note: @data may be NULL (in which case all options are set to default).
+ */
 static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 {
 	char *p;
@@ -355,12 +364,9 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 	struct pts_mount_opts opts;
 	struct super_block *s;
 
-	memset(&opts, 0, sizeof(opts));
-	if (data) {
-		error = parse_mount_options(data, PARSE_MOUNT, &opts);
-		if (error)
-			return error;
-	}
+	error = parse_mount_options(data, PARSE_MOUNT, &opts);
+	if (error)
+		return error;
 
 	if (opts.newinstance)
 		s = sget(fs_type, NULL, set_anon_super, NULL);
