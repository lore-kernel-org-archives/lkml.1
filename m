Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbXBWKID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbXBWKID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbXBWKIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:08:02 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60004 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbXBWKIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:08:01 -0500
Date: Fri, 23 Feb 2007 02:07:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: circular locking: /proc/sys/vm/drop_caches
Message-Id: <20070223020743.28ede2d4.akpm@linux-foundation.org>
In-Reply-To: <20070223063538.GA13679@elte.hu>
References: <20070223063538.GA13679@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Feb 2007 07:35:38 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> i just got the lockdep warning below when doing:
> 
>   echo 3 > /proc/sys/vm/drop_caches
> 
> is this a known quirk in the drop_caches code?

It is - we're taking inode_lock at just the wrong level there and I don't
know how to fix it.  The basic problem is that we're doing a list_head
walk: if we drop the lock we have to start again.

Well, I do know how to fix it: rip the various inode lists and use a tagged
radix tree instead - make writeback's per-superblock inode walk work the
same as writeback's per-inode page walk.  That will also alow us to drop
the lock and then resume the drop_caches thing at the point where we left
off.

But it's a large change and has some quite tricky issues which need to be
carried over from the existing code and I don't have time to do it.

The only (lame) thing I can say for now is that drop_caches is a
debug-only, root-only thing :(

