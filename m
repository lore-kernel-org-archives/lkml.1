Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZC0RCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZC0RCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZC0RCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:02:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56237 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbZC0RCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:02:21 -0400
Date: Fri, 27 Mar 2009 17:02:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327170208.GA27646@srcf.ucam.org>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 04:51:50PM +0000, Alan Cox wrote:
> On Fri, 27 Mar 2009 16:28:41 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > The context was situations like errors on close() not occuring unless 
> > you've fsync()ed first. I don't think that error case is sufficiently 
> > common to warrant the cost of an fsync() on every single close, 
> > especially since doing so would cripple any application that ever tried 
> > to run on ext3.
> 
> The fsync if you need to see all errors on close case has been true since
> before V7 unix. Its the normal default behaviour on these systems so
> anyone who assumes otherwise is just broken. There is a limit to the
> extent the OS can clean up after completely broken user apps.

If user applications should always check errors, and if errors can't be 
reliably produced unless you fsync() before close(), then the correct 
behaviour for the kernel is to always flush buffers to disk before 
returning from close(). The reason we don't is that it would be an 
unacceptable performance hit to take in return for an uncommon case - in 
exactly the same way as always calling fsync() before close() is an 
unacceptable performance hit to take in return for an uncommon case.

> IMHO the real solution to a lot of this actually got proposed earlier in
> the thread. Adding "fbarrier()" allows the expression of ordering without
> blocking and provides something new apps can use to get best performance.

If every application that does a clobbering rename has to call 
fbarrier() first, then the kernel should just guarantee to do so on the 
application's behalf. ext3, ext4 and btrfs all effectively do this, so 
we should just make it explicit that Linux filesystems are expected to 
behave this way. If people want to make their code Linux specific then 
that's their problem, not the kernel's.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
