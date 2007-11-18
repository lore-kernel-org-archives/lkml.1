Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbXKRTmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbXKRTmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 14:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbXKRTmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 14:42:36 -0500
Received: from pat.uio.no ([129.240.10.15]:50342 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbXKRTmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 14:42:35 -0500
Subject: Re: NFS Bug in 2.6.23 ? SOLUTION ?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Gianluca Alberici <gianluca@abinetworks.biz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <474087F6.9030305@abinetworks.biz>
References: <473D6B5C.4090701@abinetworks.biz>
	 <20071116121148.GI4290@tatooine.rebelbase.local>
	 <1195222863.7653.18.camel@heimdal.trondhjem.org>
	 <473EEEC7.1070300@abinetworks.biz> <473F2464.3020905@abinetworks.biz>
	 <474087F6.9030305@abinetworks.biz>
Content-Type: text/plain
Date: Sun, 18 Nov 2007 14:42:21 -0500
Message-Id: <1195414941.10559.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.3, required=12.0, autolearn=disabled, AWL=-0.278)
X-UiO-Scanned: B13D2BEECAEF27976AE59EA14DF925BC97A98CF5
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -2 maxlevel 200 minaction 2 bait 0 mail/h: 509 total 5206357 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-11-18 at 19:44 +0100, Gianluca Alberici wrote:
> Trond,
> 
> The problem is in nfs_mountpoint_timeout. After this time 
> dentry_delete(/,4) removes the mountpoint, then it is very difficult to 
> automount (at least with CFSD), one has got to try 2 or three times 
> cd'ing into the mount point. Applications wont ever had the chance to 
> autoremount (ENOTDIR).

Sounds like CFSD has a bug w.r.t. what fsid it returns to the client.

> I have some questions:
> 
> - nfs_mountpoint_timeout seems to be set in sysctl.c even if nfsv4 is 
> not. Is this correct ? I've read somewhere that it was introduced for v4.

Wrong. It applies to all mountpoint crossing. If the server tells us
that the fsid has changed, then we create a new mountpoint.

> - Why this sysctl is not registered in my 2.6.20 kernel where it should 
> be registered ?

Prior to 2.6.21-rc5, we had a bug in register_nfs_fs() whereby it failed
to register the sysctl table unless you enabled NFSv4.

> - Why this parameter has not a 'disabled' value (i mean kind of -1) ?

Why should it? The current behaviour is quite correct. If you cross a
mountpoint, then you should remount in order to ensure that the inode
numbers remain unique per-filesystem.

We know that some ancient NFS servers had problems returning the correct
fsid in readdirplus replies, so 2.6.22 adds support to disable
readdirplus calls via a 'nordirplus' mount option. I guess you could try
that...

Trond

