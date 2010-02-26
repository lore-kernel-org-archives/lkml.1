Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935834Ab0BZMH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:07:29 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51615 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935816Ab0BZMH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:07:27 -0500
To: john.johansen@canonical.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       john.johansen@canonical.com
In-reply-to: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
Subject: Re: [PATCH] Fix __d_path for lazy unmounts
References: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
Message-Id: <E1NkyyX-0000l1-01@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 26 Feb 2010 13:07:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010, john.johansen@canonical.co wrote:
> From: John Johansen <john.johansen@canonical.com>
> 
> When __d_path() hits a lazily unmounted mount point, it tries to prepend
> the name of the lazily unmounted dentry to the path name.  It gets this wrong,
> and also overwrites the slash that separates the name from the following
> pathname component. This patch fixes that; if a process was in directory
> /foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
> missing slash), while the new result with this patch is ``/foo/bar''.

Example:

# mkdir -p /tmp/foo/bar
# mkdir /tmp/mnt
# mount --bind /tmp/foo /tmp/mnt
# cd /tmp/mnt/bar
# /bin/pwd
/tmp/mnt/bar
# umount -l /tmp/mnt
# /bin/pwd
foobar

After the patch it will be /foo/bar.

Why is the path starting with "/foo"?  Does that make any sense?

Last time this was discussed the proposals which are halfway sane
were:

 a) "(unreachable)/bar" or something along those lines
 b) ENOENT

And with either one care needs to be taken to limit this change to
interfaces (both internal and userspace) where it's not likely to
cause breakage.

Thanks,
Miklos
