Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0BVNlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:41:17 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:34810 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0BVNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:41:15 -0500
Subject: Re: [PATCH] Security: add static to security_ops and
 default_security_ops  variable
From: Stephen Smalley <sds@tycho.nsa.gov>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, lsm <linux-security-module@vger.kernel.org>
In-Reply-To: <628d1651002191952l625e555asf70aed5557355344@mail.gmail.com>
References: <628d1651002191952l625e555asf70aed5557355344@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 22 Feb 2010 08:41:12 -0500
Message-Id: <1266846072.15933.4.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 11:52 +0800, wzt wzt wrote:
> Enhance the security framework to support resetting the active security
> module. This eliminates the need for direct use of the security_ops and
> default_security_ops variables outside of security.c, so make security_ops
> and default_security_ops static. Also remove the secondary_ops variable as
> a cleanup since there is no use for that. secondary_ops was originally used by
> SELinux to call the "secondary" security module (capability or dummy),
> but that was replaced by direct calls to capability and the only
> remaining use is to save and restore the original security ops pointer
> value if SELinux is disabled by early userspace based on /etc/selinux/config.
> Further, if we support this directly in the security framework, then we can
> just use &default_security_ops for this purpose since that is now available.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

Looks good, but the patch was whitespace damaged and didn't apply for
me.  Read Documentation/email-clients.txt.


> ---
>  include/linux/security.h |    2 ++
>  security/capability.c    |    4 ----
>  security/security.c      |   11 +++++++++--
>  security/selinux/hooks.c |   13 +------------
>  4 files changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 2c627d3..8cbc714 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -95,6 +95,8 @@ struct seq_file;
>  extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
>  extern int cap_netlink_recv(struct sk_buff *skb, int cap);
> 
> +void reset_security_ops(void);
> +
>  #ifdef CONFIG_MMU
>  extern unsigned long mmap_min_addr;
>  extern unsigned long dac_mmap_min_addr;
> diff --git a/security/capability.c b/security/capability.c
> index 5c700e1..4875142 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -906,10 +906,6 @@ static void cap_audit_rule_free(void *lsmrule)
>  }
>  #endif /* CONFIG_AUDIT */
> 
> -struct security_operations default_security_ops = {
> -       .name   = "default",
> -};
> -
>  #define set_to_cap_if_null(ops, function)                              \
>         do {                                                            \
>                 if (!ops->function) {                                   \
> diff --git a/security/security.c b/security/security.c
> index 122b748..663b630 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -23,10 +23,12 @@ static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
>         CONFIG_DEFAULT_SECURITY;
> 
>  /* things that live in capability.c */
> -extern struct security_operations default_security_ops;
>  extern void security_fixup_ops(struct security_operations *ops);
> 
> -struct security_operations *security_ops;      /* Initialized to NULL */
> +static struct security_operations *security_ops;
> +static struct security_operations default_security_ops = {
> +       .name   = "default",
> +};
> 
>  static inline int verify(struct security_operations *ops)
>  {
> @@ -63,6 +65,11 @@ int __init security_init(void)
>         return 0;
>  }
> 
> +void reset_security_ops(void)
> +{
> +       security_ops = &default_security_ops;
> +}
> +
>  /* Save user chosen LSM */
>  static int __init choose_lsm(char *str)
>  {
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 9a2ee84..1cbf18f 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -125,13 +125,6 @@ __setup("selinux=", selinux_enabled_setup);
>  int selinux_enabled = 1;
>  #endif
> 
> -
> -/*
> - * Minimal support for a secondary security module,
> - * just to allow the use of the capability module.
> - */
> -static struct security_operations *secondary_ops;
> -
>  /* Lists of inode and superblock security structures initialized
>     before the policy was loaded. */
>  static LIST_HEAD(superblock_security_head);
> @@ -5672,9 +5665,6 @@ static __init int selinux_init(void)
>                                             0, SLAB_PANIC, NULL);
>         avc_init();
> 
> -       secondary_ops = security_ops;
> -       if (!secondary_ops)
> -               panic("SELinux: No initial security operations\n");
>         if (register_security(&selinux_ops))
>                 panic("SELinux: Unable to register with kernel.\n");
> 
> @@ -5835,8 +5825,7 @@ int selinux_disable(void)
>         selinux_disabled = 1;
>         selinux_enabled = 0;
> 
> -       /* Reset security_ops to the secondary module, dummy or capability. */
> -       security_ops = secondary_ops;
> +       reset_security_ops();
> 
>         /* Try to destroy the avc node cache */
>         avc_disable();
> --
> 1.6.5.3
-- 
Stephen Smalley
National Security Agency

