Return-Path: <linux-kernel-owner+w=401wt.eu-S932955AbZHDPe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbZHDPe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbZHDPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:34:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43186 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934AbZHDPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:34:18 -0400
Date: Tue, 4 Aug 2009 10:17:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/6] KEYS: Allow keyctl_revoke() on keys that have
	SETATTR but not WRITE perm
Message-ID: <20090804151747.GA3698@us.ibm.com>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145535.17676.87650.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804145535.17676.87650.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Allow keyctl_revoke() to operate on keys that have SETATTR but not WRITE
> permission, rather than only on keys that have WRITE permission.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Code seems to match the comment, and I see no docs saying this (SETATTR
implies revoke) shouldn't be the case, so I guess that call is purely
up to you :)

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  security/keys/keyctl.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index b85ace2..1160b64 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -343,7 +343,13 @@ long keyctl_revoke_key(key_serial_t id)
>  	key_ref = lookup_user_key(id, 0, KEY_WRITE);
>  	if (IS_ERR(key_ref)) {
>  		ret = PTR_ERR(key_ref);
> -		goto error;
> +		if (ret != -EACCES)
> +			goto error;
> +		key_ref = lookup_user_key(id, 0, KEY_SETATTR);
> +		if (IS_ERR(key_ref)) {
> +			ret = PTR_ERR(key_ref);
> +			goto error;
> +		}
>  	}
> 
>  	key_revoke(key_ref_to_ptr(key_ref));
