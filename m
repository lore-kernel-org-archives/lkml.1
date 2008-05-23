Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbYEWJsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbYEWJsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbYEWJsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:48:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35146 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYEWJse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:48:34 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       swhiteho@redhat.com
In-reply-to: <20080523091805.GB27119@infradead.org> (message from Christoph
	Hellwig on Fri, 23 May 2008 05:18:05 -0400)
Subject: Re: [patch 04/14] gfs2: dont call permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171546.697638614@szeredi.hu> <20080523091805.GB27119@infradead.org>
Message-Id: <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 11:48:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bad idea.  You're duplicating bits out of permission for no good
> reason.  I spent quite a bit of effort to make sure we don't have
> this duplicated logic around.

In this case you are wrong.  Look at the ugly conditional locking
gfs2_permission() does, which is probably due to the fact that it's
doing a recursion via calling permission() from inside already locked
parts in the filesystem.

That's _much_ worse than a duplicated IS_IMMUTABLE() call.  Which btw,
is a filesystem implementation detail: it needs to re-check the
immutability of the file after it has been locked.  I'm not even sure
it's strictly needed.  Steven?

Generally this sort of recursion through the VFS is ugly and
unnecessary, it's much better to provide helper for what the VFS is
doing if there's a lot of duplication.  But in this case there's
really no point in that at all.

Miklos
