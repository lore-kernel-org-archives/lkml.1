Return-Path: <linux-kernel-owner+w=401wt.eu-S1764539AbXHKWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764539AbXHKWU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 18:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759579AbXHKWUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 18:20:17 -0400
Received: from mx1.suse.de ([195.135.220.2]:47105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759108AbXHKWUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 18:20:15 -0400
To: casey@schaufler-ca.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
References: <46BDF88B.2060301@schaufler-ca.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Aug 2007 01:14:27 +0200
In-Reply-To: <46BDF88B.2060301@schaufler-ca.com>
Message-ID: <p73zm0xslyk.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> Smack is the Simplified Mandatory Access Control Kernel.

I like the simplified part.

> +static int smk_get_access(smack_t sub, smack_t obj)
> +{
> +	struct smk_list_entry *sp = smack_list;
> +
> +	for (; sp != NULL; sp = sp->smk_next)
> +		if (sp->smk_rule.smk_subject == sub &&
> +		    sp->smk_rule.smk_object == obj)
> +			return sp->smk_rule.smk_access;

Do I miss something, or is there really no locking for the reader side
of the list? That looks dangerous. Of course a global lock for readers 
would be likely a scaling disaster. You could use RCU.

Or if you assume rules are changed only very infrequently it might
be more cache friendly to compile all the rules into a linear buffer
and then just replace the whole buffer atomically with a RCU
grace period on cahnges.

It doesn't look like it would scale to larger numbers of rules though.
Is that intended? Would caching of decisions fit into the design?

Also in general code style would need some improvements;
e.g. no externs in .c; no ../.. include hacks etc.
You also seem weak on the Documentation front.
Other than that it looks reasonably clean (haven't read all of it)

-Andi
