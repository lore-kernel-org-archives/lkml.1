Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYDJPMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYDJPMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbYDJPMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:12:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42000 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759698AbYDJPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:12:23 -0400
Date: Thu, 10 Apr 2008 17:12:18 +0200
From: Jan Kara <jack@suse.cz>
To: Martin Mares <mj@ucw.cz>
Cc: Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410151218.GD6725@atrey.karlin.mff.cuni.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <mj+md-20080410.140857.3331.nikam@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mj+md-20080410.140857.3331.nikam@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello!
> 
> > [*] file_pos_{read,write} (fs/read_write.c) are not called under lock (in 
> > sys_read, sys_write, ...), so even if f_pos is written atomically, you will 
> > be able to get races when accessing shared descriptor from different threads.
> 
> There are however cases when such behavior is perfectly valid: For example
> you can have a file of records of a fixed size, whose order does not matter.
> Then multiple processes can produce the records in parallel, sharing
> a single fd.
  Well, but noone guarantees that both processes don't read the same
data.

> > I think that POSIX states, that behavior is undefined under these conditions.
> 
> Do you have a pointer to that?
  SUSv3 says:
On files that support seeking (for example, a regular file), the read()
shall start at a position in the file given by the file offset
associated with fildes. The file offset shall be incremented by the
number of bytes actually read.

  But nowhere is specified when this happens so OS is perfectly free to
advance f_pos after read finishes when read from the other process is
already running. And Linux does exactly that - actually, we do:
  pos = f_pos
  do reading which advances pos
  f_pos = pos

  So it can even in theory happen that one thread reads entries 1,2,3,2
because the other thread in the mean time finished reading entry 1...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
