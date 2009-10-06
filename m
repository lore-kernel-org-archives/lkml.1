Return-Path: <linux-kernel-owner+w=401wt.eu-S933412AbZJFVcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbZJFVcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933378AbZJFVcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:32:02 -0400
Received: from claw.goop.org ([74.207.240.146]:40571 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbZJFVcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:32:01 -0400
Message-ID: <4ACBB725.4010605@goop.org>
Date: Tue, 06 Oct 2009 14:31:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: airlied@linux.ie, dri-devel@lists.sourceforge.net, JBeulich@novell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: make sure page protections are updated after changing
 vm_flags.
References: <4AC3E1EB.4020903@goop.org> <20091006133937.246a4f33.akpm@linux-foundation.org>
In-Reply-To: <20091006133937.246a4f33.akpm@linux-foundation.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/09 13:39, Andrew Morton wrote:
> On Wed, 30 Sep 2009 15:55:39 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Some architectures compute ->vm_page_prot depending on ->vm_flags, so
>> we need to update the protections after adjusting the flags.
>>
>> Reported-by: Jan Beulich <JBeulich@novell.com>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
>> index 8104eca..9d3e39f 100644
>> --- a/drivers/gpu/drm/drm_gem.c
>> +++ b/drivers/gpu/drm/drm_gem.c
>> @@ -537,7 +537,7 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
>>  	vma->vm_ops = obj->dev->driver->gem_vm_ops;
>>  	vma->vm_private_data = map->handle;
>>  	/* FIXME: use pgprot_writecombine when available */
>> -	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
>> +	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
>>  
>>  	/* Take a ref for this mapping of the object, so that the fault
>>  	 * handler can dereference the mmap offset's pointer to the object.
>>     
> u fail changelogology.
>
> What were the consequences of the bug which you just fixed?
>   

AFAIK this only affects running X under Xen; without this patch you get
lots of coloured blobs on the screen, or maybe a complete lockup.  Or
anything really.

But that still depends on lots of out-of-tree stuff, so I don't think
there are any consequences for anyone else.  But it is wrong in principle.

    J
