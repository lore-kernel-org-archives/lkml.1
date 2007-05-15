Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbXEOEtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbXEOEtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758006AbXEOEtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:49:18 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45018
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628AbXEOEtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:49:16 -0400
From: Rob Landley <rob@landley.net>
To: Dave Jones <davej@redhat.com>
Subject: Re: tracking down disk spinups.
Date: Tue, 15 May 2007 00:49:06 -0400
User-Agent: KMail/1.9.1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070514185734.GM27604@redhat.com> <200705141628.35617.rob@landley.net> <20070514204651.GA7242@redhat.com>
In-Reply-To: <20070514204651.GA7242@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705150049.06974.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 4:46 pm, Dave Jones wrote:
> On Mon, May 14, 2007 at 04:28:35PM -0400, Rob Landley wrote:
>  > On Monday 14 May 2007 2:57 pm, Dave Jones wrote:
>  > > Why did the kernel ignore what I told it to do ?
>  > > I'm sure it thinks it knows better than me for a reason, but
>  > > I'd like to know what it is.
>  > 
>  > Remount doesn't switch filesystem drivers, it tells the existing 
filesystem 
>  > driver to accept new flags and/or a new option string.
> 
> yes, I had misinterpreted what 'remount' did. I thought behind the scenes
> it actually did a umount/mount.

I implemented the BusyBox mount command last year.  (Well, rewrote three times 
until just about none of the old code was left.)  Getting remount to work 
right is a monster headache.  (The new flags _replace_ the old flags, not 
delta against them, so you have to parse /etc/mtab (or /proc/mounts), read 
the old flags out of that, mask them yourself, and supply them back in.  And 
of course, not all of them are flags, some remain strings, but you can't keep 
strings you turned into flags because the driver will barf that it's an 
unrecognized string option...  Headache.  And don't get me started on vfat 
spitting back string options from /proc/mounts that are THE DEFAULT VALUES...  
Grrr.  I'll stop now.)

You can always umount/mount yourself.

>  > To switch drivers you have to umount the old sucker and mount the new 
one.  
>  > (The idea of handing off consistent cache data from one mounted 
filesystem 
>  > driver to another...  Ouch.)
> 
> a umount would purge the cache, but that's irrelevant given it doesn't
> work that way.
> 
> Anyways, I rebooted after s/ext3/ext2/ on my fstab, and found things
> hadn't really got any more obvious what was going on.
> Instead of 'kjournald' writing stuff out, now it's 'pdflush'.
> 
> *has sudden brainwave*
> 
> Ahh, it's doing atime updates. Duh.

I had to add MS_SILENT (1<<15) to the default mount options for busybox 
(because otherwise the kernel got log message diarrhea).  I was seriously 
tempted to add MS_NOATIME to that, but didn't.

I should write up a good "mount" spec, from the kernel's point of view.  
(There isn't one.  I looked.)

Rob
