Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZLCL4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZLCL4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZLCL4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:56:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52915 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZLCL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:56:42 -0500
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jamie@shareable.org, pavel@ucw.cz,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
	<1259783983-26884-3-git-send-email-jlayton@redhat.com>
	<E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu>
	<m1tyw8nwgk.fsf@fess.ebiederm.org>
	<E1NG9iu-0002jR-1r@pomaz-ex.szeredi.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 03 Dec 2009 03:56:41 -0800
In-Reply-To: <E1NG9iu-0002jR-1r@pomaz-ex.szeredi.hu> (Miklos Szeredi's message of "Thu\, 03 Dec 2009 12\:19\:48 +0100")
Message-ID: <m18wdknudi.fsf@fess.ebiederm.org>
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

> On Thu, 03 Dec 2009, Eric W. Biederman wrote:
>> > The only worry I have is that this adds an extra branch in a very hot
>> > codepath (do_lookup).  An error can't be returned, as you note, and
>> > for bind mounted directories d_invalidate() will not succeed: the
>> > directory is busy, it's referenced by the mount. 
>> 
>> Not true.  d_mountpoint is false, so d_invalidate can succeed.
>
> Have a look at the code.  d_invalidate() doesn't check for a
> mountpoint, it checks the refcount.  It needs to keep the directory
> dentry hashed if it's in any way reachable other than from the cache
> (file descriptor, cwd, mount, etc).

Ah.  I thought you were thinking about the mandatory have_submounts()
check in dentry->d_op->d_revalidate().

I expect the generic d_invalidate will simply hit the:
	spin_lock(&dcache_lock);
	if (d_unhashed(dentry)) {
		spin_unlock(&dcache_lock);
		return 0;
	}

After the distributed filesystem has called d_drop in
dentry->d_op->d_revalidate (when appropriate.

Eric



