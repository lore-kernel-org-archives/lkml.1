Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbYB0W7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbYB0W7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYB0W7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:59:11 -0500
Received: from smtp-out.google.com ([216.239.33.17]:54224 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYB0W7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:59:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=uM2pwSlYNTDtuVdQfwbH5z9YxYqZWcmI5fx9LuEueoY2NP2jjLmMG7N1fQyeupG6d
	0iZEUi0lwILDOq0yCl9Ig==
Date: Wed, 27 Feb 2008 14:58:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline
 __attribute__((format (printf,x,y) to statement expression macros
In-Reply-To: <1204095249.19319.444.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802271454430.3836@chino.kir.corp.google.com>
References: <1204081722.19319.405.camel@localhost>  <1204084947.19319.411.camel@localhost>  <20080227041316.GA23188@parisc-linux.org>  <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com> <1204095249.19319.444.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Joe Perches wrote:

> > Joe, what version of gcc are you using?
> 
> $ gcc --version
> gcc (GCC) 4.2.2 20071128 (prerelease) (4.2.2-3.1mdv2008.0)
> 
> It's definitely odd.
> The .o size changes are inconsistent.
> Some get bigger, some get smaller.
> 
> The versioning ones I understand but I have no idea why
> changes in drivers/ or mm/ or net/ exist.
> 

When I did the same comparisons on my x86_64 defconfig with gcc 4.1.3, I 
only saw differences in drivers/ and fs/.

> I think it's gcc optimization changes, but dunno...
> Any good ideas?
> 

What's interesting about this is that it doesn't appear to be related to 
your change (static inline function to macro definition).  It appears to 
be simply removing the static inline function.

The only reference to __simple_attr_check_format() in either the x86 or 
x86_64 defconfig is via DEFINE_SIMPLE_ATTRIBUTE() in fs/debugfs/file.c.

If you remove the only reference to it:

diff --git a/include/linux/fs.h b/include/linux/fs.h
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2044,7 +2044,6 @@ static inline void simple_transaction_set(struct file *file, size_t n)
 #define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
-	__simple_attr_check_format(__fmt, 0ull);			\
 	return simple_attr_open(inode, file, __get, __set, __fmt);	\
 }									\
 static struct file_operations __fops = {				\

The text size remains the same:

   text    data     bss     dec     hex filename
5386111  846328  719560 6951999  6a143f vmlinux.before
5386111  846328  719560 6951999  6a143f vmlinux.after

Yet if you remove the reference _and_ the static inline function itself, 
replacing it with nothing:

diff --git a/include/linux/fs.h b/include/linux/fs.h
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2044,7 +2044,6 @@ static inline void simple_transaction_set(struct file *file, size_t n)
 #define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
-	__simple_attr_check_format(__fmt, 0ull);			\
 	return simple_attr_open(inode, file, __get, __set, __fmt);	\
 }									\
 static struct file_operations __fops = {				\
@@ -2055,12 +2054,6 @@ static struct file_operations __fops = {				\
 	.write	 = simple_attr_write,					\
 };
 
-static inline void __attribute__((format(printf, 1, 2)))
-__simple_attr_check_format(const char *fmt, ...)
-{
-	/* don't do anything, just let the compiler check the arguments; */
-}
-
 int simple_attr_open(struct inode *inode, struct file *file,
 		     int (*get)(void *, u64 *), int (*set)(void *, u64),
 		     const char *fmt);

The text size does become smaller:

   text    data     bss     dec     hex filename
5386111  846328  719560 6951999  6a143f vmlinux.before
5386047  846328  719560 6951935  6a13ff vmlinux.after

gcc 4.0.3 maintains the same text size for both cases, while it appears 
gcc 4.1.3 and your version, 4.2.2, have this different behavior.

		David
