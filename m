Return-Path: <linux-kernel-owner+w=401wt.eu-S1750923AbXCLR30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923AbXCLR30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXCLR3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:29:25 -0400
Received: from styx.suse.cz ([82.119.242.94]:48175 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750760AbXCLR3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:29:25 -0400
Date: Mon, 12 Mar 2007 18:35:00 +0100
From: Jan Kara <jack@suse.cz>
To: Ashif Harji <asharji@cs.uwaterloo.ca>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: do_generic_mapping_read performance issue
Message-ID: <20070312173500.GF23532@duck.suse.cz>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca> <20070312142012.GH30777@atrey.karlin.mff.cuni.cz> <20070312143900.GB6016@wotan.suse.de> <20070312151355.GB23532@duck.suse.cz> <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-03-07 13:05:17, Ashif Harji wrote:
> 
> On Mon, 12 Mar 2007, Jan Kara wrote:
> 
> >On Mon 12-03-07 15:39:00, Nick Piggin wrote:
> >>On Mon, Mar 12, 2007 at 03:20:12PM +0100, Jan Kara wrote:
> >>>  Hi,
> >>>
> >>>>Hi, I am encountering a performance problem, which I have tracked into 
> >>>>the
> >>>>Linux kernel. The problem occurs with my experimental web server that 
> >>>>uses
> >>>>sendfile to repeatedly transmit files.  The files are based on the 
> >>>>static
> >>>>portion of the SPECweb99 fileset and range in size to model a reasonable
> >>>>workload.  With this workload, a significant number of the requests are
> >>>>for files of size 4 KB or less.
> >>>>
> >>>>I have determined that the performance problems occurs in the function
> >>>>do_generic_mapping_read in file mm/filemap.c for kernel version 
> >>>>2.6.20.1.
> >>>>Here is the specific code fragment:
> >>>>
> >>>>        /*
> >>>>         * When (part of) the same page is read multiple times
> >>>>         * in succession, only mark it as accessed the first time.
> >>>>         */
> >>>>        if (prev_index != index)
> >>>>                mark_page_accessed(page);
> >>>  Actually, the code is like that certainly for two years :).
> >>
> >>Did it always use ra->prev_page? ISTR it using pos%PAGE_SIZE == 0 at some
> >>stage (ie. read from the start of a page -- obviously that also has 
> >>holes).
> > Yes, at least in 2.6.12-rc5 which is the first one in git :).
> >
> >>>>I was wondering if anyone could explain why the call to 
> >>>>mark_page_accessed
> >>>>is conditional? That is, what problem it is trying to solve. It would 
> >>>>seem
> >>>>that in many scenarios, if the same page is accessed repeatedly, then it
> >>>>would be appropriate to keep that page cached.
> >>>  I also don't know why the condition is there but it's there at least
> >>>for two years so I'm not sure anybody remembers ;). Nick, do you have
> >>>an idea?
> >>
> >>Yeah it is there because that is basically how our "use once" detection
> >>handles the case where an app does not read in chunks that are PAGE_SIZE
> >>multiples and PAGE_SIZE aligned.
> > OK, I see. Then I'm not sure the check does more good than bad. Because
> >if we happen to reread the same chunk several times, then the check does a
> >wrong thing...
> 
> I would like to submit a patch to fix the performance problem.  The 
> simplest solution is to remove the check.  Even in the situation where an 
> application does not read in PAGE_SIZE multiples as described above, if 
> the page is accessed frequently it should remain in the cache.  However, I 
> am open to suggestions for a more sophisticated scheme.
  Well, yes, that's an obvious solution. I just wanted to make sure that
such change won't break some other load. But so far it seems it won't...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
