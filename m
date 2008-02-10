Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYBJSy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYBJSy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYBJSyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:54:37 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:57730 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbYBJSyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:54:36 -0500
Message-ID: <47AF483E.2060202@web.de>
Date: Sun, 10 Feb 2008 19:53:50 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [2/6] uaccess: add probe_kernel_write()
References: <20080210071326.GB3851@elte.hu>
In-Reply-To: <20080210071326.GB3851@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/KfHb4xL5B7a7n6L9UVeG8geFYpr5aC1Oln9tA
	q2Qtg7WiDLvhKEqI9XS7wuLfHGTyoKt7imXtj7hEP+/fwxa6jA
	d77WhS3P0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> add probe_kernel_write() - copy & paste of the existing
> probe_kernel_access(), extended to writes.

Along Linus' suggestion to work on larger chunks in kgdb, here are
improved probe_kernel_read/write helpers that take a size argument.

I'm leaving the original probe_kernel_read as is for now, but maybe it
can be converted to probe_kernel_read (I don't want to dive into this as
well :) ).

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 uaccess.h |   38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 98cfe02..ef75869 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -85,25 +85,49 @@ static inline unsigned long __copy_from_user_nocache(void *to,
 	})
 
 /**
+ * probe_kernel_read(): safely attempt to read from a location
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from address @src to the buffer at @dst.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+#define probe_kernel_read(dst, src, size)		\
+	({						\
+		long ret;				\
+		mm_segment_t old_fs = get_fs();		\
+							\
+		set_fs(KERNEL_DS);			\
+		pagefault_disable();			\
+		ret = __copy_from_user_inatomic((dst),	\
+	 (__force const void __user *)(src), (size));	\
+		pagefault_enable();			\
+		set_fs(old_fs);				\
+		ret ? -EFAULT : 0;			\
+	})
+
+/**
  * probe_kernel_write(): safely attempt to write to a location
- * @addr: address to write to - its type is type typeof(rdval)*
- * @rdval: write to this variable
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
  *
- * Safely write to address @addr from variable @rdval.  If a kernel fault
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-#define probe_kernel_write(addr, rdval)			\
+#define probe_kernel_write(dst, src, size)		\
 	({						\
 		long ret;				\
 		mm_segment_t old_fs = get_fs();		\
 							\
 		set_fs(KERNEL_DS);			\
 		pagefault_disable();			\
-		ret = __put_user(rdval,			\
-	 (__force typeof(rdval) __user *)(addr));	\
+		ret = __copy_to_user_inatomic(		\
+	 (__force void __user *)(dst), (src), (size));	\
 		pagefault_enable();			\
 		set_fs(old_fs);				\
-		ret;					\
+		ret ? -EFAULT : 0;			\
 	})
 
 #endif		/* __LINUX_UACCESS_H__ */
