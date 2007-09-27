Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbXI0GZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbXI0GZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbXI0GZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:25:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47193 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbXI0GZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:25:12 -0400
Message-ID: <46FB4CB3.3090004@garzik.org>
Date: Thu, 27 Sep 2007 02:24:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com> <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>
In-Reply-To: <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On 9/27/07, Tejun Heo <htejun@gmail.com> wrote:
>> Tejun Heo wrote:
>>> Torsten Kaiser wrote:
>>>> Comparing the driver/ata directory from rc3-mm1 and rc4-mm1 the
>>>> following change looked the most suspicions to me:
>>>> http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=blobdiff;f=drivers/ata/sata_sil24.c;h=3dcb223117be9739ee04d70b6bfc776a4b839a3f;hp=e0cd31aa8002350add53ba6ff07493e503275244;hb=020bc1bd8d369a77bd9379cd9763ac0057651753;hpb=8d4bdf8087e682df98bdb856f6ad451bf6d597e7
>>>>
>>>> That after rc4-mm1 the sata_sil24.c did not change anymore also
>>>> matches the occurrence of the error.
>>>>
>>>> To confirm my theorie I exchanged the sata_sil24.c from rc8-mm1 with
>>>> the version from rc3-mm1.
>>>> I was able to boot the resulting kernel successfully 5 times, without
>>>> the error happening again.
>>> Thanks a lot for chasing down the problem.  The changed code is address
>>> initialization path and it's weird that it causes intermittent failures,
>>> not a consistent one.
>>>
>>> Anyways, does the attached patch fix the problem?
> 
> I'm starting to *really* hate that bug.
> My analysis was wrong, as I booted to modified 2.6.23-rc8-mm1 this
> morning, that failed too. (Same error messages as -rc7-mm1 from the
> first mail in this thread.)
> So it's not that change that causes the breakage.
> 
> And I'm not really finding a good pattern to what boots fail and what work.
> It seems to only fail, if I completely power off the system for
> several hours. (Using the physical switch at the backside of the
> powersupply, not the normal soft-off)
> 
> One of the five boots I tried yesterday, I also powered the system
> completely off that way, but only leaving it off ~10..20 seconds
> seemed not to trigger the bug.
> 
> But I still think that is not a hardware failure, as the -rc3-mm1
> kernel never showed that error, even when I used it several times
> after the first -rc4-mm1 failures.
> 
>> If not, can you add printk of iomap[SIL24_PORT_BAR], offset, initialized
>> cmd_addr and scr_addr in the loop and see whether anything is different
>> between when the driver works and fails.
> 
> Should I do this anyway?
> 
> I compared the dmesg form good and bad boots with -rc7-mm1 but could
> not see any difference, so do you think that these additional
> diagnostics could show a difference?
> Or could you suggest any other debugging options I should try?

I think since its a reproducible problem, I think it's easiest to get 
you straight to git-bisect.  In this case, that would be

1. Clone branch "upstream" of 
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

2. Test.  If bug persists, you have narrowed down the problem to the -mm 
changes from the SATA developers, that are to be sent for 2.6.24.  If 
the problem does not persist, then it's a problem added in the -mm 
patchset alone, which carries few ATA patches outside of libata-dev.git.

3. If the problem is in libata-dev.git#upstream (likely), you can now 
use git-bisect to find the specific commit that causes the problems. 
Read the git-bisect man page for full details, but the basics are

	a) start with a known good point (v2.6.22? v2.6.23?) and
	known bad point (HEAD, aka the most recent commit in
	libata-dev.git#upstream)

	b) build and boot kernels, marking each as known-good or
	known-bad.

	c) This process will systematically narrow down the problem
	to a single git commit.

Regards,

	Jeff



