Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYCWSEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYCWSEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 14:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYCWSEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 14:04:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:54436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYCWSEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 14:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=R1J0xgd63vA2MYtIcL9C01PnAjr/Wn5C34jMj4dyplPgZQwfjS21HER/jXntR04g4uigqGAq7DxbfpB4vfaxy4+nVULxdjj3P0P3agRVpeScBNfYhbsv8vDltmr3uq/4+ddsl3Rg3JECE40wyX+sQKD4yWoSSdXQQNfccjTHne4=
Message-ID: <47E69BB3.3050508@gmail.com>
Date: Sun, 23 Mar 2008 21:04:35 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080322173500.7b8b6751.akpm@linux-foundation.org>
In-Reply-To: <20080322173500.7b8b6751.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 22 Mar 2008 13:24:54 -0700 David Brownell <david-b@pacbell.net> wrote:
>
>   
>> I noticed this with 2.6.25-rc2 (if not before), and the problem
>> is still there with 2.6.25-rc6-git (as of this AM).
>>
>> System is an Athlon64 single CPU laptop, and instead of reading a
>> few dozen wakeups per second, it says a many tens of thousands...
>> clearly wrong.  In previous kernels it gave more plausible counts;
>> unfortunately high because of various un-evolved desktop tools in
>> this Ubuntu system (Feisty).
>>
>> Possibly more truthful, it says that the system never enters
>> C1 or C2, and spends all its time in C0.  Though if I look at
>> /sys/devices/system/cpu/cpu0/cpuidle/state[01]/usage, that
>> seems to tell a different story ... it's C0 that's never used.
>> In previous kernels it reported time in both C0 and C2.  ISTR
>> some patch to avoid C2, which would explain part of this.
>>
>> Comments or fixes, anyone?
>>     
There are patches in #9998, which fix irq storm in ACPI EC GPE.
It looks like this storm was already present at least in .22 kernel.
I was able to trace it down to HW failure to clear status bit of
corresponding GPE, so as soon as we return from serving one interrupt,
we get another. It would be great if we find why we can't clear this bit.
It does not seem to be IO access issue, as enable bit is in adjacent 8-bit
register and write to it succeeds. I've seen patch for calling _PSW for all
possible wake devices, as it might be constantly waking us even in runtime,
but it seems to not help.
>
> This is likely to be an acpi regression, isn't it?
>
> A git-bisect would be nice, please.
>   
Might be long too, if it was present in .22...
It would be nice if you can at least tell the latest good point.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

