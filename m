Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYCCXnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYCCXnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYCCXmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:42:54 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48689 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYCCXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:42:52 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH 6/9] LSM/Audit: Introduce generic Audit LSM hooks
Date: Mon, 3 Mar 2008 18:36:15 -0500
User-Agent: KMail/1.9.7
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
References: <20080301194752.GA19636@ubuntu> <20080301200005.GG19636@ubuntu>
In-Reply-To: <20080301200005.GG19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031836.15528.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008 3:00:05 pm Ahmed S. Darwish wrote:
> Introduce a generic Audit interface for security modules
> by adding the following new LSM hooks:
>
> audit_rule_init(field, op, rulestr, lsmrule)
> audit_rule_known(krule)
> audit_rule_match(secid, field, op, rule, actx)
> audit_rule_free(rule)
>
> Those hooks are only available if CONFIG_AUDIT is enabled.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Reviewed-by: Paul Moore <paul.moore@hp.com>

> ---
>
>  include/linux/security.h |   72
> +++++++++++++++++++++++++++++++++++++++++++++++ security/dummy.c     
>    |   31 +++++++++++++++++++-
>  security/security.c      |   25 ++++++++++++++++
>  3 files changed, 127 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index b5d1ad7..eb663e5 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -43,6 +43,7 @@
>  extern unsigned securebits;
>
>  struct ctl_table;
> +struct audit_krule;
>
>  /*
>   * These functions are in security/capability.c and are used
> @@ -1227,6 +1228,37 @@ struct request_sock;
>   *	@secdata contains the security context.
>   *	@seclen contains the length of the security context.
>   *
> + * Security hooks for Audit
> + *
> + * @audit_rule_init:
> + *	Allocate and initialize an LSM audit rule structure.
> + *	@field contains the required Audit action. Fields flags are
> defined in include/linux/audit.h + *	@op contains the operator the
> rule uses.
> + *	@rulestr contains the context where the rule will be applied to.
> + *	@lsmrule contains a pointer to receive the result.
> + *	Return 0 if @lsmrule has been successfully set,
> + *	-EINVAL in case of an invalid rule.
> + *
> + * @audit_rule_known:
> + *	Specifies whether given @rule contains any fields related to
> current LSM. + *	@rule contains the audit rule of interest.
> + *	Return 1 in case of relation found, 0 otherwise.
> + *
> + * @audit_rule_match:
> + *	Determine if given @secid matches a rule previously approved
> + *	by @audit_rule_known.
> + *	@secid contains the security id in question.
> + *	@field contains the field which relates to current LSM.
> + *	@op contains the operator that will be used for matching.
> + *	@rule points to the audit rule that will be checked against.
> + *	@actx points to the audit context associated with the check.
> + *	Return 1 if secid matches the rule, 0 if it does not, -ERRNO on
> failure. + *
> + * @audit_rule_free:
> + *	Deallocate the LSM audit rule structure previously allocated by
> + *	audit_rule_init.
> + *	@rule contains the allocated rule
> + *
>   * This is the main security structure.
>   */
>  struct security_operations {
> @@ -1487,6 +1519,13 @@ struct security_operations {
>  	int (*key_getsecurity)(struct key *key, char **_buffer);
>  #endif	/* CONFIG_KEYS */
>
> +#ifdef CONFIG_AUDIT
> +	int (*audit_rule_init)(u32 field, u32 op, char *rulestr, void
> **lsmrule); +	int (*audit_rule_known)(struct audit_krule *krule);
> +	int (*audit_rule_match)(u32 secid, u32 field, u32 op, void
> *lsmrule, +				struct audit_context *actx);
> +	void (*audit_rule_free)(void *lsmrule);
> +#endif /* CONFIG_AUDIT */
>  };
>
>  /* prototypes */
> @@ -2670,5 +2709,38 @@ static inline int
> security_key_getsecurity(struct key *key, char **_buffer) #endif
>  #endif /* CONFIG_KEYS */
>
> +#ifdef CONFIG_AUDIT
> +#ifdef CONFIG_SECURITY
> +int security_audit_rule_init(u32 field, u32 op, char *rulestr, void
> **lsmrule); +int security_audit_rule_known(struct audit_krule
> *krule);
> +int security_audit_rule_match(u32 secid, u32 field, u32 op, void
> *lsmrule, +			      struct audit_context *actx);
> +void security_audit_rule_free(void *lsmrule);
> +
> +#else
> +
> +static inline int security_audit_rule_init(u32 field, u32 op, char
> *rulestr, +					   void **lsmrule)
> +{
> +	return 0;
> +}
> +
> +static inline int security_audit_rule_known(struct audit_krule
> *krule) +{
> +	return 0;
> +}
> +
> +static inline int security_audit_rule_match(u32 secid, u32 field,
> u32 op, +				   void *lsmrule, struct audit_context *actx)
> +{
> +	return 0;
> +}
> +
> +static inline void security_audit_rule_free(void *lsmrule)
> +{ }
> +
> +#endif /* CONFIG_SECURITY */
> +#endif /* CONFIG_AUDIT */
> +
>  #endif /* ! __LINUX_SECURITY_H */
>
> diff --git a/security/dummy.c b/security/dummy.c
> index b4967f4..241ab20 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -998,6 +998,30 @@ static int dummy_key_getsecurity(struct key
> *key, char **_buffer)
>
>  #endif /* CONFIG_KEYS */
>
> +#ifdef CONFIG_AUDIT
> +static inline int dummy_audit_rule_init(u32 field, u32 op, char
> *rulestr, +					void **lsmrule)
> +{
> +	return 0;
> +}
> +
> +static inline int dummy_audit_rule_known(struct audit_krule *krule)
> +{
> +	return 0;
> +}
> +
> +static inline int dummy_audit_rule_match(u32 secid, u32 field, u32
> op, +					 void *lsmrule,
> +					 struct audit_context *actx)
> +{
> +	return 0;
> +}
> +
> +static inline void dummy_audit_rule_free(void *lsmrule)
> +{ }
> +
> +#endif /* CONFIG_AUDIT */
> +
>  struct security_operations dummy_security_ops;
>
>  #define set_to_dummy_if_null(ops, function)				\
> @@ -1187,6 +1211,11 @@ void security_fixup_ops (struct
> security_operations *ops) set_to_dummy_if_null(ops, key_permission);
>  	set_to_dummy_if_null(ops, key_getsecurity);
>  #endif	/* CONFIG_KEYS */
> -
> +#ifdef CONFIG_AUDIT
> +	set_to_dummy_if_null(ops, audit_rule_init);
> +	set_to_dummy_if_null(ops, audit_rule_known);
> +	set_to_dummy_if_null(ops, audit_rule_match);
> +	set_to_dummy_if_null(ops, audit_rule_free);
> +#endif
>  }
>
> diff --git a/security/security.c b/security/security.c
> index 1748329..1bf2ee4 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1118,3 +1118,28 @@ int security_key_getsecurity(struct key *key,
> char **_buffer) }
>
>  #endif	/* CONFIG_KEYS */
> +
> +#ifdef CONFIG_AUDIT
> +
> +int security_audit_rule_init(u32 field, u32 op, char *rulestr, void
> **lsmrule) +{
> +	return security_ops->audit_rule_init(field, op, rulestr, lsmrule);
> +}
> +
> +int security_audit_rule_known(struct audit_krule *krule)
> +{
> +	return security_ops->audit_rule_known(krule);
> +}
> +
> +void security_audit_rule_free(void *lsmrule)
> +{
> +	security_ops->audit_rule_free(lsmrule);
> +}
> +
> +int security_audit_rule_match(u32 secid, u32 field, u32 op, void
> *lsmrule, +			      struct audit_context *actx)
> +{
> +	return security_ops->audit_rule_match(secid, field, op, lsmrule,
> actx); +}
> +
> +#endif /* CONFIG_AUDIT */



-- 
paul moore
linux security @ hp
