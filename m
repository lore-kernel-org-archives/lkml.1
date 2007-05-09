Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXEIV4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXEIV4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbXEIVzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:55:49 -0400
Received: from waste.org ([66.93.16.53]:54566 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759315AbXEIVzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:55:48 -0400
Date: Wed, 9 May 2007 16:55:38 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070509215538.GK11115@waste.org>
References: <4642389E.4080804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4642389E.4080804@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 02:09:50PM -0700, Jeremy Fitzhardinge wrote:
> I've had a couple of instances of a linux-2.6 mercurial repo getting
> corrupted in some odd way this morning.  It looks like files are being
> truncated; not to size 0, but losing something off the end.
> 
> This is on an xfs filesystem.  I haven't had any crashes/oops, and I
> don't think its the normal files getting filled with 0 problem.  I saw
> this before the most recent set of xfs updates, but it happened again
> afterwards too.
> 
> Mercurial uses a strictly append-only model for updating its repo files,
> but it looks like maybe an append operation didn't stick.

(Unless you're using the mq extension, which regularly truncates
files. But you're definitely the first person to run into this sort of
thing in any case.)

> I'm repulling a fresh copy of the repo; I'll be able to compare
> before/after.  Update: yep, definitely truncated:
> 
> $ ls -l .hg-new/store/data/_documentation/pi-futex.txt.i .hg-broken/store/data/_documentation/pi-futex.txt.i
> 4 -rw-rw-r-- 1 jeremy jeremy 3309 May  9 09:43 .hg-broken/store/data/_documentation/pi-futex.txt.i
> 4 -rw-rw-r-- 1 jeremy jeremy 3797 May  9 13:38 .hg-new/store/data/_documentation/pi-futex.txt.i
> 
> also
>   3476 -rw-rw-r--  1 jeremy jeremy   3558208 May  9 13:55 00manifest.i
>   3476 -rw-rw-r--  1 jeremy jeremy   3555200 May  9 09:41 00manifest.i~
>
> where 00manifest.i~ is the broken one. The files are identical up to the
> truncation point.
> 
> The repo passed "hg verify" just after I pulled it, so this corruption
> came about after a while.
> 
> Hm, the other possibility is that nlinks is being misreported.

I think if the files are identical up to the truncation point, we can
rule out nlink concerns. If for some reason Mercurial's COW logic got
fooled, the result would be a bit of a jumble at the end. And you'd be
unlikely to hit any sort of race as a single user on a laptop.

Can you use hg debugindex to determine if the truncation point
corresponds with a whole delta or whether it's in the middle of a
delta? 

For noninterleaved revlogs like your manifest above, the .i file is an
index build of a collection of 64-byte entries. It's pretty hard to
imagine how you'd lose 8 bytes since all I/O is done in multiples of
64-bytes. Oh, I'm misreading that - they differ by 3008 bytes, which
is 47 * 64. 

-- 
Mathematics is the supreme nostalgia of our time.
