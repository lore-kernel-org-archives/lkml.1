Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbYFCMRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbYFCMRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYFCMQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:16:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43324 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYFCMQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:16:52 -0400
Date: Tue, 3 Jun 2008 07:16:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 09/10] netns: Enable tagging for net_class directories
	in sysfs
Message-ID: <20080603121647.GA11503@us.ibm.com>
References: <20080602134438.224352910@theryb.frec.bull.fr> <20080602134439.782528644@theryb.frec.bull.fr> <20080603040818.GA18507@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603040818.GA18507@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (gregkh@suse.de):
> On Mon, Jun 02, 2008 at 03:46:08PM +0200, Benjamin Thery wrote:
> > net: Enable tagging for net_class directories in sysfs
> > 
> > The problem.  Network devices show up in sysfs and with the network
> > namespace active multiple devices with the same name can show up in
> > the same directory, ouch!
> > 
> > To avoid that problem and allow existing applications in network namespaces
> > to see the same interface that is currently presented in sysfs, this
> > patch enables the tagging directory support in sysfs.
> > 
> > By using the network namespace pointers as tags to separate out the
> > the sysfs directory entries we ensure that we don't have conflicts
> > in the directories and applications only see a limited set of
> > the network devices.
> 
> I don't like it how the network subsystem is starting to leach into the
> sysfs core here.  What happens when the next subsystem wants to do the
> same thing?  And then the next one?  Will they all have to do this kind
> of intrusive changes to sysfs?

At least as far as the tagging goes, each namespace which needs to do
this (network, devices, and user, at least) will add a field to the
tag structure and call sysfs_enable_tagging() on the relevant
directories.  So no more core sysfs changes should be needed, as Eric
tried to make this generic enough to be generally useful.

> Can't this be done only in the network subsystem?

sysfs/kobject layer has to somehow decide what to show for
/sys/class/net contents based on the mountpoint, right, so I don't see
how the network subsystem could do it.

The only non-tagging alternative I'd see would be to keep entirely
separate kobject pools for each namespace.  To do that we'd probably
want to break /sys/class/net into a separate fs that can be
remounted, so at least we don't have to keep the rest of the kobject
pools (/sys/firmware, kernel, etc) in sync...

Eric had mentioned before breaking /sys into multiple mountpoints, so
I'll assume the fact that he implemented tagging means that there was
too much cross-linking and whatnot across the /sys tree to make that
feasible.

More importantly, that approach would require more core sysfs changes
for the next namespace, whereas the tagging approach does not!

thanks,
-serge
