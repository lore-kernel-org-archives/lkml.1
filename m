Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZCKH2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZCKH2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 03:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZCKH2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 03:28:30 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:63040 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZCKH23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 03:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B1ZgHHIvrFAFrt511uf4B3OfIX7g6HfuML51KOvdvnD8ShGrnaVO006XMzeXbrd/nF
         AXliOqhc7zThXYwrqwe7FuUQr7B1nMyEDL1KutjtgaGNrCHF0C2ChG5qaED0yomn/Sfc
         KVM0G/A7Nm1Jb4n4QTWF3eQqG+Rj8jnyRTjJ8=
Date: Wed, 11 Mar 2009 15:28:55 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Christopher Brannon <cmbrannon@cox.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-ID: <20090311072855.GC3262@hack>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 09:06:46PM -0600, Christopher Brannon wrote:

<snip>

>@@ -0,0 +1,112 @@
>+#include <linux/init.h>
>+#include <linux/module.h>
>+#include <linux/fs.h>
>+#include <linux/miscdevice.h>
>+#include <linux/time.h>
>+#include <linux/jiffies.h>
>+#include <linux/uaccess.h>
>+
>+MODULE_AUTHOR("Christopher Brannon <cmbrannon79@gmail.com>");
>+MODULE_LICENSE("GPL");
>+
>+const long long NS_PER_SEC = 1000000000;
>+const long long NS_PER_USEC = 1000;
>+const size_t time_bufsize = 256;

I notice that you use this "const" as an array size below, so
you are using VLA, yes, C99 supports it but this is in the kernel,
try to avoid this by using marco:

#define BUFSIZE 256

And yes, C's const sucks. :)


>+
>+static ssize_t time_read(struct file *, char __user *, size_t, loff_t *);
>+static ssize_t time_write(struct file *, const char __user *, size_t, loff_t *);
>+
>+static const struct file_operations time_fops = {
>+	.owner = THIS_MODULE,
>+	.read = time_read,
>+	.write = time_write,
>+};
>+
>+static struct miscdevice timedev = {
>+	.minor = MISC_DYNAMIC_MINOR,
>+	.name = "time",
>+	.fops = &time_fops
>+};
>+
>+static int time2text(char *buffer, size_t bufsize)
>+{
>+	int count = 0;
>+	struct timeval tv;
>+	long long nanos;
>+
>+/* jiffies isn't 0 at boot time; its value is INITIAL_JIFFIES. */
>+	u64 ticks = get_jiffies_64() - INITIAL_JIFFIES;
>+
>+	do_gettimeofday(&tv);
>+	nanos = tv.tv_sec * NS_PER_SEC + tv.tv_usec * NS_PER_USEC;
>+	count =
>+	    scnprintf(buffer, bufsize, "%ld %lld %llu %d\n", tv.tv_sec, nanos,
>+		      ticks, HZ);
>+	return count;
>+}
>+
>+static int text2time(char *buffer)
>+{
>+	struct timespec tv;
>+	int result = strict_strtol(buffer, 10, &tv.tv_sec);
>+	if ((result == 0) && (tv.tv_sec > 0)) {
>+		tv.tv_nsec = 0;
>+		do_settimeofday(&tv);
>+	} else
>+		result = -EINVAL;	/* only positive longs are valid. */
>+	return result;
>+}
>+
>+static ssize_t
>+time_read(struct file *f, char __user *buffer, size_t count, loff_t * offset)
>+{
>+	int result = 0;
>+	if (*offset != 0)
>+		result = 0;
>+	else {
>+		char tmpbuf[time_bufsize];
>+		int timetextlen = time2text(tmpbuf, time_bufsize);
>+		unsigned long readcount = min(count, (size_t) timetextlen);
>+		if (timetextlen <= 0)
>+			return -EAGAIN;
>+		if (!copy_to_user(buffer, tmpbuf, readcount)) {
>+			*offset += readcount;
>+			result = readcount;
>+		} else
>+			result = -EFAULT;
>+	}
>+	return result;
>+}
>+
>+static ssize_t
>+time_write(struct file *f, const char __user * buffer, size_t count,
>+	   loff_t *offset)
>+{
>+	unsigned int result = 0;
>+	char tmpbuf[time_bufsize];
>+
>+	if (*offset != 0)
>+		return -EINVAL;
>+	if (count > ((size_t) time_bufsize - 1))
>+		return -EINVAL;	/* Likely trying to feed bogus data anyway. */
>+	result = copy_from_user(tmpbuf, buffer, count);
>+	if (result)
>+		return -EFAULT;
>+	tmpbuf[count] = '\0';
>+	if (text2time(tmpbuf))
>+		return -EINVAL;
>+	return count;
>+}
>+
>+static int __init time_init(void)
>+{
>+	return misc_register(&timedev);
>+}
>+
>+static void __exit time_exit(void)
>+{
>+	misc_deregister(&timedev);
>+}
>+
>+module_init(time_init);
>+module_exit(time_exit);
>-- 
>1.6.1.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Do what you love, f**k the rest! F**k the regulations!
 
