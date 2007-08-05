Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXHEPCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXHEPCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbXHEPCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:02:36 -0400
Received: from thunk.org ([69.25.196.29]:36901 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbXHEPCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:02:34 -0400
Date: Sun, 5 Aug 2007 10:46:45 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Claudio Martins <ctpm@ist.utl.pt>, Jeff Garzik <jeff@garzik.org>,
       Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805144645.GA28263@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Claudio Martins <ctpm@ist.utl.pt>, Jeff Garzik <jeff@garzik.org>,
	Ingo Molnar <mingo@elte.hu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
	dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
	richard@rsk.demon.co.uk, david@lang.hm
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu> <200708050051.40758.ctpm@ist.utl.pt> <20070805014926.400d0608@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805014926.400d0608@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 01:49:26AM +0100, Alan Cox wrote:
> HSM is the usual one, and to a large extent probably why Unix originally
> had atime. Basically migrating less used files away so as to keep the
> system disks tidy.
> 
> Its not something usally found on desktop boxes so it doesn't in anyway
> argue against the distribution using noatime or relative atime, but on
> big server boxes it matters

In addition, big server boxes are usually not reading a huge *number*
of files per second.  The place where you see this as a problem is (a)
compilation, thanks to huge /usr/include hierarchies (and here things
have gotten worse over time as include files have gotten much more
complex than in the early Unix days), and (b) silly desktop apps that
want to scan huge numbers of XML files or who want to read every
single image file on the desktop or in an open file browser window to
show c00l icons.  Oh, and I guess I should include Maildir setups.

If you are always reading from the same small set of files (i.e., a
database workload), then those inodes only get updated every 5 seconds
(the traditional/default metadata update sync time, as well as the
default ext3 journal update time), it's no big deal.  Or if you are
running a mail server, most of the time the mail queue files are
getting updated anyway as you process them, and usually the mail is
delivered before 5 seconds is up anyway.  

So earlier, when Ingo characterized it as, "whenever you read from a
file, even one in memory cache.... do a write!", it's probably a bit
unfair.  Traditional Unix systems simply had very different workload
characteristics than many modern dekstop systems today.

							- Ted
