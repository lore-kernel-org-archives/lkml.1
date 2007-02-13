Return-Path: <linux-kernel-owner+w=401wt.eu-S1030626AbXBMGgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030626AbXBMGgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 01:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030653AbXBMGgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 01:36:25 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56405 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030626AbXBMGgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 01:36:25 -0500
Date: Mon, 12 Feb 2007 22:35:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Dobriyan <adobriyan@openvz.org>, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, duncan.sands@math.u-psud.fr
Subject: Re: [PATCH v4] Fix rmmod/read/write races in /proc entries
Message-Id: <20070212223552.59d733b1.akpm@linux-foundation.org>
In-Reply-To: <20070211202330.GA24509@martell.zuzino.mipt.ru>
References: <20070208132012.GA6041@localhost.sw.ru>
	<20070209010037.7f4393c5.akpm@linux-foundation.org>
	<20070211202330.GA24509@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007 23:23:30 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> [PATCH v4] Fix rmmod/read/write races in /proc entries

This:

static ssize_t
proc_file_write(struct file *file, const char __user *buffer,
		size_t count, loff_t *ppos)
{
	struct inode *inode = file->f_path.dentry->d_inode;
	struct proc_dir_entry * dp;
	ssize_t rv = -EIO;
	
	dp = PDE(inode);

	if (!dp->write_proc)
		goto out;

	spin_lock(&dp->pde_unload_lock);
	if (!dp->proc_fops)
		/*
		 * remove_proc_entry() marked PDE as "going away".
		 * No new writers allowed.
		 */
		goto out_unlock;

versus

		spin_lock(&de->pde_unload_lock);
		/*
		 * Stop accepting new readers/writers. If you're dynamically
		 * allocating ->proc_fops, save a pointer somewhere.
		 */
		de->proc_fops = NULL;
		/* Wait until all existing readers/writers are done. */
		if (de->pde_users > 0) {
			struct completion c;

			init_completion(&c);
			if (!de->pde_unload_completion)
				de->pde_unload_completion = &c;

			spin_unlock(&de->pde_unload_lock);
			spin_unlock(&proc_subdir_lock);

			wait_for_completion(de->pde_unload_completion);

			spin_lock(&proc_subdir_lock);
			goto continue_removing;
		}
		spin_unlock(&de->pde_unload_lock);
  <here>
	...
	<free de>

What prevents proc_file_write() from looking up and playing with this de in
<here>?


Also... lockdep wants this:

--- a/fs/proc/generic.c~fix-rmmod-read-write-races-in-proc-entries-fix
+++ a/fs/proc/generic.c
@@ -790,9 +790,8 @@ void remove_proc_entry(const char *name,
 		de->proc_fops = NULL;
 		/* Wait until all existing readers/writers are done. */
 		if (de->pde_users > 0) {
-			struct completion c;
+			DECLARE_COMPLETION_ONSTACK(c);
 
-			init_completion(&c);
 			if (!de->pde_unload_completion)
 				de->pde_unload_completion = &c;
 
_

