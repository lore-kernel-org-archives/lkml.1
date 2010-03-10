Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab0CJSD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:03:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578Ab0CJSDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:03:55 -0500
Date: Wed, 10 Mar 2010 13:03:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Nauman Rafique <nauman@google.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface
	"weight_device" for IO-Controller
Message-ID: <20100310180336.GC10738@redhat.com>
References: <20100304152400.GB18786@redhat.com> <4B906BB6.3080104@cn.fujitsu.com> <20100305141300.GA3296@redhat.com> <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com> <20100308230905.GB3614@redhat.com> <4B95A9C6.9060504@cn.fujitsu.com> <20100309190340.GD8663@redhat.com> <4B96E8CC.9080803@cn.fujitsu.com> <20100310153032.GB10738@redhat.com> <1786ab031003100938x19e7c054ieba6c34ebd939ad6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1786ab031003100938x19e7c054ieba6c34ebd939ad6@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 09:38:35AM -0800, Chad Talbott wrote:
> On Wed, Mar 10, 2010 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > This still leaves the issue of reaching a gendisk object from request
> > queue. Looking into it.
> 
> It looks like we have that pairing way back in blk_register_queue()
> which takes a gendisk.  Is there any reason we don't hold onto the
> gendisk there?  Eyeballing add_disk() and unlink_gendisk() seems to
> confirm that gendisk lifetime spans request_queue.
> 

Yes, looking at the code, it looks like gendisk and request_queue object's
lifetime is same and probably we can store a pointer to gendisk in
request_queue at blk_register_queue() time. And then use this pointer to
retrieve gendisk->disk_name to report stats.

> Nauman and I were also wondering why blkio_group and blkio_policy_node
> store a dev_t, rather than a direct pointer to gendisk.  dev_t seems
> more like a userspace<->kernel interface than an inside-the-kernel
> interface.
> 

blkio_policy_node currently can't store a pointer to gendisk because there
is no mechanism to call back into blkio if device is removed. So if we
implement something so that once device is removed, blkio layer gets a
callback and we cleanup any state/rules associated with that device, then
I think we should be able to store the pointer to gendisk.

I am still trying to figure out how elevator/ioscheduler state is cleaned
up if a device is removed while some IO is happening to it.

OTOH, Gui, may be one can use blk_lookup_devt() to lookup the dev_t of a
device using the disk name (sda). I just noticed it while reading the
code.

Thanks
Vivek
