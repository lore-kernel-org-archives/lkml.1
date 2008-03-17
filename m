Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYCQMX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYCQMX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYCQMXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:23:47 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:8940 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752707AbYCQMXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:23:45 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1205698279.8167.44.camel@nimitz.home.sr71.net>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>
	 <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>
	 <1205525184.12763.32.camel@nimitz.home.sr71.net>
	 <47DAE55C.3080506@tremplin-utc.net>
	 <1205530551.8167.20.camel@nimitz.home.sr71.net>
	 <47DB013D.3060102@tremplin-utc.net>
	 <1205537395.8167.31.camel@nimitz.home.sr71.net>  <47DBC578.7050101@imap.cc>
	 <1205698279.8167.44.camel@nimitz.home.sr71.net>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 13:23:35 +0100
Message-Id: <1205756615.8514.311.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-16 at 13:11 -0700, Dave Hansen wrote:

> >  ACPI: Core revision 20070126
> > +INFO: trying to register non-static key.
> > +the code is fine but needs lockdep annotation.
> > +turning off the locking correctness validator.
> > +Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1-testing #3
> > + [<c014321e>] __lock_acquire+0x144/0xb6e
> > + [<c010b1a2>] ? native_sched_clock+0xe0/0xff
> > + [<c017fc57>] ? kmem_cache_alloc+0x89/0xc9
> > + [<c0142ce0>] ? trace_hardirqs_on+0xe8/0x11d
> > + [<c014404f>] lock_acquire+0x6a/0x90
> > + [<c013b460>] ? down_trylock+0xc/0x27
> > + [<c03016cb>] _spin_lock_irqsave+0x42/0x72
> > + [<c013b460>] ? down_trylock+0xc/0x27
> > + [<c013b460>] down_trylock+0xc/0x27
> > + [<c021fa65>] acpi_os_wait_semaphore+0x67/0x13d
> > + [<c023a39e>] acpi_ut_acquire_mutex+0x65/0xcf
> > + [<c0230261>] acpi_ns_root_initialize+0x1a/0x289
> > + [<c043ad54>] acpi_initialize_subsystem+0x47/0x6a
> > + [<c043afd4>] acpi_early_init+0x57/0xf8
> > + [<c04248ff>] start_kernel+0x34d/0x35a
> > + [<c0424019>] i386_start_kernel+0x8/0xa
> > + =======================
> >  ACPI: Checking initramfs for custom DSDT
> >  Parsing all Control Methods:
> >  Table [DSDT](id 0001) - 637 Objects with 63 Devices 160 Methods 41
> > Regions
> 
> Hi Tim,
> 
> Again, thanks for the excellent bug reporting. 
> 
> This is actually a different problem (and not my code again, thank
> goodness).  I think a few of these got fixed in current -mm.  According
> to Peter Z, these mean:
> 
> > It means the lock_class_key ended up in non-static storage.
> > 
> > In practise it often means you initialized a on-stack structure
> > incorrectly. DECLARE_WAIT_QUEUE_HEAD() vs
> > DECLARE_WAIT_QUEUE_HEAD_ONSTACK() for example.
> 
> So, this looks like an on-stack ACPI structure that got initialized
> wrongly.  At least we already have those dudes on the cc. :)

Actually looks like the semaphore thing again, its a spinlock inside of
down_tylock().

> But, this might also get fixed by reverting the patch as Linus just did.
> It might just be best to wait for another -mm release and see how it
> settles out.  

Looks like another of the semaphore thingies.. Does this go away once
you apply the semaphore lockdep fixup from here:

  http://lkml.org/lkml/2008/3/12/63

