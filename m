Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZC0Jt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZC0Jt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbZC0Jtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:49:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59562 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbZC0Jtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:49:46 -0400
Message-ID: <49CCA122.8070908@jp.fujitsu.com>
Date: Fri, 27 Mar 2009 18:49:22 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 3/3] x86, mce: Add mce=nopoll option to disable timer
 polling
References: <49CB3F4B.8070406@jp.fujitsu.com> <49CB4453.6000407@linux.intel.com>
In-Reply-To: <49CB4453.6000407@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto wrote:
>> This patch adds "mce=nopoll" option to disable timer polling
>> for corrected errors from boot.  Unlike "mce=off", it doesn't
>> prevent handling for uncorrected errors.
>>
>> It is useful if:
>>  - You don't have any interests in corrected errors. You may
>>    use option mce_threshold=0 to disable cmci too.
>>  - You'd like to care banks only which cmci are supported.
> 
> These two seem to be conflicting. CMCI errors are corrected errors
> too. Why would the user care about the reporting mechanism
> and only shut down one or not another?

Separate the two in different case.
The first case is easy to understand.
The second case is ... yes, unusual request.

I think these 2 mechanism, polling and threshold interrupt, can
be used in parallel, because there are errors having various
characteristics.

Assume that:
 error A : Easily happen (i.e. once in every minute)
   polling   : o (with long interval preferred)
   interrupt : o (with high threshold) 
 error B : Burst in short time once happened
   polling   : o
   interrupt : x (low threshold will be storm of interrupt,
                  high threshold cannot report the error) 
 error C : Rarely happen (bit serious?)
   polling   : x (waste of CPU)
   interrupt : o (with low threshold) 

However still I could not find situation where the second case
is reasonable...  Well, it was bad example.  Please ignore.

> Also I'm not sure a boot argument is really needed. Isn't it
> good enough to do this early at boot through sysfs?

Maybe it is good for this option, as far as polling never run
so soon.  Because sysfs is available after start of polling
timer, boot argument is required just in theory of logics.

>>  - You have an application such as hardware monitor that
>>    checks error banks, and that can conflict with OS's polling.
> 
> Well then your patch is not enough because it doesn't shut off
> boot time clearing/logging of corrected errors left over from
> boot for once. And CMCI.

This case also requires mce_threshold=0 to shut off CMCI like
the first case.  I should wrote down it for this third case too.

I don't think it is really required, but if the bootlog, that left
over from previous boot, is required by the application, then the
application should use /dev/mcelog.  If all works well, there would
be left-overred CE and/or UE, or recovered UE that happened after
the boot.  Isn't it easy? 

>>  - Your system have an intelligent BIOS which can provide
>>    enough health information, so reports from OS is redundant.
> 
> It would seem inconvenient then to require the user to set a special
> boot option. I think it would be better if the BIOS set a flag
> somewhere that the kernel can check.

Of course there would be no such inconvenient if BIOS can prohibit
OS capability (by hiding resources etc.), and/or if there are good
interface for such use between OS and BIOS.
But there is not such interface yet.  And I think setting option is
reasonably quick and convenient way at this time, rather than
requesting/waiting revised BIOS and/or new specification for the
interface.

>> Once booted, we can disable polling by setting check_interval
>> to 0, but there are no mention about the fact.
> 
> That's true, Documentation/x86/x86_64/machinecheck should be fixed
> to say 0 means no polling. I'm not sure new boot option are the
> preferred fix for missing documentation though @)

Indeed.

One another problem is that there are multiple documentations for
machinecheck parameters, but not linked well:

 - Documentation/kernel-parameters.txt
    ("See Documentation/x86/x86_64/boot-options.txt" for "mce=")
 - Documentation/x86/x86_64/boot-options.txt
    ("AMD64 specific boot options" is not true now!)
 - Documentation/x86/x86_64/machinecheck
    (which I had not noticed the existence at first, oops!)

>>  static int check_interval = 5 * 60; /* 5 minutes */
>> @@ -633,11 +635,12 @@ static void mce_init_timer(void)
>>  {
>>  	struct timer_list *t = &__get_cpu_var(mce_timer);
>>  
>> +	/* Disable polling if check_interval is 0 */
>> +	if (!check_interval)
>> +		return;
> 
> This check shouldn't be needed, the next two checks already do that.

That is for readability improvement.

+	/* Disable polling if check_interval is 0 */
+	if (!check_interval)
+		return;
 	/* data race harmless because everyone sets to the same value */
 	if (!next_interval)
 		next_interval = check_interval * HZ;
-	if (!next_interval)
-		return;

Are there any case where the HZ becomes 0?

> Also there's a conflicting patch pending which moves next_interval
> to be per CPU.

Even if next_interval becomes per CPU, global check_interval can live
with it.  I don't mind doing rebase my patches on top of your pending
patches, so if prepared please send your patches to LKML (CC-ing me)
any time soon.


Thanks,
H.Seto

