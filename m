Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYCNFeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYCNFeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYCNFem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:34:42 -0400
Received: from mga05.intel.com ([192.55.52.89]:6004 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbYCNFel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:34:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,498,1199692800"; 
   d="scan'208";a="533735808"
Subject: Re: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Kay Sievers <kay.sievers@vrfy.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080314050113.GE18152@suse.de>
References: <1205394417.3215.85.camel@ymzhang>
	 <20080313151413.GA14045@suse.de>
	 <20080313091921.834d2532.randy.dunlap@oracle.com>
	 <20080313171202.GA5233@suse.de> <1205455819.3215.154.camel@ymzhang>
	 <20080314050113.GE18152@suse.de>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Mar 2008 13:32:28 +0800
Message-Id: <1205472748.3215.273.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 22:01 -0700, Greg KH wrote:
> On Fri, Mar 14, 2008 at 08:50:19AM +0800, Zhang, Yanmin wrote:
> > On Thu, 2008-03-13 at 10:12 -0700, Greg KH wrote:
> > > On Thu, Mar 13, 2008 at 09:19:21AM -0700, Randy Dunlap wrote:
> > > > On Thu, 13 Mar 2008 08:14:13 -0700 Greg KH wrote:
> > > > 
> > > > > On Thu, Mar 13, 2008 at 03:46:57PM +0800, Zhang, Yanmin wrote:
> > > > > > Comparing with 2.6.24, on my 16-core tigerton, hackbench process mode has about
> > > > > > 40% regression with 2.6.25-rc1, and more than 20% regression with kernel
> > > > > > 2.6.25-rc4, because rc4 includes the reverting patch of scheduler load balance.
> > > > > > 
> > > > > > Command to start it.
> > > > > > #hackbench 100 process 2000
> > > > > > I ran it for 3 times and sum the values.
> > > > > > 
> > > > > > I tried to investiagte it by bisect.
> > > > > > Kernel up to tag 0f4dafc0563c6c49e17fe14b3f5f356e4c4b8806 has the 20% regression.
> > > > > > Kernel up to tag 6e90aa972dda8ef86155eefcdbdc8d34165b9f39 hasn't regression.
> > > > > > 
> > > > > > Any bisect between above 2 tags cause kernel hang. I tried to checkout to a point between
> > > > > > these 2 tags for many times manually and kernel always paniced.
> > > > > 
> > > > > Where is the kernel panicing?  The changeset right after the last one
> > > > > above: bc87d2fe7a1190f1c257af8a91fc490b1ee35954, is a change to efivars,
> > > > > are you using that in your .config?
> > > > > 
> > > > > > All patches between the 2 tags are on kobject restructure. I guess such restructure
> > > > > > creates more cache miss on the 16-core tigerton.
> > > > > 
> > > > > Nothing should be creating kobjects on a normal load like this, so a
> > > > > regression seems very odd.  Unless the /sys/kernel/uids/ stuff is
> > > > > triggering this?
> > > > > 
> > > > > Do you have a link to where I can get hackbench (google seems to find
> > > > > lots of reports with it, but not the source itself), so I can test to
> > > > > see if we are accidentally creating kobjects with this load?
> > > > 
> > > > The version that I see referenced most often (unscientifically :)
> > > > is somewhere under people.redhat.com/mingo/, like so:
> > > > http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
> > > 
> > > Great, thanks for the link.
> > > 
> > > In using that version, I do not see any kobjects being created at all
> > > when running the program.  So I don't see how a kobject change could
> > > have caused any slowdown.
> > > 
> > > Yanmin, is the above link the version you are using?
> > Yes.
> > 
> > > 
> > > Hm, running with "hackbench 100 process 2000" seems to lock up my
> > > laptop, maybe I shouldn't run 4000 tasks at once on such a memory
> > > starved machine...
> > The issue doesn't exist on my 8-core stoakley and on tulsa. So I don't think
> > you could reproduce it on laptop.
> 
> But I should see any kobjects being created and destroyed as you are
> thinking that is the problem here, right?
Not just thinking. That's based on lots of testing. But as you know, performance
work is complicated often. Now, I think maybe kernel image changes cache line alignment.

> 
> And I don't see any, so I'm thinking that this is probably something
> else.
Yes.

> 
> I'm still interested in why your machine was oopsing when bisecting
> through the kobject commits.  I thought it all should have worked
> without problems, as I spend enough time trying to ensure it was so...
Kernel panic after printing warning in kref_get when executing add_disk
in rd_init.

Thanks,
Yanmin


