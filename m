Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZAZX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZAZX1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZAZX1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:27:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:15479 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZAZX1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PfUUXrdCAFG4RFo8buJShECPOHLqf8F7nguqnZ4sA/WmlSRYM8dvQDDBEOEQtF3/jC
         1d4wRB1Q1nbU8cgoqQLJaii5X2G/2UZVaPMCBwqL4KnIVzJNxzJEzonoSZ2kvx/BlGqz
         sRXybWcVqkSJiYjMGZDNWmmgpJSOshy7xWYvA=
Date: Tue, 27 Jan 2009 02:32:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: jlayton@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] proc: remove struct proc_dir_entry::owner
Message-ID: <20090126233247.GB7339@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting ->owner as done currently (pde->owner = THIS_MODULE) is racy
as correctly noted at bug #12454. Someone can lookup entry with NULL
->owner, thus not pinning enything, and release it later resulting
in module refcount underflow.

We can keep ->owner and supply it at registration time like ->proc_fops
and ->data.

But this leaves ->owner as easy-manipulative field (just one C assignment)
and somebody will forget to unpin previous/pin current module when
switching ->owner. ->proc_fops is declared as "const" which should give
some thoughts.

->read_proc/->write_proc were just fixed to not require ->owner for
protection.

rmmod'ed directories will be empty and return "." and ".." -- no harm.
And directories with tricky enough readdir and lookup shouldn't be modular.
We definitely don't want such modular code.

Removing ->owner will also make PDE smaller.

So, let's nuke it.

Kudos to Jeff Layton for reminding about this, let's say, oversight.

http://bugzilla.kernel.org/show_bug.cgi?id=12454

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 Documentation/DocBook/procfs_example.c  |    9 --------
 arch/alpha/kernel/srm_env.c             |    5 ----
 arch/blackfin/mm/sram-alloc.c           |    1 -
 arch/ia64/kernel/palinfo.c              |    2 -
 arch/ia64/sn/kernel/sn2/prominfo_proc.c |    9 +------
 arch/powerpc/kernel/rtas_flash.c        |    1 -
 arch/x86/kernel/cpu/mtrr/if.c           |   10 +--------
 drivers/acpi/ac.c                       |    1 -
 drivers/acpi/battery.c                  |    1 -
 drivers/acpi/button.c                   |    3 --
 drivers/acpi/fan.c                      |    2 -
 drivers/acpi/processor_core.c           |    2 -
 drivers/acpi/sbs.c                      |    1 -
 drivers/acpi/thermal.c                  |    2 -
 drivers/acpi/video.c                    |    5 ----
 drivers/char/ipmi/ipmi_msghandler.c     |   12 +++-------
 drivers/char/ipmi/ipmi_si_intf.c        |    6 ++--
 drivers/input/input.c                   |    2 -
 drivers/isdn/hardware/eicon/divasi.c    |    1 -
 drivers/media/video/cpia.c              |    4 +--
 drivers/message/i2o/i2o_proc.c          |    2 -
 drivers/net/bonding/bond_main.c         |   35 +-----------------------------
 drivers/net/irda/vlsi_ir.c              |    7 ------
 drivers/net/wireless/airo.c             |    1 -
 drivers/platform/x86/asus_acpi.c        |    3 --
 drivers/platform/x86/thinkpad_acpi.c    |    2 -
 drivers/platform/x86/toshiba_acpi.c     |    3 --
 drivers/rtc/rtc-proc.c                  |   10 +-------
 drivers/scsi/scsi_devinfo.c             |    2 -
 drivers/scsi/scsi_proc.c                |    3 --
 drivers/video/via/viafbdev.c            |    5 ----
 fs/afs/proc.c                           |    1 -
 fs/cifs/cifs_debug.c                    |    1 -
 fs/jfs/jfs_debug.c                      |    1 -
 fs/nfs/client.c                         |    2 -
 fs/proc/inode.c                         |   18 ++-------------
 fs/proc/proc_tty.c                      |    1 -
 fs/reiserfs/procfs.c                    |    5 +---
 include/linux/ipmi_smi.h                |    2 +-
 include/linux/proc_fs.h                 |    4 ---
 net/appletalk/atalk_proc.c              |    1 -
 net/atm/mpoa_proc.c                     |    1 -
 net/atm/proc.c                          |    1 -
 net/can/bcm.c                           |    4 ---
 net/can/proc.c                          |    2 -
 net/core/pktgen.c                       |    1 -
 net/irda/irproc.c                       |    1 -
 net/llc/llc_proc.c                      |    1 -
 net/sctp/protocol.c                     |    8 +-----
 net/sunrpc/cache.c                      |    4 ---
 net/sunrpc/stats.c                      |   10 +-------
 sound/core/info.c                       |   31 +-------------------------
 52 files changed, 26 insertions(+), 226 deletions(-)

diff --git a/Documentation/DocBook/procfs_example.c b/Documentation/DocBook/procfs_example.c
index 8c6396e..a5b1179 100644
--- a/Documentation/DocBook/procfs_example.c
+++ b/Documentation/DocBook/procfs_example.c
@@ -117,9 +117,6 @@ static int __init init_procfs_example(void)
 		rv = -ENOMEM;
 		goto out;
 	}
-	
-	example_dir->owner = THIS_MODULE;
-	
 	/* create jiffies using convenience function */
 	jiffies_file = create_proc_read_entry("jiffies", 
 					      0444, example_dir, 
@@ -130,8 +127,6 @@ static int __init init_procfs_example(void)
 		goto no_jiffies;
 	}
 
-	jiffies_file->owner = THIS_MODULE;
-
 	/* create foo and bar files using same callback
 	 * functions 
 	 */
@@ -146,7 +141,6 @@ static int __init init_procfs_example(void)
 	foo_file->data = &foo_data;
 	foo_file->read_proc = proc_read_foobar;
 	foo_file->write_proc = proc_write_foobar;
-	foo_file->owner = THIS_MODULE;
 		
 	bar_file = create_proc_entry("bar", 0644, example_dir);
 	if(bar_file == NULL) {
@@ -159,7 +153,6 @@ static int __init init_procfs_example(void)
 	bar_file->data = &bar_data;
 	bar_file->read_proc = proc_read_foobar;
 	bar_file->write_proc = proc_write_foobar;
-	bar_file->owner = THIS_MODULE;
 		
 	/* create symlink */
 	symlink = proc_symlink("jiffies_too", example_dir, 
@@ -169,8 +162,6 @@ static int __init init_procfs_example(void)
 		goto no_symlink;
 	}
 
-	symlink->owner = THIS_MODULE;
-
 	/* everything OK */
 	printk(KERN_INFO "%s %s initialised\n",
 	       MODULE_NAME, MODULE_VERS);
diff --git a/arch/alpha/kernel/srm_env.c b/arch/alpha/kernel/srm_env.c
index 78ad7cd..d12af47 100644
--- a/arch/alpha/kernel/srm_env.c
+++ b/arch/alpha/kernel/srm_env.c
@@ -218,7 +218,6 @@ srm_env_init(void)
 				BASE_DIR);
 		goto cleanup;
 	}
-	base_dir->owner = THIS_MODULE;
 
 	/*
 	 * Create per-name subdirectory
@@ -229,7 +228,6 @@ srm_env_init(void)
 				BASE_DIR, NAMED_DIR);
 		goto cleanup;
 	}
-	named_dir->owner = THIS_MODULE;
 
 	/*
 	 * Create per-number subdirectory
@@ -241,7 +239,6 @@ srm_env_init(void)
 		goto cleanup;
 
 	}
-	numbered_dir->owner = THIS_MODULE;
 
 	/*
 	 * Create all named nodes
@@ -254,7 +251,6 @@ srm_env_init(void)
 			goto cleanup;
 
 		entry->proc_entry->data		= (void *) entry;
-		entry->proc_entry->owner	= THIS_MODULE;
 		entry->proc_entry->read_proc	= srm_env_read;
 		entry->proc_entry->write_proc	= srm_env_write;
 
@@ -275,7 +271,6 @@ srm_env_init(void)
 
 		entry->id			= var_num;
 		entry->proc_entry->data		= (void *) entry;
-		entry->proc_entry->owner	= THIS_MODULE;
 		entry->proc_entry->read_proc	= srm_env_read;
 		entry->proc_entry->write_proc	= srm_env_write;
 	}
diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 834cab7..530d139 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -854,7 +854,6 @@ static int __init sram_proc_init(void)
 		printk(KERN_WARNING "unable to create /proc/sram\n");
 		return -1;
 	}
-	ptr->owner = THIS_MODULE;
 	ptr->read_proc = sram_proc_read;
 	return 0;
 }
diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index e5c57f4..a4f19c7 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -1002,8 +1002,6 @@ create_palinfo_proc_entries(unsigned int cpu)
 		*pdir = create_proc_read_entry(
 				palinfo_entries[j].name, 0, cpu_dir,
 				palinfo_read_entry, (void *)f.value);
-		if (*pdir)
-			(*pdir)->owner = THIS_MODULE;
 		pdir++;
 	}
 }
diff --git a/arch/ia64/sn/kernel/sn2/prominfo_proc.c b/arch/ia64/sn/kernel/sn2/prominfo_proc.c
index 4dcce3d..e633288 100644
--- a/arch/ia64/sn/kernel/sn2/prominfo_proc.c
+++ b/arch/ia64/sn/kernel/sn2/prominfo_proc.c
@@ -225,7 +225,6 @@ static struct proc_dir_entry *sgi_prominfo_entry;
 int __init prominfo_init(void)
 {
 	struct proc_dir_entry **entp;
-	struct proc_dir_entry *p;
 	cnodeid_t cnodeid;
 	unsigned long nasid;
 	int size;
@@ -246,14 +245,10 @@ int __init prominfo_init(void)
 		sprintf(name, "node%d", cnodeid);
 		*entp = proc_mkdir(name, sgi_prominfo_entry);
 		nasid = cnodeid_to_nasid(cnodeid);
-		p = create_proc_read_entry("fit", 0, *entp, read_fit_entry,
+		create_proc_read_entry("fit", 0, *entp, read_fit_entry,
 					   (void *)nasid);
-		if (p)
-			p->owner = THIS_MODULE;
-		p = create_proc_read_entry("version", 0, *entp,
+		create_proc_read_entry("version", 0, *entp,
 					   read_version_entry, (void *)nasid);
-		if (p)
-			p->owner = THIS_MODULE;
 		entp++;
 	}
 
diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 149cb11..13011a9 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -669,7 +669,6 @@ static void remove_flash_pde(struct proc_dir_entry *dp)
 {
 	if (dp) {
 		kfree(dp->data);
-		dp->owner = NULL;
 		remove_proc_entry(dp->name, dp->parent);
 	}
 }
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 4c42146..fb73a52 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -377,10 +377,6 @@ static const struct file_operations mtrr_fops = {
 	.release = mtrr_close,
 };
 
-
-static struct proc_dir_entry *proc_root_mtrr;
-
-
 static int mtrr_seq_show(struct seq_file *seq, void *offset)
 {
 	char factor;
@@ -423,11 +419,7 @@ static int __init mtrr_if_init(void)
 	    (!cpu_has(c, X86_FEATURE_CENTAUR_MCR)))
 		return -ENODEV;
 
-	proc_root_mtrr =
-		proc_create("mtrr", S_IWUSR | S_IRUGO, NULL, &mtrr_fops);
-
-	if (proc_root_mtrr)
-		proc_root_mtrr->owner = THIS_MODULE;
+	proc_create("mtrr", S_IWUSR | S_IRUGO, NULL, &mtrr_fops);
 	return 0;
 }
 
diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 9b917da..88e42ab 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -191,7 +191,6 @@ static int acpi_ac_add_fs(struct acpi_device *device)
 						     acpi_ac_dir);
 		if (!acpi_device_dir(device))
 			return -ENODEV;
-		acpi_device_dir(device)->owner = THIS_MODULE;
 	}
 
 	/* 'state' [R] */
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 65132f9..df11963 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -737,7 +737,6 @@ static int acpi_battery_add_fs(struct acpi_device *device)
 						     acpi_battery_dir);
 		if (!acpi_device_dir(device))
 			return -ENODEV;
-		acpi_device_dir(device)->owner = THIS_MODULE;
 	}
 
 	for (i = 0; i < ACPI_BATTERY_NUMFILES; ++i) {
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 171fd91..c2f0606 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -200,12 +200,10 @@ static int acpi_button_add_fs(struct acpi_device *device)
 
 	if (!entry)
 		return -ENODEV;
-	entry->owner = THIS_MODULE;
 
 	acpi_device_dir(device) = proc_mkdir(acpi_device_bid(device), entry);
 	if (!acpi_device_dir(device))
 		return -ENODEV;
-	acpi_device_dir(device)->owner = THIS_MODULE;
 
 	/* 'info' [R] */
 	entry = proc_create_data(ACPI_BUTTON_FILE_INFO,
@@ -522,7 +520,6 @@ static int __init acpi_button_init(void)
 	acpi_button_dir = proc_mkdir(ACPI_BUTTON_CLASS, acpi_root_dir);
 	if (!acpi_button_dir)
 		return -ENODEV;
-	acpi_button_dir->owner = THIS_MODULE;
 	result = acpi_bus_register_driver(&acpi_button_driver);
 	if (result < 0) {
 		remove_proc_entry(ACPI_BUTTON_CLASS, acpi_root_dir);
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index eaaee16..8a02944 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -193,7 +193,6 @@ static int acpi_fan_add_fs(struct acpi_device *device)
 						     acpi_fan_dir);
 		if (!acpi_device_dir(device))
 			return -ENODEV;
-		acpi_device_dir(device)->owner = THIS_MODULE;
 	}
 
 	/* 'status' [R/W] */
@@ -347,7 +346,6 @@ static int __init acpi_fan_init(void)
 	acpi_fan_dir = proc_mkdir(ACPI_FAN_CLASS, acpi_root_dir);
 	if (!acpi_fan_dir)
 		return -ENODEV;
-	acpi_fan_dir->owner = THIS_MODULE;
 #endif
 
 	result = acpi_bus_register_driver(&acpi_fan_driver);
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 0cc2fd3..fa2f742 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -359,7 +359,6 @@ static int acpi_processor_add_fs(struct acpi_device *device)
 		if (!acpi_device_dir(device))
 			return -ENODEV;
 	}
-	acpi_device_dir(device)->owner = THIS_MODULE;
 
 	/* 'info' [R] */
 	entry = proc_create_data(ACPI_PROCESSOR_FILE_INFO,
@@ -1137,7 +1136,6 @@ static int __init acpi_processor_init(void)
 	acpi_processor_dir = proc_mkdir(ACPI_PROCESSOR_CLASS, acpi_root_dir);
 	if (!acpi_processor_dir)
 		return -ENOMEM;
-	acpi_processor_dir->owner = THIS_MODULE;
 
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 6050ce4..59afd52 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -488,7 +488,6 @@ acpi_sbs_add_fs(struct proc_dir_entry **dir,
 		if (!*dir) {
 			return -ENODEV;
 		}
-		(*dir)->owner = THIS_MODULE;
 	}
 
 	/* 'info' [R] */
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 99e6f1f..c11f9ae 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1506,7 +1506,6 @@ static int acpi_thermal_add_fs(struct acpi_device *device)
 						     acpi_thermal_dir);
 		if (!acpi_device_dir(device))
 			return -ENODEV;
-		acpi_device_dir(device)->owner = THIS_MODULE;
 	}
 
 	/* 'state' [R] */
@@ -1875,7 +1874,6 @@ static int __init acpi_thermal_init(void)
 	acpi_thermal_dir = proc_mkdir(ACPI_THERMAL_CLASS, acpi_root_dir);
 	if (!acpi_thermal_dir)
 		return -ENODEV;
-	acpi_thermal_dir->owner = THIS_MODULE;
 
 	result = acpi_bus_register_driver(&acpi_thermal_driver);
 	if (result < 0) {
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index f261737..77028ef 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1125,8 +1125,6 @@ static int acpi_video_device_add_fs(struct acpi_device *device)
 	if (!device_dir)
 		return -ENOMEM;
 
-	device_dir->owner = THIS_MODULE;
-
 	/* 'info' [R] */
 	entry = proc_create_data("info", S_IRUGO, device_dir,
 			&acpi_video_device_info_fops, acpi_driver_data(device));
@@ -1403,8 +1401,6 @@ static int acpi_video_bus_add_fs(struct acpi_device *device)
 	if (!device_dir)
 		return -ENOMEM;
 
-	device_dir->owner = THIS_MODULE;
-
 	/* 'info' [R] */
 	entry = proc_create_data("info", S_IRUGO, device_dir,
 				 &acpi_video_bus_info_fops,
@@ -2125,7 +2121,6 @@ static int __init acpi_video_init(void)
 	acpi_video_dir = proc_mkdir(ACPI_VIDEO_CLASS, acpi_root_dir);
 	if (!acpi_video_dir)
 		return -ENODEV;
-	acpi_video_dir->owner = THIS_MODULE;
 
 	result = acpi_bus_register_driver(&acpi_video_bus);
 	if (result < 0) {
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 7a88dfd..e93fc8d 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1944,7 +1944,7 @@ static int stat_file_read_proc(char *page, char **start, off_t off,
 
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
 			    read_proc_t *read_proc,
-			    void *data, struct module *owner)
+			    void *data)
 {
 	int                    rv = 0;
 #ifdef CONFIG_PROC_FS
@@ -1970,7 +1970,6 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
 	} else {
 		file->data = data;
 		file->read_proc = read_proc;
-		file->owner = owner;
 
 		mutex_lock(&smi->proc_entry_lock);
 		/* Stick it on the list. */
@@ -1993,23 +1992,21 @@ static int add_proc_entries(ipmi_smi_t smi, int num)
 	smi->proc_dir = proc_mkdir(smi->proc_dir_name, proc_ipmi_root);
 	if (!smi->proc_dir)
 		rv = -ENOMEM;
-	else
-		smi->proc_dir->owner = THIS_MODULE;
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "stats",
 					     stat_file_read_proc,
-					     smi, THIS_MODULE);
+					     smi);
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "ipmb",
 					     ipmb_file_read_proc,
-					     smi, THIS_MODULE);
+					     smi);
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "version",
 					     version_file_read_proc,
-					     smi, THIS_MODULE);
+					     smi);
 #endif /* CONFIG_PROC_FS */
 
 	return rv;
@@ -4265,7 +4262,6 @@ static int ipmi_init_msghandler(void)
 	    return -ENOMEM;
 	}
 
-	proc_ipmi_root->owner = THIS_MODULE;
 #endif /* CONFIG_PROC_FS */
 
 	setup_timer(&ipmi_timer, ipmi_timeout, 0);
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 3000135..e58ea4c 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2899,7 +2899,7 @@ static int try_smi_init(struct smi_info *new_smi)
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "type",
 				     type_file_read_proc,
-				     new_smi, THIS_MODULE);
+				     new_smi);
 	if (rv) {
 		printk(KERN_ERR
 		       "ipmi_si: Unable to create proc entry: %d\n",
@@ -2909,7 +2909,7 @@ static int try_smi_init(struct smi_info *new_smi)
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "si_stats",
 				     stat_file_read_proc,
-				     new_smi, THIS_MODULE);
+				     new_smi);
 	if (rv) {
 		printk(KERN_ERR
 		       "ipmi_si: Unable to create proc entry: %d\n",
@@ -2919,7 +2919,7 @@ static int try_smi_init(struct smi_info *new_smi)
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "params",
 				     param_read_proc,
-				     new_smi, THIS_MODULE);
+				     new_smi);
 	if (rv) {
 		printk(KERN_ERR
 		       "ipmi_si: Unable to create proc entry: %d\n",
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1730d73..ec3db3a 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -903,8 +903,6 @@ static int __init input_proc_init(void)
 	if (!proc_bus_input_dir)
 		return -ENOMEM;
 
-	proc_bus_input_dir->owner = THIS_MODULE;
-
 	entry = proc_create("devices", 0, proc_bus_input_dir,
 			    &input_devices_fileops);
 	if (!entry)
diff --git a/drivers/isdn/hardware/eicon/divasi.c b/drivers/isdn/hardware/eicon/divasi.c
index f4969fe..69e71eb 100644
--- a/drivers/isdn/hardware/eicon/divasi.c
+++ b/drivers/isdn/hardware/eicon/divasi.c
@@ -118,7 +118,6 @@ static int DIVA_INIT_FUNCTION create_um_idi_proc(void)
 		return (0);
 
 	um_idi_proc_entry->read_proc = um_idi_proc_read;
-	um_idi_proc_entry->owner = THIS_MODULE;
 
 	return (1);
 }
diff --git a/drivers/media/video/cpia.c b/drivers/media/video/cpia.c
index c3b0c8c..43ab0ad 100644
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -1381,9 +1381,7 @@ static void proc_cpia_create(void)
 {
 	cpia_proc_root = proc_mkdir("cpia", NULL);
 
-	if (cpia_proc_root)
-		cpia_proc_root->owner = THIS_MODULE;
-	else
+	if (!cpia_proc_root)
 		LOG("Unable to initialise /proc/cpia\n");
 }
 
diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
index 9a36b5a..7045c45 100644
--- a/drivers/message/i2o/i2o_proc.c
+++ b/drivers/message/i2o/i2o_proc.c
@@ -2037,8 +2037,6 @@ static int __init i2o_proc_fs_create(void)
 	if (!i2o_proc_dir_root)
 		return -1;
 
-	i2o_proc_dir_root->owner = THIS_MODULE;
-
 	list_for_each_entry(c, &i2o_controllers, list)
 	    i2o_proc_iop_add(i2o_proc_dir_root, c);
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9fb3883..290f2c5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3435,25 +3435,12 @@ static void bond_remove_proc_entry(struct bonding *bond)
  */
 static void bond_create_proc_dir(void)
 {
-	int len = strlen(DRV_NAME);
-
-	for (bond_proc_dir = init_net.proc_net->subdir; bond_proc_dir;
-	     bond_proc_dir = bond_proc_dir->next) {
-		if ((bond_proc_dir->namelen == len) &&
-		    !memcmp(bond_proc_dir->name, DRV_NAME, len)) {
-			break;
-		}
-	}
-
 	if (!bond_proc_dir) {
 		bond_proc_dir = proc_mkdir(DRV_NAME, init_net.proc_net);
-		if (bond_proc_dir) {
-			bond_proc_dir->owner = THIS_MODULE;
-		} else {
+		if (!bond_proc_dir)
 			printk(KERN_WARNING DRV_NAME
 				": Warning: cannot create /proc/net/%s\n",
 				DRV_NAME);
-		}
 	}
 }
 
@@ -3462,25 +3449,7 @@ static void bond_create_proc_dir(void)
  */
 static void bond_destroy_proc_dir(void)
 {
-	struct proc_dir_entry *de;
-
-	if (!bond_proc_dir) {
-		return;
-	}
-
-	/* verify that the /proc dir is empty */
-	for (de = bond_proc_dir->subdir; de; de = de->next) {
-		/* ignore . and .. */
-		if (*(de->name) != '.') {
-			break;
-		}
-	}
-
-	if (de) {
-		if (bond_proc_dir->owner == THIS_MODULE) {
-			bond_proc_dir->owner = NULL;
-		}
-	} else {
+	if (bond_proc_dir) {
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
 		bond_proc_dir = NULL;
 	}
diff --git a/drivers/net/irda/vlsi_ir.c b/drivers/net/irda/vlsi_ir.c
index 723c458..95c791a 100644
--- a/drivers/net/irda/vlsi_ir.c
+++ b/drivers/net/irda/vlsi_ir.c
@@ -1867,13 +1867,6 @@ static int __init vlsi_mod_init(void)
 	 * without procfs - it's not required for the driver to work.
 	 */
 	vlsi_proc_root = proc_mkdir(PROC_DIR, NULL);
-	if (vlsi_proc_root) {
-		/* protect registered procdir against module removal.
-		 * Because we are in the module init path there's no race
-		 * window after create_proc_entry (and no barrier needed).
-		 */
-		vlsi_proc_root->owner = THIS_MODULE;
-	}
 
 	ret = pci_register_driver(&vlsi_irda_driver);
 
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index fc4322c..37765ac 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4428,7 +4428,6 @@ static int setup_proc_entry( struct net_device *dev,
 		goto fail;
 	apriv->proc_entry->uid = proc_uid;
 	apriv->proc_entry->gid = proc_gid;
-	apriv->proc_entry->owner = THIS_MODULE;
 
 	/* Setup the StatsDelta */
 	entry = proc_create_data("StatsDelta",
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index 1e74988..9e1ce02 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -975,7 +975,6 @@ asus_proc_add(char *name, proc_writefunc *writefunc,
 	proc->write_proc = writefunc;
 	proc->read_proc = readfunc;
 	proc->data = acpi_driver_data(device);
-	proc->owner = THIS_MODULE;
 	proc->uid = asus_uid;
 	proc->gid = asus_gid;
 	return 0;
@@ -1008,7 +1007,6 @@ static int asus_hotk_add_fs(struct acpi_device *device)
 	if (proc) {
 		proc->read_proc = proc_read_info;
 		proc->data = acpi_driver_data(device);
-		proc->owner = THIS_MODULE;
 		proc->uid = asus_uid;
 		proc->gid = asus_gid;
 	} else {
@@ -1422,7 +1420,6 @@ static int __init asus_acpi_init(void)
 		printk(KERN_ERR "Asus ACPI: Unable to create /proc entry\n");
 		return -ENODEV;
 	}
-	asus_proc_dir->owner = THIS_MODULE;
 
 	result = acpi_bus_register_driver(&asus_hotk_driver);
 	if (result < 0) {
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index bcbc051..c30f38a 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6992,7 +6992,6 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 			ret = -ENODEV;
 			goto err_out;
 		}
-		entry->owner = THIS_MODULE;
 		entry->data = ibm;
 		entry->read_proc = &dispatch_procfs_read;
 		if (ibm->write)
@@ -7405,7 +7404,6 @@ static int __init thinkpad_acpi_module_init(void)
 		thinkpad_acpi_module_exit();
 		return -ENODEV;
 	}
-	proc_dir->owner = THIS_MODULE;
 
 	ret = platform_driver_register(&tpacpi_pdriver);
 	if (ret) {
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 40e60fc..9f18726 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -679,8 +679,6 @@ static acpi_status __init add_device(void)
 					      toshiba_proc_dir,
 					      (read_proc_t *) dispatch_read,
 					      item);
-		if (proc)
-			proc->owner = THIS_MODULE;
 		if (proc && item->write_func)
 			proc->write_proc = (write_proc_t *) dispatch_write;
 	}
@@ -772,7 +770,6 @@ static int __init toshiba_acpi_init(void)
 		toshiba_acpi_exit();
 		return -ENODEV;
 	} else {
-		toshiba_proc_dir->owner = THIS_MODULE;
 		status = add_device();
 		if (ACPI_FAILURE(status)) {
 			toshiba_acpi_exit();
diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index 0c6257a..c086fc3 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -105,14 +105,8 @@ static const struct file_operations rtc_proc_fops = {
 
 void rtc_proc_add_device(struct rtc_device *rtc)
 {
-	if (rtc->id == 0) {
-		struct proc_dir_entry *ent;
-
-		ent = proc_create_data("driver/rtc", 0, NULL,
-				       &rtc_proc_fops, rtc);
-		if (ent)
-			ent->owner = rtc->owner;
-	}
+	if (rtc->id == 0)
+		proc_create_data("driver/rtc", 0, NULL, &rtc_proc_fops, rtc);
 }
 
 void rtc_proc_del_device(struct rtc_device *rtc)
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 099b545..b134813 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -596,8 +596,6 @@ int __init scsi_init_devinfo(void)
 		error = -ENOMEM;
 		goto out;
 	}
-
-	p->owner = THIS_MODULE;
 #endif /* CONFIG_SCSI_PROC_FS */
 
  out:
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 82f7b2d..77fbddb 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -115,8 +115,6 @@ void scsi_proc_hostdir_add(struct scsi_host_template *sht)
         	if (!sht->proc_dir)
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
 			       __func__, sht->proc_name);
-		else
-			sht->proc_dir->owner = sht->module;
 	}
 	mutex_unlock(&global_host_template_mutex);
 }
@@ -163,7 +161,6 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 	} 
 
 	p->write_proc = proc_scsi_write_proc;
-	p->owner = sht->module;
 }
 
 /**
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 37b433a..e327b84 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -2059,25 +2059,21 @@ static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
 	if (viafb_entry) {
 		entry = create_proc_entry("dvp0", 0, *viafb_entry);
 		if (entry) {
-			entry->owner = THIS_MODULE;
 			entry->read_proc = viafb_dvp0_proc_read;
 			entry->write_proc = viafb_dvp0_proc_write;
 		}
 		entry = create_proc_entry("dvp1", 0, *viafb_entry);
 		if (entry) {
-			entry->owner = THIS_MODULE;
 			entry->read_proc = viafb_dvp1_proc_read;
 			entry->write_proc = viafb_dvp1_proc_write;
 		}
 		entry = create_proc_entry("dfph", 0, *viafb_entry);
 		if (entry) {
-			entry->owner = THIS_MODULE;
 			entry->read_proc = viafb_dfph_proc_read;
 			entry->write_proc = viafb_dfph_proc_write;
 		}
 		entry = create_proc_entry("dfpl", 0, *viafb_entry);
 		if (entry) {
-			entry->owner = THIS_MODULE;
 			entry->read_proc = viafb_dfpl_proc_read;
 			entry->write_proc = viafb_dfpl_proc_write;
 		}
@@ -2086,7 +2082,6 @@ static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
 		    viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name) {
 			entry = create_proc_entry("vt1636", 0, *viafb_entry);
 			if (entry) {
-				entry->owner = THIS_MODULE;
 				entry->read_proc = viafb_vt1636_proc_read;
 				entry->write_proc = viafb_vt1636_proc_write;
 			}
diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 7578c1a..8630615 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -146,7 +146,6 @@ int afs_proc_init(void)
 	proc_afs = proc_mkdir("fs/afs", NULL);
 	if (!proc_afs)
 		goto error_dir;
-	proc_afs->owner = THIS_MODULE;
 
 	p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
 	if (!p)
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 490e34b..949c36e 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -402,7 +402,6 @@ cifs_proc_init(void)
 	if (proc_fs_cifs == NULL)
 		return;
 
-	proc_fs_cifs->owner = THIS_MODULE;
 	proc_create("DebugData", 0, proc_fs_cifs, &cifs_debug_data_proc_fops);
 
 #ifdef CONFIG_CIFS_STATS
diff --git a/fs/jfs/jfs_debug.c b/fs/jfs/jfs_debug.c
index 6a73de8..dd824d9 100644
--- a/fs/jfs/jfs_debug.c
+++ b/fs/jfs/jfs_debug.c
@@ -90,7 +90,6 @@ void jfs_proc_init(void)
 
 	if (!(base = proc_mkdir("fs/jfs", NULL)))
 		return;
-	base->owner = THIS_MODULE;
 
 	for (i = 0; i < NPROCENT; i++)
 		proc_create(Entries[i].name, 0, base, Entries[i].proc_fops);
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 9b728f3..5ca8d35 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1535,8 +1535,6 @@ int __init nfs_fs_proc_init(void)
 	if (!proc_fs_nfs)
 		goto error_0;
 
-	proc_fs_nfs->owner = THIS_MODULE;
-
 	/* a file of servers with which we're dealing */
 	p = proc_create("servers", S_IFREG|S_IRUGO,
 			proc_fs_nfs, &nfs_server_list_fops);
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7a55346..5660b9c 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -58,11 +58,8 @@ static void proc_delete_inode(struct inode *inode)
 
 	/* Let go of any associated proc directory entry */
 	de = PROC_I(inode)->pde;
-	if (de) {
-		if (de->owner)
-			module_put(de->owner);
+	if (de)
 		de_put(de);
-	}
 	if (PROC_I(inode)->sysctl)
 		sysctl_head_put(PROC_I(inode)->sysctl);
 	clear_inode(inode);
@@ -449,12 +446,9 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 {
 	struct inode * inode;
 
-	if (!try_module_get(de->owner))
-		goto out_mod;
-
 	inode = iget_locked(sb, ino);
 	if (!inode)
-		goto out_ino;
+		return NULL;
 	if (inode->i_state & I_NEW) {
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->fd = 0;
@@ -485,14 +479,8 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 			}
 		}
 		unlock_new_inode(inode);
-	} else
-	       module_put(de->owner);
+	}
 	return inode;
-
-out_ino:
-	module_put(de->owner);
-out_mod:
-	return NULL;
 }			
 
 int proc_fill_super(struct super_block *s)
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index d153946..4a9e0f6 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -152,7 +152,6 @@ void proc_tty_register_driver(struct tty_driver *driver)
 	if (!ent)
 		return;
 	ent->read_proc = driver->ops->read_proc;
-	ent->owner = driver->owner;
 	ent->data = driver;
 
 	driver->proc_entry = ent;
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 37173fa..d79a913 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -492,7 +492,6 @@ int reiserfs_proc_info_init(struct super_block *sb)
 	spin_lock_init(&__PINFO(sb).lock);
 	REISERFS_SB(sb)->procdir = proc_mkdir(b, proc_info_root);
 	if (REISERFS_SB(sb)->procdir) {
-		REISERFS_SB(sb)->procdir->owner = THIS_MODULE;
 		REISERFS_SB(sb)->procdir->data = sb;
 		add_file(sb, "version", show_version);
 		add_file(sb, "super", show_super);
@@ -556,9 +555,7 @@ int reiserfs_proc_info_global_init(void)
 {
 	if (proc_info_root == NULL) {
 		proc_info_root = proc_mkdir(proc_info_root_name, NULL);
-		if (proc_info_root) {
-			proc_info_root->owner = THIS_MODULE;
-		} else {
+		if (!proc_info_root) {
 			reiserfs_warning(NULL,
 					 "reiserfs: cannot create /proc/%s",
 					 proc_info_root_name);
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index 62b7366..f7c9c75 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -230,6 +230,6 @@ static inline void ipmi_free_smi_msg(struct ipmi_smi_msg *msg)
    automatically be dstroyed when the interface is destroyed. */
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
 			    read_proc_t *read_proc,
-			    void *data, struct module *owner);
+			    void *data);
 
 #endif /* __LINUX_IPMI_SMI_H */
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 4f13811..d7c76e8 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -41,9 +41,6 @@ enum {
  * while parent/subdir create the directory structure (every
  * /proc file has a parent, but "subdir" is NULL for all
  * non-directory entries).
- *
- * "owner" is used to protect module
- * from unloading while proc_dir_entry is in use
  */
 
 typedef	int (read_proc_t)(char *page, char **start, off_t off,
@@ -70,7 +67,6 @@ struct proc_dir_entry {
 	 * somewhere.
 	 */
 	const struct file_operations *proc_fops;
-	struct module *owner;
 	struct proc_dir_entry *next, *parent, *subdir;
 	void *data;
 	read_proc_t *read_proc;
diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index 162199a..fd8e084 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -281,7 +281,6 @@ int __init atalk_proc_init(void)
 	atalk_proc_dir = proc_mkdir("atalk", init_net.proc_net);
 	if (!atalk_proc_dir)
 		goto out;
-	atalk_proc_dir->owner = THIS_MODULE;
 
 	p = proc_create("interface", S_IRUGO, atalk_proc_dir,
 			&atalk_seq_interface_fops);
diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 4990541..1a0f5cc 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -281,7 +281,6 @@ int mpc_proc_init(void)
 		printk(KERN_ERR "Unable to initialize /proc/atm/%s\n", STAT_FILE_NAME);
 		return -ENOMEM;
 	}
-	p->owner = THIS_MODULE;
 	return 0;
 }
 
diff --git a/net/atm/proc.c b/net/atm/proc.c
index 49487b3..e7b3b27 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -476,7 +476,6 @@ int __init atm_proc_init(void)
 				     atm_proc_root, e->proc_fops);
 		if (!dirent)
 			goto err_out_remove;
-		dirent->owner = THIS_MODULE;
 		e->dirent = dirent;
 	}
 	ret = 0;
diff --git a/net/can/bcm.c b/net/can/bcm.c
index b7c7d46..95d7f32 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1604,10 +1604,6 @@ static int __init bcm_module_init(void)
 
 	/* create /proc/net/can-bcm directory */
 	proc_dir = proc_mkdir("can-bcm", init_net.proc_net);
-
-	if (proc_dir)
-		proc_dir->owner = THIS_MODULE;
-
 	return 0;
 }
 
diff --git a/net/can/proc.c b/net/can/proc.c
index 520fef5..1463653 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -473,8 +473,6 @@ void can_init_proc(void)
 		return;
 	}
 
-	can_dir->owner = THIS_MODULE;
-
 	/* own procfs entries from the AF_CAN core */
 	pde_version     = can_create_proc_readentry(CAN_PROC_VERSION, 0644,
 					can_proc_read_version, NULL);
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 6549848..85eb240 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3812,7 +3812,6 @@ static int __init pg_init(void)
 	pg_proc_dir = proc_mkdir(PG_PROC_DIR, init_net.proc_net);
 	if (!pg_proc_dir)
 		return -ENODEV;
-	pg_proc_dir->owner = THIS_MODULE;
 
 	pe = proc_create(PGCTRL, 0600, pg_proc_dir, &pktgen_fops);
 	if (pe == NULL) {
diff --git a/net/irda/irproc.c b/net/irda/irproc.c
index 88e80a3..8ff1861 100644
--- a/net/irda/irproc.c
+++ b/net/irda/irproc.c
@@ -70,7 +70,6 @@ void __init irda_proc_register(void)
 	proc_irda = proc_mkdir("irda", init_net.proc_net);
 	if (proc_irda == NULL)
 		return;
-	proc_irda->owner = THIS_MODULE;
 
 	for (i = 0; i < ARRAY_SIZE(irda_dirs); i++)
 		d = proc_create(irda_dirs[i].name, 0, proc_irda,
diff --git a/net/llc/llc_proc.c b/net/llc/llc_proc.c
index b58bd7c..d208b33 100644
--- a/net/llc/llc_proc.c
+++ b/net/llc/llc_proc.c
@@ -236,7 +236,6 @@ int __init llc_proc_init(void)
 	llc_proc_dir = proc_mkdir("llc", init_net.proc_net);
 	if (!llc_proc_dir)
 		goto out;
-	llc_proc_dir->owner = THIS_MODULE;
 
 	p = proc_create("socket", S_IRUGO, llc_proc_dir, &llc_seq_socket_fops);
 	if (!p)
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index b78e3be..f571338 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -106,12 +106,8 @@ static __init int sctp_proc_init(void)
 		goto out_nomem;
 #ifdef CONFIG_PROC_FS
 	if (!proc_net_sctp) {
-		struct proc_dir_entry *ent;
-		ent = proc_mkdir("sctp", init_net.proc_net);
-		if (ent) {
-			ent->owner = THIS_MODULE;
-			proc_net_sctp = ent;
-		} else
+		proc_net_sctp = proc_mkdir("sctp", init_net.proc_net);
+		if (!proc_net_sctp)
 			goto out_free_percpu;
 	}
 
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 4735caa..20029a7 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -313,7 +313,6 @@ static int create_cache_proc_entries(struct cache_detail *cd)
 	cd->proc_ent = proc_mkdir(cd->name, proc_net_rpc);
 	if (cd->proc_ent == NULL)
 		goto out_nomem;
-	cd->proc_ent->owner = cd->owner;
 	cd->channel_ent = cd->content_ent = NULL;
 
 	p = proc_create_data("flush", S_IFREG|S_IRUSR|S_IWUSR,
@@ -321,7 +320,6 @@ static int create_cache_proc_entries(struct cache_detail *cd)
 	cd->flush_ent = p;
 	if (p == NULL)
 		goto out_nomem;
-	p->owner = cd->owner;
 
 	if (cd->cache_request || cd->cache_parse) {
 		p = proc_create_data("channel", S_IFREG|S_IRUSR|S_IWUSR,
@@ -329,7 +327,6 @@ static int create_cache_proc_entries(struct cache_detail *cd)
 		cd->channel_ent = p;
 		if (p == NULL)
 			goto out_nomem;
-		p->owner = cd->owner;
 	}
 	if (cd->cache_show) {
 		p = proc_create_data("content", S_IFREG|S_IRUSR|S_IWUSR,
@@ -337,7 +334,6 @@ static int create_cache_proc_entries(struct cache_detail *cd)
 		cd->content_ent = p;
 		if (p == NULL)
 			goto out_nomem;
-		p->owner = cd->owner;
 	}
 	return 0;
 out_nomem:
diff --git a/net/sunrpc/stats.c b/net/sunrpc/stats.c
index 085372e..1ef6e46 100644
--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -262,14 +262,8 @@ void
 rpc_proc_init(void)
 {
 	dprintk("RPC:       registering /proc/net/rpc\n");
-	if (!proc_net_rpc) {
-		struct proc_dir_entry *ent;
-		ent = proc_mkdir("rpc", init_net.proc_net);
-		if (ent) {
-			ent->owner = THIS_MODULE;
-			proc_net_rpc = ent;
-		}
-	}
+	if (!proc_net_rpc)
+		proc_net_rpc = proc_mkdir("rpc", init_net.proc_net);
 }
 
 void
diff --git a/sound/core/info.c b/sound/core/info.c
index 70fa871..35df614 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -154,11 +154,6 @@ EXPORT_SYMBOL(snd_seq_root);
 struct snd_info_entry *snd_oss_root;
 #endif
 
-static inline void snd_info_entry_prepare(struct proc_dir_entry *de)
-{
-	de->owner = THIS_MODULE;
-}
-
 static void snd_remove_proc_entry(struct proc_dir_entry *parent,
 				  struct proc_dir_entry *de)
 {
@@ -522,32 +517,11 @@ static const struct file_operations snd_info_entry_operations =
 	.release =		snd_info_entry_release,
 };
 
-/**
- * snd_create_proc_entry - create a procfs entry
- * @name: the name of the proc file
- * @mode: the file permission bits, S_Ixxx
- * @parent: the parent proc-directory entry
- *
- * Creates a new proc file entry with the given name and permission
- * on the given directory.
- *
- * Returns the pointer of new instance or NULL on failure.
- */
-static struct proc_dir_entry *snd_create_proc_entry(const char *name, mode_t mode,
-						    struct proc_dir_entry *parent)
-{
-	struct proc_dir_entry *p;
-	p = create_proc_entry(name, mode, parent);
-	if (p)
-		snd_info_entry_prepare(p);
-	return p;
-}
-
 int __init snd_info_init(void)
 {
 	struct proc_dir_entry *p;
 
-	p = snd_create_proc_entry("asound", S_IFDIR | S_IRUGO | S_IXUGO, NULL);
+	p = create_proc_entry("asound", S_IFDIR | S_IRUGO | S_IXUGO, NULL);
 	if (p == NULL)
 		return -ENOMEM;
 	snd_proc_root = p;
@@ -974,12 +948,11 @@ int snd_info_register(struct snd_info_entry * entry)
 		return -ENXIO;
 	root = entry->parent == NULL ? snd_proc_root : entry->parent->p;
 	mutex_lock(&info_mutex);
-	p = snd_create_proc_entry(entry->name, entry->mode, root);
+	p = create_proc_entry(entry->name, entry->mode, root);
 	if (!p) {
 		mutex_unlock(&info_mutex);
 		return -ENOMEM;
 	}
-	p->owner = entry->module;
 	if (!S_ISDIR(entry->mode))
 		p->proc_fops = &snd_info_entry_operations;
 	p->size = entry->size;
-- 
1.5.6.5

