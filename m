Return-Path: <linux-kernel-owner+w=401wt.eu-S2992458AbXDLK0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992458AbXDLK0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992457AbXDLK0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:26:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40892 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992440AbXDLK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:26:21 -0400
Date: Thu, 12 Apr 2007 11:28:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       John Johansen <jjohansen@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 39/41] AppArmor: Profile loading and manipulation,
 pathname matching
Message-ID: <20070412112852.49819a73@the-village.bc.nu>
In-Reply-To: <20070412090849.465428000@suse.de>
References: <20070412090809.917795000@suse.de>
	<20070412090849.465428000@suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	th.td_id = ntohs(*(u16 *) (blob));
> +	th.td_flags = ntohs(*(u16 *) (blob + 2));
> +	th.td_lolen = ntohl(*(u32 *) (blob + 8));

Use cpu_to and _to_cpu functions for here so it is clear the intended
direction and endianness.

> +
> +static inline int aa_inbounds(struct aa_ext *e, size_t size)
> +{
> +	return (e->pos + size <= e->end);
> +}

Can e->pos + size ever overflow. If so this check isn't safe.


> + * aa_unpack_profile - unpack a serialized profile
> + * @e: serialized data extent information
> + * @error: error code returned if unpacking fails
> + */
> +static struct aa_profile *aa_unpack_profile(struct aa_ext *e)
> +{
> +	struct aa_profile *profile = NULL;
> +

> +	/* get optional subprofiles */
> +	if (aa_is_nameX(e, AA_LIST, "hats")) {
> +		while (!aa_is_nameX(e, AA_LISTEND, NULL)) {
> +			struct aa_profile *subprofile;
> +			subprofile = aa_unpack_profile(e);
> +			if (IS_ERR(subprofile)) {

What bounds recursion here on invalid input ?

