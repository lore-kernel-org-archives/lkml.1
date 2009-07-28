Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZG1GXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZG1GXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 02:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZG1GXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 02:23:10 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42858 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZG1GXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 02:23:09 -0400
Message-ID: <4A6E98DC.5020200@ct.jp.nec.com>
Date: Tue, 28 Jul 2009 15:21:16 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] task_struct cleanup: move binfmt field to mm_struct
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com> <4A693569.1090009@ct.jp.nec.com> <20090724161449.GA3509@redhat.com> <4A6CF466.9040608@ct.jp.nec.com> <20090727165901.GA8854@redhat.com>
In-Reply-To: <20090727165901.GA8854@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> (add Rusty)
> 
> On 07/27, Hiroshi Shimamoto wrote:
>>  void set_binfmt(struct linux_binfmt *new)
>>  {
>> -	if (current->binfmt)
>> -		module_put(current->binfmt->module);
>> +	struct mm_struct *mm = current->mm;
>> +
>> +	BUG_ON(!mm);
>> +	if (mm->binfmt)
> 
> I am not sure we need this BUG_ON() above. If mm == NULL we will
> have the same debug info after the crash.

Ah, right. It will crash at accessing mm->binfmt and we'll get the
same information. I didn't think seriously.
BTW, now I noticed that it looks similar the security issue with
NULL page mapping. If the kernel has the page mapping to NULL,
it causes unstable behavior, no?

> 
>> @@ -619,6 +621,9 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
>>  	mm->hiwater_rss = get_mm_rss(mm);
>>  	mm->hiwater_vm = mm->total_vm;
>>
>> +	if (mm->binfmt && !try_module_get(mm->binfmt->module))
>> +		goto free_pt;
> 
> free_pt does mmput() which calls module_put(mm->binfmt->module). This
> is not right when try_module_get() fails. Hmm, the same if dup_mmap()
> fails, we are doing an extra module_put().

Good catch, should avoid over putting binfmt->module.

> 
> Perhaps we can use __module_get() again, current->mm->binfmt holds a
> reference. But this is a user-visible change, currently fork() can't
> succeed if ->module->state == MODULE_STATE_GOING.
> 
> So I think we need another small change:
> 
> 	 free_pt:
> 	+	mm->binfmt = NULL;
> 	 	mmput(mm);

looks good for me.
Will send an update.

thanks,
Hiroshi

