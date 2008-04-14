Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbYDNQUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbYDNQUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYDNQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:20:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:57714 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757954AbYDNQUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:20:33 -0400
Date: Mon, 14 Apr 2008 18:20:31 +0200
From: Jan Kara <jack@suse.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Jan Kara <jack@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080414162031.GD15824@duck.suse.cz>
References: <agh4d-6yc-35@gated-at.bofh.it> <ah5tY-3lR-7@gated-at.bofh.it> <ah5DA-3X9-9@gated-at.bofh.it> <ah5X5-4tl-13@gated-at.bofh.it> <ah66A-4Nk-7@gated-at.bofh.it> <ah7vN-7Wz-9@gated-at.bofh.it> <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411135544.GG2160@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-04-08 09:55:44, Lennart Sorensen wrote:
> On Fri, Apr 11, 2008 at 02:24:34PM +0200, Bodo Eggert wrote:
> > AS far as I understand, the race is e.g.:
> > 
> > fpos := A:a, we want to make process/thread a read A:b or B:a without it
> > being a correct value in fpos. a!=b!=c, A!=B, A!=C.
> > 
> > a: read fpos.high (A:?)
> > b: write fpos (B:b)
> > a: read fpos.low (A:b)
> > 
> > 
> > If you change this to 
> > 
> > a: read fpos.high
> > a: read fpos.low
> > a: read fpos.high
> > a: read fpos.low
> > 
> > and compare the results, you need to
> > 
> > a: read fpos.high (A:?)
> > b: write fpos (B:b)
> > a: read fpos.low (A:b)
> > b: write fpos (A:c)
> > a: read fpos.high (A:b),(A:?)
> > b: write fpos (C:b)
> > a: read fpos.low (A:b),(A:b)
> > 
> > That would be winning three races in order to hit the bug. 
> > 
> > 
> > OTOH, writers MUST NOT be interrupted, because:
> > 
> > b: write fpos.high (B:a)
> > a: read fpos.high (B:?)
> > a: read fpos.low (B:a)
> > a: read fpos.high (B:a),(B:?)
> > a: read fpos.low (B:a),(B:a)
> > b: write fpos.low (B:b)
> 
> So if you write multithreaded code and don't understand what locking
> around shared resources is for, then your application might break.  Can
> you give an example where locking is being used correctly where this can
> possibly fail?  The kernel can't prevent idiots from writing bad code
> that breaks.
> 
> I just don't get this "problem".
  Well, as Jiri Kosina wrote, this isn't a problem unless someone finds
a way how to use this race for some attack (and for example making f_pos
negative compromises security so it is not so far-fetched as it would
seem). So proactively fixing this makes some sence.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
