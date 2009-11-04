Return-Path: <linux-kernel-owner+w=401wt.eu-S933136AbZKDXgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbZKDXgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933097AbZKDXgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:36:14 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:54247 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076AbZKDXgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:36:13 -0500
Date: Thu, 5 Nov 2009 05:06:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 01/20] blkio: Documentation
Message-ID: <20091104233612.GM3560@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
 <1257291837-6246-2-git-send-email-vgoyal@redhat.com>
 <20091104172100.GL3560@balbir.in.ibm.com>
 <20091104175243.GE2870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091104175243.GE2870@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2009-11-04 12:52:44]:

> On Wed, Nov 04, 2009 at 10:51:00PM +0530, Balbir Singh wrote:
> > * Vivek Goyal <vgoyal@redhat.com> [2009-11-03 18:43:38]:
> > 
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  Documentation/cgroups/blkio-controller.txt |  106 ++++++++++++++++++++++++++++
> > >  1 files changed, 106 insertions(+), 0 deletions(-)
> > >  create mode 100644 Documentation/cgroups/blkio-controller.txt
> > > 
> > > diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> > > new file mode 100644
> > > index 0000000..dc8fb1a
> > > --- /dev/null
> > > +++ b/Documentation/cgroups/blkio-controller.txt
> > > @@ -0,0 +1,106 @@
> > > +				Block IO Controller
> > > +				===================
> > > +Overview
> > > +========
> > > +cgroup subsys "blkio" implements the block io controller. There seems to be
> > > +a need of various kind of IO control policies (like proportional BW, max BW)
> > > +both at leaf nodes as well as at intermediate nodes in storage hierarchy. Plan
> > > +is to use same cgroup based management interface for blkio controller and
> > > +based on user options switch IO policies in the background.
> > > +
> > > +In the first phase, this patchset implements proportional weight time based
> > > +division of disk policy. It is implemented in CFQ. Hence this policy takes
> > > +effect only on leaf nodes when CFQ is being used.
> > > +
> > > +HOWTO
> > > +=====
> > > +You can do a very simple testing of running two dd threads in two different
> > > +cgroups. Here is what you can do.
> > > +
> > > +- Enable group scheduling in CFQ
> > > +	CONFIG_CFQ_GROUP_IOSCHED=y
> > > +
> > > +- Compile and boot into kernel and mount IO controller (blkio).
> > > +
> > > +	mount -t cgroup -o blkio none /cgroup
> > > +
> > > +- Create two cgroups
> > > +	mkdir -p /cgroup/test1/ /cgroup/test2
> > > +
> > > +- Set weights of group test1 and test2
> > > +	echo 1000 > /cgroup/test1/blkio.weight
> > > +	echo 500 > /cgroup/test2/blkio.weight
> > > +
> > > +- Create two same size files (say 512MB each) on same disk (file1, file2) and
> > > +  launch two dd threads in different cgroup to read those files.
> > > +
> > > +	sync
> > > +	echo 3 > /proc/sys/vm/drop_caches
> > > +
> > > +	dd if=/mnt/sdb/zerofile1 of=/dev/null &
> > > +	echo $! > /cgroup/test1/tasks
> > > +	cat /cgroup/test1/tasks
> > > +
> > > +	dd if=/mnt/sdb/zerofile2 of=/dev/null &
> > > +	echo $! > /cgroup/test2/tasks
> > > +	cat /cgroup/test2/tasks
> > > +
> > > +- At macro level, first dd should finish first. To get more precise data, keep
> > > +  on looking at (with the help of script), at blkio.disk_time and
> > > +  blkio.disk_sectors files of both test1 and test2 groups. This will tell how
> > > +  much disk time (in milli seconds), each group got and how many secotors each
> > > +  group dispatched to the disk. We provide fairness in terms of disk time, so
> > > +  ideally io.disk_time of cgroups should be in proportion to the weight.
> > > +
> > > +Various user visible config options
> > > +===================================
> > > +CONFIG_CFQ_GROUP_IOSCHED
> > > +	- Enables group scheduling in CFQ. Currently only 1 level of group
> > > +	  creation is allowed.
> > > +
> > > +CONFIG_DEBUG_CFQ_IOSCHED
> > > +	- Enables some debugging messages in blktrace. Also creates extra
> > > +	  cgroup file blkio.dequeue.
> > > +
> > > +Config options selected automatically
> > > +=====================================
> > > +These config options are not user visible and are selected/deselected
> > > +automatically based on IO scheduler configuration.
> > > +
> > > +CONFIG_BLK_CGROUP
> > > +	- Block IO controller. Selected by CONFIG_CFQ_GROUP_IOSCHED.
> > > +
> > > +CONFIG_DEBUG_BLK_CGROUP
> > > +	- Debug help. Selected by CONFIG_DEBUG_CFQ_IOSCHED.
> > > +
> > > +Details of cgroup files
> > > +=======================
> > > +- blkio.ioprio_class
> > > +	- Specifies class of the cgroup (RT, BE, IDLE). This is default io
> > > +	  class of the group on all the devices.
> > > +
> > > +	  1 = RT; 2 = BE, 3 = IDLE
> > > +
> > > +- blkio.weight
> > > +	- Specifies per cgroup weight.
> > > +
> > > +	  Currently allowed range of weights is from 100 to 1000.
> > > +
> > > +- blkio.time
> > > +	- disk time allocated to cgroup per device in milliseconds. First
> > > +	  two fields specify the major and minor number of the device and
> > > +	  third field specifies the disk time allocated to group in
> > > +	  milliseconds.
> > > +
> > > +- blkio.sectors
> > > +	- number of sectors transferred to/from disk by the group. First
> > > +	  two fields specify the major and minor number of the device and
> > > +	  third field specifies the number of sectors transferred by the
> > > +	  group to/from the device.
> > > +
> > > +- blkio.dequeue
> > > +	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
> > > +	  gives the statistics about how many a times a group was dequeued
> > > +	  from service tree of the device. First two fields specify the major
> > > +	  and minor number of the device and third field specifies the number
> > > +	  of times a group was dequeued from a particular device.
> > 
> > Hi, Vivek,
> > 
> > Are the parameters inter-related? What if you have conflicts w.r.t.
> > time, sectors, etc?
> 
> What kind of conflicts?
> 
> time, sectors, and dequeue are read only files. They are mainly for 
> monitoring purposes. CFQ provides fairness in terms of disk time, so one
> can monitor whether time share received by a group is fair or not.
> 
> "sectors" just gives additional data of how many sectors were transferred.
> It it not a necessary file. I just exported it to get some sense of both
> time and amount IO done by cgroup.
> 
> So I am not sure what kind of conflicts you are referring to.
>

OK, so they are read only statistics? I seemed to parse the document
differently 

-- 
	Balbir
