Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0CITD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:03:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab0CITDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:03:53 -0500
Date: Tue, 9 Mar 2010 14:03:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Nauman Rafique <nauman@google.com>, jens.axboe@oracle.com,
       Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface
	"weight_device" for IO-Controller
Message-ID: <20100309190340.GD8663@redhat.com>
References: <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com> <20100304152400.GB18786@redhat.com> <4B906BB6.3080104@cn.fujitsu.com> <20100305141300.GA3296@redhat.com> <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com> <20100308230905.GB3614@redhat.com> <4B95A9C6.9060504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B95A9C6.9060504@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 09:52:06AM +0800, Gui Jianfeng wrote:

[..]
> >>>> +static int blkio_policy_parse_and_set(char *buf,
> >>>> +                                   struct blkio_policy_node *newpn)
> >>>> +{
> >>>> +     char *s[4], *p, *major_s = NULL, *minor_s = NULL;
> >>>> +     int ret;
> >>>> +     unsigned long major, minor, temp;
> >>>> +     int i = 0;
> >>>> +     dev_t dev;
> >>>> +
> >>>> +     memset(s, 0, sizeof(s));
> >>>> +
> >>>> +     while ((p = strsep(&buf, " ")) != NULL) {
> >>>> +             if (!*p)
> >>>> +                     continue;
> >>>> +
> >>>> +             s[i++] = p;
> >>>> +
> >>>> +             /* Prevent from inputing too many things */
> >>>> +             if (i == 3)
> >>>> +                     break;
> >>>> +     }
> >>>> +
> >>>> +     if (i != 2)
> >>>> +             return -EINVAL;
> >>>> +
> >>>> +     p = strsep(&s[0], ":");
> >>>> +     if (p != NULL)
> >>>> +             major_s = p;
> >>>> +     else
> >>>> +             return -EINVAL;
> >>>> +
> >>>> +     minor_s = s[0];
> >>>> +     if (!minor_s)
> >>>> +             return -EINVAL;
> >>>> +
> >>>> +     ret = strict_strtoul(major_s, 10, &major);
> >>>> +     if (ret)
> >>>> +             return -EINVAL;
> >>>> +
> >>>> +     ret = strict_strtoul(minor_s, 10, &minor);
> >>>> +     if (ret)
> >>>> +             return -EINVAL;
> >>>> +
> >>>> +     dev = MKDEV(major, minor);
> >> I am not quite sure if exposing a mojor,minor number is the best
> >> interface that can be exposed to user space. How about actual disk
> >> names like sda, sdb, .. etc? The only problem I see there is that it
> >> seems tricky to get to these disk names from within the block layer.
> >> "struct request_queue" has a pointer to backing_dev which has a device
> >> from which we can get major,minor. But in order to get to disk name,
> >> we would have to call get_gendisk which can hold a semaphore. Is this
> >> the reason for us going with major,minor as a user interface to
> >> specify a disk? I bet there are good reasons for us not keeping a
> >> pointer to "struct gendisk" from "struct request_queue". If we could
> >> keep that pointer, our user interface could be very easily modified to
> >> be the disk name like sda, sdb, etc.
> > 
> > That's a good question. Why not use device names instead of device
> > numbers? From user's perspective, device names will be more intutive
> > to use.
> > 
> > At the same time, will it look odd to handle devices with their names as WWID.
> > 
> > /dev/mapper/3600508b400105df70000e000026f0000
> > 
> > Though I see that there is an alternate way to address the same device
> > like /dev/dm-2 etc.
> > 
> > So from user's perspective I think it will be more intutive to handle
> > disk names instead of numbers.
> > 
> > Gui, did you forsee issues in implementing disk names?
> 
> Hi Vivek,
> 
> >From the implementation of view, we need a device number as a key in blkio_policy_node, 
> if using device name as user interface, i can't figure out a way to retirve the 
> corresponding device number by means of device name (like sda, not "/dev/sda"). 

Hi Gui,

How about using full device path names (/dev/sda)? "blockdev" utility also
expects full device pathnames. Same seems to be the case with device mapper
targets.

"device" cgroup controller probably is using major and minor numbers because
it needs to control creation of device file (mknod).

May be we can use lookup_bdev() to get block_device pointer and then
get_gendisk() to check if it is a partition.

I am not very sure but device name/path interface might turn out to be
more intutive.

Jens, do you have any thoughts on this?

Thanks
Vivek
