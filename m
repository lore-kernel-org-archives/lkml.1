Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZLCLLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZLCLLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZLCLLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:11:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58111 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbZLCLLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:11:45 -0500
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jamie@shareable.org, pavel@ucw.cz,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
	<1259783983-26884-3-git-send-email-jlayton@redhat.com>
	<E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 03 Dec 2009 03:11:39 -0800
In-Reply-To: <E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu> (Miklos Szeredi's message of "Thu\, 03 Dec 2009 11\:58\:43 +0100")
Message-ID: <m1tyw8nwgk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 2/2] vfs: force reval on dentry of bind mounted files on FS_REVAL_DOT filesystems
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed,  2 Dec 2009, Jeff Layton wrote:
>> In the case of a bind mounted file, the path walking code will assume
>> that the cached dentry that was bind mounted is valid. This is a problem
>> problem for NFSv4 in a way that's similar to LAST_BIND symlinks.
>> 
>> Fix this by revalidating the dentry if FS_FOLLOW_DOT is set and
>> __follow_mount returns true.
>> 
>> Note that in the non-open codepath, we cannot return an error to the
>> lookup if the revalidation fails. Doing so will leave a bind mount in
>> a state such that we can't unmount it. In that case we'll just have to
>> settle for d_invalidating it (which should mostly turn out to be a
>> d_drop in this case) and returning success.
>
> The only worry I have is that this adds an extra branch in a very hot
> codepath (do_lookup).  An error can't be returned, as you note, and
> for bind mounted directories d_invalidate() will not succeed: the
> directory is busy, it's referenced by the mount. 

Not true.  d_mountpoint is false, so d_invalidate can succeed.

> So basically the
> only thing this does is working around the NFSv4 issue. 

No, this should catch other cases where we have a dentry goes
stale as well, and lets the distributed filesystem handle it.

It is probably worth a benchmark to ease the concerns about the hotpath.
I expect the cpu will predict the branch as unlikely and we won't see
any difference.

Eric
