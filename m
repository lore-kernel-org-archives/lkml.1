Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZDOCZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZDOCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZDOCZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:25:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:58576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbZDOCZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:25:12 -0400
Message-ID: <49E544DF.2060109@kernel.org>
Date: Wed, 15 Apr 2009 11:22:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 1/5] mmap: don't assume f_op->mmap() doesn't change vma->vm_file
References: <1239674662-31318-1-git-send-email-tj@kernel.org> <1239674662-31318-2-git-send-email-tj@kernel.org> <Pine.LNX.4.64.0904142047410.16616@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904142047410.16616@blonde.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 02:22:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hugh Dickins wrote:
> On Tue, 14 Apr 2009, Tejun Heo wrote:
> 
>> mmap_region() assumes that vma->vm_file isn't changed by f_op->mmap()
>> and continues to use cache file after f_op->mmap() returns.
> 
> It does use "file" again in the unmap_and_free_vma error path
> (isn't that reasonable? if the ->mmap failed, it shouldn't have
> mucked with vma; and even if it has, then we'd better not change
> the current behaviour of which to fput), but I don't see where else.
> 
> Further down, covering both vma->vm_file previously set and previously
> unset cases, there is a "file = vma->vm_file;" before file is used.
> So I think this patch is not necessary - if it is necessary, it's
> already a bug, because already we switch from /dev/zero to a
> shmem file there.

Right, ->mmap() shouldn't modify @vma if it has failed.  I was trying
to clarify that @vma->file may change as the code was a bit confusing
regarding whether @vma->vm_file is allowed to be substituted or not.
Hmmmm... how about adding a BUG_ON() or WARN_ON() in the failure path
to make sure @vma->vm_file hasn't changed?

Anyways, I'm dropping this patch and updating FUSE mmap implementation
accordingly.  Thanks for the comment.

-- 
tejun
