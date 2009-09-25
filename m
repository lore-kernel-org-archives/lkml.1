Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZIYEQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZIYEQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZIYEQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:16:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33788 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZIYEQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:16:30 -0400
Date: Fri, 25 Sep 2009 06:16:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mbroz@redhat.com, tytso@mit.edu, mingo@elte.hu
Subject: Re: [PATCH] Add missing blk_trace_remove_sysfs to be in pair with
	blk_trace_init_sysfs
Message-ID: <20090925041633.GQ23126@kernel.dk>
References: <c4e36d110909210307m6579807ehe4d659053c4dc696@mail.gmail.com> <4AB86A03.7060207@cn.fujitsu.com> <c4e36d110909220057q6d9ce816yfcec7de4849c1969@mail.gmail.com> <4ABAC663.60906@cn.fujitsu.com> <c4e36d110909240326k16bf40cdpfa4b818d1a24a25f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4e36d110909240326k16bf40cdpfa4b818d1a24a25f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24 2009, Zdenek Kabelac wrote:
> 2009/9/24 Li Zefan <lizf@cn.fujitsu.com>:
> >>>> Subject: [PATCH] Add missing blk_trace_remove_sysfs to be in pair with
> >>>> blk_trace_init_sysfs
> >>>> From: Zdenek Kabelac <zkabelac@redhat.com>
> >>>>
> >>>> Adds missing blk_trace_remove_sysfs() to be in pair with
> >>>> blk_trace_init_sysfs() introduced in commit
> >>>> 1d54ad6da9192fed5dd3b60224d9f2dfea0dcd82.
> >>>>
> >>>> Problem was noticed via kmemleak backtrace when some sysfs entries
> >>>> were note properly destroyed during  device removal:
> >>>>
> >>> Thanks for reporting and fixing this!
> >>>
> >>>> @@ -465,6 +466,7 @@ void blk_unregister_queue(struct gendisk *disk)
> >>>>
> >>>>               kobject_uevent(&q->kobj, KOBJ_REMOVE);
> >>>>               kobject_del(&q->kobj);
> >>>> +             blk_trace_remove_sysfs(disk_to_dev(disk));
> >>> This should be moved outside of 'if'.
> >>>
> >>
> >> I was not really sure about the proper place - if it could be placed
> >> before if() or after the if(){} - as I've not checked in depth
> >
> > Just use the reverse order against blk_register_queue() should be fine.
> 
> Yes - I think the order of release is correct.
> 
> >
> >> connection between kobj and sysfs. It's somewhat unclear why all the
> >> kobject operation are only within this if(){} block - so I've thought
> >> there is some reason...
> >> IMHO only elv_unregister_queue() should be probably in the if(){} block.
> >>
> >
> > Seems it's a bug to put kobject_put(dev->kobj) in the if block.
> >
> > I created a stacked device (mdadm) and kmemleak still reported leaks
> > even after I fixed the blktrace issue. And then I moved kobejct_put()
> > outside the if, no more leaks reports.
> >
> 
> Ok - I didn't have a testcase where the request_fn would be NULL.
> So in this case I propose this patch:
> 
> ---
> Add missing blk_trace_remove_sysfs to be in pair with blk_trace_init_sysfs
> introduced in commit 1d54ad6da9192fed5dd3b60224d9f2dfea0dcd82.
> Release kobject also in case the request_fn is NULL.
> 
> Problem was noticed via kmemleak backtrace when some sysfs entries were
> note properly destroyed during  device removal:

Thanks, this looks good now, applied.

-- 
Jens Axboe

