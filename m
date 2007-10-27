Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXJ0VCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXJ0VCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXJ0VCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:02:24 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:26138 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbXJ0VCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LQoVJijh+FddLZtLizT5aM0wcj3zZ1lOjgceIzQ4zMX2R6prIY6DMk69x+QjUI3iEcV49aPHYdN7fRlUP18f04f0e2u+5YXAOC2F+PMbTagdytWUgknfFT1U7T59eFH884s2g3VVKCfhemY1QM6ifJhAdUyC5KA5QEEC4mX2TuE=
Message-ID: <524f69650710271402g65a9ec1cqcc7bc3a964097e39@mail.gmail.com>
Date: Sat, 27 Oct 2007 16:02:21 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: Networked filesystems vs backing_dev_info
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>, sfrench@samba.org,
       jaharkes@cs.cmu.edu, "Andrew Morton" <akpm@linux-foundation.org>,
       vandrove@vc.cvut.cz
In-Reply-To: <1193477666.5648.61.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193477666.5648.61.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Hi,
>
> I had me a little look at bdi usage in networked filesystems.
>
>  NFS, CIFS, (smbfs), AFS, CODA and NCP
>
> And of those, NFS is the only one that I could find that creates
> backing_dev_info structures. The rest seems to fall back to
> default_backing_dev_info.
>
> With my recent per bdi dirty limit patches the bdi has become more
> important than it has been in the past. While falling back to the
> default_backing_dev_info isn't wrong per-se, it isn't right either.
>
> Could I implore the various maintainers to look into this issue for
> their respective filesystem. I'll try and come up with some patches to
> address this, but feel free to beat me to it.

I would like to understand more about your patches to see what bdi
values makes sense for CIFS and how to report possible congestion back
to the page manager.   I had been thinking about setting bdi->ra_pages
so that we do more sensible readahead and writebehind - better
matching what is possible over the network and what the server
prefers.    SMB/CIFS Servers typically allow a maximum of 50 requests
in parallel at one time from one client (although this is adjustable
for some). The CIFS client prefers to do writes 14 pages (an iovec of
56K) at a time (although many servers can efficiently handle multiple
of these 56K writes in parallel).  With minor changes CIFS could
handle even larger writes (to just under 64K for Windows and just
under 128K for Samba - the current CIFS Unix Extensions allow servers
to negotiate much larger writes, but lacking a "receivepage"
equivalent Samba does not currently support larger than 128K).
Ideally, to improve large file copy utilization, I would like to see
from 3-10 writes of 56K (or larger in the future) in parallel.   The
read path is harder since we only do 16K reads to Windows and Samba -
but we need to increase the number of these that are done in parallel
on the same inode.  There is a large Google Summer of Code patch for
this which needs more review.


-- 
Thanks,

Steve
