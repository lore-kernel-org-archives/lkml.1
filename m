Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbYECMA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbYECMA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYECMAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:00:19 -0400
Received: from lazybastard.de ([212.112.238.170]:53960 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbYECMAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:00:18 -0400
Date: Sat, 3 May 2008 14:00:05 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, linux-mtd@lists.infradead.org
Subject: Re: LogFS merge
Message-ID: <20080503120005.GA32608@logfs.org>
References: <481C3087.8020501@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481C3087.8020501@free.fr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 11:29:43 +0200, matthieu castet wrote:
>
> Shouldn't this get review by mtd guys first ?

They were on Cc: on most of the review rounds.

> Also for info, there have been some issue raised by the ubifs developer [1].

I am aware of them.  When ignoring FUD and personal things (Artem and I
have a history), it should come down to roughly this:

1.
Ubifs takes the easy approach and uses ubi for wear leveling, bad block
handling, ets.  Saves a ton of work, gives quick results and is limited
by ubi scan time, which is O(n).

Logfs ignores ubi and does wear leveling, bad block handling, etc.
itself.  Bad block handling in particular is not too robust yet.  If you
expect blocks to rot away after mkfs time, logfs is a bad choice.

2.
Logfs still scans the medium.  It currently does not store free space
maps and has to search for free space the hard way.  I still have a
patch to keep the map in-memory, which will avoid any rescans.  But the
real deal is to store it in a file with some additional tricks to make
things work in a log-structured fashion.  Not done yet.

Ubifs has a seperate region to store its free space map, which has its
own GC.  Wear leveling is dealt with through ubi.  Again, ubi makes life
easier.

3. Code size.

4. Mount time.  I don't see any numbers I could quote, but I believe
ubifs is somewhere close to a second.  Does anyone know?  Logfs is in
the 10-60ms range.

5.
Ubifs has write-back caching for file data.  Their benchmarks blow jffs2
or logfs out of the water, which isn't surprising when comparing DRAM to
flash.

Logfs has write-back caching for metadata (indirect blocks, etc.) but
immediatly writes normal data.  Some embedded folks actually prefer this
approach, as it is more deterministic.  For most uses it simply throws
away some performance.  Extending caching to normal data isn't too hard
and fairly high on my list.

6.
"Logfs isn't finished yet."
My usual answer to that is that Linux isn't finished yet either.  We're
still improving performance, adding hardware support and fixing bugs
some 15 years after people started using it.  The question is not
whether there are improvements left, but whether it is good enough
already.

Jörn

-- 
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello
