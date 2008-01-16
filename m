Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYAPBGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYAPBGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbYAPBGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:06:12 -0500
Received: from namei.org ([69.55.235.186]:47620 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756049AbYAPBGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:06:10 -0500
Date: Wed, 16 Jan 2008 12:05:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/26] Add a secctx_to_secid() LSM hook to go along with
 the existing
In-Reply-To: <20080115234735.22183.36356.stgit@warthog.procyon.org.uk>
Message-ID: <Xine.LNX.4.64.0801161204470.24959@us.intercode.com.au>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
 <20080115234735.22183.36356.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008, David Howells wrote:

> secid_to_secctx() LSM hook.  This patch also includes the SELinux
> implementation for this hook.
> 
> Signed-off-by: Paul Moore <paul.moore@hp.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

This is useful in its own right, and I would like to push it upstream for 
2.6.24 unless there are any objections.

> ---
> 
>  include/linux/security.h |   13 +++++++++++++
>  security/dummy.c         |    6 ++++++
>  security/security.c      |    6 ++++++
>  security/selinux/hooks.c |    6 ++++++
>  4 files changed, 31 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index b7ba073..e8f2f2d 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1200,6 +1200,10 @@ struct request_sock;
>   *	Convert secid to security context.
>   *	@secid contains the security ID.
>   *	@secdata contains the pointer that stores the converted security context.
> + * @secctx_to_secid:
> + *      Convert security context to secid.
> + *      @secid contains the pointer to the generated security ID.
> + *      @secdata contains the security context.
>   *
>   * @release_secctx:
>   *	Release the security context.
> @@ -1389,6 +1393,7 @@ struct security_operations {
>   	int (*getprocattr)(struct task_struct *p, char *name, char **value);
>   	int (*setprocattr)(struct task_struct *p, char *name, void *value, size_t size);
>  	int (*secid_to_secctx)(u32 secid, char **secdata, u32 *seclen);
> +	int (*secctx_to_secid)(char *secdata, u32 seclen, u32 *secid);
>  	void (*release_secctx)(char *secdata, u32 seclen);
>  
>  #ifdef CONFIG_SECURITY_NETWORK
> @@ -1623,6 +1628,7 @@ int security_setprocattr(struct task_struct *p, char *name, void *value, size_t
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>  int security_netlink_recv(struct sk_buff *skb, int cap);
>  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
> +int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid);
>  void security_release_secctx(char *secdata, u32 seclen);
>  
>  #else /* CONFIG_SECURITY */
> @@ -2305,6 +2311,13 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int security_secctx_to_secid(char *secdata,
> +					   u32 seclen,
> +					   u32 *secid)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline void security_release_secctx(char *secdata, u32 seclen)
>  {
>  }
> diff --git a/security/dummy.c b/security/dummy.c
> index 6f97089..72f1666 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -943,6 +943,11 @@ static int dummy_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  	return -EOPNOTSUPP;
>  }
>  
> +static int dummy_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static void dummy_release_secctx(char *secdata, u32 seclen)
>  {
>  }
> @@ -1109,6 +1114,7 @@ void security_fixup_ops (struct security_operations *ops)
>   	set_to_dummy_if_null(ops, getprocattr);
>   	set_to_dummy_if_null(ops, setprocattr);
>   	set_to_dummy_if_null(ops, secid_to_secctx);
> +	set_to_dummy_if_null(ops, secctx_to_secid);
>   	set_to_dummy_if_null(ops, release_secctx);
>  #ifdef CONFIG_SECURITY_NETWORK
>  	set_to_dummy_if_null(ops, unix_stream_connect);
> diff --git a/security/security.c b/security/security.c
> index 92d66d6..1ef4908 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -821,6 +821,12 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  }
>  EXPORT_SYMBOL(security_secid_to_secctx);
>  
> +int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
> +{
> +	return security_ops->secctx_to_secid(secdata, seclen, secid);
> +}
> +EXPORT_SYMBOL(security_secctx_to_secid);
> +
>  void security_release_secctx(char *secdata, u32 seclen)
>  {
>  	return security_ops->release_secctx(secdata, seclen);
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 20a6b55..1d3eab7 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4734,6 +4734,11 @@ static int selinux_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  	return security_sid_to_context(secid, secdata, seclen);
>  }
>  
> +static int selinux_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
> +{
> +	return security_context_to_sid(secdata, seclen, secid);
> +}
> +
>  static void selinux_release_secctx(char *secdata, u32 seclen)
>  {
>  	kfree(secdata);
> @@ -4937,6 +4942,7 @@ static struct security_operations selinux_ops = {
>  	.setprocattr =                  selinux_setprocattr,
>  
>  	.secid_to_secctx =		selinux_secid_to_secctx,
> +	.secctx_to_secid =		selinux_secctx_to_secid,
>  	.release_secctx =		selinux_release_secctx,
>  
>          .unix_stream_connect =		selinux_socket_unix_stream_connect,
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>
