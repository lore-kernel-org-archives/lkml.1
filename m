Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYDIVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYDIVdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYDIVdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:33:00 -0400
Received: from lazybastard.de ([212.112.238.170]:59315 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbYDIVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:33:00 -0400
Date: Wed, 9 Apr 2008 23:32:41 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, ext-adrian.hunter@nokia.com, jwboyer@gmail.com,
       "Artem B. Bityutskiy" <dedekind@yandex.ru>
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080409213241.GA12179@logfs.org>
References: <47F1EC20.6050600@wpkg.org> <20080409210907.GA9683@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080409210907.GA9683@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 April 2008 23:09:07 +0200, Pavel Machek wrote:
> 
> I'd like compressed filesystem for maps and lingvistic data... but
> will the flash flesystems have 'reasonable' performance when used on
> harddrive?

If someone implemented readpages(), that might be possible - depending
on your definition of 'reasonable' and your workload.

Writes will hit the disk roughly in order.  When readahead requests a
bunch of pages, there is some chance of them being adjacent and having
the block layer combine most of the bios into a few large ones.

The main drawbacks are:
- No reservations.  If data is written in random order or several
  writers chew away in parallel, write order will be fairly pessimal.
- No readahead yet.  Wouldn't be hard to do.
- Garbage collection completely ignores fragmentation.  If segments are
  needed and one contains a nice long extend from a single file, that
  data will be written elsewhere, often split between two segments.
  Rinse, repeat and fragmentation will increase over time.
- File creation/deletion currently will cause disk heads to jump in
  triangles.  This hurts write performance on most flash media as well,
  so it will get changed reasonably soon.

All of those are solvable.  Some will definitely be solved because the
help performance on flash media as well.  Other may or may not.

Jörn

-- 
When people work hard for you for a pat on the back, you've got
to give them that pat.
-- Robert Heinlein
