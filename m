Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0CIUjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:39:42 -0500
Received: from smtp-out.google.com ([216.239.33.17]:9459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0CIUjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:39:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=GQ1/EMXeRRUlLm8g8ozHuLspbPYIaxZOv2hisGh2cD3BhxLkChFuSPagzxz2L4Ljw
	KSjmSdh2PewC7XrCQJ9TQ==
MIME-Version: 1.0
In-Reply-To: <20100309201656.GA3013@redhat.com>
References: <20100303143311.GA2866@redhat.com> <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> 
	<1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> 
	<4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com> 
	<20100304152400.GB18786@redhat.com> <4B906BB6.3080104@cn.fujitsu.com> 
	<20100305141300.GA3296@redhat.com> <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com> 
	<20100309201656.GA3013@redhat.com>
From: Nauman Rafique <nauman@google.com>
Date: Tue, 9 Mar 2010 12:39:08 -0800
Message-ID: <e98e18941003091239h665cc812o498301fadade6de6@mail.gmail.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface "weight_device" 
	for IO-Controller
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jens.axboe@oracle.com,
       Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 12:16 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Mar 08, 2010 at 11:39:54AM -0800, Nauman Rafique wrote:
> [..]
>> >> +static int blkio_policy_parse_and_set(char *buf,
>> >> +                                   struct blkio_policy_node *newpn)
>> >> +{
>> >> +     char *s[4], *p, *major_s = NULL, *minor_s = NULL;
>> >> +     int ret;
>> >> +     unsigned long major, minor, temp;
>> >> +     int i = 0;
>> >> +     dev_t dev;
>> >> +
>> >> +     memset(s, 0, sizeof(s));
>> >> +
>> >> +     while ((p = strsep(&buf, " ")) != NULL) {
>> >> +             if (!*p)
>> >> +                     continue;
>> >> +
>> >> +             s[i++] = p;
>> >> +
>> >> +             /* Prevent from inputing too many things */
>> >> +             if (i == 3)
>> >> +                     break;
>> >> +     }
>> >> +
>> >> +     if (i != 2)
>> >> +             return -EINVAL;
>> >> +
>> >> +     p = strsep(&s[0], ":");
>> >> +     if (p != NULL)
>> >> +             major_s = p;
>> >> +     else
>> >> +             return -EINVAL;
>> >> +
>> >> +     minor_s = s[0];
>> >> +     if (!minor_s)
>> >> +             return -EINVAL;
>> >> +
>> >> +     ret = strict_strtoul(major_s, 10, &major);
>> >> +     if (ret)
>> >> +             return -EINVAL;
>> >> +
>> >> +     ret = strict_strtoul(minor_s, 10, &minor);
>> >> +     if (ret)
>> >> +             return -EINVAL;
>> >> +
>> >> +     dev = MKDEV(major, minor);
>>
>> I am not quite sure if exposing a mojor,minor number is the best
>> interface that can be exposed to user space. How about actual disk
>> names like sda, sdb, .. etc? The only problem I see there is that it
>> seems tricky to get to these disk names from within the block layer.
>> "struct request_queue" has a pointer to backing_dev which has a device
>> from which we can get major,minor. But in order to get to disk name,
>> we would have to call get_gendisk which can hold a semaphore. Is this
>> the reason for us going with major,minor as a user interface to
>> specify a disk? I bet there are good reasons for us not keeping a
>> pointer to "struct gendisk" from "struct request_queue". If we could
>> keep that pointer, our user interface could be very easily modified to
>> be the disk name like sda, sdb, etc.
>
> Hi Nauman,
>
> Do we really store a device name in "struct gendisk"? IIUC, a disk is
> identified by its major and minor number and then there can be multiple
> device files pointing to same disk.
>
> So I have a disk /dev/sdc in my system and I created another alias to
> same disk using mknod and mounted the disk using the alias.
>
> mknod /dev/sdc-alias b 8 32
> mount /dev/sdc-alias /mnt
>
> If that's the case, there is no way gendisk can store the pathname.
> Instead, device file has inode associated with it, and there we store
> major, minor number of disk, and using that we operate on disk/partition.

You are right, you can create more aliases to point the same device.
But there is one name stored in disk_name field of struct gendisk. And
I guess this is the same name that you will see if you do "ls
/sys/block/". block layer exposes all its sysfs variables going
through the disk names. For example, if you have to switch a scheduler
on a block device, you would use the name like sdb and do "echo cfq >
/sys/block/sdb/queue/scheduler". The same holds true if you want to
change a io scheduler specific tunable, e.g.
/sys/block/sdb/queue/iosched/back_seek_max.

My point is that all per device interfaces in the io cgroup category
should use the same device names; this includes all the stats
reporting, interfaces to set weights, and so on. And not come up with
a different way of identifying devices.

>
> If that's the case, then major/minor number based interface for blkio
> makes sense. Because we also need to export stats regarding the disk
> time consumed by cgroup on a particular device, the only unique identifier
> of the disk seems to be {major,minor} pair and multiple block device
> files can be pointing to same disk. Because it is many to one mapping, it
> will not be possible to reverse map it.
>
> So I guess we need to continue to handle rules and stats using major/minor
> numbers. One improvement probably we can do and that is allow setting
> rules both by major/minor number and device file path. But internally
> cgroup code will map device file path to major minor numbers and rules
> will be displayed against major/minor number and not original device path.
>
> Thanks
> Vivek
>
