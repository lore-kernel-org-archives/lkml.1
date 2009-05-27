Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbZE0GbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbZE0GbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZE0GbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:31:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbZE0GbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:31:09 -0400
Date: Tue, 26 May 2009 23:31:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Mike Galbraith <efault@gmx.de>, viro@ZenIV.linux.org.uk, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uks,
       Kay Sievers <kay.sievers@vrfy.org>, shemminger@vyatta.com,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Message-Id: <20090526233102.b86e7f84.akpm@linux-foundation.org>
In-Reply-To: <461911.6351.qm@web32603.mail.mud.yahoo.com>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>
	<20090428182837.62c51f26.akpm@linux-foundation.org>
	<1240977096.5478.3.camel@marge.simson.net>
	<20090429011755.c141c599.akpm@linux-foundation.org>
	<20090429120827.GI8633@ZenIV.linux.org.uk>
	<1241014725.15095.19.camel@marge.simson.net>
	<20090505154911.e0309a4f.akpm@linux-foundation.org>
	<1241585140.5196.28.camel@marge.simson.net>
	<957194.27869.qm@web32605.mail.mud.yahoo.com>
	<1241599065.18090.18.camel@marge.simson.net>
	<461911.6351.qm@web32603.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 03:22:28 -0700 (PDT) Martin Knoblauch <knobi@knobisoft.de> wrote:

> 
> ----- Original Message ----
> 
> > From: Mike Galbraith <efault@gmx.de>
> > To: Martin Knoblauch <knobi@knobisoft.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>; viro@ZenIV.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk
> > Sent: Wednesday, May 6, 2009 10:37:45 AM
> > Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> > 
> > On Wed, 2009-05-06 at 00:55 -0700, Martin Knoblauch wrote:
> > 
> > >  just to bring this back to my problem :-)
> > 
> > Good idea :-)
> > 
> > >  Last week I reported that the "new" sysfs entry in /proc/mounts already comes 
> > out of initrd. Does this ring a bell?
> > > 
> > > http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/03048.html
> > 
> > Nope, no bells.
> > 
> > The only thing I can suggest is that you try a bisection.
> > 
> >     -Mike
> 
>  OK, so I finally managed to bisect the issue down to the following commit. Not much that I can say about it. Someone else suggested that it might all be a question of timing. Might very well be. I will try it out on a system with a different SCSI/RAID controller. The failing system has an "Smart Array 6i" (cciss). "cciss", "ext3" and "jbd" are all modules coming from initrd.
> 
> |commit 1120f8b8169fb2cb51219d326892d963e762edb6
> |Author: Stephen Hemminger <shemminger@vyatta.com>
> |Date:   Thu Dec 18 09:17:16 2008 -0800
> |
> |    PCI: handle long delays in VPD access
> |
> |    Accessing the VPD area can take a long time.  The existing
> |    VPD access code fails consistently on my hardware. There are comments
> |
> |    Change the access routines to:
> |      * use a mutex rather than spinning with IRQ's disabled and lock held
> |      * have a much longer timeout
> |      * call cond_resched while spinning
> |
> |    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> |    Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> |    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 

<hello, any maintainers out there?>

So afacit what's happening is that the above change caused one of your
PCI devices to take a very long time to initialise, yes?  Was it the
CCISS driver?

If you add "printk.time=y" to the kernel boot command line then you'll
get timestamped boot messages which will make it easier to determine
where the time was consumed.  Adding `initcall_debug' to the boot line
will help us delve further into the delay, assuming that the offending
driver is build into vmlinux (which it might not be).

Either way, it would be useful to know which driver the above change
broke.

Once we know that, the questions is: doe sthe driver still work?  If
so, then presumably the hardware if behaving unexpectedly, or in a way
which we're failing to cope with.

Or perhaps that patch was simply buggy.

btw, I don't agree that this report should be closed for "fuzziness"! 
AFACIT the regression clearly and reproducibly occurs on one of your
machines, yes?  That ain't fuzzy!

