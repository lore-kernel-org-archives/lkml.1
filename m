Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbXEOIJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbXEOIJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbXEOIJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:09:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36158 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758757AbXEOIJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:09:27 -0400
Date: Tue, 15 May 2007 13:46:52 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  2/14] Add a new mount flag (MNT_UNION) for union mount
Message-ID: <20070515081652.GD3465@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514093902.GD4139@in.ibm.com> <Pine.LNX.4.61.0705142237270.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705142237270.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 10:38:46PM +0200, Jan Engelhardt wrote:
> 
> On May 14 2007 15:09, Bharata B Rao wrote:
> >
> >Introduce MNT_UNION, MS_UNION and FS_WHT flags. There are the necessary flags
> >for doing
> >
> >    mount /dev/hda3 /mnt -o union
> >
> >You need additional patches for util-linux for that to work.
> >
> >Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> >Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> >---
> > 
> >+	/* Unions couldn't be writable if the filesystem
> >+	 * doesn't know about whiteouts */
> >+	err = -ENOTSUPP;
> >+	if ((mnt_flags & MNT_UNION) &&
> >+	    !(newmnt->mnt_sb->s_flags & MS_RDONLY) &&
> >+	    !(newmnt->mnt_sb->s_type->fs_flags & FS_WHT))
> >+		goto unlock;
> >+
> 
> Maybe I am too biased towards unionfs/aufs, but if I have an {rw,rw} union
> with whiteouts disabled (delete=all in unionfs speak), then FS_WHT
> does not need to be supported. Your patches do not seem to do
> delete=all semantics, do they?
> 

No, they don't support delete=all semantics.

Correct me if I am wrong, but a key difference from unionfs is that in
union mounts only the topmost layer is writable (and it doesn't matter if
the lower layers are mounted rw), while this not so with unionfs.
Hence when we delete any file which is present in a lower layer, we create
a whiteout for it on the topmost layer to mask it out.

So there can be two cases in union mounts:
1. A file exists in topmost layer and also in one or more lower layers. Deleting
the file would result in the top layer file being deleted and a whiteout being
created in the top layer.

2. A file exists in one or more of lower layers, but not in the topmost layer.
Deleting this file would result in just a whiteout being created in the
topmost layer.

Regards,
Bharata.
