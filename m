Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXBNITn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXBNITn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932168AbXBNITn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:19:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:50434 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXBNITm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:19:42 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@lst.de>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, walt <wa1ter@myrealbox.com>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
Date: Wed, 14 Feb 2007 00:19:35 -0800
User-Agent: KMail/1.9.5
References: <200702021923.02491.agruen@suse.de> <200702050032.06905.agruen@suse.de>
In-Reply-To: <200702050032.06905.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702140019.36378.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 00:32, Andreas Gruenbacher wrote:
> Here is an updated patch that also catches this special case.
> [...]

The d_path change was to not start unreachable paths with slashes. In the 
extreme case, this leads to an empty string. As it turns out, we are 
reporting meaningless paths to users in a bunch of places in /proc, like 
in /proc/$pid/mounts, where we ended up with entries like this:

	rootfs  rootfs rw 0 0

No wonder this immediately broke things; sorry for that.

Mountpoints are reported relative to the chroot if they are reachable from the 
chroot, and relative to the namespace they are defined in otherwise. This is 
big nonsense, but it's unclear to me how to best fix it:

  - don't report unreachable mount points,
  - somehow indicate which mountpoints are reachable and which are not,
    like by prepending a question flag?

What's the point in reporting the rootfs at all -- it's never reachable to an 
ordinary process?

The same issue shows up in a few other places as well: /proc/$pid/mountstats 
which is similar to /proc/$pid/mounts, and here:

  /proc/$pid/maps
  /proc/$pid/smaps
  /proc/$pid/numa_maps
  /proc/swaps
  /proc/mdstat
  /proc/net/rpc/nfsd.fh/content
  /proc/net/rpc/nfsd.export/content

We surely do not want to hide the entries that have unreachable pathnames 
here...

Thanks,
Andreas
