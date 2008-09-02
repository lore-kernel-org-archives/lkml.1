Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYIBR3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYIBR3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYIBR3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:29:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:44719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYIBR3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:29:35 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: David Woodhouse <dwmw2@infradead.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <20080902170954.GE3086@webber.adilger.int>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron>
	 <20080902170954.GE3086@webber.adilger.int>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 18:29:29 +0100
Message-Id: <1220376569.2982.225.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 11:09 -0600, Andreas Dilger wrote:
> The fsid is supposed to be a persistent, unique identifier for the
> filesystem, used by NFS in file handles.  Using st_dev is unsafe,
> because that may change from one server boot to the next, because
> of device probing order, driver changes, etc.  Also, not all
> filesystems
> HAVE a valid st_dev in the first place, which is the whole reason
> for this thread.

Yes, putting st_dev in f_fsid probably isn't a good thing to do.

> I think a ->get_fsid() export method would be preferable.

I implemented that, but it doesn't really work. The fsid->export mapping
happens in userspace, so mountd needs access to the fsid. So the mount
would work fine and return a FH with the appropriate fsid, and then
mountd would have no knowledge of how to handle that FH, and mount(8) on
the client would eventually time out and fail.

It worked if I prepopulated the nfsd.fh cache in expkey_parse() so we
didn't end up asking userspace to resolve that FH for us -- but that was
just a quick hack. It wouldn't have worked after a server reboot, for
example -- we'd have asked userspace again.

We'd need to export that fsid to userspace somehow. I did briefly think
about adding something like ',uuid=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' to
each line in /proc/mounts, as if it was a file system option -- but I
don't like that much.

When looking for other options, I realised that we already have the
f_fsid field in struct statfs, and we might as well just use that. That
does seem to be what it was _designed_ for, after all.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



