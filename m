Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYFIQZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYFIQZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYFIQZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:25:04 -0400
Received: from ns.suse.de ([195.135.220.2]:33059 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYFIQZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:25:01 -0400
Date: Mon, 9 Jun 2008 18:25:37 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
       anderson@redhat.com
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080609182537.06847134@halley.suse.de>
In-Reply-To: <87bq2bmvro.fsf@saeurebad.de>
References: <20080608134628.757299158@halley.suse.de>
	<20080608134629.743220278@halley.suse.de>
	<87bq2bmvro.fsf@saeurebad.de>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johannes Weiner [2008-06-09 00:01]:
>
> >  		/*
> > @@ -811,11 +812,11 @@ void __init reserve_bootmem_generic(unsi
> >  		 * firmware tables:
> >  		 */
> >  		if (pfn < max_pfn_mapped)
> > -			return;
> > +			return -EFAULT;
> 
> This seemed to be `just do nothing' behaviour.  Wouldn't 0 be more
> correct here?  Or something else so there is a difference between the
> path that does not print a warning (the one below) and the path that
> does?

Well, I don't think that we should return success when memory
allocation fails. For kdump, I think if the memory has not been
reserved, then the function should failed, for whatever reason it
failed. Because we cannot load the crashkernel.

So IMO the code should look like

[...]
	int ret;

	if (pfn >= end_pfn)
		return -EFAULT;

	/* Should check here against the e820 map to avoid double free */
#ifdef CONFIG_NUMA
	nid = phys_to_nid(phys);
[...]


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Maintenance
