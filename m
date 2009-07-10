Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbZGJHJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbZGJHJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZGJHIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:08:54 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34394 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZGJHIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:08:53 -0400
Message-ID: <4A56E83B.50600@mxs.nes.nec.co.jp>
Date: Fri, 10 Jul 2009 16:05:31 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdump: Enable kdump if 2nd-kernel is loaded.
References: <4A55A4AE.3000206@mxs.nes.nec.co.jp> <4A56E069.5040907@jp.fujitsu.com>
In-Reply-To: <4A56E069.5040907@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Seto-san,

Thank you for your comment.

Hidetoshi Seto wrote:
>> This patch enables a kdump if 2nd-kernel is loaded.
>> (The patch is based on linux-2.6.31-rc2.)
>>
>> Now, a kdump is enabled if a kernel parameter "oops=panic" is specified and
>> 2nd-kernel is loaded. I think that a kdump should be enabled regardless of
>> "oops=panic" if 2nd-kernel is loaded, because a system administrator loads
>> 2nd-kernel for enabling a kdump.
> 
> I think this description is slightly wrong because kdump will be invoked
> from panic, regardless of the panic_on_oops.
> 
> Maybe:
>  A kdump on oops is enabled if a kernel parameter "oops=panic" ...
>          ~~~~~~~

Right, I should add "on oops" to the above description.


>> * Reference
>>   The discussion about this patch
>>   http://lists.infradead.org/pipermail/kexec/2009-July/003417.html
> 
> I'd like to quote your comment:
> 
>>> I tried to test a kdump on linux-2.6.31-rc1 *without* a kernel parameter
>>> "oops=panic" by `echo c > /proc/sysrq-trigger`, but a kdump did not work
>>> because a kdump, which is occurred by `echo c > /proc/sysrq-trigger`, has
>>> been changed to a NULL pointer error instead of calling crash_kexec()
>>> since linux-2.6.31-rc1.
> 
> So the real problem is that kdump is not triggered by the NULL pointer oops
> if !panic_on_oops, isn't it?
>
> It seems that you should report this trouble of sysrq-c as a regression.

I don't think this problem is a regression of sysrq-c.
This change of sysrq-c looks reasonable to me. Because sysrq-c is used
for the test of kdump, and its code path has been changed to the same
path as a kdump on oops (a real problem, not test).
So we can test a kdump by a real oops, that is good to me.
As a result, I could find this problem a kdump is not enabled without
"oops=panic".


>> Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
>> Acked-by: Simon Horman <horms@verge.net.au>
>> ---
>> --- a/kernel/kexec.c	2009-07-08 12:30:26.000000000 +0900
>> +++ b/kernel/kexec.c	2009-07-08 12:38:08.000000000 +0900
>> @@ -57,6 +57,8 @@ struct resource crashk_res = {
>>  
>>  int kexec_should_crash(struct task_struct *p)
>>  {
>> +	if (kexec_crash_image)
>> +		return 1;
>>  	if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
>>  		return 1;
>>  	return 0;
> 
> I think kexec cannot crash if there is no image, right?
> 
> Then:
> 
>  if (kexec_crash_image)
>  	return 1;
>  return 0;
> 
> or
> 
>  return (kexec_crash_image) ? 1 : 0;
> 
> or
> 
>  since crash_kexec() is nop if !kexec_crash_image,
>  replace all:
>    if (kexec_should_crash(p))
>    	crash_kexec(reg);
>  at everywhere in kernel to a simple line:
>    crash_kexec(reg);
>  and remove kexec_should_crash() completely
> 
> would be better fix.

Good point, I like the first option because it is safe that a caller of
crash_kexec() checks it. That is not a strong opinion ;-)


Thanks
Ken'ichi Ohmichi
