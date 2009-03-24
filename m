Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZCXWUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZCXWUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZCXWTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:19:25 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:43645 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbZCXWTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sO/LKt/ONvUlTBwayINF8wf3IgBoWd5ngG80CrtVpr3kQWihXaWXdZpyFDA7FZ7dXq
         /PHofyDZMjXh0nfMhEj9h+/3DYhQ+mbmP6OF6a/D/mhzmZ+b/vl+N9+ueV45ooIhI54K
         sfDR1QkSAsYZCFJLxJR0Fk8VMmZDJWHX81CLE=
Message-ID: <49C95C66.2050100@gmail.com>
Date: Tue, 24 Mar 2009 19:19:18 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090321)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Dave Airlie <airlied@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error: freeing invalid memtype
References: <49C03208.6050603@gmail.com> <1237399938.4529.208.camel@localhost.localdomain> <49C572CC.6090704@gmail.com> <20090323190720.GA16831@linux-os.sc.intel.com>
In-Reply-To: <20090323190720.GA16831@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> On Sat, Mar 21, 2009 at 04:05:48PM -0700, Kevin Winchester wrote:
>> Pallipadi, Venkatesh wrote:
>>> Kevin,
>>>
>>> Can you please send me the output of
>>> # cat /debug/x86/pat_memtype_list
>>>
>>> (with debugfs mounted at /debug) as soon as you login into X and also
>>> when you start seeing these errors with etracer and glxinfo.
>>>
>> Here is the output before attempting to run glxinfo:
>> : :
>> : :
>>
>> Does that help track down the problem?  I am about to try disabling PAT
>> in my config to see if that fixes things.
>>
> 
> Can you please try the patch below and let me whether it helps.
> 
> Thanks,
> Venki
> 
> x86, PAT: Change vma prot in pci_mmap to reflect inherited prot
>     
> While looking at the issue in the thread
> http://marc.info/?l=dri-devel&m=123606627824556&w=2
> noticed a bug in pci PAT code and memory type setting.
>     
> pci mmap code did not set the proper protection in vma, when it
> inherited protection in reserve_memtype. This bug only affects
> the case where there exists a WC mapping before X does an mmap
> with /proc or /sys pci interface. This will cause X userlevel
> mmap from /proc or /sysfs to fail on fork.
>     
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 5ead808..f234a37 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -319,6 +319,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
>  			return -EINVAL;
>  		}
>  		flags = new_flags;
> +		vma->vm_page_prot = __pgprot(
> +			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
> +			flags);
>  	}
>  
>  	if (((vma->vm_pgoff < max_low_pfn_mapped) ||

This patch fixes the problem for me - no more errors in my dmesg.  I suppose that I also
did update to the latest mainline as well, so it could possibly have been some other patch
instead.  If you think there is a big risk of that, let me know and I'll repeat the test
and make sure that this patch is the only difference.

Thanks,

-- 
Kevin Winchester

