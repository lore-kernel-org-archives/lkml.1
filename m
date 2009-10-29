Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZJ2FkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZJ2FkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 01:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZJ2FkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 01:40:23 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56889 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZJ2FkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 01:40:22 -0400
Date: Thu, 29 Oct 2009 00:40:29 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Use RCU primitives for list operation
Message-ID: <20091029054029.GE11558@us.ibm.com>
References: <20091004125327.105675949@I-love.SAKURA.ne.jp> <4ACE1CFE.3020507@canonical.com> <alpine.LRH.2.00.0910121203090.19066@tundra.namei.org> <200910132034.DAE39014.OVLFFOMHJQFOSt@I-love.SAKURA.ne.jp> <200910132037.BHJ57351.QLVJtMHSFOFOOF@I-love.SAKURA.ne.jp> <200910132039.HAD48971.JFOOMQFSFOtVLH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910132039.HAD48971.JFOOMQFSFOtVLH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> [PATCH] TOMOYO: Use RCU primitives for list operation
> 
> Remove down_read()/up_read() by replacing with RCU primitives.
> SRCU based garbage collector will be added in the future.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  security/tomoyo/common.c   |   52 ++++++++++-----------------------------------
>  security/tomoyo/common.h   |   14 ++++++------
>  security/tomoyo/domain.c   |   38 ++++++++++----------------------
>  security/tomoyo/file.c     |   50 ++++++++++++++-----------------------------
>  security/tomoyo/realpath.c |    4 ---
>  5 files changed, 49 insertions(+), 109 deletions(-)
> 
> --- security-testing-2.6.orig/security/tomoyo/common.c
> +++ security-testing-2.6/security/tomoyo/common.c
> @@ -365,9 +365,6 @@ bool tomoyo_is_domain_def(const unsigned
>   *
>   * @domainname: The domainname to find.
>   *
> - * Caller must call down_read(&tomoyo_domain_list_lock); or
> - * down_write(&tomoyo_domain_list_lock); .
> - *
>   * Returns pointer to "struct tomoyo_domain_info" if found, NULL otherwise.
>   */
>  struct tomoyo_domain_info *tomoyo_find_domain(const char *domainname)
> @@ -377,7 +374,7 @@ struct tomoyo_domain_info *tomoyo_find_d
> 
>  	name.name = domainname;
>  	tomoyo_fill_path_info(&name);
> -	list_for_each_entry(domain, &tomoyo_domain_list, list) {
> +	list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
>  		if (!domain->is_deleted &&
>  		    !tomoyo_pathcmp(&name, domain->domainname))
>  			return domain;
> @@ -837,8 +834,7 @@ bool tomoyo_domain_quota_is_ok(struct to
> 
>  	if (!domain)
>  		return true;
> -	down_read(&tomoyo_domain_acl_info_list_lock);
> -	list_for_each_entry(ptr, &domain->acl_info_list, list) {
> +	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
>  		if (ptr->type & TOMOYO_ACL_DELETED)
>  			continue;
>  		switch (tomoyo_acl_type2(ptr)) {

You are removing the down_read()s, but not replacing them with
rcu_read_lock()s.  I assume this is based on the same discussions
you had with Paul awhile ago about the safety of walking the list
bc you only append to the end (which I trust must have concluded
in your favor)?

If you'll be adding gc eventually anyway, is it really worthwhile
to 'violate the rules' now by calling list_for_each_entry_rcu()
without being inside rcu_read_lock() now?  I fear it'll only serve
to confuse readers, especially those looking for rcu users to serve
as examples.

-serge
