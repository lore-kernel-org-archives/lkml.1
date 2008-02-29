Return-Path: <linux-kernel-owner+w=401wt.eu-S934009AbYB2WPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbYB2WPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbYB2WP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:15:26 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:54273 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759706AbYB2WPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:15:25 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: hch@infradead.org
Cc: viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1204150294-4678-2-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-2-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 16:50:45 -0500
Message-Id: <1204321845.2715.125.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am adding a new hook to provide the functionality that Casey
suggested. It takes an inode, context, contextlen and sets it in the
LSM. The question is that since there is a need to be able to set
in-core, on-disk, or both; should these be two separate hooks? or should
we make the hook take a flag that has in-core, and ondisk and it can be
masked together for both?

Dave


On Wed, 2008-02-27 at 17:11 -0500, David P. Quigley wrote:
> Before the inode_xattr_getsecurity call was removed the caller would
> concatenate the security namespace prefix and the suffix provided by the lsm to
> obtain the security xattr. This hook provides the functionality to obtain the full
> LSM xattr name. The patch also provides implementations for the dummy security
> module and SELinux. This method is used instead of restoring the old method
> since it only requires an offset into the returned pointer to obtain the
> suffix. This approach is more efficient than concatenating the security xattr
> namespace string with the suffix to get a usable string.
> 
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> ---
>  include/linux/security.h |    8 ++++++++
>  security/dummy.c         |    6 ++++++
>  security/security.c      |    6 ++++++
>  security/selinux/hooks.c |   10 ++++++++--
>  4 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index fe52cde..c80bee4 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1394,6 +1394,7 @@ struct security_operations {
>  	int (*secid_to_secctx)(u32 secid, char **secdata, u32 *seclen);
>  	int (*secctx_to_secid)(char *secdata, u32 seclen, u32 *secid);
>  	void (*release_secctx)(char *secdata, u32 seclen);
> +	const char *(*maclabel_getname) (void);
>  
>  #ifdef CONFIG_SECURITY_NETWORK
>  	int (*unix_stream_connect) (struct socket * sock,
> @@ -1633,6 +1634,7 @@ int security_netlink_recv(struct sk_buff *skb, int cap);
>  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
>  int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid);
>  void security_release_secctx(char *secdata, u32 seclen);
> +const char *security_maclabel_getname(void);
>  
>  #else /* CONFIG_SECURITY */
>  
> @@ -2316,6 +2318,12 @@ static inline int security_secctx_to_secid(char *secdata,
>  static inline void security_release_secctx(char *secdata, u32 seclen)
>  {
>  }
> +
> +static inline const char *security_maclabel_getname(void)
> +{
> +	return NULL;
> +}
> +
>  #endif	/* CONFIG_SECURITY */
>  
>  #ifdef CONFIG_SECURITY_NETWORK
> diff --git a/security/dummy.c b/security/dummy.c
> index 649326b..928ef41 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -960,6 +960,11 @@ static void dummy_release_secctx(char *secdata, u32 seclen)
>  {
>  }
>  
> +static const char *dummy_maclabel_getname(void)
> +{
> +	return NULL;
> +}
> +
>  #ifdef CONFIG_KEYS
>  static inline int dummy_key_alloc(struct key *key, struct task_struct *ctx,
>  				  unsigned long flags)
> @@ -1118,6 +1123,7 @@ void security_fixup_ops (struct security_operations *ops)
>   	set_to_dummy_if_null(ops, secid_to_secctx);
>  	set_to_dummy_if_null(ops, secctx_to_secid);
>   	set_to_dummy_if_null(ops, release_secctx);
> +	set_to_dummy_if_null(ops, maclabel_getname);
>  #ifdef CONFIG_SECURITY_NETWORK
>  	set_to_dummy_if_null(ops, unix_stream_connect);
>  	set_to_dummy_if_null(ops, unix_may_send);
> diff --git a/security/security.c b/security/security.c
> index d15e56c..1a84eb1 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -845,6 +845,12 @@ void security_release_secctx(char *secdata, u32 seclen)
>  }
>  EXPORT_SYMBOL(security_release_secctx);
>  
> +const char *security_maclabel_getname(void)
> +{
> +	return security_ops->maclabel_getname();
> +}
> +EXPORT_SYMBOL(security_maclabel_getname);
> +
>  #ifdef CONFIG_SECURITY_NETWORK
>  
>  int security_unix_stream_connect(struct socket *sock, struct socket *other,
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 75c2e99..e7fc9c9 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5163,6 +5163,11 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
>  	kfree(secdata);
>  }
>  
> +static const char *selinux_maclabel_getname(void)
> +{
> +      return XATTR_NAME_SELINUX;
> +}
> +
>  #ifdef CONFIG_KEYS
>  
>  static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
> @@ -5351,8 +5356,9 @@ static struct security_operations selinux_ops = {
>  	.secid_to_secctx =		selinux_secid_to_secctx,
>  	.secctx_to_secid =		selinux_secctx_to_secid,
>  	.release_secctx =		selinux_release_secctx,
> -
> -        .unix_stream_connect =		selinux_socket_unix_stream_connect,
> +	.maclabel_getname =  		selinux_maclabel_getname,
> +        
> +	.unix_stream_connect =		selinux_socket_unix_stream_connect,
>  	.unix_may_send =		selinux_socket_unix_may_send,
>  
>  	.socket_create =		selinux_socket_create,

