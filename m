Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZCDQb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZCDQb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZCDQbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:31:49 -0500
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:45781 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751994AbZCDQbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:31:48 -0500
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49AEACE0.7030706@schaufler-ca.com>
Date: Wed, 04 Mar 2009 08:31:28 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: etienne <etienne.basset@numericable.fr>
CC: LSM <linux-security-module@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [patch][smack][2.6.29-rc] fixes for unlabeled host support
References: <49AE20CF.1030601@numericable.fr>
In-Reply-To: <49AE20CF.1030601@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> Hello,
>
> The following patch (against 2.6.29rc5) fixes a few issues in the smack/netlabel 
> "unlabeled host support" functionnality that was added in 2.6.29rc.
> It should go in before -final.
>
>
> 1) smack_host_label disregard a "0.0.0.0/0 @" rule (or other label), preventing 'tagged' tasks to access Internet (many systems drop packets with IP options)
> 2) netmasks were not handled correctly, they were stored in a way _not equivalent_  to conversion to be32 (it was equivalent for /0, /8, /16, /24, /32 masks but not other masks)
> 3) smack_netlbladdr prefixes (IP/mask) were not consistent (mask&IP was not done), so there could have been different list entries for the same IP prefix; if those entries had different labels, well ... 
> 4) they were not sorted 
>
> 1) 2) 3) are bugs, 4) is a more cosmetic issue.
> The patch :
> -creates a new helper smk_netlbladdr_insert to insert a smk_netlbladdr, sorted by netmask length
> -use the new sorted nature of  smack_netlbladdrs list to simplify smack_host_label : 
>  the first match _will_ be the more specific
> -corrects endianness issues in smk_write_netlbladdr &  netlbladdr_seq_show
>
>
> regards,
> Etienne Basset
>
> Signed-off-by: <etienne.basset@numericable.fr>
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>
>
> security/smack/smack_lsm.c |   43 +++++------------------------
>  security/smack/smackfs.c   |   64 +++++++++++++++++++++++++++++++++----------
>  2 files changed, 57 insertions(+), 50 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 0278bc0..e7ded13 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1498,58 +1498,31 @@ static int smack_socket_post_create(struct socket *sock, int family,
>   * looks for host based access restrictions
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
>  static char *smack_host_label(struct sockaddr_in *sip)
>  {
>  	struct smk_netlbladdr *snp;
> -	char *bestlabel = NULL;
>  	struct in_addr *siap = &sip->sin_addr;
> -	struct in_addr *liap;
> -	struct in_addr *miap;
> -	struct in_addr bestmask;
>  
>  	if (siap->s_addr == 0)
>  		return NULL;
>  
> -	bestmask.s_addr = 0;
> -
>  	for (snp = smack_netlbladdrs; snp != NULL; snp = snp->smk_next) {
> -		liap = &snp->smk_host.sin_addr;
> -		miap = &snp->smk_mask;
> -		/*
> -		 * If the addresses match after applying the list entry mask
> -		 * the entry matches the address. If it doesn't move along to
> -		 * the next entry.
> -		 */
> -		if ((liap->s_addr & miap->s_addr) !=
> -		    (siap->s_addr & miap->s_addr))
> -			continue;
>  		/*
> -		 * If the list entry mask identifies a single address
> -		 * it can't get any more specific.
> +		 * we break after finding the first match because
> +		 * the list is sorted from longest to shortest mask
> +		 * so we have found the most specific match
>  		 */
> -		if (miap->s_addr == 0xffffffff)
> +		if ((&snp->smk_host.sin_addr)->s_addr  ==
> +			(siap->s_addr & (&snp->smk_mask)->s_addr)) {
>  			return snp->smk_label;
> -		/*
> -		 * If the list entry mask is less specific than the best
> -		 * already found this entry is uninteresting.
> -		 */
> -		if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
> -			continue;
> -		/*
> -		 * This is better than any entry found so far.
> -		 */
> -		bestmask.s_addr = miap->s_addr;
> -		bestlabel = snp->smk_label;
> +		}
>  	}
>  
> -	return bestlabel;
> +	return NULL;
>  }
>  
>  /**
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 8e42800..51f0efc 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -650,10 +650,6 @@ static void *netlbladdr_seq_next(struct seq_file *s, void *v, loff_t *pos)
>  
>  	return skp;
>  }
> -/*
> -#define BEMASK	0x80000000
> -*/
> -#define BEMASK	0x00000001
>  #define BEBITS	(sizeof(__be32) * 8)
>  
>  /*
> @@ -663,12 +659,10 @@ static int netlbladdr_seq_show(struct seq_file *s, void *v)
>  {
>  	struct smk_netlbladdr *skp = (struct smk_netlbladdr *) v;
>  	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
> -	__be32 bebits;
> -	int maskn = 0;
> +	int maskn;
> +	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
>  
> -	for (bebits = BEMASK; bebits != 0; maskn++, bebits <<= 1)
> -		if ((skp->smk_mask.s_addr & bebits) == 0)
> -			break;
> +	for (maskn = 0; temp_mask; temp_mask <<= 1, maskn++);
>  
>  	seq_printf(s, "%u.%u.%u.%u/%d %s\n",
>  		hp[0], hp[1], hp[2], hp[3], maskn, skp->smk_label);
> @@ -702,6 +696,42 @@ static int smk_open_netlbladdr(struct inode *inode, struct file *file)
>  }
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
> +
> +	if (smack_netlbladdrs == NULL) {
> +		smack_netlbladdrs = new;
> +		return;
> +	}
> +
> +	/* the comparison '>' is a bit hacky, but works */
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
> +}
> +
> +
> +/**
>   * smk_write_netlbladdr - write() for /smack/netlabel
>   * @filp: file pointer, not actually used
>   * @buf: where to get the data from
> @@ -724,8 +754,9 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
>  	struct netlbl_audit audit_info;
>  	struct in_addr mask;
>  	unsigned int m;
> -	__be32 bebits = BEMASK;
> +	u32 mask_bits = (1<<31);
>  	__be32 nsa;
> +	u32 temp_mask;
>  
>  	/*
>  	 * Must have privilege.
> @@ -761,10 +792,13 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
>  	if (sp == NULL)
>  		return -EINVAL;
>  
> -	for (mask.s_addr = 0; m > 0; m--) {
> -		mask.s_addr |= bebits;
> -		bebits <<= 1;
> +	for (temp_mask = 0; m > 0; m--) {
> +		temp_mask |= mask_bits;
> +		mask_bits >>= 1;
>  	}
> +	mask.s_addr = cpu_to_be32(temp_mask);
> +
> +	newname.sin_addr.s_addr &= mask.s_addr;
>  	/*
>  	 * Only allow one writer at a time. Writes should be
>  	 * quite rare and small in any case.
> @@ -772,6 +806,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
>  	mutex_lock(&smk_netlbladdr_lock);
>  
>  	nsa = newname.sin_addr.s_addr;
> +	/* try to find if the prefix is already in the list */
>  	for (skp = smack_netlbladdrs; skp != NULL; skp = skp->smk_next)
>  		if (skp->smk_host.sin_addr.s_addr == nsa &&
>  		    skp->smk_mask.s_addr == mask.s_addr)
> @@ -787,9 +822,8 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
>  			rc = 0;
>  			skp->smk_host.sin_addr.s_addr = newname.sin_addr.s_addr;
>  			skp->smk_mask.s_addr = mask.s_addr;
> -			skp->smk_next = smack_netlbladdrs;
>  			skp->smk_label = sp;
> -			smack_netlbladdrs = skp;
> +			smk_netlbladdr_insert(skp);
>  		}
>  	} else {
>  		rc = netlbl_cfg_unlbl_static_del(&init_net, NULL,
>
>
>   

