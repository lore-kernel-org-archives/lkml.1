Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZEYXDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZEYXDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZEYXD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:03:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZEYXDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:03:25 -0400
Message-ID: <4A1B2377.3060601@zytor.com>
Date: Mon, 25 May 2009 16:02:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org> <alpine.LFD.2.01.0905251543570.3435@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905251543570.3435@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replying to add Venki back to the Cc: list since I typed his name]

Linus Torvalds wrote:
> 
> On Mon, 25 May 2009, H. Peter Anvin wrote:
>> +static void wbinvd_local(void *unused)
>> +{
>> +	wbinvd();
>> +}
>> +
>>  static void cpa_flush_array(unsigned long *start, int numpages, int cache,
>>  			    int in_flags, struct page **pages)
>>  {
>> @@ -218,8 +223,9 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
>>  
>>  	/* 4M threshold */
>>  	if (numpages >= 1024) {
>> -		if (boot_cpu_data.x86_model >= 4)
>> -			wbinvd();
>> +		if (boot_cpu_data.x86 >= 4)
>> +			on_each_cpu(wbinvd_local, NULL, 1);
>> +
> 
> This looks a bit wrong.
> 
> Just above this, we've done
> 
> 	on_each_cpu(__cpa_flush_range, NULL, 1);
> 
> and quite frankly, it seems to be that what we _should_ have done is to 
> instead change that to
> 
> 	long do_wbinvd = cache && numpages >= 1024;
> 
> 	on_each_cpu(__cpa_flush_all, (void *)do_wbinvd, 1);
> 	if (!cache || do_wbinvd)
> 		return;
> 
> 	.. do the cflush dance .. 
> 
> instead.
> 
> Now you made it do two different "on_each_cpu" things. Maybe it doesn't 
> matter, but it just seems wrong.
> 
> 		Linus


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

