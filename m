Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYHLNP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYHLNP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYHLNPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:15:42 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:56003 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYHLNPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:15:40 -0400
Subject: Re: RFC: I/O bandwidth controller
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: baramsori72@gmail.com, balbir@linux.vnet.ibm.com,
       xen-devel@lists.xensource.com, uchida@ap.jp.nec.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org, dave@linux.vnet.ibm.com, ngupta@google.com,
       righi.andrea@gmail.com
In-Reply-To: <20080812.201025.57762305.taka@valinux.co.jp>
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp>
	 <48A0A689.40908@gmail.com> <loom.20080812T071504-212@post.gmane.org>
	 <20080812.201025.57762305.taka@valinux.co.jp>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Tue, 12 Aug 2008 22:15:38 +0900
Message-Id: <1218546938.4456.72.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 20:52 +0900, Hirokazu Takahashi wrote:
> Hi,
> 
> > > Fernando Luis Vázquez Cao wrote:
> > > >>> This seems to be the easiest part, but the current cgroups
> > > >>> infrastructure has some limitations when it comes to dealing with block
> > > >>> devices: impossibility of creating/removing certain control structures
> > > >>> dynamically and hardcoding of subsystems (i.e. resource controllers).
> > > >>> This makes it difficult to handle block devices that can be hotplugged
> > > >>> and go away at any time (this applies not only to usb storage but also
> > > >>> to some SATA and SCSI devices). To cope with this situation properly we
> > > >>> would need hotplug support in cgroups, but, as suggested before and
> > > >>> discussed in the past (see (0) below), there are some limitations.
> > > >>>
> > > >>> Even in the non-hotplug case it would be nice if we could treat each
> > > >>> block I/O device as an independent resource, which means we could do
> > > >>> things like allocating I/O bandwidth on a per-device basis. As long as
> > > >>> performance is not compromised too much, adding some kind of basic
> > > >>> hotplug support to cgroups is probably worth it.
> > > >>>
> > > >>> (0) http://lkml.org/lkml/2008/5/21/12
> > > >> What about using major,minor numbers to identify each device and account
> > > >> IO statistics? If a device is unplugged we could reset IO statistics
> > > >> and/or remove IO limitations for that device from userspace (i.e. by a
> > > >> deamon), but pluggin/unplugging the device would not be blocked/affected
> > > >> in any case. Or am I oversimplifying the problem?
> > > > If a resource we want to control (a block device in this case) is
> > > > hot-plugged/unplugged the corresponding cgroup-related structures inside
> > > > the kernel need to be allocated/freed dynamically, respectively. The
> > > > problem is that this is not always possible. For example, with the
> > > > current implementation of cgroups it is not possible to treat each block
> > > > device as a different cgroup subsytem/resource controlled, because
> > > > subsystems are created at compile time.
> > > 
> > > The whole subsystem is created at compile time, but controller data
> > > structures are allocated dynamically (i.e. see struct mem_cgroup for
> > > memory controller). So, identifying each device with a name, or a key
> > > like major,minor, instead of a reference/pointer to a struct could help
> > > to handle this in userspace. I mean, if a device is unplugged a
> > > userspace daemon can just handle the event and delete the controller
> > > data structures allocated for this device, asynchronously, via
> > > userspace->kernel interface. And without holding a reference to that
> > > particular block device in the kernel. Anyway, implementing a generic
> > > interface that would allow to define hooks for hot-pluggable devices (or
> > > similar events) in cgroups would be interesting.
> > > 
> > > >>> 3. & 4. & 5. - I/O bandwidth shaping & General design aspects
> > > >>>
> > > >>> The implementation of an I/O scheduling algorithm is to a certain extent
> > > >>> influenced by what we are trying to achieve in terms of I/O bandwidth
> > > >>> shaping, but, as discussed below, the required accuracy can determine
> > > >>> the layer where the I/O controller has to reside. Off the top of my
> > > >>> head, there are three basic operations we may want perform:
> > > >>>   - I/O nice prioritization: ionice-like approach.
> > > >>>   - Proportional bandwidth scheduling: each process/group of processes
> > > >>> has a weight that determines the share of bandwidth they receive.
> > > >>>   - I/O limiting: set an upper limit to the bandwidth a group of tasks
> > > >>> can use.
> > > >> Use a deadline-based IO scheduling could be an interesting path to be
> > > >> explored as well, IMHO, to try to guarantee per-cgroup minimum bandwidth
> > > >> requirements.
> > > > Please note that the only thing we can do is to guarantee minimum
> > > > bandwidth requirement when there is contention for an IO resource, which
> > > > is precisely what a proportional bandwidth scheduler does. An I missing
> > > > something?
> > > 
> > > Correct. Proportional bandwidth automatically allows to guarantee min
> > > requirements (instead of IO limiting approach, that needs additional
> > > mechanisms to achive this).
> > > 
> > > In any case there's no guarantee for a cgroup/application to sustain
> > > i.e. 10MB/s on a certain device, but this is a hard problem anyway, and
> > > the best we can do is to try to satisfy "soft" constraints.
> > 
> > I think guaranteeing the minimum I/O bandwidth is very important. In the 
> > business site, especially in streaming service system, administrator requires 
> > the functionality to satisfy QoS or performance of their service. 
> > Of course, IO throttling is important, but, personally, I think guaranteeing 
> > the minimum bandwidth is more important than limitation of maximum bandwidth 
> > to satisfy the requirement in real business sites.
> > And I know Andrea’s io-throttle patch supports the latter case well and it is 
> > very stable. 
> > But, the first case(guarantee the minimum bandwidth) is not supported in any 
> > patches.
> > Is there any plans to support it? and Is there any problems in implementing it?
> > I think if IO controller can support guaranteeing the minimum bandwidth and 
> > work-conserving mode simultaneously, it more easily satisfies the requirement 
> > of the business sites.
> > Additionally, I didn’t understand “Proportional bandwidth automatically allows 
> > to guarantee min
> > requirements” and “soft constraints”.
> > Can you give me a advice about this ? 
> > Thanks in advance.
> > 
> > Dong-Jae Kang
> 
> I think this is what dm-ioband does.
> 
> Let's say you make two groups share the same disk, and give them
> 70% of the bandwidth the disk physically has and 30% respectively.
> This means the former group is almost guaranteed to be able to use
> 70% of the bandwidth even when the latter one is issuing quite
> a lot of I/O requests.
> 
> Yes, I know there exist head seek lags with traditional magnetic disks,
> so it's important to improve the algorithm to reduce this overhead.
> 
> And I think it is also possible to add a new scheduling policy to
> guarantee the minimum bandwidth. It might be cool if some group can
> use guranteed bandwidths and the other share the rest on proportional
> bandwidth policy.

Yes, it would be really cool if we could provide hard bandwidth
guarantees but it certainly does not look like a trivial task. To
achieve that, among other things, we would need to take into account
both the topology of block devices (RAID type, etc) and the physical
characteristics of the disks that compose them.

The former problem could be tackled at the block layer, since it is
there that stacking devices are implemented. But it is the elevators who
should examine the characteristics of the underlying devices, and
schedule IO in such a way that the variable factors, such as seek times,
do not compromise the hard bandwidth requirements (of course, it would
also be nice if we did not kill global I/O performance in the process).
Finally such an elevator would still need to cooperate with the block
layer to make further topology-dependent adjustments.

- Fernando

P.S.: For some reason I received neither Dong-Jae's email nor yours, so
I had to pick it up from the mailing list. I would appreciate it if you
kept me CCed.

