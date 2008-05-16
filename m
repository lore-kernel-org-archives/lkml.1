Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbYEPXL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbYEPXL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbYEPXLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:11:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14286 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbYEPXLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:11:47 -0400
Date: Fri, 16 May 2008 16:11:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.25: access permission filesystem 0.21
Message-Id: <20080516161116.37774c5e.randy.dunlap@oracle.com>
In-Reply-To: <873aon44sr.fsf@rat.lan>
References: <873aon44sr.fsf@rat.lan>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 22:59:32 +0200 Olaf Dietsche wrote:

> This patch adds a new permission managing file system.
> Furthermore, it adds two modules, which make use of this file system.


(attachment fragments copied as needed for comments:)

fs/accessfs/Kconfig:

+config ACCESSFS_USER_PORTS
+	tristate "User permission based IP ports"
+	depends on ACCESS_FS
+	select NET_HOOKS
+	default n
+	help
+	  If you say Y here, you will be able to control access to IP ports
+	  based on user-/groupid. For this to work, you must say Y
+	  to CONFIG_NET_HOOKS.
+
+	  If you're unsure, say N.

Just spell out userid instead of using "user-".  The hyphen is only
saving one character, so just make it clearer by spelling it out.
(Several instances of this, including in the Documentation.)

This config option should probably also depend on INET since
it selects NET_HOOKS and NET_HOOKS depends on INET (and since
select won't follow any dependency chain).

+config ACCESSFS_IGNORE_NET_BIND_SERVICE
+	bool "Ignore CAP_NET_BIND_SERVICE capability"
+	depends on ACCESSFS_USER_PORTS
+	default n
+	help
+	  This option lets you decide, wether a user with 

                                       whether

Oh.  That line ends with a space.  Please check all Kconfig and
source file lines to make sure that they do not end with whitespace.

+	  CAP_NET_BIND_SERVICE capability is able to override
+	  your userport configuration.
+
+	  If you build this as a module, you can specify this
+	  option at module load time (ignore_net_bind_service).
+
+	  If you're unsure, say n.


Have the networking people commented on the NET_HOOKS and their
function methods?


inode.c:

+static inline void accessfs_readdir_aux(struct file *filp,
+					struct accessfs_direntry *dir,
+					int start, void *dirent,
+					filldir_t filldir)

is rather large to be inlined.  Why do that?

+int accessfs_register(struct accessfs_direntry *dir, const char *name,
+		      struct access_attr *attr)
+{
+	int err;
+	if (dir == 0)
+		return -EINVAL;

Don't check for 0, check for NULL (when it's a pointer being tested).
So use either
	if (dir == NULL)
or
	if (!dir)

(several of these seen)

+static int __init init_accessfs_fs(void)
+{
+
+	/* create mount point for accessfs */
+	mountdir = proc_mkdir("access",&proc_root);

space after comma.

+	return register_filesystem(&accessfs_fs_type);
+}
+
+static void __exit exit_accessfs_fs(void)
+{
+	unregister_filesystem(&accessfs_fs_type);
+	remove_proc_entry("access",&proc_root);

ditto.

+}


ip.c:

+	bind_to_port = kmalloc(max_prot_sock * sizeof(*bind_to_port),
+			       GFP_KERNEL);
+	if (bind_to_port == 0)
+		return -ENOMEM;

Test pointer for NULL or use !bind_to_port.

+static void __exit exit_ip(void)
+{
+	struct accessfs_direntry *dir = accessfs_make_dirpath("net/ip/bind");
+	int i;
+	net_hooks_unregister(&ip_net_ops);
+	for (i = 1; i < max_prot_sock; ++i) {
+		char	buf[sizeof("65536")];

			buf[sizeof("65536") + 1]; ???

+		sprintf(buf, "%d", i);
+		accessfs_unregister(dir, buf);
+	}


Documentation/filesystems/accessfs.txt:

Change "user-/" to "userid/".

---
~Randy
