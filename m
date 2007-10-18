Return-Path: <linux-kernel-owner+w=401wt.eu-S1764487AbXJRE51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764487AbXJRE51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbXJRE5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:57:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53379 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXJRE5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:57:15 -0400
Date: Thu, 18 Oct 2007 05:57:05 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 8 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071018045705.GM8181@ftp.linux.org.uk>
References: <47158CE4.30706@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47158CE4.30706@schaufler-ca.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 09:17:40PM -0700, Casey Schaufler wrote:

At random:

> +static int smack_netlabel(struct sock *sk)
> +{
> +	static int initialized;
> +	struct socket_smack *ssp = sk->sk_security;
> +	struct netlbl_lsm_secattr secattr;
> +	int rc = 0;
> +
> +	if (!initialized) {
> +		smk_cipso_doi();
> +		initialized = 1;
> +	}

And just what happens if another task calls the same while we are
blocked on allocation in smk_cipso_doi()?

Another problem is your handling of smk_known - you add to head under
mutex; fine.  However, you read without one _and_ have no barriers
in initializing new list entries.

Think what happens if CPU1 adds to list and CPU2 sees write to smk_known
*before* it sees write to ->smk_next.  We see a single-element list and
we'll be lucky if that single entry won't be FUBAR.
