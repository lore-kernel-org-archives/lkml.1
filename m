Return-Path: <linux-kernel-owner+w=401wt.eu-S933269AbZHDSnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbZHDSnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933255AbZHDSnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:43:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46981 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221AbZHDSnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:43:50 -0400
Date: Tue, 4 Aug 2009 13:43:34 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] KEYS: Add garbage collection for dead, revoked and
	expired keys.
Message-ID: <20090804184334.GC8442@us.ibm.com>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145546.17676.98776.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804145546.17676.98776.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Add garbage collection for dead, revoked and expired keys.  This involved
> erasing all links to such keys from keyrings that point to them.  At that
> point, the key will be deleted in the normal manner.
> 
> Keyrings from which garbage collection occurs are shrunk and their quota
> consumption reduced as appropriate.
> 
> Dead keys (for which the key type has been removed) will be garbage collected
> immediately.
> 
> Revoked and expired keys will hang around for a number of seconds, as set in
> /proc/sys/kernel/keys/gc_delay before being automatically removed.  The default
> is 5 minutes.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---

...

> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index 3dba81c..acbe0d5 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -1000,3 +1000,81 @@ static void keyring_revoke(struct key *keyring)
>  	}
> 
>  } /* end keyring_revoke() */
> +
> +/*
> + * Collect garbage from the contents of a keyring
> + */
> +void keyring_gc(struct key *keyring, time_t limit)
> +{
> +	struct keyring_list *klist, *new;
> +	struct key *key;
> +	int loop, keep, max;
> +
> +	kenter("%x", key_serial(keyring));
> +
> +	down_write(&keyring->sem);
> +
> +	klist = keyring->payload.subscriptions;
> +	if (!klist)
> +		goto just_return;
> +
> +	/* work out how many subscriptions we're keeping */
> +	keep = 0;
> +	for (loop = klist->nkeys - 1; loop >= 0; loop--) {
> +		key = klist->keys[loop];
> +		if (!test_bit(KEY_FLAG_DEAD, &key->flags) &&
> +		    !(key->expiry > 0 && key->expiry <= limit))
These two lines (repeated below) beg for a helper?

> +	for (loop = klist->nkeys - 1; loop >= 0; loop--) {
> +		key = klist->keys[loop];
> +		if (!test_bit(KEY_FLAG_DEAD, &key->flags) &&
> +		    !(key->expiry > 0 && key->expiry <= limit)) {
> +			if (keep >= max)
> +				goto discard_new;

Can this happen?  This implies that the number of live keys
went up, but we're under keyring->sem?

> +			new->keys[keep++] = key_get(key);
> +		}
> +	}
> +	new->nkeys = keep;
> +
> +	/* adjust the quota */
> +	key_payload_reserve(keyring,
> +			    sizeof(struct keyring_list) +
> +			    KEYQUOTA_LINK_BYTES * keep);
> +
> +	if (keep == 0) {
> +		rcu_assign_pointer(keyring->payload.subscriptions, NULL);
> +		kfree(new);
> +	} else {
> +		rcu_assign_pointer(keyring->payload.subscriptions, new);
> +	}
> +
> +	up_write(&keyring->sem);
> +
> +	call_rcu(&klist->rcu, keyring_clear_rcu_disposal);
> +	kleave(" [yes]");
> +	return;
> +
> +discard_new:
> +	new->nkeys = keep;
> +	keyring_clear_rcu_disposal(&new->rcu);
> +just_return:
> +	up_write(&keyring->sem);
> +	kleave(" [no]");
> +}
> diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
> index b611d49..5e05dc0 100644
> --- a/security/keys/sysctl.c
> +++ b/security/keys/sysctl.c
> @@ -13,6 +13,8 @@
>  #include <linux/sysctl.h>
>  #include "internal.h"
> 
> +static const int zero, one = 1, max = INT_MAX;
> +
>  ctl_table key_sysctls[] = {
>  	{
>  		.ctl_name = CTL_UNNUMBERED,
> @@ -20,7 +22,9 @@ ctl_table key_sysctls[] = {
>  		.data = &key_quota_maxkeys,
>  		.maxlen = sizeof(unsigned),
>  		.mode = 0644,
> -		.proc_handler = &proc_dointvec,
> +		.proc_handler = &proc_dointvec_minmax,
> +		.extra1 = (void *) &one,
> +		.extra2 = (void *) &max,
>  	},
>  	{
>  		.ctl_name = CTL_UNNUMBERED,
> @@ -28,7 +32,9 @@ ctl_table key_sysctls[] = {
>  		.data = &key_quota_maxbytes,
>  		.maxlen = sizeof(unsigned),
>  		.mode = 0644,
> -		.proc_handler = &proc_dointvec,
> +		.proc_handler = &proc_dointvec_minmax,
> +		.extra1 = (void *) &one,
> +		.extra2 = (void *) &max,
>  	},
>  	{
>  		.ctl_name = CTL_UNNUMBERED,
> @@ -36,7 +42,9 @@ ctl_table key_sysctls[] = {
>  		.data = &key_quota_root_maxkeys,
>  		.maxlen = sizeof(unsigned),
>  		.mode = 0644,
> -		.proc_handler = &proc_dointvec,
> +		.proc_handler = &proc_dointvec_minmax,
> +		.extra1 = (void *) &one,
> +		.extra2 = (void *) &max,
>  	},
>  	{
>  		.ctl_name = CTL_UNNUMBERED,
> @@ -44,7 +52,19 @@ ctl_table key_sysctls[] = {
>  		.data = &key_quota_root_maxbytes,
>  		.maxlen = sizeof(unsigned),
>  		.mode = 0644,
> -		.proc_handler = &proc_dointvec,
> +		.proc_handler = &proc_dointvec_minmax,
> +		.extra1 = (void *) &one,
> +		.extra2 = (void *) &max,
> +	},
> +	{
> +		.ctl_name = CTL_UNNUMBERED,
> +		.procname = "gc_delay",
> +		.data = &key_gc_delay,

I see where this variable is defined at top of the patch, but
I don't see where it is actually used?

> +		.maxlen = sizeof(unsigned),
> +		.mode = 0644,
> +		.proc_handler = &proc_dointvec_minmax,
> +		.extra1 = (void *) &zero,
> +		.extra2 = (void *) &max,
>  	},
>  	{ .ctl_name = 0 }
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
