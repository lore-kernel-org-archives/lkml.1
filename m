Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYKKWSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYKKWSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYKKWSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:18:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56126 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbYKKWSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:18:10 -0500
Message-ID: <491A0483.3010504@redhat.com>
Date: Wed, 12 Nov 2008 00:17:39 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>	<1226409701-14831-2-git-send-email-ieidus@redhat.com>	<1226409701-14831-3-git-send-email-ieidus@redhat.com>	<1226409701-14831-4-git-send-email-ieidus@redhat.com> <20081111150345.7fff8ff2@bike.lwn.net>
In-Reply-To: <20081111150345.7fff8ff2@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> I don't claim to begin to really understand the deep VM side of this
> patch, but I can certainly pick nits as I work through it...sorry for
> the lack of anything more substantive.
>
>   
>> +static struct list_head slots;
>>     
>
> Some of these file-static variable names seem a little..terse...
>
>   
>> +#define PAGECMP_OFFSET 128
>> +#define PAGEHASH_SIZE (PAGECMP_OFFSET ? PAGECMP_OFFSET : PAGE_SIZE)
>> +/* hash the page */
>> +static void page_hash(struct page *page, unsigned char *digest)
>>     
>
> So is this really saying that you only hash the first 128 bytes, relying on
> full compares for the rest?  I assume there's a perfectly good reason for
> doing it that way, but it's not clear to me from reading the code.  Do you
> gain performance which is not subsequently lost in the (presumably) higher
> number of hash collisions?
>
>   
>> +static int ksm_scan_start(struct ksm_scan *ksm_scan, int scan_npages,
>> +			  int max_npages)
>> +{
>> +	struct ksm_mem_slot *slot;
>> +	struct page *page[1];
>> +	int val;
>> +	int ret = 0;
>> +
>> +	down_read(&slots_lock);
>> +
>> +	scan_update_old_index(ksm_scan);
>> +
>> +	while (scan_npages > 0 && max_npages > 0) {
>>     
>
> Should this loop maybe check kthread_run too?  It seems like you could loop
> for a long time after kthread_run has been set to zero.
>
>   
>> +static int ksm_dev_open(struct inode *inode, struct file *filp)
>> +{
>> +	try_module_get(THIS_MODULE);
>> +	return 0;
>> +}
>> +
>> +static int ksm_dev_release(struct inode *inode, struct file *filp)
>> +{
>> +	module_put(THIS_MODULE);
>> +	return 0;
>> +}
>> +
>> +static struct file_operations ksm_chardev_ops = {
>> +	.open           = ksm_dev_open,
>> +	.release        = ksm_dev_release,
>> +	.unlocked_ioctl = ksm_dev_ioctl,
>> +	.compat_ioctl   = ksm_dev_ioctl,
>> +};
>>     
>
> Why do you roll your own module reference counting?  Is there a reason you
> don't just set .owner and let the VFS handle it?
>   

Yes, I am taking get_task_mm() if the module will be removed before i 
free the mms, things will go wrong

> Given that the KSM_REGISTER_MEMORY_REGION ioctl() creates unswappable
> memory, should there be some sort of capability check done there?  A check
> for starting/stopping the thread might also make sense.  Or is that
> expected to be handled via permissions on /dev/ksm?
>   

Well, I think giving premmision to /dev/ksm default as root is enough.
No?

> Actually, it occurs to me that there's no sanity checks on any of the
> values passed in by ioctl().  What happens if the user tells KSM to scan a
> bogus range of memory?
>   

Well get_user_pages() run in context of the process, therefore it should 
fail in "bogus range of memory"

> Any benchmarks on the runtime cost of having KSM running?
>   

This one is problematic, ksm can take anything from 0% to 100% cpu
its all depend on how fast you run it.
it have 3 parameters:
number of pages to scan before it go to sleep
maximum number of pages to merge while we scanning the above pages 
(merging is expensive)
time to sleep (when runing from userspace using /dev/ksm, we actually do 
it there (userspace)

> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

