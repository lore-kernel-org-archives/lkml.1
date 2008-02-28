Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYB1I32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYB1I32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYB1I3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:29:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYB1I3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:29:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=fg8rsp9I61ptGRKZU0kgdv74S5gbQhzQFRedZ5amQhGZFk7pQi03nJRAeEucOZxok
	gWitnLIE6Rog0ISj7qI6Q==
Date: Thu, 28 Feb 2008 00:28:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jan Hubicka <hubicka@ucw.cz>
cc: Joe Perches <joe@perches.com>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org,
       zadeck@naturalbridge.com
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline 
 __attribute__((format (printf,x,y) to statement expression macros
In-Reply-To: <20080227235835.GA31048@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.DEB.1.00.0802280021250.2818@chino.kir.corp.google.com>
References: <1204081722.19319.405.camel@localhost> <1204084947.19319.411.camel@localhost> <20080227041316.GA23188@parisc-linux.org> <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com> <1204095249.19319.444.camel@localhost>
 <alpine.DEB.1.00.0802271454430.3836@chino.kir.corp.google.com> <20080227235835.GA31048@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Jan Hubicka wrote:

> > -static inline void __attribute__((format(printf, 1, 2))) 
> > -__simple_attr_check_format(const char *fmt, ...)
> 
> It would be nice to have a testcase, but I guess it is because GCC can't
> inline variadic functions.  The function gets identified as const and
> removed as unused by DCE, but this happens later (that is after early
> inlining and before real inlining).  GCC 4.0.3 didn't have early inliner
> so it is probably where the difference is comming from.
> 
> One possibility to handle this side case would be to mark const
> functions early during early optimization and only refine it using
> Kenny's existing IPA pass that should turn this issue into no-op.
> 
> We probably also can simply allow inlining variadic functions not
> calling va_start.  I must say that this option appeared to me but I was
> unable to think of any sane use case.  This probably is one ;)
> 

The only testcase I can identify is the current version of Linux, because 
I've certainly never seen this type of behavior before.

What's interesting is that you can remove __simple_attr_check_format() 
completely and replace it with an empty function definition:

	static inline void completely_useless_function(void)
	{
	}

that is not referenced anywhere in the tree:

diff --git a/include/linux/fs.h b/include/linux/fs.h
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2044,7 +2044,6 @@ static inline void simple_transaction_set(struct file *file, size_t n)
 #define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)           \
 static int __fops ## _open(struct inode *inode, struct file *file)     \
 {                                                                      \
-       __simple_attr_check_format(__fmt, 0ull);                        \
        return simple_attr_open(inode, file, __get, __set, __fmt);      \
 }                                                                      \
 static struct file_operations __fops = {                               \
@@ -2055,10 +2054,8 @@ static struct file_operations __fops = {                         \
        .write   = simple_attr_write,                                   \
 };
 
-static inline void __attribute__((format(printf, 1, 2)))
-__simple_attr_check_format(const char *fmt, ...)
+static inline void completely_useless_function(void)
 {
-       /* don't do anything, just let the compiler check the arguments; */
 }
 
 int simple_attr_open(struct inode *inode, struct file *file,


And the size remains identical after this patch has been applied:

   text    data     bss     dec     hex filename
5386111  846328  719560 6951999  6a143f vmlinux.before
5386111  846328  719560 6951999  6a143f vmlinux.after

Yet, if you subsequently remove completely_useless_function(), the image 
is smaller:


diff --git a/include/linux/fs.h b/include/linux/fs.h
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2044,7 +2044,6 @@ static inline void simple_transaction_set(struct file *file, size_t n)
 #define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)           \
 static int __fops ## _open(struct inode *inode, struct file *file)     \
 {                                                                      \
-       __simple_attr_check_format(__fmt, 0ull);                        \
        return simple_attr_open(inode, file, __get, __set, __fmt);      \
 }                                                                      \
 static struct file_operations __fops = {                               \
@@ -2055,12 +2054,6 @@ static struct file_operations __fops = {                         \
        .write   = simple_attr_write,                                   \
 };
 
-static inline void __attribute__((format(printf, 1, 2)))
-__simple_attr_check_format(const char *fmt, ...)
-{
-       /* don't do anything, just let the compiler check the arguments; */
-}
-
 int simple_attr_open(struct inode *inode, struct file *file,
                     int (*get)(void *, u64 *), int (*set)(void *, u64),
                     const char *fmt);


Then:

   text    data     bss     dec     hex filename
5386111  846328  719560 6951999  6a143f vmlinux.before
5386047  846328  719560 6951935  6a13ff vmlinux.after

So the only thing I can imagine is that gcc 4.1.3 and gcc 4.2.2 emit a 
larger text size simply based on the number of functions being defined, 
regardless of whether they are referenced in the source or not.  gcc 4.0.3 
doesn't have this behavior.

It's easy to reproduce:

	$ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.3.tar.bz2
	$ tar xvf linux-2.6.24.3.tar.bz2
	$ cd linux-2.6.24.3
	$ make defconfig ARCH=x86_64
	$ make ARCH=x86_64
	$ size vmlinux
	$ patch -p1 < remove-simple-attr-check-format.patch
	$ make ARCH=x86_64
	$ size vmlinux
