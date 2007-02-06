Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXBFNNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXBFNNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXBFNNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:13:25 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:57198 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXBFNNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:13:24 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
In-Reply-To: <20070206020916.GA31476@wotan.suse.de>
References: <20070204063707.23659.20741.sendpatchset@linux.site>
	 <20070204063833.23659.55105.sendpatchset@linux.site>
	 <20070204014445.88e6c8c7.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702041036420.24838@hermes-1.csi.cam.ac.uk>
	 <20070204031039.46b56dbb.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702041737110.19190@hermes-1.csi.cam.ac.uk>
	 <20070206020916.GA31476@wotan.suse.de>
Content-Type: text/plain
Organization: Computing Service, University of Cambridge, UK
Date: Tue, 06 Feb 2007 13:13:06 +0000
Message-Id: <1170767587.12042.4.camel@imp.csi.cam.ac.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 03:09 +0100, Nick Piggin wrote:
> On Sun, Feb 04, 2007 at 05:40:35PM +0000, Anton Altaparmakov wrote:
> > On Sun, 4 Feb 2007, Andrew Morton wrote:
> > > truncate's OK: we're holding i_mutex.
> > 
> > How about excluding readpage() (in addition to truncate if Nick is right  
> > and some cases of truncate do not hold i_mutex) with an extra page flag as
> > I proposed for truncate exclusion?  Then it would not matter that
> > prepare_write might have allocated blocks and might expose stale data.    
> > It would go to sleep and wait on the bit to be cleared instead of trying  
> > to bring the page uptodate.  It can then lock the page and either find it 
> > uptodate (because commit_write did it) or not and then bring it uptodate.
> > 
> > Then we could safely fault in the page, copy from it into a temporary 
> > page, then lock the destination page again and copy into it.
> > 
> > This is getting more involved as a patch again...  )-:  But at least it   
> > does not affect the common case except for having to check the new page 
> > flag in every readpage() and truncate() call.  But at least the checks 
> > could be with an "if (unlikely(newpageflag()))" so should not be too bad.
> > 
> > Have I missed anything this time?
> 
> Yes. If you have a flag to exclude readpage(), then you must also
> exclude filemap_nopage, in which case it is still deadlocky.

Ouch, you are of course right.  )-:

Best regards,

        Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

