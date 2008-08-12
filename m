Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbYHLRTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbYHLRTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYHLRSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:18:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbYHLRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:18:53 -0400
Date: Tue, 12 Aug 2008 10:18:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <87ej4u9nf5.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, OGAWA Hirofumi wrote:
> 
> This fixes -EOVERFLOW case, and cleans up related stuff.

I think it just makes things more confused.

If we actually want to change the readdir() thing, then we should just 
make the rule be:

 - if the callback returns a non-zero value, the filesystem "readdir()" 
   function should return that value (right now they are taught to return 
   zero, and return errors on internal fatal things). And get rid of 
   "buf.error" entirely.

   The reason for the whole "buf.error" etc stuff is simply because that 
   avoided having the low-level filesystem even care about things. But if 
   you really want to clean this up, we should *NOT* continue the current 

 - the callers should then do

	error = vfs_readdir(file, filldir, &buf);
	lastdirent = buf.previous;
	if (lastdirent) {
		error = count - buf.count;
		if (put_user(file->f_pos, &lastdirent->d_off))
			error = -EFAULT;
	}
	fput(file);
	return error;

   and we wouldn't need any other logic at all.

As to -EOVERFLOW, I suspect we are better off just dropping that whole 
logic. Returning -EOVERFLOW and truncating the readdir listing is likely 
much worse than the alternative. It made sense back when we needed to get 
people to upgrade the system interfaces, now it just means that old 
binaries won't work at all.

		Linus
