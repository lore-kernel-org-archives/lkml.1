Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0BBRCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:02:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36522 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab0BBRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:02:08 -0500
Date: Tue, 2 Feb 2010 17:01:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100202170157.GH12882@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
 <20100201231847.GC12882@ZenIV.linux.org.uk>
 <20100202010653.GD12882@ZenIV.linux.org.uk>
 <m1k4uwfag1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k4uwfag1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 09:55:42PM -0800, Eric W. Biederman wrote:

> We already have rename_lock, which is only take for write in d_move_locked.
> 
> I wonder if there is an instruction sequence that could guarantee that the
> string copy is done atomically from the perspective of another cpu,
> d_iname fits nicely on a single cache line so it should be possible.  
> 
> That is a stronger guarantee than we need.   All we really need is the
> guarantee that a reader will see the string null terminator.  dentries already
> have rcu safe lifetimes.
> 
> Hmm.
> 
> We should be able to do:
>         struct qstr *name;
>         int len;
>         char buf[MAX_LEN + 1];
>         long seq;
> 
>         do {
> 		seq = read_seqbegin(&rename_lock);
>         	rcu_read_lock();
> 	        name = rcu_dereference(dentry->d_name.name);
> 	        len = dentry->d_name.len;
>                 if (read_seqretry(&rename_lock, seq)
>                 	continue;
> 	        if (len > MAX_LEN)
> 	        	len = MAX_LEN;
> 		memcpy(buf, name, len);
> 	        buf[len] = '\0';
> 	        rcu_read_unlock();
> 	} while (read_seqretry(&rename_lock, seq));

Actually, WTF do we bother?  seqlock writer grabs embedded spinlock.
So can we, since *that* is far more narrow than ->d_lock and it's
static, so it's not like somebody outside of dcache.c can decide
to grab.

We could just inline string() into dname_string() and take the entire
thing to fs/dcache.c.  And protect it either with direct locking
of rename_lock.lock or another seq_writelock; contention is not
an issue, since if printk guts are your hotpath you are already
FUBAR.

Something like that (completely untested):

diff --git a/fs/dcache.c b/fs/dcache.c
index 953173a..a4d30bc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1703,6 +1703,48 @@ void d_move(struct dentry * dentry, struct dentry * target)
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
+
+	write_seqlock(&rename_lock);
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
index 3b8aeec..ab0e40a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -915,6 +915,8 @@ static char *uuid_string(char *buf, char *end, const u8 *addr,
  *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
  *           little endian output byte order is:
  *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
+ * - 'd' For dentry name.  NOTE: don't use under dentry->d_lock, there
+ *       you can safely use ->d_name.name instead.
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -958,6 +960,9 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		break;
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
+	case 'd':
+		return dname_string(buf, end, ptr, spec.precision,
+				    spec.field_width, spec.flags & LEFT);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
@@ -1191,6 +1196,7 @@ qualifier:
  *   http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %pd print dentry name
  * %n is ignored
  *
  * The return value is the number of characters which would
