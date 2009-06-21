Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZFUN5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZFUN5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZFUN5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:57:31 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:37942 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZFUN5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gb8d3+wtO8s43mXhRAQ4ENXvDhE2+72b8fA6ErJt7yoImKPxvYeHe8k4zVAp+vCC4N
         guJK7Br2XB0g0t1qTGuBU8wFk16hwkXuSknsVYORn4FfucHcHLfddNFbLW69Tw6GMmRM
         jo82JtZIa8CpLstnoODbj3ItvGLh5fS/GlseE=
Message-ID: <4A3E3C49.7010907@googlemail.com>
Date: Sun, 21 Jun 2009 14:57:29 +0100
From: Ken Milmore <ken.milmore@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Write barriers on MD RAID1
References: <4A188CAD.1080009@googlemail.com> <0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name>
In-Reply-To: <0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I had better bump my previous post as this regression is still 
present in 2.6.29.5.

To recap, commit cec0707e40ae25794b5a2de7b7f03c51961f80d9 has broken 
write barriers on md raid1 block devices in 2.6.29 and later kernels. 
Reversing this commit appears to fix the problem.

Please let me know if I'm harassing the wrong maintainers here!

-Ken.


NeilBrown wrote:
> On Sun, May 24, 2009 9:54 am, Ken Milmore wrote:
>> Support for write barriers on MD RAID1 devices appears to be broken on
>> 2.6.29 and later kernels.  Mounting an ext3 or ext4 filesystem over an
>> md raid1 block device gives the kernel message:
>>
>>    JBD: barrier-based sync failed on md0 - disabling barriers
>>
>> Is this intentional?  It looks like a regression to me, since write
>> barriers (ostensibly) worked for MD RAID1 on earlier kernels (well, all
>> of the 2.6.27 series at least...)
>>
>> Doing a git bisect suggested that this is the culprit:
>>
>> commit cec0707e40ae25794b5a2de7b7f03c51961f80d9
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date:   Tue Jan 13 15:28:32 2009 +0100
>>
>>      block: silently error an unsupported barrier bio
> 
> Yes, that patch is broken.
> the new code it introduces should probably go in the top of
> __make_request rather than just before the call to ->make_request_fn.
> make_request_fn functions other than __make_request generally
> don't use ->next_ordered at all.
> 
> Jens?  Would you agree?
> 
> NeilBrown
> 
> 
>> Rolling this back from 2.6.29.4 made the JBD error message go away for
>> me.  I tried to do some disk benchmarking to determine if write barriers
>> were really still working, but the results were not very conclusive.
>>
>> Details of test setup:
>> - 2.6.29.4 kernel (config from slackware-current)
>> - ext3 filesystem (mounted with barrier=1), also tried ext4
>> - MD RAID1 block device over two SATA disks
>> - Intel motherboard AHCI controller (82801)
>>
>> I got similar behaviour on a virtualised setup using qemu, with the RAID
>> over two emulated IDE disks.
>>
>> Please contact me if I can provide any further information.
>>
>> -Ken Milmore.
>>
> 
> 

