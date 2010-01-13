Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179Ab0AMTvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0AMTvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087Ab0AMTvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:51:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44288 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab0AMTvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:51:00 -0500
Date: Wed, 13 Jan 2010 19:51:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfs: Fix refcnt leak with __do_follow_link() in
 do_filp_open()
Message-ID: <20100113195059.GC4673@ZenIV.linux.org.uk>
References: <87vdf8jxug.fsf@devron.myhome.or.jp>
 <87r5pwjxr2.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r5pwjxr2.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 03:35:13AM +0900, OGAWA Hirofumi wrote:
> Hi,
> 
> I noticed refcnt leak in do_filp_open() by recent change. Could you
> review this one?
> 
> 
> __do_follow_link() handles "nd->path and path" refcnt by special way.
> If path->mnt == nd->path.mnt (i.e. those is sharing the refcnt), it
> gets refcnt of path->mnt, to make simple error path of it.
> 
> So, we can't call __do_follow_link() twice without special care,
> because it will get refcnt of path->mnt twice. (i.e. current
> do_filp_open() is leaking path->mnt if first __do_follow_link()
> returned -ESTALE and path->mnt != nd->path.mnt)
> 
> This moves the special refcnt handling from __do_follow_link() as
> path_unshare_refcnt(). Then call it once for that do_filp_open() path.

Point, but... that's not the way I'd do it (again, see #untested for the
direction it's heading).  What we ought to do is simply "put ourselves
in trust-no-one mode (LOOKUP_REVAL) and restart the entire thing; if
we'd already been through that, fail immediately".

And yes, it needs to be pulled in front of queue and go in before .34.
Will do shortly.
