Return-Path: <linux-kernel-owner+w=401wt.eu-S965110AbXIBLFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110AbXIBLFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXIBLFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:05:07 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43144
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932369AbXIBLFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:05:05 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Date: Sun, 2 Sep 2007 06:05:00 -0500
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <200709020344.51437.rob@landley.net> <46DA7A4C.6080501@zytor.com>
In-Reply-To: <46DA7A4C.6080501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709020605.00782.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2007 3:54:36 am H. Peter Anvin wrote:
> Rob Landley wrote:
> > On Saturday 01 September 2007 5:16:03 pm Andi Kleen wrote:
> >> Rob Landley <rob@landley.net> writes:
> >>> A lot of embedded people like to configure /proc out of the kernel for
> >>> space reasons.  This would make that noticeably more painful.
> >>
> >> I had a patch for a sysctl_name(2) for this a long time ago.
> >> If it was a serious issue that could be reintroduced.
> >>
> >> BTW sysctl(2) only needs to be quiet for a single sysctl used
> >> by glibc.
> >>
> >> -Andi
> >
> > Yeah, I found it:
> > http://lkml.org/lkml/2003/7/10/345
> >
> > I think that if /proc/sys could be broken out as a separate filesystem,
> > and it was small and simple, the embedded people would probably be happy.
> >  Is your patch significantly smaller than such a filesystem would be? 
> > (Keeping in mind that the smallest thing you can do is run from
> > initramfs, and I think that's pulling in libfs already...)
>
> IMO, the big problem with /proc/sys (and, for that matter, /sys) is
> mainly that they have to live in the process namespace, which is highly
> awkward when one uses chroot().
>
> One way to solve *that* might be a system call to get a file descriptor
> to the root of sysfs or procsysfs which can be used with openat().  That
> has its own perils, of course...

If you're going to add a new api, you might as well go with the sysctl-by-name 
patch above, which looks reasonably small and simple to me from a very quick 
glance at a 2.6.0-era patch.

The advantage of breaking /proc/sys into a separate filesystem doesn't 
introduce a new API (although possibly a new line in the init scripts), so 
existing software doesn't have to change to use it, which is good.  It 
increases orthogonality and granularity, which embedded guys like me are 
generally in favor of. :)

On the other hand, if you're adding a system call to get a file descriptor to 
an arbitrary superblock you can then openat...  How do you refer to said 
superblock?  (Perhaps invent a "volume" syntax for all the superblocks, ala 
the amiga?  Do the /proc and /sys superblocks exist if nobody's mounted them 
yet?  Yes the open could instantiate them, but I'm wondering about the "list 
available filesystems that aren't in your namespace" and the security fun 
from that.  Presumably this is doable as non-root, because if you're root you 
can just mount /proc and /sys and go from there...)

You could also special case "mount" so that if you try to mount sysfs on /sys 
or proc on /proc (and they're not already mount points) you don't need to be 
root.  Seems a bit evil, though...

> 	-hpa

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
