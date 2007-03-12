Return-Path: <linux-kernel-owner+w=401wt.eu-S965883AbXCLOUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965883AbXCLOUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965886AbXCLOUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:20:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52642 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965883AbXCLOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:20:13 -0400
Date: Mon, 12 Mar 2007 15:20:12 +0100
From: Jan Kara <jack@suse.cz>
To: Ashif Harji <asharji@cs.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: do_generic_mapping_read performance issue
Message-ID: <20070312142012.GH30777@atrey.karlin.mff.cuni.cz>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> Hi, I am encountering a performance problem, which I have tracked into the 
> Linux kernel. The problem occurs with my experimental web server that uses 
> sendfile to repeatedly transmit files.  The files are based on the static 
> portion of the SPECweb99 fileset and range in size to model a reasonable 
> workload.  With this workload, a significant number of the requests are 
> for files of size 4 KB or less.
> 
> I have determined that the performance problems occurs in the function
> do_generic_mapping_read in file mm/filemap.c for kernel version 2.6.20.1.
> Here is the specific code fragment:
> 
>         /*
>          * When (part of) the same page is read multiple times
>          * in succession, only mark it as accessed the first time.
>          */
>         if (prev_index != index)
>                 mark_page_accessed(page);
  Actually, the code is like that certainly for two years :).

> The implication of this code is that for files of size less than or equal 
> to a single page, the page associated with such a file is likely to get 
> evicted from the cache regardless of how frequently it is accessed.  The 
> reason is that after the first access, prev_index is always zero and index 
> can only be zero. Hence, mark_page_accessed is never called after the 
> first time the file is requested.  As a result, the page is evicted from 
> the cache no matter how frequently it is used.  By changing the kernel to 
> always call mark_page_accessed for these files, the server throughput is 
> increased by as much as 20%.
  Your analysis seems to be right. But to observe this behaviour you have
to have the file open and just always reread it using the same file
descriptor, don't you? That's probably not too common...

> I was wondering if anyone could explain why the call to mark_page_accessed 
> is conditional? That is, what problem it is trying to solve. It would seem 
> that in many scenarios, if the same page is accessed repeatedly, then it 
> would be appropriate to keep that page cached.
  I also don't know why the condition is there but it's there at least
for two years so I'm not sure anybody remembers ;). Nick, do you have
an idea?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
