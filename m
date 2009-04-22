Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZDVDLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZDVDLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 23:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZDVDLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 23:11:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZDVDLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 23:11:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HroNd5lWfjyJFUZ0p70Glx0Efb74YQCHdeEnnMaN9oO4C4urNDWBKohq5xN6LYcvS
	ZCUcGI4G26QoxUZY6aZ8w==
MIME-Version: 1.0
In-Reply-To: <49EE895A.1060101@cn.fujitsu.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	 <49DF1256.7080403@cn.fujitsu.com> <20090413130958.GB18007@redhat.com>
	 <49EE895A.1060101@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 20:10:56 -0700
Message-ID: <e98e18940904212010m5b2e00f9xda32cb2c9594ca29@mail.gmail.com>
Subject: Re: [RFC] IO Controller
From: Nauman Rafique <nauman@google.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 8:04 PM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Vivek Goyal wrote:
>> On Fri, Apr 10, 2009 at 05:33:10PM +0800, Gui Jianfeng wrote:
>>> Vivek Goyal wrote:
>>>> Hi All,
>>>>
>>>> Here is another posting for IO controller patches. Last time I had posted
>>>> RFC patches for an IO controller which did bio control per cgroup.
>>>   Hi Vivek,
>>>
>>>   I got the following OOPS when testing, can't reproduce again :(
>>>
>>
>> Hi Gui,
>>
>> Thanks for the report. Will look into it and see if I can reproduce it.
>
>  Hi Vivek,
>
>  The following script can reproduce the bug in my box.
>
> #!/bin/sh
>
> mkdir /cgroup
> mount -t cgroup -o io io /cgroup
> mkdir /cgroup/test1
> mkdir /cgroup/test2
>
> echo cfq > /sys/block/sda/queue/scheduler
> echo 7 > /cgroup/test1/io.ioprio
> echo 1 > /cgroup/test2/io.ioprio
> echo 1 > /proc/sys/vm/drop_caches
> dd if=1000M.1 of=/dev/null &
> pid1=$!
> echo $pid1
> echo $pid1 > /cgroup/test1/tasks
> dd if=1000M.2 of=/dev/null
> pid2=$!
> echo $pid2
> echo $pid2 > /cgroup/test2/tasks
>
>
> rmdir /cgroup/test1
> rmdir /cgroup/test2
> umount /cgroup
> rmdir /cgroup

Yes, this bug happens when we move a task from a cgroup to another
one, and delete the cgroup. Since the actual move to the new cgroup is
performed in a delayed fashion, if the cgroup is removed before
another request from the task is seen (and the actual move is
performed) , it results in a hit on BUG_ON. I am working on a patch
that will solve this problem and a few others; basically it would do
ref counting  for io_group structure. I am having a few problems with
it at the moment; will post the patch as soon as I can get it to work.

>
> --
> Regards
> Gui Jianfeng
>
>
>
>
