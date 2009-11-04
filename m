Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbZKDSU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbZKDSU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbZKDSU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:20:27 -0500
Received: from outbound-mail-12.bluehost.com ([69.89.18.112]:49411 "HELO
	outbound-mail-12.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757692AbZKDSUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:20:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=P8WnvPij5x3Xx9wXx4hL9iW1b6CEs7VrHS8kh17m3/VkAkFra1Q/8IsqOhM9P5udNbHthld1nsl6C4zfEkAGuCgnofaT0Spl1BHMh1zaGAJx+XrxQu0NTFQLhVRY3aaI;
Date: Wed, 4 Nov 2009 10:20:26 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] resources: when allocate_resource() fails, leave
 resource untouched
Message-ID: <20091104102026.5698a9b4@jbarnes-piketon>
In-Reply-To: <20091102174536.12512.56685.stgit@bob.kio>
References: <20091102174536.12512.56685.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Nov 2009 10:45:36 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> When "allocate_resource(root, new, size, ...)" fails, we currently
> clobber "new".  This is inconvenient for the caller, who might care
> about the original contents of the resource.
> 
> For example, when pci_bus_alloc_resource() fails, the "can't allocate
> mem resource %pR" message from pci_assign_resources() currently
> contains junk for the resource start/end.
> 
> This patch delays the "new" update until we're about to return
> success.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
>  kernel/resource.c |   26 ++++++++++++++------------
>  1 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index fb11a58..dc15686 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -308,35 +308,37 @@ static int find_resource(struct resource *root,
> struct resource *new, void *alignf_data)
>  {
>  	struct resource *this = root->child;
> +	resource_size_t start, end;
>  
> -	new->start = root->start;
> +	start = root->start;
>  	/*
>  	 * Skip past an allocated resource that starts at 0, since
> the assignment
>  	 * of this->start - 1 to new->end below would cause an
> underflow. */
>  	if (this && this->start == 0) {
> -		new->start = this->end + 1;
> +		start = this->end + 1;
>  		this = this->sibling;
>  	}
>  	for(;;) {
>  		if (this)
> -			new->end = this->start - 1;
> +			end = this->start - 1;
>  		else
> -			new->end = root->end;
> -		if (new->start < min)
> -			new->start = min;
> -		if (new->end > max)
> -			new->end = max;
> -		new->start = ALIGN(new->start, align);
> +			end = root->end;
> +		if (start < min)
> +			start = min;
> +		if (end > max)
> +			end = max;
> +		start = ALIGN(start, align);
>  		if (alignf)
>  			alignf(alignf_data, new, size, align);
> -		if (new->start < new->end && new->end - new->start
> >= size - 1) {
> -			new->end = new->start + size - 1;
> +		if (start < end && end - start >= size - 1) {
> +			new->start = start;
> +			new->end = start + size - 1;
>  			return 0;
>  		}
>  		if (!this)
>  			break;
> -		new->start = this->end + 1;
> +		start = this->end + 1;
>  		this = this->sibling;
>  	}
>  	return -EBUSY;

Seems like a reasonable change to me.  Linus is usually the gatekeeper
for resource.c.

-- 
Jesse Barnes, Intel Open Source Technology Center
