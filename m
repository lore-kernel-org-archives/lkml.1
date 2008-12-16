Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYLPT3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYLPT3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYLPT31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:29:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbYLPT31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:29:27 -0500
Date: Tue, 16 Dec 2008 11:28:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mike Waychison <mikew@google.com>
cc: Oren Laadan <orenl@cs.columbia.edu>, jeremy@goop.org, arnd@arndb.de,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v11][PATCH 03/13] General infrastructure for checkpoint
 restart
In-Reply-To: <4947FBC8.2000601@google.com>
Message-ID: <alpine.LFD.2.00.0812161116380.14014@localhost.localdomain>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu> <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu> <4947FBC8.2000601@google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Dec 2008, Mike Waychison wrote:
> 
> set_fs(fs) here

Btw, this all is an excellent example of why people should try to aim for 
small functions and use lots of them.

It's often _way_ more readable to do

	static inline int __some_fn(...)
	{
		.. do the real work here ..
	}

	int some_fn(...)
	{
		int retval;

		prepare();
		retval = __some_fn(..)
		finish();

		return retval;
	}

where "prepare/finish" can be about locking, or set_fs(), or allocation 
and de-allocation of temporary buffers, or any number of things like that.

With set_fs() in particular, the wrapper function also tends to be the 
perfect place to change a regular (kernel) pointer into a user pointer. 
IOW, it's the place to make sparse happy, where you can do things like

	uptr = (__force void __user *)ptr;

and comment on the fact that the forced user pointer cast is valid only 
because of the set_fs().

Because it looks like the code isn't sparse-clean.

Btw, I also think that code like this is bogus:

	nwrite = file->f_op->write(file, addr, nleft, &file->f_pos);

because you're not supposed to pass in the raw file->f_pos to that 
function. It's fundamentally thread-unsafe. I realize that maybe you don't 
care, but the thing is, you're supposed to do

	loff_t pos = file->pos;
	..
	nwrite = file->f_op->write(file, addr, nleft, &pos);
	..
	file->f_pos = pos;

and in fact preferably use "file_pos_read()" and "file_pos_write()" (but 
we've never exposed them outside of fs/read_write.c, so I guess we should 
do that).

And yes, I realize that some code does take the address of f_pos directly 
(splice, nfsctl, others), and I realize that it works, but it's still bad 
form. Please don't add more of them.

			Linus
