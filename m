Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbYCCX1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbYCCX1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbYCCX1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:27:33 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:15613 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbYCCX1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:27:32 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH 2/9] SELinux: setup new inode/ipc getsecid hooks
Date: Mon, 3 Mar 2008 18:25:14 -0500
User-Agent: KMail/1.9.7
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
References: <20080301194752.GA19636@ubuntu> <20080301195230.GC19636@ubuntu>
In-Reply-To: <20080301195230.GC19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031825.14550.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008 2:52:30 pm Ahmed S. Darwish wrote:
> Setup the new inode_getsecid and ipc_getsecid() LSM hooks
> for SELinux.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Reviewed-by: Paul Moore <paul.moore@hp.com>

> ---
>
>  hooks.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index f42ebfc..06597d7 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2724,6 +2724,12 @@ static int selinux_inode_killpriv(struct
> dentry *dentry) return secondary_ops->inode_killpriv(dentry);
>  }
>
> +static void selinux_inode_getsecid(const struct inode *inode, u32
> *secid) +{
> +	struct inode_security_struct *isec = inode->i_security;
> +	*secid = isec->sid;
> +}
> +
>  /* file security operations */
>
>  static int selinux_revalidate_file_permission(struct file *file, int
> mask) @@ -3120,7 +3126,8 @@ static int selinux_task_getsid(struct
> task_struct *p)
>
>  static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
>  {
> -	selinux_get_task_sid(p, secid);
> +	struct task_security_struct *tsec = p->security;
> +	*secid = tsec->sid;
>  }
>
>  static int selinux_task_setgroups(struct group_info *group_info)
> @@ -4090,7 +4097,7 @@ static int
> selinux_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *
> goto out;
>
>  	if (sock && family == PF_UNIX)
> -		selinux_get_inode_sid(SOCK_INODE(sock), &peer_secid);
> +		selinux_inode_getsecid(SOCK_INODE(sock), &peer_secid);
>  	else if (skb)
>  		selinux_skb_peerlbl_sid(skb, family, &peer_secid);
>
> @@ -4970,6 +4977,12 @@ static int selinux_ipc_permission(struct
> kern_ipc_perm *ipcp, short flag) return ipc_has_perm(ipcp, av);
>  }
>
> +static void selinux_ipc_getsecid(struct kern_ipc_perm *ipcp, u32
> *secid) +{
> +	struct ipc_security_struct *isec = ipcp->security;
> +	*secid = isec->sid;
> +}
> +
>  /* module stacking operations */
>  static int selinux_register_security (const char *name, struct
> security_operations *ops) {
> @@ -5292,6 +5305,7 @@ static struct security_operations selinux_ops =
> { .inode_listsecurity =           selinux_inode_listsecurity,
> .inode_need_killpriv =		selinux_inode_need_killpriv,
>  	.inode_killpriv =		selinux_inode_killpriv,
> +	.inode_getsecid =               selinux_inode_getsecid,
>
>  	.file_permission =		selinux_file_permission,
>  	.file_alloc_security =		selinux_file_alloc_security,
> @@ -5332,6 +5346,7 @@ static struct security_operations selinux_ops =
> { .task_to_inode =                selinux_task_to_inode,
>
>  	.ipc_permission =		selinux_ipc_permission,
> +	.ipc_getsecid =                 selinux_ipc_getsecid,
>
>  	.msg_msg_alloc_security =	selinux_msg_msg_alloc_security,
>  	.msg_msg_free_security =	selinux_msg_msg_free_security,



-- 
paul moore
linux security @ hp
