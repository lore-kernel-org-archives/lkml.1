Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXIQOdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXIQOdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbXIQOdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:33:10 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34204 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbXIQOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:33:09 -0400
Date: Mon, 17 Sep 2007 16:32:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Message-ID: <20070917163257.331c7605@twins>
In-Reply-To: <13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>
	<1189850897.21778.301.camel@twins>
	<20070915035228.8b8a7d6d.akpm@linux-foundation.org>
	<13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 15:04:05 +0100 Anton Altaparmakov <aia21@cam.ac.uk>
wrote:

> They files  
> are attached this time rather than inlined so people don't complain  
> about line wrapping!  (No doubt people will not complain about them  
> being attached!  )-:)

I switched mailer after I learnt about flowed stuffs. Still,
appreciated.

> If I read it correctly it appears all of low memory is eaten up by  
> buffer_heads.
> 
> <quote>
> # name            <active_objs> <num_objs> <objsize> <objperslab>  
> <pagesperslab>
> : tunables <limit> <batchcount> <sharedfactor> : slabdata  
> <active_slabs> <num_s
> labs> <sharedavail>
> buffer_head       12569528 12569535     56   67    1 : tunables   
> 120   60    8 :
> slabdata 187605 187605      0
> </quote>
> 
> That is 671MiB of low memory in buffer_heads.
> 
> But why is the kernel not reclaiming them by getting rid of the page  
> cache pages they are attached to or even leaving the pages around but  
> killing their buffers?

Well, you see, you have this very odd configuration where:

11GB highmem
 1GB normal

pagecache pages go into highmem
buggerheads go into normal

I'm guessing there is no pressure at all on zone_highmem so the
kernel will not try to reclaim pagecache. And because the pagecache
pages are happily sitting there, the buggerheads are pinned and do not
get reclaimed.
