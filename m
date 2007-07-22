Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbXGVRzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbXGVRzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXGVRzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:55:22 -0400
Received: from pat.uio.no ([129.240.10.15]:46658 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXGVRzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:55:20 -0400
Subject: Re: NFS mount gives ENETDOWN in -git15
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andi Kleen <ak@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707211531.17750.ak@suse.de>
References: <200707211531.17750.ak@suse.de>
Content-Type: multipart/mixed; boundary="=-j27T8iKe8B8FKEoe0c32"
Date: Sun, 22 Jul 2007 13:55:16 -0400
Message-Id: <1185126916.6577.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.111)
X-UiO-Scanned: 153362F7984643677E9477A4B8A7EF67C6CF1EA0
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 311 total 2929265 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-j27T8iKe8B8FKEoe0c32
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2007-07-21 at 15:31 +0200, Andi Kleen wrote:
> I tried to mount another nfs mount on a system running with nfsroot.
> But I get
> 
> # mount basil:/home /basil/home/
> mount: Network is down
> 
> The network is not down of course, the system is happily running with nfs root from that
> server. Userland is older SUSE 10.0

Does Al's patch help in any way?

Cheers
  Trond


--=-j27T8iKe8B8FKEoe0c32
Content-Disposition: inline
Content-Description: Attached message - [PATCH] fix broken handling of
	port=... in NFS option parsing
Content-Type: message/rfc822

Received: from exsvlrb01.hq.netapp.com ([10.56.8.62]) by
	exsvl03.hq.netapp.com with Microsoft SMTPSVC(6.0.3790.1830); Sun, 22 Jul
	2007 02:59:13 -0700
Received: from sacexrs01.hq.netapp.com ([10.99.190.105]) by
	exsvlrb01.hq.netapp.com with Microsoft SMTPSVC(6.0.3790.1830); Sun, 22 Jul
	2007 02:59:13 -0700
Received: from smtp1.corp.netapp.com ([10.57.156.124]) by
	sacexrs01.hq.netapp.com with Microsoft SMTPSVC(6.0.3790.1830); Sun, 22 Jul
	2007 02:59:12 -0700
Received: from mx1.netapp.com (mx1.dmz.netapp.com [10.254.64.60]) by
	smtp1.corp.netapp.com (8.13.1/8.13.1/NTAP-1.6) with ESMTP id l6M9xBYt020931
	for <Trond.Myklebust@netapp.com>; Sun, 22 Jul 2007 02:59:12 -0700 (PDT)
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAALrHokbDXP0ChGdsb2JhbACPWQEBCQoPGA
X-IronPort-AV: E=Sophos;i="4.16,568,1175497200";  d="scan'208";a="89214520"
X-SBRS: 3.2
Received: from zeniv.linux.org.uk ([195.92.253.2]) by mx1.netapp.com with
	ESMTP/TLS/DHE-RSA-AES256-SHA; 22 Jul 2007 02:59:11 -0700
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.52 #1 (Red Hat
	Linux)) id 1ICYDS-0003JE-Pw; Sun, 22 Jul 2007 10:59:06 +0100
Date: Sun, 22 Jul 2007 10:59:06 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Lever <chuck.lever@oracle.com>, Trond Myklebust <Trond.Myklebust@netapp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix broken handling of port=... in NFS option parsing
Message-ID: <20070722095906.GX21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Return-Path: viro@ftp.linux.org.uk
X-OriginalArrivalTime: 22 Jul 2007 09:59:12.0704 (UTC)
	FILETIME=[F49CC400:01C7CC46]
X-Evolution-Source: exchange://trond;auth=NTLM@exsvl03.hq.netapp.com/
Content-Transfer-Encoding: 7bit

	Obviously broken on little-endian; fortunately, the option is
not frequently used...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b34b7a7..b2a851c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -732,7 +732,7 @@ static int nfs_parse_mount_options(char *raw,
 				return 0;
 			if (option < 0 || option > 65535)
 				return 0;
-			mnt->nfs_server.address.sin_port = htonl(option);
+			mnt->nfs_server.address.sin_port = htons(option);
 			break;
 		case Opt_rsize:
 			if (match_int(args, &mnt->rsize))

--=-j27T8iKe8B8FKEoe0c32--

