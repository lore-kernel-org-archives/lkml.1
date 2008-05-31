Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYEaSpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYEaSpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYEaSpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:45:43 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42916 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbYEaSpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:45:42 -0400
Date: Sat, 31 May 2008 19:44:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
In-Reply-To: <20080530204307.GA4978@ucw.cz>
Message-ID: <Pine.LNX.4.64.0805311925190.27293@blonde.site>
References: <20080530102619.GA2468@elf.ucw.cz> <Pine.LNX.4.64.0805301451020.19914@blonde.site>
 <20080530204307.GA4978@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Pavel Machek wrote:
> > > sync_file_range(SYNC_FILE_RANGE_WRITE) blocks ... which makes problem
> > > for s2disk: there we want to start writeout as early as possible
> > > (system is going to shut down after write, and we need the data on
> > > disk).
> > > 
> > > Unfortuantely, sync_file_range(SYNC_FILE_RANGE_WRITE) blocks, which
> > > does not work for us. Is there non-blocking variant? "Start writeout
> > > on this fd, but don't block me"?
> > 
> > I guess there are lots of reasons why it may block (get rescheduled)
> > briefly, but why would that matter to you?  Are you saying that its
> > whole design has got broken somehow, and now SYNC_FILE_RANGE_WRITE
> > is behaving as if SYNC_FILE_RANGE_WAIT_AFTER had been supplied too?
> 
> It appears to me like it includes WAIT_AFTER, yes.
> 
> I was not sure what the expected behaviour was... lets say we have a
> lot of dirty data (like 40MB) and system with enough free memory. Is
> it reasonable to expect SYNC_FILE_RANGE_WRITE to return pretty much
> immediately? (like in less than 10msec)? Because it seems to take more
> like a second here...
> 
> (Underlying 'file' is actually /dev/sda1 -- aka my swap partition, but
> that should not matter --right?)

Right (so long as you're not swapping to it at the same time!).
And it seems to be behaving the same way on a regular file.

All I can say so far is that I find the same as you do:
SYNC_FILE_RANGE_WRITE (after writing) takes a significant amount of time,
more than half as long as when you add in SYNC_FILE_RANGE_WAIT_AFTER too.

Which make the sync_file_range call pretty pointless: your usage seems
perfectly reasonable to me, but somehow we've broken its behaviour.
I'll be investigating ...

Hugh
