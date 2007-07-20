Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbXGTGlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbXGTGlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbXGTGlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:41:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:40778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbXGTGlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:41:39 -0400
From: Neil Brown <neilb@suse.de>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Date: Fri, 20 Jul 2007 16:41:33 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18080.22813.143226.671265@notabene.brown>
Cc: "David CHANIAL" <david.ml@euro-web.fr>,
       "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
In-Reply-To: message from Satyam Sharma on Thursday July 19
References: <200707160638.15750.david.ml@euro-web.fr>
	<18076.42052.961808.528867@notabene.brown>
	<a781481a0707190711s58d7ab24xa53c6975d4172597@mail.gmail.com>
	<a781481a0707190811y725ac900m13e9b6a02eab7b0@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 19, satyam.sharma@gmail.com wrote:
> Ugh, not a good day for me today ... my earlier conclusion was right,
> but not the reasoning behind it ... hopefully this time I'll do better :-)


Looks good.  Thanks for your helpful analysis.

> 
> 0x34 bytes is the offset of ex_uuid in struct fh_export.
> %ecx == 0, which means ex_uuid was NULL.

Yup. That shouldn't happen, but I can see that it is possible.

There was another case were ex_uuid could conceivably be referenced
while NULL that I fixed a little while ago.  Looks like I need to fix
this one too.  Something like the following.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfsfh.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff .prev/fs/nfsd/nfsfh.c ./fs/nfsd/nfsfh.c
--- .prev/fs/nfsd/nfsfh.c	2007-07-13 17:41:48.000000000 +1000
+++ ./fs/nfsd/nfsfh.c	2007-07-20 12:53:36.000000000 +1000
@@ -566,13 +566,23 @@ enum fsid_source fsid_source(struct svc_
 	case FSID_DEV:
 	case FSID_ENCODE_DEV:
 	case FSID_MAJOR_MINOR:
-		return FSIDSOURCE_DEV;
+		if (fhp->fh_export->ex_dentry->d_inode->i_sb->s_type->fs_flags
+		    & FS_REQUIRES_DEV)
+			return FSIDSOURCE_DEV;
+		break;
 	case FSID_NUM:
-		return FSIDSOURCE_FSID;
-	default:
 		if (fhp->fh_export->ex_flags & NFSEXP_FSID)
 			return FSIDSOURCE_FSID;
-		else
-			return FSIDSOURCE_UUID;
+		break;
+	default:
+		break;
 	}
+	/* either a UUID type filehandle, or the filehandle doesn't
+	 * match the export.
+	 */
+	if (fhp->fh_export->ex_flags & NFSEXP_FSID)
+		return FSIDSOURCE_FSID;
+	if (fhp->fh_export->ex_uuid)
+		return FSIDSOURCE_UUID;
+	return FSIDSOURCE_DEV;
 }
