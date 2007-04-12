Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbXDLMsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbXDLMsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXDLMsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:48:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:38851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbXDLMsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:48:20 -0400
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 39/41] AppArmor: Profile loading and manipulation, pathname matching
References: <20070412090809.917795000@suse.de>
	<20070412090849.465428000@suse.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Apr 2007 15:46:38 +0200
In-Reply-To: <20070412090849.465428000@suse.de>
Message-ID: <p733b35903l.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jjohansen@suse.de writes:

[didn't review code fully, just some stuff I noticed]

> +
> +struct aa_dfa {
> +	struct table_header *tables[YYTD_ID_NXT];
> +};

If that is passed in from user space you would need special compat
code for 64bit kernels who support 32bit userland.
Better to avoid pointers.

> +
> +	/* get optional subprofiles */
> +	if (aa_is_nameX(e, AA_LIST, "hats")) {
> +		while (!aa_is_nameX(e, AA_LISTEND, NULL)) {
> +			struct aa_profile *subprofile;
> +			subprofile = aa_unpack_profile(e);

Is there any check that would guard the recursion from stack
overflow on malicious input?  

> +	/*
> +	 * Replacement needs to allocate a new aa_task_context for each
> +	 * task confined by old_profile.  To do this the profile locks
> +	 * are only held when the actual switch is done per task.  While
> +	 * looping to allocate a new aa_task_context the old_task list
> +	 * may get shorter if tasks exit/change their profile but will
> +	 * not get longer as new task will not use old_profile detecting
> +	 * that is stale.
> +	 */
> +	do {
> +		new_cxt = aa_alloc_task_context(GFP_KERNEL | __GFP_NOFAIL);

NOFAIL is usually a bad sign. It should be only used if there is no
alternative.

-Andi

