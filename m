Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZA3BUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZA3BUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZA3BUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:20:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbZA3BU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:20:29 -0500
Date: Thu, 29 Jan 2009 17:20:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: kerolasa@gmail.com, kerolasa@iki.fi, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>,
       Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: PROBLEM: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
Message-Id: <20090129172010.f25fe0ad.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970901291706t17fc3d9aq753f90db75396639@mail.gmail.com>
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com>
	<a6f8318b0901210427o33af879byd352adaf5fde1c29@mail.gmail.com>
	<20090129163032.f97901c5.akpm@linux-foundation.org>
	<21d7e9970901291706t17fc3d9aq753f90db75396639@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 11:06:47 +1000 Dave Airlie <airlied@gmail.com> wrote:

> On Fri, Jan 30, 2009 at 10:30 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > (cc's added)
> >
> > On Wed, 21 Jan 2009 13:27:48 +0100
> > Sami Kerola <kerolasa@iki.fi> wrote:
> >
> >> I compiled the Torvalds git kernel 2.6.29-rc2-00013 and I got an oops.
> >> The oops happens when ever X starts. Initially I was booting with run
> >> level 5 and it hung. I tried to use run level to 3 and an operating
> >> system started just fine. When I type startx the hung happen again.
> >> Please let me know if you need some more information besides oops from
> >> messages file and lspci output.
> >>
> >>
> >> Jan 21 08:53:58 lelux kernel: ------------[ cut here ]------------
> >> Jan 21 08:53:58 lelux kernel: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
> >
> > I assume that 2.6.28 didn't do this?
> 
> This is a userspace race between udev and libdrm, I'm not sure we can do
> anything in the kernel other than BUG, maybe we should just WARN instead.
> 
> Basically, libdrm creates devices nodes, the initial drm opening gets that, udev
> comes along when the module is loaded and re-creates the device node,
> when AIGLX opens the device
> it can't figure out wtf just happened, as the inode->i_mapping we use
> to store the GEM device mmap ranges is different.
> 
> I think building libdrm with --enable-udev is the correct answer, and
> maybe switching this to a WARN so it doesn't blow up.
> 
> maybe we shouldn't be storing the inode mapping like this? anyone any
> better idea?
> 

hm, I'm a bit surprised to see the drm code using `struct
address_space' and read_mapping_page() and unmap_mapping_range() and
such.  I thought those only worked with regular files and pagecache :)

Is it possible to briefly explain what's going on there?

What instance of address_space_operations does ->dev_mapping actually
point at?

