Return-Path: <linux-kernel-owner+w=401wt.eu-S934459AbXHGN7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbXHGN7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933594AbXHGN6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:58:44 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:41211 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764131AbXHGN6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:58:42 -0400
Subject: Re: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070806185231.GA21550@sergelap.austin.ibm.com>
References: <20070806185231.GA21550@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 07 Aug 2007 09:57:02 -0400
Message-Id: <1186495022.26457.44.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 13:52 -0500, Serge E. Hallyn wrote:
> >From 1376764cbb54243f088cf00c39000c4f4418f461 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Mon, 6 Aug 2007 14:20:06 -0400
> Subject: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
> 
> When a file with posix capabilities is overwritten, the
> file capabilities, like a setuid bit, should be removed.
> 
> This patch introduces security_inode_killpriv().  This is
> currently only defined for capability, and is called when
> an inode is changed to inform the security module that
> it may want to clear out any privilege attached to that inode.
> The capability module checks whether any file capabilities
> are defined for the inode, and, if so, clears them.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  fs/attr.c                |    7 +++++++
>  fs/nfsd/vfs.c            |    4 ++--
>  fs/open.c                |    3 ++-
>  fs/splice.c              |    4 ++++
>  include/linux/fs.h       |    1 +
>  include/linux/security.h |   18 ++++++++++++++++++
>  mm/filemap.c             |    5 +++++
>  security/capability.c    |    1 +
>  security/commoncap.c     |   27 +++++++++++++++++++++++++++
>  security/dummy.c         |    6 ++++++
>  security/security.c      |    5 +++++
>  11 files changed, 78 insertions(+), 3 deletions(-)
> 

> diff --git a/security/capability.c b/security/capability.c
> index dc2b66c..e23864e 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -37,6 +37,7 @@ static struct security_operations capability_ops = {
>  
>  	.inode_setxattr =		cap_inode_setxattr,
>  	.inode_removexattr =		cap_inode_removexattr,
> +	.inode_removexattr =		cap_inode_killpriv,

s/inode_removexattr/inode_killpriv/

Also, doesn't SELinux then need to define a corresponding hook function
to call the secondary module?  Otherwise, it will fall back to the dummy
implementation and stacking selinux + capabilities with file caps won't
yield the right behavior.

-- 
Stephen Smalley
National Security Agency

