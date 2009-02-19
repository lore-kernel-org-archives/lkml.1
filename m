Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZBSPZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZBSPZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZBSPYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:24:55 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:32573 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZBSPYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:24:54 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PATCH] SMACK netlabel fixes
Date: Thu, 19 Feb 2009 10:24:50 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27-gentoo-r8; KDE/4.2.0; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <499C5C44.4020902@schaufler-ca.com> <499C7A98.7000907@numericable.fr>
In-Reply-To: <499C7A98.7000907@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191024.50198.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 04:16:08 pm etienne wrote:
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 0278bc0..427595e 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1498,10 +1498,7 @@ static int smack_socket_post_create(struct socket
> *sock, int family, * looks for host based access restrictions
>   *
>   * This version will only be appropriate for really small
> - * sets of single label hosts. Because of the masking
> - * it cannot shortcut out on the first match. There are
> - * numerious ways to address the problem, but none of them
> - * have been applied here.
> + * sets of single label hosts.
>   *
>   * Returns the label of the far end or NULL if it's not special.
>   */
> @@ -1512,41 +1509,22 @@ static char *smack_host_label(struct sockaddr_in
> *sip) struct in_addr *siap = &sip->sin_addr;
>  	struct in_addr *liap;
>  	struct in_addr *miap;
> -	struct in_addr bestmask;
>
>  	if (siap->s_addr == 0)
>  		return NULL;
>
> -	bestmask.s_addr = 0;
> -
>  	for (snp = smack_netlbladdrs; snp != NULL; snp = snp->smk_next) {
>  		liap = &snp->smk_host.sin_addr;
>  		miap = &snp->smk_mask;

Unless I'm mistaken the 'liap' and 'miap' variables are only used once inside 
the for loop, why not remove them and simply reference 'snp' directly?

>  		/*
> -		 * If the addresses match after applying the list entry mask
> -		 * the entry matches the address. If it doesn't move along to
> -		 * the next entry.
> -		 */
> -		if ((liap->s_addr & miap->s_addr) !=
> -		    (siap->s_addr & miap->s_addr))
> -			continue;
> -		/*
> -		 * If the list entry mask identifies a single address
> -		 * it can't get any more specific.
> -		 */
> -		if (miap->s_addr == 0xffffffff)
> -			return snp->smk_label;
> -		/*
> -		 * If the list entry mask is less specific than the best
> -		 * already found this entry is uninteresting.
> +		 * we break after finding the first match because
> +		 * the list is sorted from longest to shortest mask
> +		 * so we have found the most specific match
>  		 */
> -		if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
> -			continue;
> -		/*
> -		 * This is better than any entry found so far.
> -		 */
> -		bestmask.s_addr = miap->s_addr;
> -		bestlabel = snp->smk_label;
> +		if (liap->s_addr  == (siap->s_addr & miap->s_addr)) {
> +			bestlabel = snp->smk_label;
> +			break;

This is being a bit nit-picky, but why not get rid of 'bestlabel' completely 
and instead of breaking here simply reutn 'snp->smk_label'?  If we ever reach 
the end of the function (no match) just return NULL.

> +		}
>  	}
>
>  	return bestlabel;

...

> @@ -663,12 +659,10 @@ static int netlbladdr_seq_show(struct seq_file *s,
> void *v) {
>  	struct smk_netlbladdr *skp = (struct smk_netlbladdr *) v;
>  	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
> -	__be32 bebits;
>  	int maskn = 0;
> +	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
>
> -	for (bebits = BEMASK; bebits != 0; maskn++, bebits <<= 1)
> -		if ((skp->smk_mask.s_addr & bebits) == 0)
> -			break;
> +	for ( ; temp_mask; temp_mask <<= 1, maskn++);

More nit-picky stuff :)  Why not set 'maskn' to zero inside the for loop 
construct instead of at the top of the function?  There is less chance for 
error this way if someone else touches the code.

>  	seq_printf(s, "%u.%u.%u.%u/%d %s\n",
>  		hp[0], hp[1], hp[2], hp[3], maskn, skp->smk_label);

...

> @@ -702,6 +696,40 @@ static int smk_open_netlbladdr(struct inode *inode,
> struct file *file) }
>
>  /**
> + * smk_netlbladdr_insert
> + * @new : netlabel to insert
> + *
> + * This helper insert netlabel in the smack_netlbladdrs list
> + * sorted by netmask length (longest to smallest)
> + */
> +static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
> +{
> +	struct smk_netlbladdr *m;

An empty line here might be nice.

> +	if (smack_netlbladdrs == NULL) {
> +		smack_netlbladdrs = new;
> +		return;
> +	}

I would prefer another one here, if that is okay with you.

> +	/** the comparison '>' is a bit hacky, but works */

Why start the comment with '/**', using a single '*' works just fine.

> +	if (new->smk_mask.s_addr > smack_netlbladdrs->smk_mask.s_addr) {
> +		new->smk_next = smack_netlbladdrs;
> +		smack_netlbladdrs = new;
> +		return;
> +	}
> +	for (m = smack_netlbladdrs; m != NULL; m = m->smk_next) {
> +		if (m->smk_next == NULL) {
> +			m->smk_next = new;
> +			return;
> +		}
> +		if (new->smk_mask.s_addr > m->smk_next->smk_mask.s_addr) {
> +			new->smk_next = m->smk_next;
> +			m->smk_next = new;
> +			return;
> +		}
> +	}

As Casey mentioned earlier (and has been brough up in the past), you should 
heavily consider using the list.h constructs, it would make life much easier 
here and elsewhere.

Bonus points if you convert the other Smack lists to using the list.h bits.

> +}

...

> +/**
>   * smk_write_netlbladdr - write() for /smack/netlabel
>   * @filp: file pointer, not actually used
>   * @buf: where to get the data from
> @@ -724,8 +752,9 @@ static ssize_t smk_write_netlbladdr(struct file *file,
> const char __user *buf, struct netlbl_audit audit_info;
>  	struct in_addr mask;
>  	unsigned int m;
> -	__be32 bebits = BEMASK;
> +	u32 mask_bits = (1<<31);

Why not just enter the value directly here?  It would be much clearer I think.

-- 
paul moore
linux @ hp

