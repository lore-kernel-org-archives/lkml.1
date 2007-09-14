Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbXIOABQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbXIOABQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbXIOABD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:01:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbXIOABA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:01:00 -0400
Date: Fri, 14 Sep 2007 16:59:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, kwc@citi.umich.edu,
       Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org,
       smfrench@gmail.com, nfsv4@linux-nfs.org
Subject: Re: [PATCH] KEYS: Make request_key() and co fundamentally
 asynchronous
Message-Id: <20070914165938.9a429e02.akpm@linux-foundation.org>
In-Reply-To: <20070912142508.19311.45995.stgit@warthog.procyon.org.uk>
References: <20070912142508.19311.45995.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 15:25:08 +0100
David Howells <dhowells@redhat.com> wrote:

> Make request_key() and co fundamentally asynchronous to make it easier for NFS
> to make use of them.  There are now accessor functions that do asynchronous
> constructions, a wait function to wait for construction to complete, and a
> completion function for the key type to indicate completion of construction.
> 
> Note that the construction queue is now gone.  Instead, keys under construction
> are linked in to the appropriate keyring in advance, and that anyone
> encountering one must wait for it to be complete before they can use it.  This
> is done automatically for userspace.
> 
> The following auxiliary changes are also made:
> 
>  (1) Key type implementation stuff is split from linux/key.h into
>      linux/key-type.h.
> 
>  (2) AF_RXRPC provides a way to allocate null rxrpc-type keys so that AFS does
>      not need to call key_instantiate_and_link() directly.
> 
>  (3) Documentation.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  Documentation/keys-request-key.txt |   25 +-
>  Documentation/keys.txt             |   91 +++++-
>  Documentation/networking/rxrpc.txt |    7 
>  fs/afs/cell.c                      |   17 -
>  include/keys/rxrpc-type.h          |    2 
>  include/linux/key-type.h           |  112 +++++++
>  include/linux/key.h                |   99 +-----
>  net/rxrpc/af_rxrpc.c               |    1 
>  net/rxrpc/ar-key.c                 |   31 ++
>  security/keys/internal.h           |   29 +-
>  security/keys/key.c                |   27 +-
>  security/keys/process_keys.c       |   16 +
>  security/keys/request_key.c        |  556 ++++++++++++++++++------------------
>  security/keys/request_key_auth.c   |    9 +
>  14 files changed, 595 insertions(+), 427 deletions(-)

So who's going to review this?  Nobody?  Well gee, maybe it was my turn
anyway.

checkpatch generates a pile of warnings, all of which afacit are legit.

> +#ifdef __KDEBUG
> +#define kenter(FMT, ...) printk("==> %s("FMT")\n",__FUNCTION__ ,##__VA_ARGS__)
> +#define kleave(FMT, ...) printk("<== %s()"FMT"\n",__FUNCTION__ ,##__VA_ARGS__)
> +#define kdebug(FMT, ...) printk(FMT"\n" ,##__VA_ARGS__)
>  #else
> -#define kenter(FMT, a...)	do {} while(0)
> -#define kleave(FMT, a...)	do {} while(0)
> -#define kdebug(FMT, a...)	do {} while(0)
> +#define kenter(FMT, ...) no_printk("==> %s("FMT")\n",__FUNCTION__ ,##__VA_ARGS__)
> +#define kleave(FMT, ...) no_printk("<== %s()"FMT"\n",__FUNCTION__ ,##__VA_ARGS__)
> +#define kdebug(FMT, ...) no_printk(FMT"\n" ,##__VA_ARGS__)
>  #endif

How many different&private versions of this sort of thing do we have?  Sigh.

The debug infrastructure changes don't appear to be related to the intent
of this patch and aren't changelogged.  Not that this matters a lot.

> @@ -901,10 +901,9 @@ void key_revoke(struct key *key)
>  
>  	/* make sure no one's trying to change or use the key when we mark
>  	 * it */
> -	down_write(&key->sem);
> -	set_bit(KEY_FLAG_REVOKED, &key->flags);
> -
> -	if (key->type->revoke)
> +	down_write_nested(&key->sem, 1);

It'd be nice to add a comment explaining to the long-suffering reader why
down_write_nested() is used here.

> @@ -151,6 +152,12 @@ struct key *request_key_auth_new(struct key *target, const char *callout_info)
>  		kleave(" = -ENOMEM");
>  		return ERR_PTR(-ENOMEM);
>  	}
> +	rka->callout_info = kmalloc(strlen(callout_info) + 1, GFP_KERNEL);
> +	if (!rka->callout_info) {
> +		kleave(" = -ENOMEM");
> +		kfree(rka);
> +		return ERR_PTR(-ENOMEM);
> +	}

You could actually use kstrdup() here, I think.

rka->callout_info gets leaked later on (goto auth_key_revoked)

>  	/* see if the calling process is already servicing the key request of
>  	 * another process */
> @@ -179,7 +186,7 @@ struct key *request_key_auth_new(struct key *target, const char *callout_info)
>  	}
>  
>  	rka->target_key = key_get(target);
> -	rka->callout_info = callout_info;
> +	strcpy(rka->callout_info, callout_info);
>  
>  	/* allocate the auth key */
>  	sprintf(desc, "%x", target->serial);

Apart from that the changes look reasonable to me, but I am not a suitable
reviewer for keys, NFS or rxrpc stuff.  Who is??

