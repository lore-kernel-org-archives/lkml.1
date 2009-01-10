Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZAJL4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZAJL4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZAJL4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:56:47 -0500
Received: from lazybastard.de ([212.112.238.170]:34630 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbZAJL4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:56:46 -0500
Date: Sat, 10 Jan 2009 12:56:27 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090110115626.GC20611@logfs.org>
References: <1231584446.3685.21.camel@johannes> <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> <1231587428.3803.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231587428.3803.0.camel@johannes>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 January 2009 12:37:08 +0100, Johannes Berg wrote:
> On Sat, 2009-01-10 at 20:02 +0900, KOSAKI Motohiro wrote:
> 
> > > This adds a b+tree library. The API and memory layout is documented in
> > > the header file lib/btree.h. There are tree versions for 32, 64 and
> > > 128 bit keys as well as unsigned long (32/64 depending on platform).
> > 
> > Can this library remove the btree code in some btree based filesystem?
> 
> Joern is going to use it for logfs, that's the point. Not sure about
> other filesystems.

Err...

While true, this is decidedly _not_ a disk-based btree.  Logfs uses it
for in-memory data structures.  So the short answer is no.

There are several differences between this implementation and one used
for disk data.

- The value is a pointer, 32/64bit depending on architecture.  Won't be
  suited for a 64bit filesystem on a 32bit host, f.e.

- Lookups are a simple loop and don't use binary search.  With a 4KiB
  btree node and 64B cacheline, binary search will only load 7 out of 64
  cachelines - making a big difference.  This implementation uses 128B
  (or cacheline size, whichever is bigger) nodes, so binary search buy
  almost nothing, but cause branch mispredictions, bigger code, etc.

There may be more.  So if you plan to replace disk-based btree code with
this, it will certainly be some amount of work.  Not sure if it is a
good idea or if one should rather have a seperate library.

Jörn

-- 
The cost of changing business rules is much more expensive for software
than for a secretaty.
-- unknown
