Return-Path: <linux-kernel-owner+w=401wt.eu-S1765233AbYD1CLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765233AbYD1CLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 22:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYD1CLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 22:11:05 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:50104 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942AbYD1CLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 22:11:04 -0400
Date: Sun, 27 Apr 2008 22:10:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org, alexl@redhat.com
Subject: Re: stat benchmark
Message-ID: <20080428021042.GB30840@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Soeren Sandmann <sandmann@daimi.au.dk>,
	linux-kernel@vger.kernel.org, alexl@redhat.com
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk> <20080425194845.GE21193@mit.edu> <ye8iqy23mhb.fsf@camel27.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye8iqy23mhb.fsf@camel27.daimi.au.dk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 01:29:52AM +0200, Soeren Sandmann wrote:
> Sorting by inode is a major improvement. The numbers are less stable,
> but consistently much lower:
> 
>     Time to readdir(): 0.238737 s
>     Time to stat 2366 files: 1.338904 s
> 
> compared to
> 
>     Time to readdir(): 0.227599 s
>     Time to stat 2366 files: 7.981752 s
> 
> Of course, 1.3 seconds is still far from instant, but it may be the
> best we can get given the realities of ext3 disk layout.

Out of curiosity, what was the directory that you were stating?  If it
took you 1.3 seconds to stat 2366, the directory have inodes scattered
all over the disk, or the disk must be very slow.  On my laptop disk,
I can stat 9543 files in 1.1 seconds (from a Maildir directory).

Also, why does the application need to stat all of the files?  Is it
just to get the file type?  (i.e., regular file vs. directory)  If so,
maybe you can use the d_type field in the directory entry returned by
readdir().

> I don't know if a general library outside glib would be useful. It
> seems that just telling people to "sort by inode before statting"
> would be just as effective as telling them "use this optimized
> library".

Well, the question is what we would need to do in order to make it
really easy for people to drop that into their code.  Programmers are
fundamentally lazy, after all, and if it's too much work to create an
interim data structure, and then qsort it, they won't.  But maybe the
glib interface is that convenient interface, and all we need to do is
change glibc to sort with a much larger chunk size.

We do need to get similar changes into find, ls, and many other
programs that might not be so interestedin linking against glibc,
though.

                     	     	     	    	 - Ted
