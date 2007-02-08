Return-Path: <linux-kernel-owner+w=401wt.eu-S1423250AbXBHTRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423250AbXBHTRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423257AbXBHTRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:17:05 -0500
Received: from s1.cableone.net ([24.116.0.227]:52332 "EHLO S1.cableone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423250AbXBHTRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:17:03 -0500
Message-ID: <62233.84.210.74.57.1170961822.squirrel@peltkore.net>
Date: Thu, 8 Feb 2007 20:10:22 +0100 (CET)
Subject: [PATCH] sprintf() to snprintf() and some style changes
From: "Vegard Nossum" <vegard@peltkore.net>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
X-IP-stats: Incoming Last 0, First 70, in=822, out=0, spam=0
X-External-IP: 69.92.239.151
X-Abuse-Info: Send abuse complaints to abuse@cableone.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
From: Vegard Nossum <vegard@peltkore.net>
Date: Thu Feb 8 19:57:16 2007 +0100
Subject: [PATCH] sprintf() to snprintf() and some style changes

Change a few instances of sprintf() to the safer snprintf(). Nicely split
lines that exceed 80 columns. Fix a few whitespace issues.


Signed-off-by: Vegard Nossum <vegard@peltkore.net>


---

 init/do_mounts.c    |   13 ++++---
 init/do_mounts_md.c |   89
+++++++++++++++++++++++++++++++--------------------
 init/do_mounts_rd.c |   12 ++++---
 init/main.c         |    3 +-
 4 files changed, 70 insertions(+), 47 deletions(-)

006417b9f08a6f1bc959b528fb2570ed33d69f42
diff --git a/init/do_mounts.c b/init/do_mounts.c
index dc1ec08..c632eeb 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -65,7 +65,7 @@ static dev_t try_name(char *name, int pa

 	/* read device number from .../dev */

-	sprintf(path, "/sys/block/%s/dev", name);
+	snprintf(path, sizeof(path), "/sys/block/%s/dev", name);
 	fd = sys_open(path, 0, 0);
 	if (fd < 0)
 		goto fail;
@@ -95,7 +95,7 @@ static dev_t try_name(char *name, int pa
 		return res;

 	/* otherwise read range from .../range */
-	sprintf(path, "/sys/block/%s/range", name);
+	snprintf(path, sizeof(path), "/sys/block/%s/range", name);
 	fd = sys_open(path, 0, 0);
 	if (fd < 0)
 		goto fail;
@@ -352,7 +352,7 @@ void __init change_floppy(char *fmt, ...
 	int fd;
 	va_list args;
 	va_start(args, fmt);
-	vsprintf(buf, fmt, args);
+	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
 	if (fd >= 0) {
@@ -380,7 +380,8 @@ void __init mount_root(void)
 		if (mount_nfs_root())
 			return;

-		printk(KERN_ERR "VFS: Unable to mount root fs via NFS, trying
floppy.\n");
+		printk(KERN_ERR "VFS: Unable to mount root fs via NFS, "
+			"trying floppy.\n");
 		ROOT_DEV = Root_FD0;
 	}
 #endif
@@ -410,8 +411,8 @@ void __init prepare_namespace(void)
 	int is_floppy;

 	if (root_delay) {
-		printk(KERN_INFO "Waiting %dsec before mounting root device...\n", -		 
     root_delay);
+		printk(KERN_INFO "Waiting %dsec before mounting "
+			"root device...\n", root_delay);
 		ssleep(root_delay);
 	}

diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 753dc54..df1fc04 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -35,15 +35,16 @@ extern int mdp_major;
  *             invoked program now).  Added ability to initialise all *  
          the MD devices (by specifying multiple "md=" lines) *         
   instead of just one.  -- KTK
- * 18May2000: Added support for persistent-superblock arrays:
+ * 18May2000:  Added support for persistent-superblock arrays:
  *             md=n,0,factor,fault,device-list   uses RAID0 for device n
*             md=n,-1,factor,fault,device-list  uses LINEAR for device n
*             md=n,device-list      reads a RAID superblock from the
devices
  *             elements in device-list are read by name_to_kdev_t so can
be
  *             a hex number or something like /dev/hda1 /dev/sdb
  * 2001-06-03: Dave Cinege <dcinege@psychosis.com>
- *		Shifted name_to_kdev_t() and related operations to md_set_drive() -
*		for later execution. Rewrote section to make devfs compatible. + *     
       Shifted name_to_kdev_t() and related operations to + *            
md_set_drive() for later execution. Rewrote section to make
+ *             devfs compatible.
  */
 static int __init md_setup(char *str)
 {
@@ -56,35 +57,45 @@ static int __init md_setup(char *str)
 		partitioned = 1;
 		str++;
 	}
-	if (get_option(&str, &minor) != 2) {	/* MD Number */
-		printk(KERN_WARNING "md: Too few arguments supplied to md=.\n"); +	/*
MD Number */
+	if (get_option(&str, &minor) != 2) {
+		printk(KERN_WARNING
+			"md: Too few arguments supplied to md=.\n");
 		return 0;
 	}
 	str1 = str;
 	for (ent=0 ; ent< md_setup_ents ; ent++)
 		if (md_setup_args[ent].minor == minor &&
 		    md_setup_args[ent].partitioned == partitioned) {
-			printk(KERN_WARNING "md: md=%s%d, Specified more than once. "
-			       "Replacing previous definition.\n", partitioned?"d":"", minor);
+			printk(KERN_WARNING
+				"md: md=%s%d, Specified more than once. "
+				"Replacing previous definition.\n",
+				partitioned ? "d" : "", minor);
 			break;
 		}
 	if (ent >= ARRAY_SIZE(md_setup_args)) {
-		printk(KERN_WARNING "md: md=%s%d - too many md initialisations\n",
partitioned?"d":"", minor);
+		printk(KERN_WARNING
+			"md: md=%s%d - too many md initialisations\n",
+			partitioned ? "d" : "", minor);
 		return 0;
 	}
 	if (ent >= md_setup_ents)
 		md_setup_ents++;
-	switch (get_option(&str, &level)) {	/* RAID level */
+	/* RAID level */
+	switch (get_option(&str, &level)) {
 	case 2: /* could be 0 or -1.. */
 		if (level == 0 || level == LEVEL_LINEAR) {
-			if (get_option(&str, &factor) != 2 ||	/* Chunk Size */
+			/* Chunk Size */
+			if (get_option(&str, &factor) != 2 ||
 					get_option(&str, &fault) != 2) {
-				printk(KERN_WARNING "md: Too few arguments supplied to md=.\n");
+				printk(KERN_WARNING
+					"md: Too few arguments supplied to "
+					"md=.\n");
 				return 0;
 			}
 			md_setup_args[ent].level = level;
-			md_setup_args[ent].chunk = 1 << (factor+12);
-			if (level ==  LEVEL_LINEAR)
+			md_setup_args[ent].chunk = 1 << (factor + 12);
+			if (level == LEVEL_LINEAR)
 				pername = "linear";
 			else
 				pername = "raid0";
@@ -96,7 +107,7 @@ static int __init md_setup(char *str)
 		/* FALL THROUGH */
 	case 0:
 		md_setup_args[ent].level = LEVEL_NONE;
-		pername="super-block";
+		pername = "super-block";
 	}

 	printk(KERN_INFO "md: Will configure md%d (%s) from %s, below.\n",
@@ -127,7 +138,8 @@ static void __init md_setup_drive(void)
 		partitioned = md_setup_args[ent].partitioned;
 		devname = md_setup_args[ent].device_names;

-		sprintf(name, "/dev/md%s%d", partitioned?"_d":"", minor);
+		snprintf(name, sizeof(name),
+			"/dev/md%s%d", partitioned ? "_d" : "", minor);
 		if (partitioned)
 			dev = MKDEV(mdp_major, minor << MdpMinorShift);
 		else
@@ -145,12 +157,15 @@ static void __init md_setup_drive(void)
 			dev = name_to_dev_t(devname);
 			if (strncmp(devname, "/dev/", 5) == 0)
 				devname += 5;
-			snprintf(comp_name, 63, "/dev/%s", devname);
+			snprintf(comp_name, sizeof(comp_name),
+				"/dev/%s", devname);
 			rdev = bstat(comp_name);
 			if (rdev)
 				dev = new_decode_dev(rdev);
 			if (!dev) {
-				printk(KERN_WARNING "md: Unknown device name: %s\n", devname);
+				printk(KERN_WARNING
+					"md: Unknown device name: %s\n",
+					devname);
 				break;
 			}

@@ -175,8 +190,8 @@ static void __init md_setup_drive(void)
 		}
 		if (sys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
 			printk(KERN_WARNING
-			       "md: Ignoring md=%d, already autodetected. (Use
raid=noautodetect)\n",
-			       minor);
+				"md: Ignoring md=%d, already autodetected. "
+				"(Use raid=noautodetect)\n", minor);
 			sys_close(fd);
 			continue;
 		}
@@ -186,11 +201,11 @@ static void __init md_setup_drive(void)
 			mdu_array_info_t ainfo;
 			ainfo.level = md_setup_args[ent].level;
 			ainfo.size = 0;
-			ainfo.nr_disks =0;
-			ainfo.raid_disks =0;
+			ainfo.nr_disks = 0;
+			ainfo.raid_disks = 0;
 			while (devices[ainfo.raid_disks])
 				ainfo.raid_disks++;
-			ainfo.md_minor =minor;
+			ainfo.md_minor = minor;
 			ainfo.not_persistent = 1;

 			ainfo.state = (1 << MD_SB_CLEAN);
@@ -203,10 +218,12 @@ static void __init md_setup_drive(void)
 					break;
 				dinfo.number = i;
 				dinfo.raid_disk = i;
-				dinfo.state = (1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC);
+				dinfo.state = (1 << MD_DISK_ACTIVE)
+					| (1 << MD_DISK_SYNC);
 				dinfo.major = MAJOR(dev);
 				dinfo.minor = MINOR(dev);
-				err = sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
+				err = sys_ioctl(fd, ADD_NEW_DISK,
+					(long)&dinfo);
 			}
 		} else {
 			/* persistent */
@@ -222,12 +239,13 @@ static void __init md_setup_drive(void)
 		if (!err)
 			err = sys_ioctl(fd, RUN_ARRAY, 0);
 		if (err)
-			printk(KERN_WARNING "md: starting md%d failed\n", minor);
+			printk(KERN_WARNING "md: starting md%d failed\n",
+				minor);
 		else {
 			/* reread the partition table.
-			 * I (neilb) and not sure why this is needed, but I cannot
-			 * boot a kernel with devfs compiled in from partitioned md
-			 * array without it
+			 * I (neilb) and not sure why this is needed, but I
+			 * cannot boot a kernel with devfs compiled in from
+			 * partitioned md array without it
 			 */
 			sys_close(fd);
 			fd = sys_open(name, 0, 0);
@@ -245,19 +263,19 @@ static int __init raid_setup(char *str)
 	pos = 0;

 	while (pos < len) {
-		char *comma = strchr(str+pos, ',');
+		char *comma = strchr(str + pos, ',');
 		int wlen;
 		if (comma)
-			wlen = (comma-str)-pos;
-		else	wlen = (len-1)-pos;
+			wlen = (comma-str) - pos;
+		else	wlen = (len - 1) - pos;

 		if (!strncmp(str, "noautodetect", wlen))
 			raid_noautodetect = 1;
-		if (strncmp(str, "partitionable", wlen)==0)
+		if (strncmp(str, "partitionable", wlen) == 0)
 			raid_autopart = 1;
-		if (strncmp(str, "part", wlen)==0)
+		if (strncmp(str, "part", wlen) == 0)
 			raid_autopart = 1;
-		pos += wlen+1;
+		pos += wlen + 1;
 	}
 	return 1;
 }
@@ -269,7 +287,8 @@ void __init md_run_setup(void)
 {
 	create_dev("/dev/md0", MKDEV(MD_MAJOR, 0));
 	if (raid_noautodetect)
-		printk(KERN_INFO "md: Skipping autodetection of RAID arrays.
(raid=noautodetect)\n");
+		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. "
+			"(raid=noautodetect)\n");
 	else {
 		int fd = sys_open("/dev/md0", 0, 0);
 		if (fd >= 0) {
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index ed652f4..119db08 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -89,7 +89,8 @@ identify_ramdisk_image(int fd, int start
 		printk(KERN_NOTICE
 		       "RAMDISK: romfs filesystem found at block %d\n",
 		       start_block);
-		nblocks = (ntohl(romfsb->size)+BLOCK_SIZE-1)>>BLOCK_SIZE_BITS;
+		nblocks = (ntohl(romfsb->size) + BLOCK_SIZE - 1)
+			>> BLOCK_SIZE_BITS;
 		goto done;
 	}

@@ -122,8 +123,8 @@ identify_ramdisk_image(int fd, int start
 		printk(KERN_NOTICE
 		       "RAMDISK: ext2 filesystem found at block %d\n",
 		       start_block);
-		nblocks = le32_to_cpu(ext2sb->s_blocks_count) <<
-			le32_to_cpu(ext2sb->s_log_block_size);
+		nblocks = le32_to_cpu(ext2sb->s_blocks_count)
+			<< le32_to_cpu(ext2sb->s_log_block_size);
 		goto done;
 	}

@@ -217,8 +218,9 @@ int __init rd_load_image(char *from)
 		goto done;
 	}

-	printk(KERN_NOTICE "RAMDISK: Loading %dKiB [%ld disk%s] into ram disk... ",
-		nblocks, ((nblocks-1)/devblocks)+1, nblocks>devblocks ? "s" : "");
+	printk(KERN_NOTICE "RAMDISK: Loading %dKiB [%ld disk%s] into "
+		"ram disk... ", nblocks, ((nblocks - 1) / devblocks) + 1,
+		nblocks>devblocks ? "s" : "");
 	for (i = 0, disk = 1; i < nblocks; i++) {
 		if (i && (i % devblocks == 0)) {
 			printk("done disk #%d.\n", disk++);
diff --git a/init/main.c b/init/main.c
index 8b4a7d7..4d846fa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -651,7 +651,8 @@ static void __init do_initcalls(void)
 		result = (*call)();

 		if (result && result != -ENODEV && initcall_debug) {
-			sprintf(msgbuf, "error code %d", result);
+			snprintf(msgbuf, sizeof(msgbuf),
+				"error code %d", result);
 			msg = msgbuf;
 		}
 		if (preempt_count() != count) {
-- 
1.2.4





