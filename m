Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbXGHSjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbXGHSjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXGHSjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:39:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbXGHSjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:39:09 -0400
Date: Sun, 8 Jul 2007 11:38:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Al Viro <viro@ftp.linux.org.uk>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference
 - git-bisect result
In-Reply-To: <alpine.LFD.0.999.0707081126260.31544@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707081130420.31544@woody.linux-foundation.org>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
 <20070708012016.455ce8d5.akpm@linux-foundation.org>
 <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de>
 <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk>
 <469121DA.6030600@redhat.com> <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707081126260.31544@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Jul 2007, Linus Torvalds wrote:
> 
> This would seem to be the minimal change, and I think it's right.

Side note: I considered just changing do_utimes() to use 
ATIME_SET/MTIME_SET instead, which would simplify the logic a lot..

But it turns out that the semantics for A/MTIME_SET is that only the owner 
of the file can do that. So the "!times" case is simply _fundamentally_ 
different from a permissions check standpoint, and there we have to check 
for "writable" rather than anything else (although ownership will override 
it).

So rather than simplify the thing, I had to add code. Oh, well.

I do think that it would be even nicer to just have a function that fills 
in the "struct nameidata" from the dfd. I think we should be able to: the 
"struct file" really does have the "f_path" thing with both dentry and mnt 
information, and that would clean up that whole ugly "filepointer-vs-nd" 
thing a lot.

That would be an "Al cleanup", though. What do you think, Al?

			Linus
