Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZCXTAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZCXTAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZCXTAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:00:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:62822 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbZCXTAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qRTUuRZcdrvANpcHdx7md6TkUSX+InGcbzb5N4ZstidjQaIvguQ9PFHzwqsX7Mg6+L
         T3+B4R3N6EHRAHBZmB9wip3+6UEz5Vok6gkDs3I2p/Mu7zUnWVA6sFJ7kfLjxyhHoJfG
         hzDQJGemzcUCCMJPHuVvJ98cRDfEm1vThOfQo=
MIME-Version: 1.0
In-Reply-To: <49C88C80.5010803@krogh.cc>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <49C87B87.4020108@krogh.cc>
	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	 <49C88C80.5010803@krogh.cc>
Date: Tue, 24 Mar 2009 12:00:41 -0700
Message-ID: <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 12:32 AM, Jesper Krogh <jesper@krogh.cc> wrote:
> David Rees wrote:
> The 480 secondes is not the "wait time" but the time gone before the
> message is printed. It the kernel-default it was earlier 120 seconds but
> thats changed by Ingo Molnar back in september. I do get a lot of less
> noise but it really doesn't tell anything about the nature of the problem.
>
> The systes spec:
> 32GB of memory. The disks are a Nexsan SataBeast with 42 SATA drives in
> Raid10 connected using 4Gbit fibre-channel. I'll let it up to you to decide
> if thats fast or slow?

The drives should be fast enough to saturate 4Gbit FC in streaming
writes.  How fast is the array in practice?

> The strange thing is actually that the above process (updatedb.mlocate) is
> writing to / which is a device without any activity at all. All activity is
> on the Fibre Channel device above, but process writing outsid that seems to
> be effected as well.

Ah.  Sounds like your setup would benefit immensely from the per-bdi
patches from Jens Axobe.  I'm sure he would appreciate some feedback
from users like you on them.

>> What's your vm.dirty_background_ratio and
>>
>> vm.dirty_ratio set to?
>
> 2.6.29-rc8 defaults:
> jk@hest:/proc/sys/vm$ cat dirty_background_ratio
> 5
> jk@hest:/proc/sys/vm$ cat dirty_ratio
> 10

On a 32GB system that's 1.6GB of dirty data, but your array should be
able to write that out fairly quickly (in a couple seconds) as long as
it's not too random.  If it's spread all over the disk, write
throughput will drop significantly - how fast is data being written to
disk when your system suffers from large write latency?

>>> Consensus seems to be something with large memory machines, lots of dirty
>>> pages and a long writeout time due to ext3.
>>
>> All filesystems seem to suffer from this issue to some degree.  I
>> posted to the list earlier trying to see if there was anything that
>> could be done to help my specific case.  I've got a system where if
>> someone starts writing out a large file, it kills client NFS writes.
>> Makes the system unusable:
>> http://marc.info/?l=linux-kernel&m=123732127919368&w=2
>
> Yes, I've hit 120s+ penalties just by saving a file in vim.

Yeah, your disks aren't keeping up and/or data isn't being written out
efficiently.

>> Only workaround I've found is to reduce dirty_background_ratio and
>> dirty_ratio to tiny levels.  Or throw good SSDs and/or a fast RAID
>> array at it so that large writes complete faster.  Have you tried the
>> new vm_dirty_bytes in 2.6.29?
>
> No.. What would you suggest to be a reasonable setting for that?

Look at whatever is there by default and try cutting them in half to start.

>> Everyone seems to agree that "autotuning" it is the way to go.  But no
>> one seems willing to step up and try to do it.  Probably because it's
>> hard to get right!
>
> I can test patches.. but I'm not a kernel-developer.. unfortunately.

Me either - but luckily there have been plenty chiming in on this thread now.

-Dave
