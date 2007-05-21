Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbXEUEik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbXEUEik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXEUEid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:38:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53516 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXEUEic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:38:32 -0400
Date: Mon, 21 May 2007 10:09:08 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH -stable] sysfs: disable reclamation by default
Message-ID: <20070521043908.GB9214@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <464A4F56.6080108@tequila.co.jp> <20070515185350.2e77bf21.akpm@linux-foundation.org> <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464C95AB.3020209@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 07:49:31PM +0200, Tejun Heo wrote:
> Maneesh Soni wrote:
> > On Thu, May 17, 2007 at 05:04:23AM -0700, Greg KH wrote:
> >> On Wed, May 16, 2007 at 08:31:00PM +0200, Tejun Heo wrote:
> >>> sd->s_dentry updates made by dentry/inode reclamation are racy and can
> >>> lead to BUG() or oops.  This is already fixed in -mm and the fix is
> >>> scheduled to be merged into upstream for 2.6.23 but the fix
> >>> reimplements sysfs dentry dropping and is too risky for -stable
> >>> kernels.
> >>>
> > 
> > But was the synchronization fix tested by people facing the race? I still
> > don't understand the racy code path. The last google problem I saw had
> > s_dentry field as NULL.
> 
> Please take a look at the following message.
> 
>   http://article.gmane.org/gmane.linux.kernel/521729
> 
> I could reproduce both races on my test machine fairly reliable with
> parallel find, cat, mount/mount while repeatedly ins/rmmoding a libata
> driver.
> 
Thanks for the pointer.. earlier it got buried in the fat rework..


> >>> This is an interim solution for -stable kernels.  sysfs reclamation is
> >>> disabled by default and can be enabled by using sysfs.enable_reclaim
> >>> kernel parameter.  Note that dentries are still created on demand, so
> >>> attribute and symlinks nodes aren't allocated on creation.  They're
> >>> allocated on first lookup and deallocated when the sysfs node is
> >>> removed.
> >> Ick, this is going to kill memory on big boxes (s390 and others) and I
> >> don't really want to apply this it if at all possible.
> >>
> > At least not make it default. This might create boot issues with these
> > boxes. 
> 
> Which makes oopsing the default.  Fun!  :-)
> 
but.. avoid oops by not booting at all is more fun !! ;-)


> >> Maneesh, any other thoughts?
> >>
> > I actually wanted to investigate this oops but left it considering the
> > rework being done by Tejun. If this still make sense we can have some
> > more debug code stuffed there or get a crashdump (kdump) to get better
> > understanding of the race.
> 
> The above message contains analysis of both races.  I just ported the
> fixes.  I have a different test machine now and can't reproduce the
> races with this one yet so I couldn't verify whether the patches
> actually fix the problem.  I'll post the patches anyway.  If anyone can
> reproduce these races, please verify the posted patches fix the problem.
> 

I would prefer fixing the race instead of making attributes non-reclaimable.

Thanks
Maneesh



-- 
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India
