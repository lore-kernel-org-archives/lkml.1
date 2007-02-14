Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbXBNPiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbXBNPiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 10:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbXBNPiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 10:38:25 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbXBNPiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 10:38:24 -0500
Date: Wed, 14 Feb 2007 07:37:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Gruenbacher <agruen@suse.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       walt <wa1ter@myrealbox.com>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
In-Reply-To: <200702140019.36378.agruen@suse.de>
Message-ID: <Pine.LNX.4.64.0702140730350.3604@woody.linux-foundation.org>
References: <200702021923.02491.agruen@suse.de> <200702050032.06905.agruen@suse.de>
 <200702140019.36378.agruen@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Feb 2007, Andreas Gruenbacher wrote:
> 
> Mountpoints are reported relative to the chroot if they are reachable from the 
> chroot, and relative to the namespace they are defined in otherwise. This is 
> big nonsense, but it's unclear to me how to best fix it:

Well, it's also what a traditional "pwd" implementation would do, so it's 
not "nonsense" in that sense.

>   - don't report unreachable mount points,
>   - somehow indicate which mountpoints are reachable and which are not,
>     like by prepending a question flag?

We could prepend another '/' (so that you'd have a path that starts with 
"//"). That's still a legal path, but it's also somethign that even POSIX 
says is valid to mean something else (eg "//ftp/.." or "//socket/.." to 
escape into another namespace).

But the fact is, some things just want a path. And it's generally *better* 
to get them a 

 - path that looks ok and starts from '/' than it is to give them 
   something that looks strange and doesn't start from root (because the 
   latter gives many many more possible attack vectors: if somebody 
   actually looks up the path, a bad user can much more easily fake a 
   relative path than fake an absolute one).

 - the path we've historically always given them.

> What's the point in reporting the rootfs at all -- it's never reachable to an 
> ordinary process?

All the paths are generally useful for USER INFORMATION. That's the 
primary use of paths for anything but "getcwd()". And the primary use for 
"getcwd()" is to do the same thing that any traditional cwd implementation 
has done, except faster (and _possibly_ better, but compatibility is more 
important than extensions - so the "better" is mainly an issue about 
non-readable or non-executable path component that we can show, and 
about being able to tell _how_ you got to a point that has multiple ways 
of getting there).

		Linus
