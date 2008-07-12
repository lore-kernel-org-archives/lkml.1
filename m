Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYGLSud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYGLSud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 14:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYGLSuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 14:50:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35773 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYGLSuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 14:50:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [linux-pm] [PATCH -mm 1/2] kexec jump -v12: kexec jump
Date: Sat, 12 Jul 2008 20:52:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
References: <Pine.LNX.4.44L0.0807112255450.9023-100000@netrider.rowland.org> <m1ej5z4v7v.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ej5z4v7v.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807122052.43805.rjw@sisk.pl>
X-Length: 3795
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 of July 2008, Eric W. Biederman wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Fri, 11 Jul 2008, Eric W. Biederman wrote:
> >
> >> I just realized with a little care the block layer does have support for this,
> >> or something very close.
> >> 
> >> You setup a software raid mirror with one disk device.    The physical
> >> device can come in and out while the filesystems depend on the real device.
> >
> > Do you mean "the filesystems depend on the logical RAID device"?  
> 
> Oh yes. Thinko.
> 
> > What's to prevent userspace from accessing the physical device 
> > directly?
> 
> Nothing.
> 
> > What this amounts to, in the end, is having a way to distinguish the
> > set of I/O requests coming from the hibernation code (reading or
> > writing the memory image) from the set of all other I/O requests.  The
> > driver or the block layer has to be set up to allow the first set
> > through while blocking the second set.  (And don't forget about the 
> > complications caused by error-recovery I/O during the hibernation 
> > activity!)
> 
> I guess this problem exists but it is not at all the problem I was
> thinking of.
> 
> > Forcing the second set of requests to filter through an extra software 
> > layer is a clumsy way of accomplishing this.  There ought to be a 
> > better approach.
> 
> The point was something different.  The reasons we can not store the
> state of the system with the hardware devices logically hot unplugged
> (and thus reuse all of the find device hotplug methods) is because
> things like the filesystem layer don't know how to cope with their
> block devices going away an coming back.
> 
> That is the problem inserting an virtual software device in the middle
> can solve.  If that works should there be a better way?  Certainly but
> to prove it out starting with a block device wrapper is a trivial way to
> go.

I have discussed that with Jens a bit and it seems we can use a special I/O
scheduler that will separate the image saving I/O from any other I/O, allowing
only the former to reach lower layers.  Since you can switch I/O schedulers on
the fly already, quite a bit of the necessary functionality is in place.

Of course, we also need character device drivers to block user space while
suspended and we need ioctls to be handled correctly at that time etc.

That said, even if devices are accessed while we're saving the image, there
will be no damage as long as those accesses will not result in any data being
actually written to non-volatile storage, such as disks.

Thanks,
Rafael
