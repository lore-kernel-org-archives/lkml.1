Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYJIQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYJIQak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbYJIQa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:30:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59985 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760035AbYJIQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:30:25 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org>
	(message from Linus Torvalds on Thu, 9 Oct 2008 09:17:59 -0700 (PDT))
Subject: Re: splice vs O_APPEND
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org>
Message-Id: <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Oct 2008 18:30:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008, Linus Torvalds wrote:
> And it turns out that handling O_APPEND is actually pretty easy, so 
> instead of doing -EINVAL, we can just implement it. Something like this 
> (untested, of course).
> 
> Does this look better?

Yeah, only the append is now racy because the O_APPEND check is
outside i_mutex.  So maybe just stick with -EINVAL in
do_splice_from()?  That also covers do_splice_direct(), which is used
in NFS and sendfile() and a couple of other places.

We know that nobody is currently relying on O_APPEND semantics with
splice, so this should be OK.

Untested patch...

Miklos

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2008-08-29 14:39:20.000000000 +0200
+++ linux-2.6/fs/splice.c	2008-10-09 18:19:25.000000000 +0200
@@ -892,6 +892,9 @@ static long do_splice_from(struct pipe_i
 {
 	int ret;
 
+	if (out->f_flags & O_APPEND)
+		return -EINVAL;
+
 	if (unlikely(!out->f_op || !out->f_op->splice_write))
 		return -EINVAL;
 
