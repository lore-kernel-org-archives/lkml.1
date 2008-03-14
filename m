Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYCNUGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYCNUGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYCNUGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:06:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36374 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbYCNUG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:06:28 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Dave Hansen <haveblue@us.ibm.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Eric Piel <eric.piel@tremplin-utc.net>, Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org
In-Reply-To: <1205517802.12763.18.camel@nimitz.home.sr71.net>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>
	 <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 13:06:24 -0700
Message-Id: <1205525184.12763.32.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those of you new to this thread, here's the initial report:

	http://marc.info/?t=120536629300001&r=1&w=2

I'm pretty sure the root cause of this bug is this commit:

	ACPI: basic initramfs DSDT override support
	71fc47a9adf8ee89e5c96a47222915c5485ac437

Which did this hunk:
        
        @@ -648,6 +654,7 @@ asmlinkage void __init start_kernel(void)
         
                check_bugs();
         
        +       populate_rootfs(); /* For DSDT override from initramfs
        */
                acpi_early_init(); /* before LAPIC and SMP init */
         
                /* Do the rest non-__init'ed, we're now alive */
        	rest_init();
        ...

Well, the fs initcalls aren't actually done until during rest_init(),
including initializing my mnt_writer[] spinlocks.  I guess I could
statically initialize them, but that's not the root of the problem, it's
just the canary in the coal mine.

I think the populate_rootfs() call is completely bogus and certainly
can't be done before the initcalls.  But, I don't immediately have any
better suggestions for you.  Can you delay the ACPI init until after the
fs initcalls are made?

-- Dave

