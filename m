Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbYB2Iof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbYB2Iof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 03:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYB2IoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 03:44:25 -0500
Received: from lazybastard.de ([212.112.238.170]:48014 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYB2IoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 03:44:24 -0500
Date: Fri, 29 Feb 2008 09:43:45 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: swap file over jffs2 partition
Message-ID: <20080229084345.GA16507@lazybastard.org>
References: <47C772E9.2000000@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47C772E9.2000000@gmx.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 February 2008 04:50:17 +0200, Dimitrios Apostolou wrote:
> 
> I intend to build a diskless linux system (root over NFS). Because it
> has 1GB of embedded flash storage, I'm thinking of using this as swap 
> (I've been bitten many times by the problems linux has with *no* 
> swap...). And to avoid wearing out the flash storage too fast, I 'm 
> thinking to format the 1GB partition as JFFS2, and create the swapfile 
> on top of it.
> 
> I'm not so experienced with JFFS and I don't know if it's too heavy for
> the CPU, for swapping. Or if there are other issues I 'll face. What do
> you think about it? Any other ways you 'd propose?
> 
> Sorry for sending this at LKML but jffs-dev mailing list seems to be 
> off. And JFFS is the only in-kernel filesystem that does wear-leveling, 
> right?

Replying in reverse order...

The relevant mailing list is linux-mtd, added to Cc:.  JFFS and JFFS2
are two different things, JFFS is older and was removed from the kernel
not too long ago.

The real fun comes not from CPU usage, but from interactions with the
memory management subsystem.  In a nutshell, JFFS2 may require memory in
order to write data.  When the system is under memory pressure, it needs
JFFS2 to write out pages, which will try to allocate memory.  It is
theoretically possible to deadlock the system in this way.

On the plus side, the write path of JFFS2 is relatively simple and
extremely low-latency.  It shouldn't be too hard to review the code and
handle all problem cases wrt. memory allocations.

One issue that is hard to solve is space reservation.  JFFS2 compresses
data and allows users to write as long as there is space remaining.  It
is possible to swap out data that compresses well, have some other
process fill up the filesystem, then try to swap out data that
compresses badly and get -ENOSPC in return.  As a system administrator
you can prevent others from ever writing to JFFS2 - and you better do!

Jörn

-- 
Joern's library part 5:
http://www.faqs.org/faqs/compression-faq/part2/section-9.html
