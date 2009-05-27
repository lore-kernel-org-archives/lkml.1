Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbZE0LWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbZE0LWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbZE0LVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:21:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60585 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbZE0LVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:21:52 -0400
Date: Wed, 27 May 2009 05:21:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Knoblauch <knobi@knobisoft.de>, Mike Galbraith <efault@gmx.de>,
       viro@ZenIV.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       tigran@aivazian.fsnet.co.uks, Kay Sievers <kay.sievers@vrfy.org>,
       shemminger@vyatta.com, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090527112153.GE5816@parisc-linux.org>
References: <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <1241014725.15095.19.camel@marge.simson.net> <20090505154911.e0309a4f.akpm@linux-foundation.org> <1241585140.5196.28.camel@marge.simson.net> <957194.27869.qm@web32605.mail.mud.yahoo.com> <1241599065.18090.18.camel@marge.simson.net> <461911.6351.qm@web32603.mail.mud.yahoo.com> <20090526233102.b86e7f84.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526233102.b86e7f84.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 11:31:02PM -0700, Andrew Morton wrote:
> On Wed, 20 May 2009 03:22:28 -0700 (PDT) Martin Knoblauch <knobi@knobisoft.de> wrote:
> 
> > 
> > ----- Original Message ----
> > 
> > > From: Mike Galbraith <efault@gmx.de>
> > > To: Martin Knoblauch <knobi@knobisoft.de>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>; viro@ZenIV.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk
> > > Sent: Wednesday, May 6, 2009 10:37:45 AM
> > > Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> > > 
> > > On Wed, 2009-05-06 at 00:55 -0700, Martin Knoblauch wrote:
> > > 
> > > >  just to bring this back to my problem :-)
> > > 
> > > Good idea :-)
> > > 
> > > >  Last week I reported that the "new" sysfs entry in /proc/mounts already comes 
> > > out of initrd. Does this ring a bell?
> > > > 
> > > > http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/03048.html
> > > 
> > > Nope, no bells.
> > > 
> > > The only thing I can suggest is that you try a bisection.
> > > 
> > >     -Mike
> > 
> >  OK, so I finally managed to bisect the issue down to the following commit. Not much that I can say about it. Someone else suggested that it might all be a question of timing. Might very well be. I will try it out on a system with a different SCSI/RAID controller. The failing system has an "Smart Array 6i" (cciss). "cciss", "ext3" and "jbd" are all modules coming from initrd.
> > 
> > |commit 1120f8b8169fb2cb51219d326892d963e762edb6
> > |Author: Stephen Hemminger <shemminger@vyatta.com>
> > |Date:   Thu Dec 18 09:17:16 2008 -0800
> > |
> > |    PCI: handle long delays in VPD access
> > |
> > |    Accessing the VPD area can take a long time.  The existing
> > |    VPD access code fails consistently on my hardware. There are comments
> > |
> > |    Change the access routines to:
> > |      * use a mutex rather than spinning with IRQ's disabled and lock held
> > |      * have a much longer timeout
> > |      * call cond_resched while spinning
> > |
> > |    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> > |    Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> > |    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> 
> <hello, any maintainers out there?>

This is the first I've seen of this report ...

> So afacit what's happening is that the above change caused one of your
> PCI devices to take a very long time to initialise, yes?  Was it the
> CCISS driver?
> 
> If you add "printk.time=y" to the kernel boot command line then you'll
> get timestamped boot messages which will make it easier to determine
> where the time was consumed.  Adding `initcall_debug' to the boot line
> will help us delve further into the delay, assuming that the offending
> driver is build into vmlinux (which it might not be).

The two message logs posted show NTP starting up within a second of
each other.  What was the problem again?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
