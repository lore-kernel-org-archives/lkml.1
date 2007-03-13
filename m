Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbXCMXH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbXCMXH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXCMXHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:07:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:6288 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXCMXHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qNgMvPU7GHS0uSC8NAUXLTOq2ACBUgb0Tiq/ARziDjeOdYut5oX0TUeh0UmxwZgsIC0w0u8anxjwyEHewMXmHjhHSSPLYq4z5GvIyn7iKO6VsZf4AXfjPcy5RaILf6tTGMi1hA6zD3zeAL69cVhq36EeRvlR2nL9lnc3gvdbilA=
Date: Wed, 14 Mar 2007 02:07:53 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Paulo Marques <pmarques@grupopie.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms race vs module unload
Message-ID: <20070313230753.GB5623@martell.zuzino.mipt.ru>
References: <20070313181815.GA5580@martell.zuzino.mipt.ru> <45F6F24E.4080600@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6F24E.4080600@grupopie.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 06:49:50PM +0000, Paulo Marques wrote:
> Alexey Dobriyan wrote:
> >[...]
> >What happens is that module_get_kallsym() drops module_mutex,
> >returns "struct module *", module unloaded, "struct module *"
> >used.
>
> The only use for the "struct module *" is to display the name of the
> module.

Ehh?

> This can be solved by adding a "char mod_name[MODULE_NAME_LEN];" field
> to "kallsym_iter" and copy the name of the module over, while still
> holding module_mutex. It would be slightly slower, but safer.

	iter->owner = module_get_kallsym(iter->pos - kallsyms_num_syms,
					 &iter->value, &iter->type,
					 iter->name, sizeof(iter->name));
	if (iter->owner == NULL)
		return 0;

	/* Label it "global" if it is exported, "local" if not exported. */
	iter->type = is_exported(iter->name, iter->owner)
					     ^^^^^^^^^^^

