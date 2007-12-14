Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXLNOla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXLNOla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXLNOlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:41:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:36322 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXLNOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:41:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=JWMbtq0JqK3yzDz+7oxBLHJxlD/FQ2cNFrhlrR/NHp3EP9LbvBEzOzdRzKZXKtyYKbQ02QTkKXjFbl5dVa9AZihrw/YXpr+uJE8sbly55QhQiSjk8jU9G7laM0TUGQQTAi11plmKAA6HHmzEZ/cXvKmmi4OIgw/b3fZi10fOfJE=
Message-ID: <476295FF.1040202@gmail.com>
Date: Fri, 14 Dec 2007 23:41:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
References: <20071213123333.GA16905@linux.vnet.ibm.com> <20071213132326.GC16905@linux.vnet.ibm.com> <20071213151847.GB5676@linux.vnet.ibm.com> <20071213162936.GA7635@suse.de> <20071213164658.GA30865@linux.vnet.ibm.com> <20071213175423.GA2977@linux.vnet.ibm.com>
In-Reply-To: <20071213175423.GA2977@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------010501010905050202090508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010501010905050202090508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dhaval Giani wrote:
> On Thu, Dec 13, 2007 at 10:16:58PM +0530, Dhaval Giani wrote:
>> On Thu, Dec 13, 2007 at 08:29:36AM -0800, Greg KH wrote:
>>> On Thu, Dec 13, 2007 at 08:48:47PM +0530, Dhaval Giani wrote:
>>>> On Thu, Dec 13, 2007 at 06:53:26PM +0530, Dhaval Giani wrote:
>>>>> On Thu, Dec 13, 2007 at 06:03:33PM +0530, Dhaval Giani wrote:
>>>>>> Hi Greg, Tejun,
>>>>>>
>>>>>> The following script causes oomkiller to be invoked on my system here.
>>>>>>
>>>>>> while echo; do cat /sys/kernel/kexec_crash_loaded; done
>>>>>>
>>>>>  while echo; do cat /sys/kernel/uevent_seqnum ; done;
>>>>>
>>>>> causes oomkiller to be invoked on 2.6.22-stable, 2.6.23-stable and
>>>>> 2.6.24-rc5 as well. It seems not be particularly related to any single
>>>>> file in sysfs.
>>>>>
>>>> And on 2.6.24-rc5-mm1 as well.
>>> How long do you have to run this?  I'm not seeing a problem here with
>>> 2.6.24-rc5 using SLUB, but I might not have run things long enough.
>>>
>> I hit it reliably under 10 mins. I've seen it with both SLUB and SLAB.
>>
>>> I ran slabinfo and don't see anything leaking either, do you?
>> Nor could I find anything, at least nothing directly apparent. (But, I
>> am not very good at ready slabinfo yet.)
>>
>> I've attached the .config if that helps in reproducing it. (Am testing
>> with SLUB again on latest -mm).
>>
> 
> OK, so it ooms there as well. I am attaching its config and part of the
> dmesg (whatever I could capture).

I can't reproduce it here either.  Please apply the attached patch and
reproduce the problem.  It will report the number of allocated buffer
pages every 10 sec.  After oom occurs, please report how this number
changed and the result of 'cat /proc/slabinfo'.

Thanks.

-- 
tejun

--------------010501010905050202090508
Content-Type: text/x-patch;
 name="sysfs-leak-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysfs-leak-debug.patch"

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4045bdc..6e7fa62 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -17,9 +17,30 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
+#include <linux/jiffies.h>
+#include <asm/atomic.h>
 
 #include "sysfs.h"
 
+static unsigned long last_jiffies = INITIAL_JIFFIES;
+static atomic_t sysfs_page_cnt = ATOMIC_INIT(0);
+
+static void sysfs_page_inc(void)
+{
+	atomic_inc(&sysfs_page_cnt);
+
+	if (time_before(jiffies, last_jiffies + 10 * HZ))
+		return;
+
+	last_jiffies = jiffies;
+	printk("XXX sysfs_page_cnt=%d\n", atomic_read(&sysfs_page_cnt));
+}
+
+static void sysfs_page_dec(void)
+{
+	atomic_dec(&sysfs_page_cnt);
+}
+
 #define to_sattr(a) container_of(a,struct subsys_attribute, attr)
 
 /*
@@ -105,8 +126,10 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	int ret = 0;
 	ssize_t count;
 
-	if (!buffer->page)
+	if (!buffer->page) {
 		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
+		sysfs_page_inc();
+	}
 	if (!buffer->page)
 		return -ENOMEM;
 
@@ -188,8 +211,10 @@ fill_write_buffer(struct sysfs_buffer * buffer, const char __user * buf, size_t
 {
 	int error;
 
-	if (!buffer->page)
+	if (!buffer->page) {
 		buffer->page = (char *)get_zeroed_page(GFP_KERNEL);
+		sysfs_page_inc();
+	}
 	if (!buffer->page)
 		return -ENOMEM;
 
@@ -434,8 +459,10 @@ static int sysfs_release(struct inode *inode, struct file *filp)
 
 	sysfs_put_open_dirent(sd, buffer);
 
-	if (buffer->page)
+	if (buffer->page) {
 		free_page((unsigned long)buffer->page);
+		sysfs_page_dec();
+	}
 	kfree(buffer);
 
 	return 0;

--------------010501010905050202090508--
