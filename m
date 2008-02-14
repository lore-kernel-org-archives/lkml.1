Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYBNPT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYBNPT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYBNPTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:19:47 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31680 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbYBNPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:19:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qGRX6R0WY5tRo25htBqX+YOk8V79ALu7F3w2IR/prgOESJR6wpSrLQpsiyEp5YorI
	WApZon1MvXN0TNwMEBL0g==
Message-ID: <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
Date: Thu, 14 Feb 2008 07:19:33 -0800
From: "Paul Menage" <menage@google.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:30 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>  > For recursive bind mounts, only the root of the tree being bound
>  > inherits the per-mount flags from the mount() arguments; sub-mounts
>  > inherit their per-mount flags from the source tree as usual.
>
>  This is rather strange behavior.  I think it would be much better, if
>  setting mount flags would work for recursive operations as well.  Also
>  what we really need is not resetting all the mount flags to some
>  predetermined values, but to be able to set or clear each flag
>  individually.

This is certainly true, but as you observe below it's a fair bit more
fiddly to specify in the API. I wasn't sure how much people recursive
bind mounts, so I figured I'd throw out this simpler version first.

>
>  For example, with the per-mount-read-only thing the most useful
>  application would be to just set the read-only flag and leave the
>  others alone.
>
>  And this is where we usually conclude, that a new userspace mount API
>  is long overdue.  So for starters, how about a new syscall for bind
>  mounts:
>
>  int mount_bind(const char *src, const char *dst, unsigned flags,
>                  unsigned mnt_flags);

The "flags" argument could be the same as for regular mount, and
contain the mnt_flags - so the extra argument could maybe usefully be
a "mnt_flags_mask", to indicate which flags we actually care about
overriding.

What would happen when an existing super-block flag changes to become
a per-mount flag (e.g. per-mount read-only)? I think that would just
fit in with the "mask" idea, as long as we complained if any bits in
mnt_flags_mask weren't actually per-mount settable.

Being able to mask/set mount flags might be useful on a remount too,
since there's no clean way to get the existing mount flags for a mount
other than by scanning /proc/mounts. So an alternative to a separate
system call would be a new mnt_flag_mask argument to mount() (whose
presence would be indicated by a flag bit being set in the main flags)
which would be used to control which bits were set cleared for
remount/bind calls. Seems a bit wasteful of bits though. If we turned
"flags" into an (optionally) 64-bit argument then we'd have plenty of
bits to be able to specify both a "set" bit and a "mask" bit for each,
without needing a new syscall.

Paul
