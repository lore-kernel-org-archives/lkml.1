Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbXHOOQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbXHOOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbXHOOQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:16:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:49353 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXHOOQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=j0l+sB1KyLcFI2dL3IDAXVvvD7j6VAmu0A3M81hCasooEuBib3qj5gtTOfUPfWBxG5yQal9YeFSrZ61Th5L71SGaLp1xTwtwfJ0ktEpR5pNv0aJbfM4keG2/wXCxEOTkwzfNgTjlukrs6gVn+A9SXfuxk3Bmyzt+ygmisKO6Gtg=
Message-ID: <84144f020708150716j55a0b904v846825cab2ab88eb@mail.gmail.com>
Date: Wed, 15 Aug 2007 17:16:45 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: trenn@suse.de
Subject: Re: [PATCH] (for review and testing first) Implement dynamic allocated array for pnp port/io resources
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Jean Delvare" <khali@linux-fr.org>, abelay@novell.com,
       "Andi Kleen" <ak@suse.de>, linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <1187186605.8780.669.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187186605.8780.669.camel@queen.suse.de>
X-Google-Sender-Auth: b9d84ecd2df4b84a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 8/15/07, Thomas Renninger <trenn@suse.de> wrote:
> +int pnp_port_alloc (struct pnp_resource_table *res)
> +{
> +       int ret = 0, i;
> +       if (res->allocated_ports == 0) {
> +               res->port_resource = kmalloc(sizeof(struct resource)
> +                                                 * PNP_ALLOC_PORTS,
> +                                                 GFP_KERNEL);

No need to use kmalloc() here. It's enough that you make sure
res->port_resource is NULL when res->allocated_ports is zero and
krealloc() will do the right thing.

On 8/15/07, Thomas Renninger <trenn@suse.de> wrote:
> +               if (!res->port_resource) {
> +                       ret = -ENOMEM;
> +                       goto out;
> +               }
> +       } else {
> +               res->port_resource = krealloc(res->port_resource,
> +                                           (sizeof(struct resource)
> +                                            * res->allocated_ports)
> +                                           +
> +                                           (sizeof(struct resource)
> +                                            * PNP_ALLOC_PORTS),
> +                                           GFP_KERNEL);

Assuming res->port_resource is non-NULL here and krealloc() fails,
you've leaked the originally allocated memory.

                                         Pekka
