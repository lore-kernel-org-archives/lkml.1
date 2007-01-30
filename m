Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXA3KZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXA3KZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbXA3KZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:25:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52242 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbXA3KZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:25:21 -0500
Date: Tue, 30 Jan 2007 02:24:57 -0800
From: Andrew Morton <akpm@osdl.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: bug reading /proc/sys/kernel/*: only first byte read.
Message-Id: <20070130022457.d0159eba.akpm@osdl.org>
In-Reply-To: <4538C47B.9060808@tls.msk.ru>
References: <4538C47B.9060808@tls.msk.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Oct 2006 16:43:39 +0400
Michael Tokarev <mjt@tls.msk.ru> wrote:

> I were debugging a weird problem with busybox, and come across
> this chunk of strace output:
> 
> open("/proc/sys/kernel/osrelease", O_RDONLY) = 3
> read(3, "2", 1)                         = 1
> read(3, "", 1)                          = 0
> close(3)                                = 0
> 
> As you can see, after reading one byte from /proc/sys/kernel/osrelease,
> next read() returns 0, which is treated as end-of-file by an application.
> 
> Why busybox does this single-byte reads is another question (many
> shells does that, in order to be able to stop reading at newline).
> 
> But this is definitely a bug in kernel, and should be fixed....
> 
> It exists in 2.6.17 and 2.6.18
> 

Well this nearly killed me.  kernel-side proc handlers are ghastly things.

Could I have this reviewed please?  It surely has a hole in it somewhere.


From: Andrew Morton <akpm@osdl.org>

If you try to read things like /proc/sys/kernel/osrelease with single-byte
reads, you get just one byte and then EOF.  This is because _proc_do_string()
assumes that the caller is read()ing into a buffer which is large enough to
fit the whole string in a single hit.

Fix.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff -puN kernel/sysctl.c~_proc_do_string-fix-short-reads kernel/sysctl.c
--- a/kernel/sysctl.c~_proc_do_string-fix-short-reads
+++ a/kernel/sysctl.c
@@ -1682,8 +1682,7 @@ static int _proc_do_string(void* data, i
 	char __user *p;
 	char c;
 	
-	if (!data || !maxlen || !*lenp ||
-	    (*ppos && !write)) {
+	if (!data || !maxlen || !*lenp) {
 		*lenp = 0;
 		return 0;
 	}
@@ -1705,18 +1704,38 @@ static int _proc_do_string(void* data, i
 		((char *) data)[len] = 0;
 		*ppos += *lenp;
 	} else {
-		len = strlen(data);
+		loff_t pos = *ppos;
+		const size_t slen = strlen(data);
+
+		/*
+		 * len is the amount of data to copy, and becomes the amount of
+		 * data which was copied
+		 */
+		len = slen;
+		if (pos > len) {
+			*lenp = 0;
+			return 0;
+		}
 		if (len > maxlen)
 			len = maxlen;
 		if (len > *lenp)
 			len = *lenp;
-		if (len)
-			if(copy_to_user(buffer, data, len))
-				return -EFAULT;
-		if (len < *lenp) {
-			if(put_user('\n', ((char __user *) buffer) + len))
+		/* Don't copy past the end of the string */
+		if (len > slen - pos)
+			len = slen - pos;
+		data += pos;
+		/* Copy as much of the string as we can */
+		if (len) {
+			if (copy_to_user(buffer, data, len))
 				return -EFAULT;
-			len++;
+		}
+		/* If we copied the whole string, now write a \n */
+		if (len + pos == slen) {
+			if (len + pos < maxlen) {
+				if (put_user('\n', (char __user *)buffer + len))
+					return -EFAULT;
+				len++;
+			}
 		}
 		*lenp = len;
 		*ppos += len;
_

