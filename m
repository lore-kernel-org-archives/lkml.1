Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZKMIKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZKMIKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZKMIKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:10:33 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:21926 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754147AbZKMIKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:10:32 -0500
Date: Fri, 13 Nov 2009 09:10:31 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
Message-ID: <20091113091031.3f6d4bba@marrow.netinsight.se>
In-Reply-To: <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	<4AFC4D31.2000101@gmail.com>
	<20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 16:56:49 -0500
David VomLehn <dvomlehn@cisco.com> wrote:

> Good question. Some more detail on our application might help. In some
> situations, we may have no disk and only enough flash for the bootloader.
> The kernel is downloaded over the network. When we get to user space, we
> initialize a number of things dynamically. For example, we dynamically
> compute some MAC address, and most of the IP addresses are obtained with
> DHCP. This are very useful to have for panic analysis.
> 
> Since there is neither flash nor disk, user space has no place to store
> this information, should the kernel panic. When we come back up, we will get
> different MAC and IP addresses. Storing them in memory is our only hope.
> 
> Fortunately, there is a section of RAM that the bootloader promises not
> to overwrite. On a panic, we capture the messages written on the console
> and store them in the protected area. If the information from the
> /proc file is written as part of the panic, we will capture it, too.

Can't you solve this completely from userspace using phram and mtdoops
instead? I.e., setup two phram areas

	modprobe phram 4K@start-of-your-area,4K@start-of-your-area+4K    # Can't remember the exact syntax!

you'll then get /dev/mtdX and /dev/mtdX+1 for these two. You can then do

	modprobe mtdoops mtddev=/dev/mtdX+1 dump_oops=0

to load mtdoops to catch the panic in the second area, and just write
your userspace messages to /dev/mtdX.


One thing probably have to be fixed though: I don't think phram has a
panic_write, which will be needed by mtdoops to catch the panic - this
should be trivial to add though since it's plain RAM.

// Simon
