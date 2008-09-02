Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYIBGmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYIBGmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYIBGmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:42:10 -0400
Received: from mail2.shareable.org ([80.68.89.115]:52230 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYIBGmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:42:09 -0400
Date: Tue, 2 Sep 2008 07:42:01 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: (repost) Confirmation of methods for calculating requested pathname.
Message-ID: <20080902064201.GA1327@shareable.org>
References: <48AA49DE.6000006@nttdata.co.jp> <48BCC1B6.5030901@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BCC1B6.5030901@nttdata.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kentaro Takeda wrote:
> If our understanding is correct, we would like to propose a new
> method that does not require modifications to vfs helper functions.
> Attached patch is a trial of this method.
> 
> vfs helper functions are surrounded by mnt_want_write() and
> mnt_drop_write() pairs which receive "struct vfsmount" parameter
> since 2.6.26. So, by remembering the absolute pathname of "struct
> vfsmount" of the moment, LSM module can calculate an absolute
> pathname of the given "struct dentry" parameter inside vfs_*
> functions, without passing "struct vfsmount" parameter to vfs_*
> functions.
> 
> This approach doesn't access vfsmount inside vfs helper functions,
> and modification of existing kernel is only in task_struct and
> mnt_want/drop_write().

This is exactly the same as passing vfsmount through vfs helper functions,
except the parameter is "hidden" inside struct task.

Although this seems to violate the idea that the vfs helper call
chains (including functions they call) aren't affected by the mount
point, to be frank they are affected by the mount point _already_ - by
virtue of mnt_get_write()/mnt_drop_write() existing.

Ironically, the _current_ way that vfs helper call chains are affected
by mount point is for security: read-only mount points are basic security.

So I don't understand the objection to using path mount point in
security decisions, given that it already is to some extent.

This patch seems ugly at first because of hidden parameters in struct
task.  On the other hand, mnt_get_write() already does a similar thing
(and the implementation is uglier imho, though clever), and it is accepted.

-- Jamie
