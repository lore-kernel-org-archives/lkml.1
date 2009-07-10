Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZGJGci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZGJGci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZGJGc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:32:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:37620 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZGJGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MK+Bm90b6vSqSo0XNXtQQXtgwfvRIbhE2ba0dMf1rsRCapdr5SVVFithGe5WUp+RRn
         nvFh61iFl+7XJxCKBwa2BqAhYg628PoCZ5RrrPfXj+Ze73JM1codxitNvc40aexKgKKz
         rM0M0G53RKIsMzGflfCIwo/30Okc2vmoPp1lk=
MIME-Version: 1.0
In-Reply-To: <4A5493A8.2000806@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net> <4A4DE3C1.5080307@vlnb.net>
	 <a0272b440907040819l5289483cp44b37d967440ef73@mail.gmail.com>
	 <4A51DC0A.10302@vlnb.net>
	 <a0272b440907060737n59d4b155lb40c1c6d38ee96dd@mail.gmail.com>
	 <4A5238EC.1070505@vlnb.net>
	 <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com>
	 <4A5395FD.2040507@vlnb.net>
	 <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com>
	 <4A5493A8.2000806@vlnb.net>
Date: Fri, 10 Jul 2009 08:32:26 +0200
Message-ID: <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, hifumi.hisashi@oss.ntt.co.jp,
       linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com,
       randy.dunlap@oracle.com, Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/8 Vladislav Bolkhovitin <vst@vlnb.net>:
> Ronald Moesbergen, on 07/08/2009 12:49 PM wrote:
>>
>> 2009/7/7 Vladislav Bolkhovitin <vst@vlnb.net>:
>>>
>>> Ronald Moesbergen, on 07/07/2009 10:49 AM wrote:
>>>>>>>
>>>>>>> I think, most likely, there was some confusion between the tested and
>>>>>>> patched versions of the kernel or you forgot to apply the io_context
>>>>>>> patch.
>>>>>>> Please recheck.
>>>>>>
>>>>>> The tests above were definitely done right, I just rechecked the
>>>>>> patches, and I do see an average increase of about 10MB/s over an
>>>>>> unpatched kernel. But overall the performance is still pretty bad.
>>>>>
>>>>> Have you rebuild and reinstall SCST after patching kernel?
>>>>
>>>> Yes I have. And the warning about missing io_context patches wasn't
>>>> there during the compilation.
>>>
>>> Can you update to the latest trunk/ and send me the kernel logs from the
>>> kernel's boot after one dd with any block size you like >128K and the
>>> transfer rate the dd reported, please?
>>>
>>
>> I think I just reproduced the 'wrong' result:
>>
>> dd if=/dev/sdc of=/dev/null bs=512K count=2000
>> 2000+0 records in
>> 2000+0 records out
>> 1048576000 bytes (1.0 GB) copied, 12.1291 s, 86.5 MB/s
>>
>> This happens when I do a 'dd' on the device with a mounted filesystem.
>> The filesystem mount causes some of the blocks on the device to be
>> cached and therefore the results are wrong. This was not the case in
>> all the blockdev-perftest run's I did (the filesystem was never
>> mounted).
>
> Why do you think the file system (which one, BTW?) has any additional
> caching if you did "echo 3 > /proc/sys/vm/drop_caches" before the tests? All
> block devices and file systems use the same cache facilities.

I didn't drop the caches because I just restarted both machines and
thought that would be enough. But because of the mounted filesystem
the results were invalid. (The filesystem is OCFS2, but that doesn't
matter).

> I've also long ago noticed that reading data from block devices is slower
> than from files from mounted on those block devices file systems. Can
> anybody explain it?
>
> Looks like this is strangeness #2 which we uncovered in our tests (the first
> one was earlier in this thread why the context RA doesn't work with
> cooperative I/O threads as good as it should).
>
> Can you rerun the same 11 tests over a file on the file system, please?

I'll see what I can do. Just te be sure: you want me to run
blockdev-perftest on a file on the OCFS2 filesystem which is mounted
on the client over iScsi, right?

Ronald.
