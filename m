Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZBEVkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZBEVkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZBEVkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:40:10 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52115 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZBEVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:40:09 -0500
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Shakesh Jain <shjain@akamai.com>, ShakeshJain@akamai.com,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com
References: <20090204084022.GB14071@akamai.com>
	<20090205122941.17805ff1.akpm@linux-foundation.org>
	<m1zlh0txgj.fsf@fess.ebiederm.org>
	<20090205211933.GA13312@x200.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 05 Feb 2009 13:40:05 -0800
In-Reply-To: <20090205211933.GA13312@x200.localdomain> (Alexey Dobriyan's message of "Fri\, 6 Feb 2009 00\:19\:34 +0300")
Message-ID: <m1fxissgui.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, juhlenko@akamai.com, linux-kernel@vger.kernel.org, ShakeshJain@akamai.com, shjain@akamai.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] sysctl: min-max range check is broken
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

>> Yep.  There is an inconsistency here.  Given how sysctl is used and
>> tested, and the fact I could not find where it appears that anyone is
>> passing an array into min/max I would say that the proc version is
>> correct and the sysctl version is wrong.
>> 
>> The untested patch below looks like it will fix the this.
>> 
>> I don't know if there are any cases where we use minmax with an array
>> of integers but I don't see the point of using an array of minmax
>> values at this point.
>
> Multiple values, each one is bounded by it's own set of values.

Nack.  That is a change to the users of sysctl.   An array
of minmax values appears to be a brand new extension therefore
we should not make this change.

If we want new behavior we should introduce new helpers.

>> For the original sysctl design it may have made
>> some sense.  New code should be one value per file.
>
> So leave them alone.

Sure. My point is that we don't care about this for new code.
Old code was tested and used with the proc version.

NO ONE uses sys_sysctl NO ONE.

>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -2916,9 +2916,9 @@ int sysctl_intvec(struct ctl_table *table,
>>  			int value;
>>  			if (get_user(value, vec + i))
>>  				return -EFAULT;
>> -			if (min && value < min[i])
>> +			if (min && value < *min)
>>  				return -EINVAL;
>> -			if (max && value > max[i])
>> +			if (max && value > *max)
>>  				return -EINVAL;
>
> Correct way is:
>
> 	min[i] <= val[i] <= max[i]
>
> This is what sysctl_intvec() does.

Therefore sysctl_intvec is wrong because it does not match
proc_dointvec_minmax.  proc_dointvec_minmax is definitive as that what
people use and test.  sysctl_intvec is a vestigial appendage that
was never really used, and it is already deprecated and scheduled for
remove because of this.

The only way to support the case of arrays of minmax values is to
show code that cares.  I did not see anyone passing in an array
in .extra one.  So you are advocating code that will walk around
and read random values from the kernels .data section.  Which
is VERY broken.

Eric




