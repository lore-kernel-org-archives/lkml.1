Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbZGPQE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbZGPQE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932487AbZGPQEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:04:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbZGPQEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:04:24 -0400
Message-ID: <4A5F4F59.8000303@vlnb.net>
Date: Thu, 16 Jul 2009 20:03:37 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net> <4A5493A8.2000806@vlnb.net>	 <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>	 <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net>	 <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com>	 <4A5CD3E2.2060307@vlnb.net> <4A5D7794.2070607@vlnb.net>	 <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>	 <4A5F0293.3010206@vlnb.net> <a0272b440907160754j3545f4dby13882ea1ab964222@mail.gmail.com>
In-Reply-To: <a0272b440907160754j3545f4dby13882ea1ab964222@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19zUHdvsIhet0a7f1IGMV8sL77Rld4i+jkkU6Z
 /gtjxtxoQWQ+ALJTuHnmwqrlXxwujIhqgFum2kkiONMHaQC5yV
 qgMbYs40eevPEeBHB2GxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ronald Moesbergen, on 07/16/2009 06:54 PM wrote:
> 2009/7/16 Vladislav Bolkhovitin <vst@vlnb.net>:
>> Ronald Moesbergen, on 07/16/2009 11:32 AM wrote:
>>> 2009/7/15 Vladislav Bolkhovitin <vst@vlnb.net>:
>>>>> The drop with 64 max_sectors_kb on the client is a consequence of how
>>>>> CFQ
>>>>> is working. I can't find the exact code responsible for this, but from
>>>>> all
>>>>> signs, CFQ stops delaying requests if amount of outstanding requests
>>>>> exceeds
>>>>> some threshold, which is 2 or 3. With 64 max_sectors_kb and 5 SCST I/O
>>>>> threads this threshold is exceeded, so CFQ doesn't recover order of
>>>>> requests, hence the performance drop. With default 512 max_sectors_kb
>>>>> and
>>>>> 128K RA the server sees at max 2 requests at time.
>>>>>
>>>>> Ronald, can you perform the same tests with 1 and 2 SCST I/O threads,
>>>>> please?
>>> Ok. Should I still use the file-on-xfs testcase for this, or should I
>>> go back to using a regular block device?
>> Yes, please
> 
> As in: Yes, go back to block device, or Yes use file-on-xfs?

File-on-xfs :)

>>> The file-over-iscsi is quite
>>> uncommon I suppose, most people will export a block device over iscsi,
>>> not a file.
>> No, files are common. The main reason why people use direct block devices is
>> a not supported by anything believe that comparing with files they "have
>> less overhead", so "should be faster". But it isn't true and can be easily
>> checked.
> 
> Well, there are other advantages of using a block device: they are
> generally more manageble, for instance you can use LVM for resizing
> instead of strange dd magic to extend a file. When using a file you
> have to extend the volume that holds the file first, and then the file
> itself.

Files also have advantages. For instance, it's easier to backup them and 
move between servers. On modern systems with fallocate() syscall support 
you don't have to do "strange dd magic" to resize files and can nearly 
instantaneously make them bigger. Also with pretty simple modifications 
scst_vdisk can be improved to make a single virtual device from several 
files.

> And you don't lose disk space to filesystem metadata twice.

This is negligible (0.05% for XFS)

> Also, I still don't get why reads/writes from a blockdevice are
> different in speed than reads/writes from a file on a filesystem.

Me too and I'd appreciate if someone explain it. But I don't want to 
introduce one more variable in the task we are solving (how to make 
100+MB/s from iSCSI on your system).

> I
> for one will not be using files exported over iscsi, but blockdevices
> (LVM volumes).

Are you sure?

> Ronald.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
