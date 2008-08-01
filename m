Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbYHASi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbYHASi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbYHASgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:36:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23286 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbYHASgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:36:00 -0400
Date: Fri, 1 Aug 2008 11:04:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Subject: Re: linux-next: Tree for July 31 (IMA build error)
Message-Id: <20080801110441.12a48b70.randy.dunlap@oracle.com>
In-Reply-To: <1217611980.4000.10.camel@new-host-2>
References: <1217611980.4000.10.camel@new-host-2>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2008 13:33:00 -0400 Mimi Zohar wrote:

> 
> Randy Dunlap <randy.dunlap@oracle.com> wrote on 08/01/2008 01:34:14 AM:
> > security/integrity/ima:
> > 
> > linux-next-20080731/security/integrity/ima/ima_policy.c:81: error: implicit 
> > declaration of function 'security_audit_rule_match'
> > linux-next-20080731/security/integrity/ima/ima_policy.c:206: error: implicit 
> > declaration of function 'security_audit_rule_init'
> > make[4]: *** [security/integrity/ima/ima_policy.o] Error 1
> 
> - Update security/integrity/ima/Kconfig for LSM based policy rules 
>   to select CONFIG_AUDIT.
> - Add dummy security_filter_rule_init/match routines for when 
>   CONFIG_AUDIT is not configured.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Thanks.  Works for me.


> Index: security-testing-2.6/security/integrity/ima/Kconfig
> ===================================================================
> --- security-testing-2.6.orig/security/integrity/ima/Kconfig
> +++ security-testing-2.6/security/integrity/ima/Kconfig
> @@ -39,3 +39,11 @@ config IMA_BASE_HOOKS
>  	default n
>  	help
>  	  Enable this option to allow the LSM module to enforce integrity.
> +
> +config IMA_LSM_BASED_RULES
> +	bool "Enable LSM based measurement policy rules(requires audit)"
> +	depends on IMA
> +	select AUDIT
> +	default y
> +	help
> +	  Disabling this option will not enforce LSM based policy rules.
> Index: security-testing-2.6/security/integrity/ima/ima.h
> ===================================================================
> --- security-testing-2.6.orig/security/integrity/ima/ima.h
> +++ security-testing-2.6/security/integrity/ima/ima.h
> @@ -145,4 +145,25 @@ struct ima_iint_cache {
>  	u8 		digest[IMA_DIGEST_SIZE];
>  	struct mutex mutex;
>  };
> +
> +/* LSM based policy rules require audit */
> +#ifdef CONFIG_AUDIT
> +
> +#define security_filter_rule_init security_audit_rule_init
> +#define security_filter_rule_match security_audit_rule_match
> +
> +#else
> +
> +static inline int security_filter_rule_init(u32 field, u32 op, char *rulestr,
> +					    void **lsmrule)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
> +				   void *lsmrule, struct audit_context *actx)
> +{
> +	return -EINVAL;
> +}
> +#endif
>  #endif
> Index: security-testing-2.6/security/integrity/ima/ima_policy.c
> ===================================================================
> --- security-testing-2.6.orig/security/integrity/ima/ima_policy.c
> +++ security-testing-2.6/security/integrity/ima/ima_policy.c
> @@ -20,9 +20,6 @@
>  
>  #include "ima.h"
>  
> -#define security_filter_rule_init security_audit_rule_init
> -#define security_filter_rule_match security_audit_rule_match
> -
>  struct ima_measure_rule_entry {
>  	struct list_head list;
>  	int action;


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
