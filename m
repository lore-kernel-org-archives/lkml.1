Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab0BCDEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:04:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49118 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab0BCDEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:04:21 -0500
Date: Wed, 3 Feb 2010 03:04:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100203030419.GA30031@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
 <20100201231847.GC12882@ZenIV.linux.org.uk>
 <20100202010653.GD12882@ZenIV.linux.org.uk>
 <m1k4uwfag1.fsf@fess.ebiederm.org>
 <20100202170157.GH12882@ZenIV.linux.org.uk>
 <m1y6jbo36v.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6jbo36v.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 11:19:52AM -0800, Eric W. Biederman wrote:

> If we are going to take a lock this seems as sane as any.
> 
> Do we want to honor oops_in_progress aka bust_spinlocks here?
> 
> Perhaps just:
> if (oops_in_progress)
> 	return buf;
> 
> To guarantee we get the rest of a panic message out of the kernel.

Hmm...   There's another fun issue - we would want local_irq_disable() /
local_irq_enable() in d_move_locked and local_irq_save/local_irq_restore()
in dname_string(), AFAICT.

OK, here's what I've got from moving in that direction.  Folks, how does
that one look to you?  I'm not too happy about explicit manipulations
with irq flags in there, so any suggestions would be welcome.

AFAICS, that should be enough to make the damn thing safe to use in any
context outside of d_move_locked() itself...

diff --git a/fs/dcache.c b/fs/dcache.c
index 953173a..cd9fc0b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1636,6 +1636,7 @@ static void d_move_locked(struct dentry * dentry, struct dentry * target)
 	if (!dentry->d_inode)
 		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
 
+	local_irq_disable();
 	write_seqlock(&rename_lock);
 	/*
 	 * XXXX: do we really need to take target->d_lock?
@@ -1685,6 +1686,7 @@ already_unhashed:
 	fsnotify_d_move(dentry);
 	spin_unlock(&dentry->d_lock);
 	write_sequnlock(&rename_lock);
+	local_irq_enable();
 }
 
 /**
@@ -1703,6 +1705,57 @@ void d_move(struct dentry * dentry, struct dentry * target)
 	spin_unlock(&dcache_lock);
 }
 
+/*
+ * for vsprintf use only.
+ */
+char *dname_string(char *buf, char *end, struct dentry *d,
+		   int precision, int width, int left_align)
+{
+	int len, i;
+	const unsigned char *s;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (!write_tryseqlock(&rename_lock)) {
+		if (oops_in_progress) {
+			local_irq_restore(flags);
+			return buf;
+		}
+		write_seqlock(&rename_lock);
+	}
+	if (precision > d->d_name.len)
+		precision = d->d_name.len;
+
+	s = d->d_name.name;
+	if ((unsigned long)s < PAGE_SIZE)
+		s = "(null)";
+
+	len = strnlen(s, precision);
+
+	if (!left_align) {
+		while (len < width--) {
+			if (buf < end)
+				*buf = ' ';
+			++buf;
+		}
+	}
+	for (i = 0; i < len; ++i) {
+		if (buf < end)
+			*buf = *s;
+		++buf; ++s;
+	}
+
+	while (len < width--) {
+		if (buf < end)
+			*buf = ' ';
+		++buf;
+	}
+
+	write_sequnlock(&rename_lock);
+	local_irq_restore(flags);
+	return buf;
+}
+
 /**
  * d_ancestor - search for an ancestor
  * @p1: ancestor dentry
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 30b93b2..2dc286a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -379,5 +379,6 @@ extern struct vfsmount *lookup_mnt(struct path *);
 extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
 
 extern int sysctl_vfs_cache_pressure;
+extern char *dname_string(char *, char *, struct dentry *, int, int, int);
 
 #endif	/* __LINUX_DCACHE_H */
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b8aeec..918edea 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -915,6 +915,7 @@ static char *uuid_string(char *buf, char *end, const u8 *addr,
  *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
  *           little endian output byte order is:
  *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
+ * - 'd' For dentry name.
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -958,6 +959,9 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		break;
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
+	case 'd':
+		return dname_string(buf, end, ptr, spec.precision,
+				    spec.field_width, spec.flags & LEFT);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
@@ -1191,6 +1195,7 @@ qualifier:
  *   http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %pd print dentry name
  * %n is ignored
  *
  * The return value is the number of characters which would
