Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZBPCLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZBPCLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZBPCL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:11:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:40415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZBPCL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:11:26 -0500
Message-ID: <4998CB34.6090300@kernel.org>
Date: Mon, 16 Feb 2009 11:11:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Serguei Miridonov <mirsev@cicese.mx>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
References: <200902141206.06419.mirsev@cicese.mx> <49973F4F.1010804@gmail.com> <200902151000.16688.mirsev@cicese.mx> <4998593D.2050300@gmail.com>
In-Reply-To: <4998593D.2050300@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Feb 2009 02:11:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Robert Hancock wrote:
> Serguei Miridonov wrote:
>> Hello Robert and Jeff,
>>
>> Thank you for your replies.
>> On Saturday 14 February 2009, Jeff Garzik wrote:
>>> Serguei Miridonov wrote:
>>>> I have some problems with SATA in a new notebook PC (HP Pavilion
>>>> dv5t, Intel chipset). Seagate FreeAgent Pro 1TB external drivee
>>>> practically can not be used with eSATA in Linux (fresh install
>>>> from DVD Fedora 10, now fully updated), and yesterday I also had
>>>> problem with DVD recording using internal HL-DT-ST BDDVDRW drive.
>>> Some eSata fixes went into the more-recent kernels...  Can you try
>>> 2.6.29-rc5?
>>
>> Unfortunately, right now I can not provide a good testing bed for a
>> new kernel. I was also thinking about bad cable and returned it to the
>> store. Recording DVDs, as you understand, can not be considered for
>> testing: I don't do it on regular basis... I will be looking for a new
>> eSATA cable in a week or two, so when I have it I'll try to download
>> and build the kernel for these experiments.

Please try shorter (or different) cable.  Most eSATA problems are
cabling problems.  Speeding down to 1.5Gbps often improves the
situation a lot (windows might do this by default).  There was a
stupid bug in speeding down logic and speeding down to 1.5Gbps didn't
happen as designed till lately.  The fix went into -stable and should
show up in most distros soon (or just roll your own kernel).

>> I agree with you completely. Nevertheless, something like 10 errors
>> per 2GB transfer can not be the reason to give up. Vista, at least,
>> recovers and continues the data transfer. Linux simply can not return
>> the interface or connected device into operating mode. Do you think it
>> is normal?

Well, there isn't much point in keeping retrying if the same command
fails consecutively.  The problem was the broken speed down logic, so
all the retries failed and FS eventually received IO failure.  Should
have been fixed with recent changes.

....

>>>> It appears that Linux kernel has problems with
>>>> error-handling/reset of SATA hardware. I have found a lot of
>>>> reports regarding SATA problems: data transfer failures, CD/DVD
>>>> recording, waking up from suspend to RAM, etc. Aren't they all
>>>> related? Can Linux SATA chipsets drivers
>>> Not related at all, mostly.. though a lot of people seem to think
>>> they are. Often times people think problems are related because the
>>> error messages seem similar, and even the same error can be
>>> triggered by numerous different problems, often not the fault of
>>> the kernel.

Heh... yeah, this sometimes gets tiring.  Maybe we should reformat ATA
error messages every six month or so?  :-)

Joking aside, yes, there have been and are repeated patterns of
failures.  Some have passed (e.g. the ATAPI transfer length ones) and
some stay (cabling, power).  Nonetheless, in most cases, what people
think they are experiencing isn't quite correct.

>> I'm not talking now about errors triggered by the kernel due to some
>> bugs. What I see in the logs, this is the kernel fault to recover from
>> errors, not causing it. I hope that this is fixed already in newer
>> kernels, though I could not find such information in changelogs.
>>
>> I could be wrong, of course, but it seems to me that if kernel can
>> really reset the interface and return it and connected devices to
>> operating mode, then most of issues mentioned above may become not so
>> critical and people could live with them until root cause is fixed
>> properly.
>>
>> May be resetting the interface will not help is all cases if a device
>> is left in some screwed up state due to earlier poor error handling...
>> Well, this is another issue which can be device-vendor-dependent...
>> However, regarding external Seagate drive, Vista does not have any
>> special driver to handle its errors, it just works...

libata EH actually does pretty good in most cases.  You'll see a lot
of current and archived bug reports but when considering the number of
ATA devices (many of them are crappy) out in the wild and that the
influx of bug reports has gone down considerably, I think it's doing
pretty good.

In the log, ata2.00 went down after a timeout.  The reset per-se isn't
the problem and is the RTTD after a timeout as the controller and
device states are unknown.  The situations like yours in the log often
happens because an ATAPI device shuts down completely after certain
transmission problems.  When this happens, there's nothing much the
driver can do and soft reboot wouldn't recover the device either.

But seeing you're on dv5, I think you might be experiencing something
else.  Please take a look at the following bz.

  http://bugzilla.kernel.org/show_bug.cgi?id=12276

It seems recent HP laptops do something differently and make the ahci
controller behave strangely.  On dv5 and HDX16t, suspend/resume
doesn't work.  The link simply doesn't come up after resuming and this
is the _ONLY_ report of this kind of problem for all intel AHCIs ever,
so yeah HP is doing something.  I'm trying to contact HP about this
but hasn't gotten anywhere yet.

So, you're more likely to be seeing similar problem, I think.  Can you
please test whether you see the same suspend/resume problem?

Thanks.

-- 
tejun
