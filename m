Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZELMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZELMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZELMxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:53:04 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:46847 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZELMxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:53:03 -0400
Subject: Re: [patch 00/13] devtmpfs patches
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
In-Reply-To: <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	 <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil>
	 <20090511175626.GA4758@kroah.com>
	 <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
	 <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 12 May 2009 08:45:44 -0400
Message-Id: <1242132344.31807.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 23:05 +0200, Kay Sievers wrote:
> On Mon, May 11, 2009 at 22:41, David P. Quigley <dpquigl@tycho.nsa.gov> wrote:
> 
> > This however does highlight a problem with the fact that device node
> > labeling isn't being done properly. It should be possible to create this
> > fs with a different name such that it doesn't appear as a tmpfs file
> > system to SELinux. If it appears as a devtmpfs file system then we can
> > specify the root label and labels on the other devices properly in
> > policy.
> 
> That could be done, if it solves this problem. Damn, now we have the
> naming problem back again. :)
> 
> By doing its own fstype, we could also make the auto-mount optional,
> because you could always reach the filesystem anytime later.
> 
> A different fstype has the slight inconvenience, that existing
> userspace needs to be taught to handle it explicitly, while a tmfps is
> already handled automatically because we use tmpfs already today. But
> that may not be too important.
> 
> Thanks a lot for your tests and analysis,

I don't think merely changing the fstype will suffice; that merely lets
us assign a different default security context to inodes in the
filesystem (e.g. device_t vs tmpfs_t), but doesn't address the fact that
use of devtmpfs rather than just udev seems to alter the permission
checking upon an open(2) by mingetty, thereby breaking existing
policies.  Previously mingetty didn't require permissions to mknod; with
devtmpfs, it does.  I'm wondering if devtmpfs is internally performing
operations that ought to be done in kernel context rather than the
context of the userspace process that initiated the open(2).

Also, I was wondering why the existing restorecon -R /dev that is
performed by /etc/rc.sysinit to fix up the security contexts on the
initial /dev tree prior to policy load doesn't seem to be getting
applied when devtmpfs is enabled.  Does devtmpfs pass through setxattr()
requests to the underlying tmpfs mount?

-- 
Stephen Smalley
National Security Agency

