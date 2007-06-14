Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXFNU7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXFNU7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFNU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:59:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57951 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXFNU7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:59:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=T+H0+/iWgHQEmHJtsIsG2zIBe4cDHP0UWInB1xji69BR9p6vAAOhmQhFxf4rnMqJa
	wIyFM7f/txmI9caETPKCw==
Message-ID: <65dd6fd50706141358i39bba32aq139766c8a1a3de2b@mail.gmail.com>
Date: Thu, 14 Jun 2007 13:58:58 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/3] no MAX_ARG_PAGES -v2
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>
In-Reply-To: <1181810319.7348.345.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070613100334.635756997@chello.nl>
	 <617E1C2C70743745A92448908E030B2A01AF860A@scsmsx411.amr.corp.intel.com>
	 <65dd6fd50706132323i9c760f4m6e23687914d0c46e@mail.gmail.com>
	 <1181810319.7348.345.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1385,6 +1401,10 @@ int do_execve(char * filename,
>                 goto out;
>         bprm->argv_len = env_p - bprm->p;
>
> +       retval = expand_arg_vma(bprm);
> +       if (retval < 0)
> +               goto out;
> +
>         retval = search_binary_handler(bprm,regs);
>         if (retval >= 0) {
>                 /* execve success */

At this point bprm->argc hasn't been finalized yet.  For example, the
script binfmt reads the script header and adds additional arguments.
The flush_old_exec() function is a better place to call this.

I'm not 100% sure this is the right way to handle this, though.  The
problem isn't as simple as ensuring the stack doesn't overflow during
argument allocation.  We also need to ensure the program has
sufficient stack space to run subsequently.  Otherwise, the observable
behavior is identical.  Since we can't realistically predict
acceptable stack availability requirements, some amount of uncertainty
is always going to exist.  A good heuristic, though, might be to limit
argument size to a percentage (say 25%) of maximum stack size and
validate this inside copy_strings().

Ollie
