Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYKDTD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYKDTD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYKDTDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:03:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbYKDTDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:03:48 -0500
Subject: Re: 2.6.28-rc3 truncates nfsd results
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Doug Nazar <nazard@dragoninc.ca>,
       "'J. Bruce Fields'" <bfields@citi.umich.edu>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <491097DA.9040204@garzik.org>
References: <000301c93eaa$fae98460$f0bc8d20$@ca>
	 <491097DA.9040204@garzik.org>
Content-Type: multipart/mixed; boundary="=-DAMp/5ZxPj/xpeuHZlM6"
Date: Tue, 04 Nov 2008 19:03:31 +0000
Message-Id: <1225825411.11230.6.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DAMp/5ZxPj/xpeuHZlM6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-11-04 at 13:43 -0500, Jeff Garzik wrote:
> I'll try reverting this and see if the behavior improves, thanks for the 
> pointer...

See attached...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

--=-DAMp/5ZxPj/xpeuHZlM6
Content-Disposition: inline
Content-Description: Attached message - [PATCH] nfsd: fix failure to set
	eof in readdir in some situations
Content-Type: message/rfc822

Received: from hasmsx413.ger.corp.intel.com ([143.185.64.170]) by
	swsmsx413.ger.corp.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Thu, 30
	Oct 2008 21:32:11 +0000
Received: from orsmsx335.jf.intel.com ([10.22.226.40]) by
	hasmsx413.ger.corp.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Thu, 30
	Oct 2008 23:32:10 +0200
Received: from azsmsx333.amr.corp.intel.com ([10.2.121.77]) by
	orsmsx335.jf.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Thu, 30 Oct
	2008 14:31:28 -0700
Received: from fmsmga002.fm.intel.com ([10.253.24.26]) by
	azsmsx333.amr.corp.intel.com with Microsoft SMTPSVC(6.0.3790.3959); Thu, 30
	Oct 2008 14:31:28 -0700
Received: from fmsmga102.fm.intel.com ([10.1.193.69]) by
	fmsmga002-1.fm.intel.com with ESMTP; 30 Oct 2008 14:27:40 -0700
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtECAK/ECUlCXQLWgWdsb2JhbACUCwEBFiKtUYpDg1E
X-IronPort-AV: E=Sophos;i="4.33,518,1220252400";  d="scan'208";a="704586773"
Received: from mail.fieldses.org (HELO fieldses.org) ([66.93.2.214]) by
	mga11.intel.com with ESMTP; 30 Oct 2008 14:26:37 -0700
Received: from bfields by fieldses.org with local (Exim 4.69)
	(envelope-from <bfields@fieldses.org>) id 1Kvf6z-0006pW-4A; Thu, 30 Oct
	2008 17:31:25 -0400
Date: Thu, 30 Oct 2008 17:31:25 -0400
To: linux-nfs@vger.kernel.org
Cc: David Woodhouse <David.Woodhouse@intel.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] nfsd: fix failure to set eof in readdir in some situations
Message-ID: <20081030213125.GC24156@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Return-Path: bfields@fieldses.org
X-OriginalArrivalTime: 30 Oct 2008 21:31:28.0771 (UTC)
	FILETIME=[DE891D30:01C93AD6]
X-Evolution-Source: imap://GER%5cdwoodhou@imap.intel.com/
Content-Transfer-Encoding: 7bit

From: J. Bruce Fields <bfields@citi.umich.edu>

Before 14f7dd632011bb89c035722edd6ea0d90ca6b078 "[PATCH] Copy XFS
readdir hack into nfsd code", readdir_cd->err was reset to eof before
each call to vfs_readdir; afterwards, it is set only once.  Similarly,
c002a6c7977320f95b5edede5ce4e0eeecf291ff "[PATCH] Optimise NFS readdir
hack slightly", can cause us to exit without nfserr_eof set.  Fix this.

This ensures the "eof" bit is set when needed in readdir replies.  (The
particular case I saw was an nfsv4 readdir of an empty directory, which
returned with no entries (the protocol requires "." and ".." to be
filtered out), but with eof unset.)

Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/nfsd/vfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

I'm queuing this up for 2.6.28.--b.

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 0bc56f6..848a03e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1912,6 +1912,7 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 			de = (struct buffered_dirent *)((char *)de + reclen);
 		}
 		offset = vfs_llseek(file, 0, SEEK_CUR);
+		cdp->err = nfserr_eof;
 		if (!buf.full)
 			break;
 	}
-- 
1.5.5.rc1


--=-DAMp/5ZxPj/xpeuHZlM6--

