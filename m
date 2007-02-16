Return-Path: <linux-kernel-owner+w=401wt.eu-S1750761AbXBPGxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750761AbXBPGxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXBPGxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:53:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54650 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbXBPGxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:53:36 -0500
Date: Thu, 15 Feb 2007 22:52:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [patch 18/21] Xen-paravirt: Add Xen grant table support
Message-Id: <20070215225229.6b63d050.akpm@linux-foundation.org>
In-Reply-To: <20070216022531.904462260@goop.org>
References: <20070216022449.739760547@goop.org>
	<20070216022531.904462260@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 18:25:07 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> +int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
> +				int readonly)
> +{
> +	int ref;
> +
> +	if (unlikely((ref = get_free_entry()) == -1))
> +		return -ENOSPC;
> +
> +	shared[ref].frame = frame;
> +	shared[ref].domid = domid;
> +	wmb();
> +	shared[ref].flags = GTF_permit_access | (readonly ? GTF_readonly : 0);
> +
> +	return ref;
> +}
> +EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);

We have lots of open-coded mysteriously unexplained barriers in here.

I assume they're not smp_wmb() because this could be a !SMP guest talking
to an SMP host?
