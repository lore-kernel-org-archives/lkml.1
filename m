Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYJHPgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYJHPgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 11:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYJHPfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 11:35:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51653 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbYJHPfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:35:53 -0400
Subject: Re: [RFC v6][PATCH 5/9] Restore memory address space
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1223461197-11513-6-git-send-email-orenl@cs.columbia.edu>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>
	 <1223461197-11513-6-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 08:35:45 -0700
Message-Id: <1223480145.11830.3.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 06:19 -0400, Oren Laadan wrote:
> 
> +static int cr_read_private_vma_contents(struct cr_ctx *ctx)
> +{
> +       struct cr_hdr_pgarr *hh;
> +       unsigned long nr_pages;
> +       int parent, ret = 0;
> +
> +       while (1) {
> +               hh = cr_hbuf_get(ctx, sizeof(*hh));
> +               parent = cr_read_obj_type(ctx, hh, sizeof(*hh), CR_HDR_PGARR);
> +               if (parent != 0) {
> +                       if (parent < 0)
> +                               ret = parent;
> +                       else
> +                               ret = -EINVAL;
> +                       cr_hbuf_put(ctx, sizeof(*hh));
> +                       break;
> +               }
> +
> +               cr_debug("nr_pages %ld\n", (unsigned long) hh->nr_pages);
> +
> +               nr_pages = hh->nr_pages;
> +               cr_hbuf_put(ctx, sizeof(*hh));
> +
> +               if (!nr_pages)
> +                       break;
> +
> +               ret = cr_read_pages_vaddrs(ctx, nr_pages);
> +               if (ret < 0)
> +                       break;
> +               ret = cr_read_pages_contents(ctx);
> +               if (ret < 0)
> +                       break;
> +               cr_pgarr_reset_all(ctx);
> +       }
> +
> +       return ret;
> +}

This basically just uses a while(1) loop with 'break' instead of an
'out_err:' label and some gotos.  That's kinda odd for the kernel.  

-- Dave

