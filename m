Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYE3QiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYE3QiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYE3Qht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:37:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57560 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYE3Qhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:37:48 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, drepper@redhat.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <48401E7E.9090304@gmail.com> (message from Michael Kerrisk on
	Fri, 30 May 2008 17:34:22 +0200)
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
Message-Id: <E1K27bZ-0002Gk-3b@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 May 2008 18:37:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a further version of the patch, against 2.6.26rc2, with the
> 2008-05-19 git changes you sent me applied.  This patch is based on
> the draft patch you sent me.  I've tested this version of the patch,
> and it works as for all cases except the one mentioned below.  But
> note the following points:
> 
> 1) I didn't make use of the code in notify_change() that checks
> IS_IMMUTABLE() and IS_APPEND() (i.e., I did not add
> ATTR_OWNER_CHECK to the mask in the controlling if statement).
> Doing this can't easily be made to work for the
> do_futimes() case without reworking the arguments passed to
> notify_change().  Actually, I'm inclined to doubt whether it
> is a good idea to try to roll that check into notify_change() --
> at least for utimensat() it seems simpler to not do so.

Ugh...  Could we just omit this part (the if !times and write error
then check owner)?  I know it was my idea, but

 a) my ideas are often stupid
 b) one patch should ideally do just one thing

After we fixed the original issue, we can still think about this other
thing :)

> 2) I've found yet another divergence from the spec -- but this
> was in the original implementation, rather than being
> something that has been introduced.  In do_futimes() there is
> 
>         if (!times && !(file->f_mode & FMODE_WRITE))
>                 write_error = -EACCES;
> 
> However, the check here should not be against the f_mode (file access
> mode), but the against actual permission of the file referred to by
> the underlying descriptor.  This means that for the do_futimes() +
> times==NULL case, a set-user-ID root program could open a file
> descriptor O_RDWR/O_WRONLY for which the real UID does not have write
> access, and then even after reverting the the effective UID, the real
> user could still update file.

Sure, but so could a write(2), so that doesn't seem such a big
problem.

I think we should leave it this way, since changing it would affect
not just utimensat() and futimesat() but utime() and utimes() as well,
which are well established, old interfaces.  Shanging them could in
theory break userspace, which we try to avoid if possible.

Thanks,
Miklos
