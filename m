Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab0CJUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:32:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0CJUcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:32:05 -0500
Date: Wed, 10 Mar 2010 15:31:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Nauman Rafique <nauman@google.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface
	"weight_device" for IO-Controller
Message-ID: <20100310203155.GA3009@redhat.com>
References: <4B906BB6.3080104@cn.fujitsu.com> <20100305141300.GA3296@redhat.com> <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com> <20100308230905.GB3614@redhat.com> <4B95A9C6.9060504@cn.fujitsu.com> <20100309190340.GD8663@redhat.com> <4B96E8CC.9080803@cn.fujitsu.com> <20100310153032.GB10738@redhat.com> <1786ab031003100938x19e7c054ieba6c34ebd939ad6@mail.gmail.com> <20100310180336.GC10738@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310180336.GC10738@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 01:03:36PM -0500, Vivek Goyal wrote:
> On Wed, Mar 10, 2010 at 09:38:35AM -0800, Chad Talbott wrote:
> > On Wed, Mar 10, 2010 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > This still leaves the issue of reaching a gendisk object from request
> > > queue. Looking into it.
> > 
> > It looks like we have that pairing way back in blk_register_queue()
> > which takes a gendisk.  Is there any reason we don't hold onto the
> > gendisk there?  Eyeballing add_disk() and unlink_gendisk() seems to
> > confirm that gendisk lifetime spans request_queue.
> > 
> 
> Yes, looking at the code, it looks like gendisk and request_queue object's
> lifetime is same and probably we can store a pointer to gendisk in
> request_queue at blk_register_queue() time. And then use this pointer to
> retrieve gendisk->disk_name to report stats.
> 

Well, gendisk and request_queue have little different life span. Following
seems to be the sequence a block driver follows.

	blk_init_queue()
	alloc_disk() and add_disk()
	device_removed
	del_gendisk()
	blk_cleanup_queue()

So first we cleaup the gendisk structure and later driver calls to cleanup
the request queue.

> > Nauman and I were also wondering why blkio_group and blkio_policy_node
> > store a dev_t, rather than a direct pointer to gendisk.  dev_t seems
> > more like a userspace<->kernel interface than an inside-the-kernel
> > interface.
> > 
> 
> blkio_policy_node currently can't store a pointer to gendisk because there
> is no mechanism to call back into blkio if device is removed. So if we
> implement something so that once device is removed, blkio layer gets a
> callback and we cleanup any state/rules associated with that device, then
> I think we should be able to store the pointer to gendisk.
> 
> I am still trying to figure out how elevator/ioscheduler state is cleaned
> up if a device is removed while some IO is happening to it.
> 

So blk_cleanup_queue() will do this. That means few things.

- We can't store pointers to gendisk in blkio_policy_node or blkio_group
  because gendisk might have gone away but request queue is still there.
  May be one can try saving a pointer and taking a reference, but I guess
  that becomes littles complicated.

- If we are using disk name for rules and reporting stats, then we also
  need to make sure that these rules are cleared from cgroups once device
  has disappeared. Otherwise, following might happen.

	- Create a rule for sda (x,y) for cgroup test1. x,y are major and
	  minor numbers.
	- sda goes away. Rules still remains in blkio cgroup.
	- Another device gets plugged in and i guess following can happen.
		- device name is different but dev_t is same as sda.
		- device name is same (sda) but device number is
		  different.

		In both the cases a user will be confused with stale rules
		in cgroups.

 Cleaning up cgroups rules can get little complicated. I guess we need to
 create a function in blkio-cgroup.c to traverse through all the cgroups
 and cleanup any blkio_policy_nodes belonging to device going away.
	
In a nutshell, it probably is doable. You are welcome to write a patch. At
the same time I am not against deivce major/minor number based interface,
because it keeps things little simple.

Thanks
Vivek

-   
> OTOH, Gui, may be one can use blk_lookup_devt() to lookup the dev_t of a
> device using the disk name (sda). I just noticed it while reading the
> code.
> 
> Thanks
> Vivek
