Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYATMVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYATMVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 07:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYATMVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 07:21:10 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46744 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYATMVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 07:21:09 -0500
To: jengelh@computergmbh.de
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
In-reply-to: <Pine.LNX.4.64.0801201207360.14598@fbirervta.pbzchgretzou.qr>
	(message from Jan Engelhardt on Sun, 20 Jan 2008 12:20:02 +0100 (CET))
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0801201207360.14598@fbirervta.pbzchgretzou.qr>
Message-Id: <E1JGZAZ-000414-Jz@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 20 Jan 2008 13:20:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Jan 19 2008 12:05, Miklos Szeredi wrote:
> >+
> >+/*
> >+ * Write full pathname from the root of the filesystem into the buffer.
> >+ */
> >+char *dentry_path(struct dentry *dentry, char *buf, int buflen)
> 
> Hm, this functions looks very much like __d_path(). Is it
> an unintentional copy?

It is similar, but there is a significant difference: __d_path() shows
the path relative to the current process's root (possibly crossing
mount points), while dentry_path() shows the path relative to the
_filesystem's_ root (ignoring mount points, and current root).

> >@@ -601,28 +635,29 @@ static inline void mangle(struct seq_fil
> > 	seq_escape(m, s, " \t\n\\");
> > }
> > 
> >+static struct proc_fs_info {
> 
> These do not seem to be static data. Please mark them as const.
> 
> static const struct proc_fs_info.

OK.

> >+	int flag;
> >+	char *str;
> 
> const char *str.

OK.

> >+	seq_putc(m, ' ');
> >+	seq_puts(m, sb->s_flags & MS_RDONLY ? "ro" : "rw");
> >+	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
> >+		if (sb->s_flags & fs_infop->flag)
> >+			seq_puts(m, fs_infop->str);
> >+	}
> 
> {} could go.

The former is more readable, I think.  My rule is: surround anything
with {} if it's more than one line, even if not strictly necessary.
This is especially true for nested if/else statements, but makes sense
for 'for' as well.

> >+	if (sb->s_op->show_options)
> >+		err = sb->s_op->show_options(m, mnt);
> >+	if (IS_MNT_SHARED(mnt)) {
> >+		seq_printf(m, " shared:%i", get_peer_group_id(mnt));
> >+		if (IS_MNT_SLAVE(mnt))
> >+			seq_printf(m, ",slave:%i", get_master_id(mnt));
> >+	} else if (IS_MNT_SLAVE(mnt)) {
> >+		seq_printf(m, " slave:%i", get_master_id(mnt));
> >+	} else if (IS_MNT_UNBINDABLE(mnt)) {
> >+		seq_printf(m, " unbindable");
> >+	} else {
> >+		seq_printf(m, " private");
> >+	}
> >+	seq_putc(m, '\n');
> >+	return err;
> >+}
> >+
> >+struct seq_operations mountinfo_op = {
> I think this can go const.

OK

> >--- linux.orig/include/linux/mount.h	2008-01-18 19:21:38.000000000 +0100
> >+++ linux/include/linux/mount.h	2008-01-18 23:39:35.000000000 +0100
> >@@ -56,6 +56,7 @@ struct vfsmount {
> > 	struct list_head mnt_slave;	/* slave list entry */
> > 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
> > 	struct mnt_namespace *mnt_ns;	/* containing namespace */
> >+	int mnt_id;			/* mount identifier */
> > 	/*
> > 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
> > 	 * to let these frequently modified fields in a separate cache line
> 
> Should/could it be unsigned int, or does it need to store -1?

IDA returns int, so why change it?  Going over 2^31 number of mounts
doesn't seem likely in the near future.

Thanks,
Miklos
