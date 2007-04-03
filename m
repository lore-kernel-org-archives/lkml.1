Return-Path: <linux-kernel-owner+w=401wt.eu-S933945AbXDCXj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbXDCXj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXDCXj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:39:29 -0400
Received: from smtp.ono.com ([62.42.230.12]:52282 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933945AbXDCXj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:39:28 -0400
Date: Wed, 4 Apr 2007 01:38:57 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Ulrich Drepper <drepper@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070404013857.5495d055@werewolf-wl>
In-Reply-To: <200704032213.20244.ioe-lkml@rameria.de>
References: <461286D6.2040407@redhat.com>
	<20070403174457.GA15704@linux-os.sc.intel.com>
	<46129619.8050107@redhat.com>
	<200704032213.20244.ioe-lkml@rameria.de>
X-Mailer: Claws Mail 2.8.1cvs80 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 22:13:07 +0200, Ingo Oeser <ioe-lkml@rameria.de> wrote:

> Hi Ulrich,
> 
> On Tuesday 03 April 2007, Ulrich Drepper wrote:
> > So, anybody else has a proposal?  This is a pressing issue and cannot
> > wait until someday in the distant future NUMA topology information is
> > easily and speedily accessible.
> 
> Since for now you just need a fast and dirty hack, which will be replaced 
> with better interfaces, I suggest creating a directory with some files in it.
> These should just contain, what you need to handle your most pressing cases.
> 
> I propose /sys/devices/system/topology_counters/ for that.
> These can contain "online_cpu", "proped_cpu", "max_cpu"
> and maybe the same for nodes. All that as a simple file with an integer
> value.
> 
> Since sysfs-attribute files are pollable (if the owners notifies sysfs 
> on changes), you also have the notification system you need 
> (select, poll, epoll etc.).
> 
> If you promise to just keep the slow code around, than one day when the shiny 
> NUMA topology stuff is ready, this directory can be completely removed and
> glibc (plus all their users) keeps working. It will then even work better with a 
> new glibc version, which supports the shiny new NUMA topology stuff.
> 
> The kernel can create these counters quiete easy, since most of them are 
> the hamming weight (or population count) of some bitmaps.
> 
> Does this sound like a proper hacky solution? :-)
> 

Just a point of view from someone who has to parse /proc/cpuinfo.
That sort of file tree thing is useful to work from the command line but its
a kick in the a** to use from a program.
This makes you just to re-parse the tree each time you have to get the info
(open, read, atoi, close...) to fill your internal variables.

I don't know if its possible, but I would like something like:

__packt_it_tight_please struct cpumap_t {
	u16	ncpus;
	u16	ncpus_onln;
	u16	ncpus_inmyset;  // for procsets
	// Here possibly more info about topology, pack-core-thread structure...
	// in simple arrays...
};

struct cpumap_t *cpumap = mmap("/proc/sys/hw/cpumap",sizeof(struct cpumap_t));

for (...cpumap->ncpus_inmyset ....)  // 

As I said, I don't know if its possible. I vaguely remember some comments
against binary info in /proc...

Even it could be simplified if you realize some things:
- Usually people dont worry about if cpus are all the online ones or I'm
  running in a proc set. Just want to know how many can I use.
- Don't care if they are hyper-threaded, cores os independent processors.
  To adjust processing for hyper-threaded cpus, one needs to tie processes
  to processors, and you need to be root for that.
  Really, anything dependent on topology is not usable for normal programs,
  because you need to be root to control that.
  So topology is not so important.

Some (probably stupid) ideas...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam08 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
