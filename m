Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZKMLqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZKMLqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZKMLq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:46:27 -0500
Received: from smtp.nokia.com ([192.100.122.230]:33903 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZKMLq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:46:26 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: David VomLehn <dvomlehn@cisco.com>,
       Marco Stornelli <marco.stornelli@gmail.com>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
In-Reply-To: <20091113091031.3f6d4bba@marrow.netinsight.se>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	 <4AFC4D31.2000101@gmail.com>
	 <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
	 <20091113091031.3f6d4bba@marrow.netinsight.se>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 13:45:48 +0200
Message-Id: <1258112748.21596.1227.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Nov 2009 11:45:59.0744 (UTC) FILETIME=[DE903C00:01CA6456]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 09:10 +0100, Simon Kagstrom wrote:
> On Thu, 12 Nov 2009 16:56:49 -0500
> David VomLehn <dvomlehn@cisco.com> wrote:
> 
> > Good question. Some more detail on our application might help. In some
> > situations, we may have no disk and only enough flash for the bootloader.
> > The kernel is downloaded over the network. When we get to user space, we
> > initialize a number of things dynamically. For example, we dynamically
> > compute some MAC address, and most of the IP addresses are obtained with
> > DHCP. This are very useful to have for panic analysis.
> > 
> > Since there is neither flash nor disk, user space has no place to store
> > this information, should the kernel panic. When we come back up, we will get
> > different MAC and IP addresses. Storing them in memory is our only hope.
> > 
> > Fortunately, there is a section of RAM that the bootloader promises not
> > to overwrite. On a panic, we capture the messages written on the console
> > and store them in the protected area. If the information from the
> > /proc file is written as part of the panic, we will capture it, too.
> 
> Can't you solve this completely from userspace using phram and mtdoops
> instead? I.e., setup two phram areas
> 
> 	modprobe phram 4K@start-of-your-area,4K@start-of-your-area+4K    # Can't remember the exact syntax!
> 
> you'll then get /dev/mtdX and /dev/mtdX+1 for these two. You can then do
> 
> 	modprobe mtdoops mtddev=/dev/mtdX+1 dump_oops=0
> 
> to load mtdoops to catch the panic in the second area, and just write
> your userspace messages to /dev/mtdX.

This might work for them, not sure, but not for us. We store panics on
flash, and later they are automatically sent to the panic collection
system via the network. And the complications are:

1. There may be many panics before the device has network access and has
a chance to send the panics.
2. User can re-flash the device with different SW inbetween.

So we really need to print some user-space supplied information during
the panic, and then we store it on flash with mtdoops, and the later,
when the device has network access we send whole bunch of oopses via the
network.

> One thing probably have to be fixed though: I don't think phram has a
> panic_write, which will be needed by mtdoops to catch the panic - this
> should be trivial to add though since it's plain RAM.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

