Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab0BBTTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:19:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756976Ab0BBTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:19:14 -0500
Date: Tue, 2 Feb 2010 11:14:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Olivier Galibert <galibert@pobox.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] readahead: dont do start-of-file readahead after
 lseek()
In-Reply-To: <20100202184831.GD75577@dspnet.fr.eu.org>
Message-ID: <alpine.LFD.2.00.1002021111240.3664@localhost.localdomain>
References: <20100202152835.683907822@intel.com> <20100202153317.644170708@intel.com> <20100202181321.GB75577@dspnet.fr.eu.org> <alpine.LFD.2.00.1002021037110.3664@localhost.localdomain> <20100202184831.GD75577@dspnet.fr.eu.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Feb 2010, Olivier Galibert wrote:
>
> On Tue, Feb 02, 2010 at 10:40:41AM -0800, Linus Torvalds wrote:
> > IOW, if you start off with a SEEK_END, I think it's reasonable to expect 
> > it to _not_ read the whole thing.
> 
> I've seen a lot of:
>   int fd = open(...);
>   size = lseek(fd, 0, SEEK_END);
>   lseek(fd, 0, SEEK_SET);
> 
>   data = malloc(size);
>   read(fd, data, size);
>   close(fd);
> 
> Why not fstat?  I don't know.

Well, the above will work perfectly with or without the patch, since it 
does the read of the full size. There is no read-ahead hint necessary for 
that kind of single read behavior.

Rememebr: read-ahead is about filling the empty IO spaces _between_ reads, 
and turning many smaller reads into one bigger one. If you only have a 
single big read, read-ahead cannot help.

Also, keep in mind that read-ahead is not always a win. It can be a huge 
loss too. Which is why we have _heuristics_. They fundamentally cannot 
catch every case, but what they aim for is to do a good job on average.

			Linus
