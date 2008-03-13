Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYCMWbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYCMWbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbYCMW3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757662AbYCMW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:34 -0400
Date: Thu, 13 Mar 2008 15:28:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, kwc@citi.umich.edu, arunsr@cse.iitk.ac.in,
       dwalsh@redhat.com, linux-security-module@vger.kernel.org,
       dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KEYS: Make the keyring quotas controllable through
 /proc/sys
Message-Id: <20080313152850.c76ab240.akpm@linux-foundation.org>
In-Reply-To: <20080313191442.28959.28152.stgit@warthog.procyon.org.uk>
References: <20080313191432.28959.52722.stgit@warthog.procyon.org.uk>
	<20080313191442.28959.28152.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 19:14:42 +0000
David Howells <dhowells@redhat.com> wrote:

> Make the keyring quotas controllable through /proc/sys files:
> 
>  (*) /proc/sys/kernel/keys/root_maxkeys
>      /proc/sys/kernel/keys/root_maxbytes
> 
>      Maximum number of keys that root may have and the maximum total number of
>      bytes of data that root may have stored in those keys.
> 
>  (*) /proc/sys/kernel/keys/maxkeys
>      /proc/sys/kernel/keys/maxbytes
> 
>      Maximum number of keys that each non-root user may have and the maximum
>      total number of bytes of data that each of those users may have stored in
>      their keys.
> 
> Also increase the quotas as a number of people have been complaining that it's
> not big enough.  I'm not sure that it's big enough now either, but on the
> other hand, it can now be set in /etc/sysctl.conf.
> 
> ...
>
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -19,6 +19,7 @@
>  #include <linux/list.h>
>  #include <linux/rbtree.h>
>  #include <linux/rcupdate.h>
> +#include <linux/sysctl.h>
>  #include <asm/atomic.h>
>  
>  #ifdef __KERNEL__
> @@ -265,6 +266,10 @@ extern struct key *key_lookup(key_serial_t id);
>  
>  #define key_serial(key) ((key) ? (key)->serial : 0)

err, why was that a macro?  It could have been implemented as an inline. 
One which doesn't evaluate its argument twice (or once if it was -1).
 
> +#ifdef CONFIG_SYSCTL
> +extern ctl_table key_sysctls[];
> +#endif

I've been going around telling people to not bother with the ifdefs here. 
Upside: looks nicer.  Downside: defers the build error from compile-time to
link-time.

>  
> +/*
> + * key quota limits
> + * - root has its own separate limits to everyone else
> + */
> +extern unsigned key_quota_root_maxkeys;
> +extern unsigned key_quota_root_maxbytes;
> +extern unsigned key_quota_maxkeys;
> +extern unsigned key_quota_maxbytes;
> +
> +#define KEYQUOTA_LINK_BYTES	4		/* a link in a keyring is worth 4 bytes */
>  
>  
>  extern struct rb_root key_serial_tree;
> diff --git a/security/keys/key.c b/security/keys/key.c
> index 46f125a..14948cf 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -27,6 +27,11 @@ DEFINE_SPINLOCK(key_serial_lock);
>  struct rb_root	key_user_tree; /* tree of quota records indexed by UID */
>  DEFINE_SPINLOCK(key_user_lock);
>  
> +unsigned int key_quota_root_maxkeys = 200;	/* root's key count quota */
> +unsigned int key_quota_root_maxbytes = 20000;	/* root's key space quota */
> +unsigned int key_quota_maxkeys = 200;		/* general key count quota */
> +unsigned int key_quota_maxbytes = 20000;	/* general key space quota */
> +
>  static LIST_HEAD(key_types_list);
>  static DECLARE_RWSEM(key_types_sem);
>  
> @@ -236,11 +241,16 @@ struct key *key_alloc(struct key_type *type, const char *desc,
>  	/* check that the user's quota permits allocation of another key and
>  	 * its description */
>  	if (!(flags & KEY_ALLOC_NOT_IN_QUOTA)) {
> +		unsigned maxkeys = (uid == 0) ?
> +			key_quota_root_maxkeys : key_quota_maxkeys;
> +		unsigned maxbytes = (uid == 0) ?
> +			key_quota_root_maxbytes : key_quota_maxbytes;

open-coded knowledge of uid==0 might be problematic for containerisation. 
Maybe it's on the containers team's radar, maybe it's actually not a
problem, don't know.  (adds cc).


