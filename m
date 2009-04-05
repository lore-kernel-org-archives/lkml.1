Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZDEELx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZDEELx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 00:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbZDEEJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 00:09:47 -0400
Received: from thunk.org ([69.25.196.29]:54165 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749AbZDEEJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 00:09:44 -0400
Date: Sat, 4 Apr 2009 20:20:13 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Message-ID: <20090405002013.GB7553@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <alpine.LFD.2.00.0904041448090.4023@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904041448090.4023@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 03:13:13PM -0700, Linus Torvalds wrote:
> And yes, anticipatory seems to be quite noticeably better than cfq here. 
> With cfq I got a few two-second delays on 'ftruncate()' too (probably 
> because of your new serialization code?), and the longest fsync() delay 
> was over 7 seconds. That was definitely solidly in the "painful" category.

What is going on with in your "ftruncate()" case?  The synchronization
code I added will do call filemap_flush() on close if the file
descriptor had been previously truncated down to zero, either because
it was opened with O_TRUNCATE, or if ftruncate(fd, 0) was explicitly
called.  But it won't actually call fsync() or do anything special on
the actual ftrucate() call; it just sets a flag indicating that the
file in question should be flushed on close.

This is to make the right thing happen for applications which try to
edit a file in place via:

     fd = open("foo", O_RDWR);
     len = read(fd, buf, MAXBUF);
     <modify buf>
     ftruncate(fd, 0);
     write(fd, buf, len);
     close(fd);

Otherwise, given the lack of fsync(fd) in the above sequence, a crash
may leave he file "foo" truncated or only partially written out.

        	     	  		     - Ted
