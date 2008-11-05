Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYKERnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYKERnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYKERnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:43:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:11886 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYKERnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y87Tu2s5LcvlZlIQxIpYkMvaPAsFK1Ll548ecf63T2PxMH+ZwmyaCSM92x1AzFHeSl
         TP6WywC5y89m36zV9ILJu1uIq0J+TqmqxJNt09v5SKQ9fy7ZctY0DATeMLuu6fHqQM4J
         9+tfTckwAkzPI80kkXjinkno/ISrGj3X4X6L0=
Message-ID: <8bd0f97a0811050943n79a4ced9u23fc5ae6540d458@mail.gmail.com>
Date: Wed, 5 Nov 2008 12:43:31 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Cc: "Greg KH" <gregkh@suse.de>, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081105170800.GD6382@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
	 <20081105113610.GA6382@local> <20081105163334.GA8473@suse.de>
	 <20081105170800.GD6382@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 12:08, Hans J. Koch wrote:
> On Wed, Nov 05, 2008 at 08:33:34AM -0800, Greg KH wrote:
>> On Wed, Nov 05, 2008 at 12:36:11PM +0100, Hans J. Koch wrote:
>> > There seem to be archs that cannot easily implement a sensible
>> > pgprot_noncached() function, so we should merge this patch. UIO doesn't
>> > compile on these archs right now.
>>
>> No, we should fix those arches to have that function at least NULLed
>> out.  Isn't there only one, Blackfin?  Putting #ifdefs in .c files is
>> not something we really want to do if at all possible.
>
> Yep, 5 minutes after I sent the mail I regretted it. Blackfin could
> easily implement an "empty" macro that just returns its parameter.

just because it's easy to do doesnt mean it's correct.  i'm looking
for the correct answer here, not the quick & dirty & forget about it.

perhaps uio_mmap_physical() should look like:
static int uio_mmap_physical(struct vm_area_struct *vma)
{
#ifdef pgprot_noncached
    struct uio_device *idev = vma->vm_private_data;
    int mi = uio_find_mem_index(vma);
    if (mi < 0)
        return -EINVAL;

    vma->vm_flags |= VM_IO | VM_RESERVED;

    vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

    return remap_pfn_range(vma,
                   vma->vm_start,
                   idev->info->mem[mi].addr >> PAGE_SHIFT,
                   vma->vm_end - vma->vm_start,
                   vma->vm_page_prot);
#else
    return -EFAULT;
#endif
}
