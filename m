Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZHCSsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZHCSsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZHCSsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:48:40 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:44401 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZHCSsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:48:39 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: mnt_want_write_file() has problem?
References: <871vnt7vac.fsf@devron.myhome.or.jp>
	<1249324312.26977.1336.camel@nimitz>
Date: Tue, 04 Aug 2009 03:48:34 +0900
In-Reply-To: <1249324312.26977.1336.camel@nimitz> (Dave Hansen's message of
	"Mon, 03 Aug 2009 11:31:52 -0700")
Message-ID: <8763d4ivi5.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave@linux.vnet.ibm.com> writes:

> On Mon, 2009-08-03 at 06:36 +0900, OGAWA Hirofumi wrote:
>> While I'm reading some code, I suspected that mnt_want_write_file() may
>> have wrong assumption.  I think mnt_want_write_file() is assuming it
>> increments ->mnt_writers if (file->f_mode & FMODE_WRITE). But, if it's
>> special_file(), it is false?
>> 
>> Sorry, I'm still not checking all of those though. E.g. I'm thinking the
>> below.
>> 
>> static inline int __get_file_write_access(struct inode *inode,
>> 					  struct vfsmount *mnt)
>> {
>> [...]
>> 	if (!special_file(inode->i_mode)) {
>> 		/*
>> 		 * Balanced in __fput()
>> 		 */
>> 		error = mnt_want_write(mnt);
>> 		if (error)
>> 			put_write_access(inode);
>> 	}
>> 	return error;
>> }
>
> In practice I don't think this is an issue.  We were never supposed to
> do mnt_want_write(mnt) for any 'struct file' that was a special_file(),
> specifically because of what you mention.
>
> Nick's use of mnt_want_write_file() was a 1:1 drop-in for
> mnt_want_write().  So, if all is well in the world, there should not be
> any call sites where mnt_want_write_file() gets called on a
> special_file().

void file_update_time(struct file *file)
sys_fchmod()
sys_fchown()
sys_fsetxattr()
sys_fremovexattr()

Um..., the users of mnt_want_write_file() seems to be those. I think
all of those filp can be special file?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
