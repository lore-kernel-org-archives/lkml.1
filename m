Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbZJ2FW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbZJ2FW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 01:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZJ2FWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 01:22:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40297 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZJ2FWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 01:22:54 -0400
Date: Thu, 29 Oct 2009 00:23:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 17/25] TOMOYO: Add capability support.
Message-ID: <20091029052301.GC11558@us.ibm.com>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091004125332.899378759@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004125332.899378759@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> This patch contains code for checking non-posix capability.
> 
> TOMOYO is ready to support 65536 types of non-posix capabilities.
> But I can't utilize TOMOYO's ability because
> 
>  (1) Hooks are missing.

please send patches.

>    or
>  (2) Posix's capability and functionality are not one to one mapping.
>      Therefore I can't derive functionality the caller wants to use from
>      posix's capability number (e.g. CAP_SYS_ADMIN).

Hmm, it should be possible to address this in a back-compatible way.  I.e.,

#define CAP_CHOWN 0
...
#define CAP_SYS_ADMIN 21
...
#define CAP_MAC_ADMIN 33

/* start enhanced capabilities */
#ifdef CONFIG_CAPABILITIES_ENHANCED
#define CAP_SAK_CONFIG 200
#define CAP_RND_ADMIN 201
#define CAP_SYS_HOSTNAME 202
...
#else
#define CAP_SAK_CONFIG CAP_SYS_ADMIN
#define CAP_RND_ADMIN CAP_SYS_ADMIN
#define CAP_SYS_HOSTNAME CAP_SYS_ADMIN
#endif

Plus of course all that is needed (if CONFIG_CAPABILITIES_ENHANCED=y)
to support all those caps.

>    or
>  (3) Hooks are provided but it is not permitted to sleep (e.g. CAP_SYS_NICE)
>      while TOMOYO needs hooks where it is permitted to sleep.
>    or
>  (4) System calls and device drivers use the same posix's capability number.
>      Thus whether MAC's policy suits or not depends on hardware the system
>      is running. TOMOYO wants to distinguish requests from userland
>      applications and requests from kernel drivers, but I can't distinguish
>      it from posix's capability number.

Same thing?

> Therefore, LSM version of TOMOYO has very poor support compared to non-LSM
> version of TOMOYO. I hope this problem is solved in the future.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  security/tomoyo/capability.c |  141 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 141 insertions(+)
> 
> --- /dev/null
> +++ security-testing-2.6/security/tomoyo/capability.c
> @@ -0,0 +1,141 @@
> +/*
> + * security/tomoyo/capability.c
> + *
> + * Copyright (C) 2005-2009  NTT DATA CORPORATION
> + */
> +#include "internal.h"
> +
> +/**
> + * tomoyo_audit_capability_log - Audit capability log.
> + *
> + * @r:          Pointer to "struct tomoyo_request_info".
> + * @operation:  Type of operation.
> + * @is_granted: True if this is a granted log.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +static int tomoyo_audit_capability_log(struct tomoyo_request_info *r,
> +				       const u8 operation,
> +				       const bool is_granted)
> +{
> +	if (!is_granted)
> +		tomoyo_warn_log(r, "capability %s",
> +				tomoyo_cap2keyword(operation));
> +	return tomoyo_write_audit_log(is_granted, r,
> +				      TOMOYO_KEYWORD_ALLOW_CAPABILITY "%s\n",
> +				      tomoyo_cap2keyword(operation));
> +}
> +
> +/**
> + * tomoyo_capable - Check permission for capability.
> + *
> + * @operation: Type of operation.
> + *
> + * Returns true on success, false otherwise.
> + *
> + * Caller holds tomoyo_read_lock().
> + */
> +static bool tomoyo_capable2(const u8 operation)
> +{
> +	struct tomoyo_request_info r;
> +	struct tomoyo_acl_info *ptr;
> +	int error;
> +	if (tomoyo_init_request_info(&r, NULL, TOMOYO_MAX_MAC_INDEX +
> +				     operation) == TOMOYO_CONFIG_DISABLED)
> +		return true;
> +	do {
> +		error = -EPERM;
> +		list_for_each_entry_rcu(ptr, &r.domain->acl_info_list, list) {
> +			struct tomoyo_capability_acl *acl;
> +			if (ptr->is_deleted ||
> +			    ptr->type != TOMOYO_TYPE_CAPABILITY_ACL)
> +				continue;
> +			acl = container_of(ptr, struct tomoyo_capability_acl,
> +					   head);
> +			if (acl->operation != operation ||
> +			    !tomoyo_condition(&r, ptr))
> +				continue;
> +			r.cond = ptr->cond;
> +			error = 0;
> +			break;
> +		}
> +		tomoyo_audit_capability_log(&r, operation, !error);
> +		if (!error)
> +			break;
> +		error = tomoyo_supervisor(&r, TOMOYO_KEYWORD_ALLOW_CAPABILITY
> +					  "%s\n",
> +					  tomoyo_cap2keyword(operation));
> +	} while (error == 1);
> +	return !error;
> +}
> +
> +/**
> + * tomoyo_capable - Check permission for capability.
> + *
> + * @operation: Type of operation.
> + *
> + * Returns true on success, false otherwise.
> + */
> +bool tomoyo_capable(const u8 operation)
> +{
> +	const int idx = tomoyo_read_lock();
> +	const int error = tomoyo_capable2(operation);
> +	tomoyo_read_unlock(idx);
> +	return error;
> +}
> +
> +/**
> + * tomoyo_write_capability_policy - Write "struct tomoyo_capability_acl" list.
> + *
> + * @data:      String to parse.
> + * @domain:    Pointer to "struct tomoyo_domain_info".
> + * @condition: Pointer to "struct tomoyo_condition". May be NULL.
> + * @is_delete: True if it is a delete request.
> + *
> + * Returns 0 on success, negative value otherwise.
> + */
> +int tomoyo_write_capability_policy(char *data,
> +				   struct tomoyo_domain_info *domain,
> +				   struct tomoyo_condition *condition,
> +				   const bool is_delete)
> +{
> +	struct tomoyo_capability_acl e = {
> +		.head.type = TOMOYO_TYPE_CAPABILITY_ACL,
> +		.head.cond = condition,
> +	};
> +	struct tomoyo_capability_acl *entry = NULL;
> +	struct tomoyo_acl_info *ptr;
> +	int error = is_delete ? -ENOENT : -ENOMEM;
> +	u8 capability;
> +	for (capability = 0; capability < TOMOYO_MAX_CAPABILITY_INDEX;
> +	     capability++) {
> +		if (strcmp(data, tomoyo_cap2keyword(capability)))
> +			continue;
> +		break;
> +	}
> +	if (capability == TOMOYO_MAX_CAPABILITY_INDEX)
> +		return -EINVAL;
> +	e.operation = capability;
> +	if (!is_delete)
> +		entry = kmalloc(sizeof(e), GFP_KERNEL);
> +	mutex_lock(&tomoyo_policy_lock);
> +	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
> +		struct tomoyo_capability_acl *acl =
> +			container_of(ptr, struct tomoyo_capability_acl,
> +				     head);
> +		if (ptr->type != TOMOYO_TYPE_CAPABILITY_ACL ||
> +		    ptr->cond != condition || acl->operation != capability)
> +			continue;
> +		ptr->is_deleted = is_delete;
> +		error = 0;
> +		break;
> +	}
> +	if (!is_delete && error && tomoyo_commit_ok(entry, &e, sizeof(e))) {
> +		tomoyo_add_domain_acl(domain, &entry->head);
> +		entry = NULL;
> +		error = 0;
> +	}
> +	mutex_unlock(&tomoyo_policy_lock);
> +	kfree(entry);
> +	return error;
> +}
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
