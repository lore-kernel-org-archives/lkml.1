Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbZHANlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbZHANlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 09:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZHANlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 09:41:52 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60877 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZHANlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 09:41:51 -0400
Date: Sat, 1 Aug 2009 09:41:46 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Scott James Remnant <scott@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern
Message-ID: <20090801134146.GA19910@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <1248880382.23840.78.camel@quest> <20090729201857.GC17410@hmsreliant.think-freely.org> <1249071610.4800.5.camel@wing-commander>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249071610.4800.5.camel@wing-commander>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 09:20:10PM +0100, Scott James Remnant wrote:
> On Wed, 2009-07-29 at 16:18 -0400, Neil Horman wrote:
> 
> > On Wed, Jul 29, 2009 at 04:13:02PM +0100, Scott James Remnant wrote:
> > > On Mon, 2009-06-22 at 13:28 -0400, Neil Horman wrote:
> > > 
> > > > 2) Allow for the kernel to wait for a core_pattern process to complete.  One of
> > > > the things core_pattern processes might do is interrogate the status of a
> > > > crashing process via its /proc/pid directory.  To ensure that that directory is
> > > > not removed prematurely, we wait for the process to exit prior to cleaning it
> > > > up.
> > > > 
> > > Would this mean that the kernel would wait for the pattern process to
> > > complete before PANIC in the case of init core dumping?
> > > 
> > > I'd find that useful :-)
> > > 
> > Not without additional work.  If init crashed in the initramfs, I don't think
> > theres a way to handle that.  If it crashes at some later time, I think it just
> > gets restarted IIRC.  I'm sure you can change that behavior, but this patch
> > doesn't address that.
> > 
> When the system init daemon crashes, the kernel PANICs.  When not using
> core_pattern, this is ok, we get a core file - when using apport, as far
> as I can tell it never waits for apport to finish so we don't get the
> crash.
> 
This is non-sensical.  If init crashes, and the kernel panics, you'll only get a
core by sheer luck and good fortune.  The kernels paniced, theres no
serialization between the halting/rebooting of cpus and the completion of a core
dump operation, be it to a pipe or disk.

> I was hoping that by waiting for the core_pattern process to finish,
> this might solve this issue.
> 
See above, some of it might work, but if the kernel is going to panic, theres no
way to fork another process, let alone wait for it to finish, at least not with
any level of reliability.

> The other obvious fix I can apply to the init daemon is to reset the
> core pattern and deliberately dump core somewhere that can be picked up.
> 
how are you getting this core if the system is actually panic'ed?  Or is
something else actually happening.

> > If you want to debug a custom init process, why not run a wrapper program as
> > init, that just forks the init you want to run and captures the core when it
> > crashes?
> > 
> Because then that's not the init daemon; it's not pid 1, it doesn't have
> processes reparented to it.  And it's very annoying having the entire
> system reparented to gdb, which doesn't deal so well with that ;-)
> 

You're not by any chance talking about an init crash that results in a respawn
are you?  That doesn't result in a panic, and would allow for a crash to
complete.  If thats the case, then core_pattern might just work (I admit to not
having tried it).

Neil

> Scott
> -- 
> Scott James Remnant
> scott@ubuntu.com


