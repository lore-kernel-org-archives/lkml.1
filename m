Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbZHDSQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbZHDSQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933031AbZHDSQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:16:21 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48504 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025AbZHDSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:16:20 -0400
Date: Tue, 4 Aug 2009 13:16:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/6] KEYS: Deal with dead-type keys appropriately
Message-ID: <20090804181602.GA8442@us.ibm.com>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Allow keys for which the key type has been removed to be unlinked.  Currently
> dead-type keys can only be disposed of by completely clearing the keyrings
> that point to them.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

This also makes for a nice readability improvement.  Would be even nicer
to add a

#define KEY_LOOKUP_FLAGS_NONE 0

and pass that in instead of 0 at the callers doing so.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
> 
>  security/keys/internal.h     |    5 +++-
>  security/keys/key.c          |    6 ++---
>  security/keys/keyctl.c       |   50 ++++++++++++++++++++++++------------------
>  security/keys/process_keys.c |   18 +++++++++++----
>  4 files changed, 48 insertions(+), 31 deletions(-)
> 
> 
> diff --git a/security/keys/internal.h b/security/keys/internal.h
> index 9fb679c..a7252e7 100644
> --- a/security/keys/internal.h
> +++ b/security/keys/internal.h
> @@ -124,8 +124,11 @@ extern struct key *request_key_and_link(struct key_type *type,
>  					struct key *dest_keyring,
>  					unsigned long flags);
> 
> -extern key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
> +extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
>  				 key_perm_t perm);
> +#define KEY_LOOKUP_CREATE	0x01
> +#define KEY_LOOKUP_PARTIAL	0x02
> +#define KEY_LOOKUP_FOR_UNLINK	0x04
> 
>  extern long join_session_keyring(const char *name);
> 
> diff --git a/security/keys/key.c b/security/keys/key.c
> index 4a1297d..3762d5b 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -642,10 +642,8 @@ struct key *key_lookup(key_serial_t id)
>  	goto error;
> 
>   found:
> -	/* pretend it doesn't exist if it's dead */
> -	if (atomic_read(&key->usage) == 0 ||
> -	    test_bit(KEY_FLAG_DEAD, &key->flags) ||
> -	    key->type == &key_type_dead)
> +	/* pretend it doesn't exist if it is awaiting deletion */
> +	if (atomic_read(&key->usage) == 0)
>  		goto not_found;
> 
>  	/* this races with key_put(), but that doesn't matter since key_put()
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index 7f09fb8..b85ace2 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -103,7 +103,7 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
>  	}
> 
>  	/* find the target keyring (which must be writable) */
> -	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
> +	keyring_ref = lookup_user_key(ringid, KEY_LOOKUP_CREATE, KEY_WRITE);
>  	if (IS_ERR(keyring_ref)) {
>  		ret = PTR_ERR(keyring_ref);
>  		goto error3;
> @@ -185,7 +185,8 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
>  	/* get the destination keyring if specified */
>  	dest_ref = NULL;
>  	if (destringid) {
> -		dest_ref = lookup_user_key(destringid, 1, 0, KEY_WRITE);
> +		dest_ref = lookup_user_key(destringid, KEY_LOOKUP_CREATE,
> +					   KEY_WRITE);
>  		if (IS_ERR(dest_ref)) {
>  			ret = PTR_ERR(dest_ref);
>  			goto error3;
> @@ -233,9 +234,11 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
>  long keyctl_get_keyring_ID(key_serial_t id, int create)
>  {
>  	key_ref_t key_ref;
> +	unsigned long lflags;
>  	long ret;
> 
> -	key_ref = lookup_user_key(id, create, 0, KEY_SEARCH);
> +	lflags = create ? KEY_LOOKUP_CREATE : 0;
> +	key_ref = lookup_user_key(id, lflags, KEY_SEARCH);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
>  		goto error;
> @@ -309,7 +312,7 @@ long keyctl_update_key(key_serial_t id,
>  	}
> 
>  	/* find the target key (which must be writable) */
> -	key_ref = lookup_user_key(id, 0, 0, KEY_WRITE);
> +	key_ref = lookup_user_key(id, 0, KEY_WRITE);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
>  		goto error2;
> @@ -337,7 +340,7 @@ long keyctl_revoke_key(key_serial_t id)
>  	key_ref_t key_ref;
>  	long ret;
> 
> -	key_ref = lookup_user_key(id, 0, 0, KEY_WRITE);
> +	key_ref = lookup_user_key(id, 0, KEY_WRITE);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
>  		goto error;
> @@ -363,7 +366,7 @@ long keyctl_keyring_clear(key_serial_t ringid)
>  	key_ref_t keyring_ref;
>  	long ret;
> 
> -	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
> +	keyring_ref = lookup_user_key(ringid, KEY_LOOKUP_CREATE, KEY_WRITE);
>  	if (IS_ERR(keyring_ref)) {
>  		ret = PTR_ERR(keyring_ref);
>  		goto error;
> @@ -389,13 +392,13 @@ long keyctl_keyring_link(key_serial_t id, key_serial_t ringid)
>  	key_ref_t keyring_ref, key_ref;
>  	long ret;
> 
> -	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
> +	keyring_ref = lookup_user_key(ringid, KEY_LOOKUP_CREATE, KEY_WRITE);
>  	if (IS_ERR(keyring_ref)) {
>  		ret = PTR_ERR(keyring_ref);
>  		goto error;
>  	}
> 
> -	key_ref = lookup_user_key(id, 1, 0, KEY_LINK);
> +	key_ref = lookup_user_key(id, KEY_LOOKUP_CREATE, KEY_LINK);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
>  		goto error2;
> @@ -423,13 +426,13 @@ long keyctl_keyring_unlink(key_serial_t id, key_serial_t ringid)
>  	key_ref_t keyring_ref, key_ref;
>  	long ret;
> 
> -	keyring_ref = lookup_user_key(ringid, 0, 0, KEY_WRITE);
> +	keyring_ref = lookup_user_key(ringid, 0, KEY_WRITE);
>  	if (IS_ERR(keyring_ref)) {
>  		ret = PTR_ERR(keyring_ref);
>  		goto error;
>  	}
> 
> -	key_ref = lookup_user_key(id, 0, 0, 0);
> +	key_ref = lookup_user_key(id, KEY_LOOKUP_FOR_UNLINK, 0);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
>  		goto error2;
> @@ -465,7 +468,7 @@ long keyctl_describe_key(key_serial_t keyid,
>  	char *tmpbuf;
>  	long ret;
> 
> -	key_ref = lookup_user_key(keyid, 0, 1, KEY_VIEW);
> +	key_ref = lookup_user_key(keyid, KEY_LOOKUP_PARTIAL, KEY_VIEW);
>  	if (IS_ERR(key_ref)) {
>  		/* viewing a key under construction is permitted if we have the
>  		 * authorisation token handy */
> @@ -474,7 +477,8 @@ long keyctl_describe_key(key_serial_t keyid,
>  			if (!IS_ERR(instkey)) {
>  				key_put(instkey);
>  				key_ref = lookup_user_key(keyid,
> -							  0, 1, 0);
> +							  KEY_LOOKUP_PARTIAL,
> +							  0);
>  				if (!IS_ERR(key_ref))
>  					goto okay;
>  			}
> @@ -558,7 +562,7 @@ long keyctl_keyring_search(key_serial_t ringid,
>  	}
> 
>  	/* get the keyring at which to begin the search */
> -	keyring_ref = lookup_user_key(ringid, 0, 0, KEY_SEARCH);
> +	keyring_ref = lookup_user_key(ringid, 0, KEY_SEARCH);
>  	if (IS_ERR(keyring_ref)) {
>  		ret = PTR_ERR(keyring_ref);
>  		goto error2;
> @@ -567,7 +571,8 @@ long keyctl_keyring_search(key_serial_t ringid,
>  	/* get the destination keyring if specified */
>  	dest_ref = NULL;
>  	if (destringid) {
> -		dest_ref = lookup_user_key(destringid, 1, 0, KEY_WRITE);
> +		dest_ref = lookup_user_key(destringid, KEY_LOOKUP_CREATE,
> +					   KEY_WRITE);
>  		if (IS_ERR(dest_ref)) {
>  			ret = PTR_ERR(dest_ref);
>  			goto error3;
> @@ -637,7 +642,7 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
>  	long ret;
> 
>  	/* find the key first */
> -	key_ref = lookup_user_key(keyid, 0, 0, 0);
> +	key_ref = lookup_user_key(keyid, 0, 0);
>  	if (IS_ERR(key_ref)) {
>  		ret = -ENOKEY;
>  		goto error;
> @@ -700,7 +705,8 @@ long keyctl_chown_key(key_serial_t id, uid_t uid, gid_t gid)
>  	if (uid == (uid_t) -1 && gid == (gid_t) -1)
>  		goto error;
> 
> -	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
> +	key_ref = lookup_user_key(id, KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL,
> +				  KEY_SETATTR);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
>  		goto error;
> @@ -805,7 +811,8 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
>  	if (perm & ~(KEY_POS_ALL | KEY_USR_ALL | KEY_GRP_ALL | KEY_OTH_ALL))
>  		goto error;
> 
> -	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
> +	key_ref = lookup_user_key(id, KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL,
> +				  KEY_SETATTR);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
>  		goto error;
> @@ -847,7 +854,7 @@ static long get_instantiation_keyring(key_serial_t ringid,
> 
>  	/* if a specific keyring is nominated by ID, then use that */
>  	if (ringid > 0) {
> -		dkref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
> +		dkref = lookup_user_key(ringid, KEY_LOOKUP_CREATE, KEY_WRITE);
>  		if (IS_ERR(dkref))
>  			return PTR_ERR(dkref);
>  		*_dest_keyring = key_ref_to_ptr(dkref);
> @@ -1083,7 +1090,8 @@ long keyctl_set_timeout(key_serial_t id, unsigned timeout)
>  	time_t expiry;
>  	long ret;
> 
> -	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
> +	key_ref = lookup_user_key(id, KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL,
> +				  KEY_SETATTR);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
>  		goto error;
> @@ -1170,7 +1178,7 @@ long keyctl_get_security(key_serial_t keyid,
>  	char *context;
>  	long ret;
> 
> -	key_ref = lookup_user_key(keyid, 0, 1, KEY_VIEW);
> +	key_ref = lookup_user_key(keyid, KEY_LOOKUP_PARTIAL, KEY_VIEW);
>  	if (IS_ERR(key_ref)) {
>  		if (PTR_ERR(key_ref) != -EACCES)
>  			return PTR_ERR(key_ref);
> @@ -1182,7 +1190,7 @@ long keyctl_get_security(key_serial_t keyid,
>  			return PTR_ERR(key_ref);
>  		key_put(instkey);
> 
> -		key_ref = lookup_user_key(keyid, 0, 1, 0);
> +		key_ref = lookup_user_key(keyid, KEY_LOOKUP_PARTIAL, 0);
>  		if (IS_ERR(key_ref))
>  			return PTR_ERR(key_ref);
>  	}
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index 276d278..349c315 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -487,7 +487,7 @@ static int lookup_user_key_possessed(const struct key *key, const void *target)
>   * - don't create special keyrings unless so requested
>   * - partially constructed keys aren't found unless requested
>   */
> -key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
> +key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
>  			  key_perm_t perm)
>  {
>  	struct request_key_auth *rka;
> @@ -503,7 +503,7 @@ try_again:
>  	switch (id) {
>  	case KEY_SPEC_THREAD_KEYRING:
>  		if (!cred->thread_keyring) {
> -			if (!create)
> +			if (!(lflags & KEY_LOOKUP_CREATE))
>  				goto error;
> 
>  			ret = install_thread_keyring();
> @@ -521,7 +521,7 @@ try_again:
> 
>  	case KEY_SPEC_PROCESS_KEYRING:
>  		if (!cred->tgcred->process_keyring) {
> -			if (!create)
> +			if (!(lflags & KEY_LOOKUP_CREATE))
>  				goto error;
> 
>  			ret = install_process_keyring();
> @@ -642,7 +642,14 @@ try_again:
>  		break;
>  	}
> 
> -	if (!partial) {
> +	/* unlink does not use the nominated key in any way, so can skip all
> +	 * the permission checks as it is only concerned with the keyring */
> +	if (lflags & KEY_LOOKUP_FOR_UNLINK) {
> +		ret = 0;
> +		goto error;
> +	}
> +
> +	if (!(lflags & KEY_LOOKUP_PARTIAL)) {
>  		ret = wait_for_key_construction(key, true);
>  		switch (ret) {
>  		case -ERESTARTSYS:
> @@ -660,7 +667,8 @@ try_again:
>  	}
> 
>  	ret = -EIO;
> -	if (!partial && !test_bit(KEY_FLAG_INSTANTIATED, &key->flags))
> +	if (!(lflags & KEY_LOOKUP_PARTIAL) &&
> +	    !test_bit(KEY_FLAG_INSTANTIATED, &key->flags))
>  		goto invalid_key;
> 
>  	/* check the permissions */
