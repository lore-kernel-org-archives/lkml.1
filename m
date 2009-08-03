Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZHCSbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZHCSbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZHCSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:31:55 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49583 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbZHCSby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:31:54 -0400
Subject: Re: mnt_want_write_file() has problem?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <871vnt7vac.fsf@devron.myhome.or.jp>
References: <871vnt7vac.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 11:31:52 -0700
Message-Id: <1249324312.26977.1336.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 06:36 +0900, OGAWA Hirofumi wrote:
> While I'm reading some code, I suspected that mnt_want_write_file() may
> have wrong assumption.  I think mnt_want_write_file() is assuming it
> increments ->mnt_writers if (file->f_mode & FMODE_WRITE). But, if it's
> special_file(), it is false?
> 
> Sorry, I'm still not checking all of those though. E.g. I'm thinking the
> below.
> 
> static inline int __get_file_write_access(struct inode *inode,
> 					  struct vfsmount *mnt)
> {
> [...]
> 	if (!special_file(inode->i_mode)) {
> 		/*
> 		 * Balanced in __fput()
> 		 */
> 		error = mnt_want_write(mnt);
> 		if (error)
> 			put_write_access(inode);
> 	}
> 	return error;
> }

In practice I don't think this is an issue.  We were never supposed to
do mnt_want_write(mnt) for any 'struct file' that was a special_file(),
specifically because of what you mention.

Nick's use of mnt_want_write_file() was a 1:1 drop-in for
mnt_want_write().  So, if all is well in the world, there should not be
any call sites where mnt_want_write_file() gets called on a
special_file().

Future users of mnt_want_file_write() may not notice this fact, though.
This is probably worth at least a note in the documentation or perhaps a
WARN_ON().

-- Dave

