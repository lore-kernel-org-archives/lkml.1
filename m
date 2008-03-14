Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYCNVgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYCNVgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYCNVf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:35:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33558 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYCNVf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:35:56 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Dave Hansen <haveblue@us.ibm.com>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>, Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org
In-Reply-To: <47DAE55C.3080506@tremplin-utc.net>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>
	 <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>
	 <1205525184.12763.32.camel@nimitz.home.sr71.net>
	 <47DAE55C.3080506@tremplin-utc.net>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 14:35:51 -0700
Message-Id: <1205530551.8167.20.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 21:51 +0100, Eric Piel wrote:
> I'm not sure it would be possible to delay acpi_early_init() until after 
> the fs initcalls. Maybe Len knows. How about trying the opposite: what 
> is the barely minimum to initialize so that the rootfs can be populated 
> and read? Would it be possible to have a kind of 
> early_mnt_writer_initialize() that would do that?

I *can* probably do it earlier, maybe even statically, but I think
you're missing the point a bit here.  We've just been super lucky so far
that populate_rootfs() doesn't depend on any other initcalls (or at
least BUG_ON() because of them).  There may be some more buglets hiding
around.

It'd be a shame to have to have "super_early_fs_initcall()" logic for
every part of the VFS or any other initcall for that matter that you
might need.  How do we tell all future VFS hackers that they have to do
this so that the next guy doesn't break it?  I certainly missed it. :)

We could separate out the initcalls and just have the fs ones run before
the rest do.  But, I'm not sure what interactions *THAT* might have.
There are arch-specific initcalls, and I have no idea if the fs init
code depends on *those*.  That's a lot of code to check.

It is nailed when you the patch says:

+       /*
+        * Never do this at home, only the user-space is allowed to open a file.
+        * The clean way would be to use the firmware loader. But this code must be run
+        * before there is any userspace available. So we need a static/init firmware
+        * infrastructure, which doesn't exist yet...
+        */

I think requiring FS access this early in the boot processes is just
broken.  It seems like the author of the patch knew a better way and
tried to get away with a hack.  I think it backfired. :)

-- Dave

