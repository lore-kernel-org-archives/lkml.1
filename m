Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYFAPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYFAPcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYFAPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 11:32:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49252 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYFAPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 11:32:08 -0400
Date: Sun, 1 Jun 2008 16:32:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tom Spink <tspink@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] vfs: Introduce on-demand filesystem
	initialisation
Message-ID: <20080601153205.GM28946@ZenIV.linux.org.uk>
References: <1212331915-22856-1-git-send-email-tspink@gmail.com> <1212331915-22856-2-git-send-email-tspink@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212331915-22856-2-git-send-email-tspink@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 03:51:54PM +0100, Tom Spink wrote:


Occam's Razor...

You've just serialized ->kill_sb() for given fs type (and made sure that
if one gets stuck, _everything_ gets stuck).  Moreover, you've serialized
sget() against the same thing (i.e. pretty much each ->get_sb()).

All of that (and a couple of new methods) is done for something that just
plain does not belong to VFS.  It's trivially doable in filesystem *and*
it's about the objects with lifetimes that make sense only for filesystem
itself.

Hell, just do

int want_xfs_threads(void)
{
	int res = 0;
	mutex_lock(&foo_lock);
	if (!count++) {
		start threads
		if failed {
			count--;
			res = -Esomething;
		}
	}
	mutex_unlock(&foo_lock);
	return res;
}

void leave_xfs_threads(void)
{
	mutex_lock(&foo_lock);
	if (!--count)
		stop threads
	mutex_unlock(&foo_lock);
}

Call want_xfs_threads() in xfs_fs_fill_super(); call leave_xfs_threads() in
the end of xfs_put_super() and on failure exit from xfs_fs_fill_super().
End of story...  Any other fs that wants such things can do the same.
