Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbXH3N0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbXH3N0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXH3N0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:26:21 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:36634 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751797AbXH3N0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:26:20 -0400
X-YMail-OSG: MVb8HcEVM1lG5IQnru0fy8Z6oK7nVbZGJYPvMonB_idT551e0s7LClSXA1V.SmkPRY7AZJPUCw--
Date: Thu, 30 Aug 2007 08:26:13 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Adrian Bunk <bunk@kernel.org>,
       sds@tycho.nsa.gov, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [2.6 patch] remove securebits
Message-ID: <20070830132613.GA20536@vino.hallyn.com>
References: <20070824211942.GA24478@vino.hallyn.com> <46CFA6F2.9030209@kernel.org> <20070825182846.GN30705@stusta.de> <20070827150941.GA31042@vino.hallyn.com> <20070827151751.GD4121@stusta.de> <20070827152817.GA31632@vino.hallyn.com> <20070827155855.GE4121@stusta.de> <46D3CCBA.1020204@kernel.org> <20070828181959.GA24270@vino.hallyn.com> <46D614AF.8070206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D614AF.8070206@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge E. Hallyn wrote:
> > To summarize more clearly, I think that so long as we support
> > process trees with a sort of !SECURE_NOROOT support, that
> > support should include the ability to use prctl(KEEP_CAPS) the
> > way one uses it now.
> 
> > When a process tree is in strict capability mode,
> > prctl(PR_{G,S}ET_KEEP_CAPS) should return -EINVAL.
> 
> I agree. I'll try to code it up in a way that its clear how to delete
> this functionality when folk realize they no longer need it...
> 
> - -static inline int get_file_caps(struct linux_binprm *bprm)
> +int cap_bprm_set_security(struct linux_binprm *bprm)
>  {
>  	bprm_clear_caps(bprm);
> +	bprm_force_uid0_caps(bprm);
> +	current->keep_capabilities = 0;
> 
> > This is being moved from bprm_apply to bprm_set, which moves it
> > earlier.  If exec fails later on, keep_capabilities might be set
> > to 0 even though exec failed.
> 
> I'll look at it again, but I had thought I had preserved the previous
> behavior with this condensed version of the code. Are you suggesting an
> improvement to what was there, or pointing out I'm inadvertently
> breaking the old behavior?

Well it's just 'breaking' old behavior in certain error cases.  I.e. if
audit fails, or no handler is found for the binary, we never reach
compute_creds (which is called from within the binary loader), so in 
the past keep_capabilities would have remained 1 until something was
actually executed.  Now in all likelyhood the process would try to
exec something else, but if it should happen to decide to setuid()
instead, with your patch keep_capabilities will have been unexpectedly
set to 0 during the failed exec attempt.

-serge
