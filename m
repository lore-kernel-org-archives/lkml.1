Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbXJZUhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbXJZUhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXJZUhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:37:47 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:59297 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752554AbXJZUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:37:45 -0400
Subject: Re: [PATCH 2/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory
	Access Control Kernel
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4720118C.5020906@schaufler-ca.com>
References: <4720118C.5020906@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 26 Oct 2007 16:34:27 -0400
Message-Id: <1193430867.11953.200.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 20:46 -0700, Casey Schaufler wrote:
> diff -uprN -X linux-2.6.24-rc1-base/Documentation/dontdiff linux-2.6.24-rc1-base/security/smack/smack_lsm.c linux-2.6.24-rc1-smack/security/smack/smack_lsm.c
> --- linux-2.6.24-rc1-base/security/smack/smack_lsm.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.24-rc1-smack/security/smack/smack_lsm.c	2007-10-23 16:45:06.000000000 -0700
<snip>
> +/**
> + * smack_inode_getsecurity - get smack xattrs
> + * @inode: the object
> + * @name: attribute name
> + * @buffer: where to put the result
> + * @size: size of the buffer
> + * @err: unused
> + *
> + * Returns the size of the attribute or an error code
> + */
> +static int smack_inode_getsecurity(const struct inode *inode,
> +				   const char *name, void *buffer,
> +				   size_t size, int err)
> +{
> +	struct socket_smack *ssp;
> +	struct socket *sock;
> +	struct super_block *sbp;
> +	struct inode *ip = (struct inode *)inode;
> +	char *bsp = buffer;
> +	char *isp;
> +
> +	if (size < SMK_LABELLEN || name == NULL || bsp == NULL ||
> +	    inode == NULL || inode->i_security == NULL)
> +		return 0;
> +
> +	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
> +		isp = smk_of_inode(inode);
> +		strncpy(buffer, isp, SMK_LABELLEN);
> +		return strlen(isp) + 1;
> +	}
> +
> +	/*
> +	 * The rest of the Smack xattrs are only on sockets.
> +	 */
> +	sbp = ip->i_sb;
> +	if (sbp->s_magic != SOCKFS_MAGIC)
> +		return -EOPNOTSUPP;
> +
> +	sock = SOCKET_I(ip);
> +	if (sock == NULL)
> +		return -EOPNOTSUPP;
> +
> +	ssp = sock->sk->sk_security;
> +
> +	/*
> +	 * Should the packet attribute be unavailable return the error.
> +	 * This can happen if packets come in too fast.
> +	 */
> +	if (strcmp(name, XATTR_SMACK_PACKET) == 0) {
> +		if (ssp->smk_packet[0] == '\0')
> +			return -ENODATA;
> +		isp = ssp->smk_packet;

Wrong strategy, racy.  Use getpeersec hooks, SO_PEERSEC for stream or
SCM_SECURITY for datagram.  They aren't just for labeled IPSEC - they
work fine for NetLabel too, see SELinux for an example.

> +	} else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
> +		isp = ssp->smk_in;
> +	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
> +		isp = ssp->smk_out;
> +	else
> +		return -EOPNOTSUPP;
> +
> +	strncpy(buffer, isp, SMK_LABELLEN);
> +	return strlen(isp) + 1;
> +}
> +
<snip>
> +static int smack_socket_recvmsg(struct socket *sock, struct msghdr *msg,
> +				int size, int flags)
> +{
> +	struct socket_smack *ssp = sock->sk->sk_security;
> +
> +	/*
> +	 * If the depth is 0 no packets are queued.
> +	 * If the depth is > 1 the "current" has been overwritten.
> +	 */
> +
> +	if (ssp->smk_depth != 1)
> +		ssp->smk_packet[0] = '\0';
> +	if (ssp->smk_depth != 0)
> +		ssp->smk_depth--;
> +
> +	return 0;
> +}

Same deal, use SCM_SECURITY and the getpeersec_dgram hook to do this in
a race-free way.

> +
> +/**
> + * smack_socket_sock_rcv_skb - Smack packet delivery access check
> + * @sk: socket
> + * @skb: packet
> + *
> + * Returns 0 if the packet should be delivered, an error code otherwise
> + */
> +static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct netlbl_lsm_secattr secattr;
> +	struct socket_smack *ssp = sk->sk_security;
> +	char smack[SMK_LABELLEN];
> +	int rc;
> +
> +	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
> +		return 0;
> +
> +	/*
> +	 * Translate what netlabel gave us.
> +	 */
> +	memset(smack, '\0', SMK_LABELLEN);
> +	netlbl_secattr_init(&secattr);
> +	rc = netlbl_skbuff_getattr(skb, &secattr);
> +	if (rc == 0)
> +		smack_from_secattr(&secattr, smack);
> +	else
> +		strncpy(smack, smack_net_ambient, SMK_MAXLEN);
> +	netlbl_secattr_destroy(&secattr);
> +	/*
> +	 * Receiving a packet requires that the other end
> +	 * be able to write here. Read access is not required.
> +	 * This is the simplist possible security model
> +	 * for networking.
> +	 */
> +	rc = smk_access(smack, ssp->smk_in, MAY_WRITE);
> +	if (rc != 0)
> +		return rc;
> +
> +	/*
> +	 * If recv was called and there were no outstanding packets
> +	 * this is the "current" Smack value to make available.
> +	 */
> +	if (ssp->smk_depth == 0)
> +		strcpy(ssp->smk_packet, smack);
> +	ssp->smk_depth++;

Ditto.

> +
> +	return 0;
> +}
> +

-- 
Stephen Smalley
National Security Agency

