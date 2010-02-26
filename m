Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965434Ab0BZRHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:07:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56458 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965207Ab0BZRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:07:51 -0500
Message-ID: <4B87FFE1.7040001@canonical.com>
Date: Fri, 26 Feb 2010 09:07:45 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix __d_path for lazy unmounts
References: <1266668858-15253-1-git-send-email-john.johansen@canonical.com> <E1NkyyX-0000l1-01@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NkyyX-0000l1-01@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2010 04:07 AM, Miklos Szeredi wrote:
> On Sat, 20 Feb 2010, john.johansen@canonical.co wrote:
>> From: John Johansen<john.johansen@canonical.com>
>>
>> When __d_path() hits a lazily unmounted mount point, it tries to prepend
>> the name of the lazily unmounted dentry to the path name.  It gets this wrong,
>> and also overwrites the slash that separates the name from the following
>> pathname component. This patch fixes that; if a process was in directory
>> /foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
>> missing slash), while the new result with this patch is ``/foo/bar''.
>
> Example:
>
> # mkdir -p /tmp/foo/bar
> # mkdir /tmp/mnt
> # mount --bind /tmp/foo /tmp/mnt
> # cd /tmp/mnt/bar
> # /bin/pwd
> /tmp/mnt/bar
> # umount -l /tmp/mnt
> # /bin/pwd
> foobar
>
> After the patch it will be /foo/bar.
>
> Why is the path starting with "/foo"?  Does that make any sense?
>
not a lot except, connecting disconnected paths to root is what
is currently done for paths that aren't reachable but have an fs
as their root (ie the last dentry is / so it looks connected to
root).

I would be happy in this case to leave bind mounts disconnected
(no leading /) and just fix the overwriting of the internal /.

I'll make the change.

> Last time this was discussed the proposals which are halfway sane
> were:
>
>   a) "(unreachable)/bar" or something along those lines
>   b) ENOENT
>
right, I actually have another couple of __d_path patches I need
to kick out for discussion.  Last time we rolled 3 different
changes into a single patch.  This time I wanted to isolate the
changes per patch.  I'll kick them all out today.

> And with either one care needs to be taken to limit this change to
> interfaces (both internal and userspace) where it's not likely to
> cause breakage.
>
agreed.

