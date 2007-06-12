Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbXFLEkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbXFLEkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 00:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXFLEkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 00:40:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:15593 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbXFLEki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 00:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UMKTYGIWgIII8xDHSttmmXjbWgHV/1z3m5g4nZVCjCcPhpJeyoTCibzFUOpdPZwhgrbNKNYuuNMLJauwme1a/KCsPsTrb5ctppDkkB+jHgtgNsRWXGH4SgkIbU3kXAw+jKNWvCGlJxFrgfb2QIrBVWh3468qUI1Ib93tjrBKovA=
Message-ID: <466E23AF.9060002@gmail.com>
Date: Tue, 12 Jun 2007 13:40:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com> <466E1EC6.90509@linux.intel.com>
In-Reply-To: <466E1EC6.90509@linux.intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>> The data we have from this patch is that it saves typically a Watt of
>>> power (depends on the machine of course, but the range is 0.5W to
>>> 1.5W). If you want to also have an even more agressive thing where
>>> you want to start disabling the entire controller... I don't see how
>>> this is in conflict with saving power on the link level by "just"
>>> enabling a hardware feature ....
>>
>> Well, both implement about the same thing.  I prefer software
>> implementation because it's more generic and ALPE/ASP seems too
>> aggressive to me. 
> 
> Too aggressive in what way?

There are devices which lock up hard if PHY enters PS mode (only
physical power removal can reset it) and I wouldn't be surprised if some
devices aren't happy with PS being too aggressive.  Well, I actually
expect to see such devices.  It's ATA after all.  This is unknown
territory and that's why I was using 'seems ... to me'.

> There are tradeoffs on either side. Doing things in software is more
> work for the cpu, and depending on the implementation, will consume more
> power on the CPU side. (for example if you need regular timers that just
> consumes the power you are saving back up). The hardware can obviously
> switch very fast (because it's independent of any software), yet of
> course the software has higher level knowledge about how idle the link
> really is (like it knows if any files are open etc etc).
> 
> To be honest, I would be surprised if software could do significantly
> better than hardware though; it seems a simple problem: Idle -> go to
> low power, and estimating idle isn't all that hard on a link level...
> there's not all THAT much the kernel can estimate better I suspect.

I don't think the end result will vary in any significant way.  My
biggest argument for sw implementation is it can be used for other
controllers.

> This debate is very similar to the cpufreq debate from 4 years ago,
> where there were 3 levels: do it in the CPU, do it in the kernel or do
> it in userspace. All three are valid; whichever is best depends on the
> exact hardware that you have...
> (and you can argue that first everyone started in userspace, then the
> hardware improved that made a kernelspace implementation better
> (ondemand) and now Turbo Mode is more or less moving this to the
> hardware... I wouldn't be surprised if the sata side will show a similar
> trend)

Currently, ahci is the only one which has controller-side automatic PS
but some ATA devices (hdds) implement device initiated PS (DIPS).  The
sw implementation supports SW HIPS and DIPS.  We can add HW HIPS support
and hook ALPE/ASP support there but I don't think it would have benefits
over SW implementation.

I think it's a bit different from cpufreq.  ATA is cheaper and more
broken and much more diverse.

Thanks.

-- 
tejun
