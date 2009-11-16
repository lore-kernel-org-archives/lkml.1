Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbZKPKzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbZKPKzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZKPKzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:55:08 -0500
Received: from verein.lst.de ([213.95.11.210]:40751 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbZKPKzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:55:07 -0500
Date: Mon, 16 Nov 2009 11:54:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, John Kacur <jkacur@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] macintosh: Explicitly set llseek to no_llseek in ans-lcd
Message-ID: <20091116105427.GA17411@lst.de>
References: <20091010153314.827301943@linutronix.de> <alpine.LFD.2.00.0910212350210.3526@localhost.localdomain> <20091021221619.GF4880@nowhere> <200911021651.53331.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911021651.53331.arnd@arndb.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 04:51:52PM +0100, Arnd Bergmann wrote:
> I looked at what places in the code manipulate file->f_pos directly
> and found that almost all the uses in driver code are broken because
> they don't take any locks. Most of them are in driver specific
> lseek operations. Others are in read/write methods and are even
> more broken because the change gets immediately overwritten by
> vfs_read/vfs_write when the driver method returns.
> 
> IMHO, we should complete the pushdown into all ioctl methods
> that John and Thomas have started working on, fixing the lseek
> methods in those files we touch.
> 
> When that is done, all interaction between default_llseek and
> driver locking has to be with explicit calls to lock_kernel
> in those drivers, so we can reasonably well script the search
> for drivers needing the BKL in llseek: everyhing that
>  a) defines file_operations without an llseek function,
>  b) touches f_pos somewhere, and
>  c) calls lock_kernel() somewhere
> That should only be a small number and when they are fixed,
> we can remove default_llseek and instead call generic_file_llseek
> for any file operation without a separate llseek method.

As mentioned before making generic_file_llseek the new default is
probably a bad idea.  The majority of our file_operations instances
don't actually support seeking, so no_llseek should become the new
default if you spend some effort on converting things.  Anything that
wants to allow seeking will have to set a llseek method.  This also
mirrors what we do for other file operations.  None of the major ones
has a non-trivial default, it's either silently succeeding for a
selected few like open or release or returning an error for operatings
that actually do something like read and write.

