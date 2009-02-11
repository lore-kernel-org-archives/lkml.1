Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZBKXS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZBKXS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZBKXSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:18:20 -0500
Received: from tundra.namei.org ([65.99.196.166]:3236 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbZBKXST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:18:19 -0500
Date: Thu, 12 Feb 2009 10:17:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steve Grubb <sgrubb@redhat.com>, David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] integrity: audit update
In-Reply-To: <1234368748-4708-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0902121016590.16649@tundra.namei.org>
References: <1234368748-4708-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009, Mimi Zohar wrote:

> Based on discussions on linux-audit, as per Steve Grubb's request 
> http://lkml.org/lkml/2009/2/6/269, the following changes were made:
> - forced audit result to be either 0 or 1.
> - made template names const
> - Added new stand-alone message type: AUDIT_INTEGRITY_RULE
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Acked-by: Steve Grubb <sgrubb@redhat.com>

Applied.


> ---
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 930939a..4fa2810 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -36,7 +36,8 @@
>   * 1500 - 1599 kernel LSPP events
>   * 1600 - 1699 kernel crypto events
>   * 1700 - 1799 kernel anomaly records
> - * 1800 - 1999 future kernel use (maybe integrity labels and related events)
> + * 1800 - 1899 kernel integrity events
> + * 1900 - 1999 future kernel use
>   * 2000 is for otherwise unclassified kernel audit messages (legacy)
>   * 2001 - 2099 unused (kernel)
>   * 2100 - 2199 user space anomaly records
> @@ -130,6 +131,7 @@
>  #define AUDIT_INTEGRITY_STATUS	    1802 /* Integrity enable status */
>  #define AUDIT_INTEGRITY_HASH	    1803 /* Integrity HASH type */
>  #define AUDIT_INTEGRITY_PCR	    1804 /* PCR invalidation msgs */
> +#define AUDIT_INTEGRITY_RULE	    1805 /* policy rule */
>  
>  #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
>  
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index e3c16a2..165eb53 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -47,7 +47,7 @@ struct ima_template_data {
>  
>  struct ima_template_entry {
>  	u8 digest[IMA_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
> -	char *template_name;
> +	const char *template_name;
>  	int template_len;
>  	struct ima_template_data template;
>  };
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index a148a25..3cd58b6 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -15,7 +15,7 @@
>  #include <linux/module.h>
>  
>  #include "ima.h"
> -static char *IMA_TEMPLATE_NAME = "ima";
> +static const char *IMA_TEMPLATE_NAME = "ima";
>  
>  /*
>   * ima_store_template - store ima template measurements
> diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
> index 8a0f1e2..1e082bb 100644
> --- a/security/integrity/ima/ima_audit.c
> +++ b/security/integrity/ima/ima_audit.c
> @@ -22,16 +22,18 @@ static int ima_audit;
>  static int __init ima_audit_setup(char *str)
>  {
>  	unsigned long audit;
> -	int rc;
> -	char *op;
> +	int rc, result = 0;
> +	char *op = "ima_audit";
> +	char *cause;
>  
>  	rc = strict_strtoul(str, 0, &audit);
>  	if (rc || audit > 1)
> -		printk(KERN_INFO "ima: invalid ima_audit value\n");
> +		result = 1;
>  	else
>  		ima_audit = audit;
> -	op = ima_audit ? "ima_audit_enabled" : "ima_audit_not_enabled";
> -	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL, NULL, op, 0, 0);
> +	cause = ima_audit ? "enabled" : "not_enabled";
> +	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL,
> +			    op, cause, result, 0);
>  	return 1;
>  }
>  __setup("ima_audit=", ima_audit_setup);
> @@ -47,20 +49,21 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
>  		return;
>  
>  	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
> -	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u",
> +	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u ses=%u",
>  			 current->pid, current->cred->uid,
> -			 audit_get_loginuid(current));
> +			 audit_get_loginuid(current),
> +			 audit_get_sessionid(current));
>  	audit_log_task_context(ab);
>  	switch (audit_msgno) {
>  	case AUDIT_INTEGRITY_DATA:
>  	case AUDIT_INTEGRITY_METADATA:
>  	case AUDIT_INTEGRITY_PCR:
> +	case AUDIT_INTEGRITY_STATUS:
>  		audit_log_format(ab, " op=%s cause=%s", op, cause);
>  		break;
>  	case AUDIT_INTEGRITY_HASH:
>  		audit_log_format(ab, " op=%s hash=%s", op, cause);
>  		break;
> -	case AUDIT_INTEGRITY_STATUS:
>  	default:
>  		audit_log_format(ab, " op=%s", op);
>  	}
> @@ -73,6 +76,6 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
>  	if (inode)
>  		audit_log_format(ab, " dev=%s ino=%lu",
>  				 inode->i_sb->s_id, inode->i_ino);
> -	audit_log_format(ab, " res=%d", result);
> +	audit_log_format(ab, " res=%d", !result ? 0 : 1);
>  	audit_log_end(ab);
>  }
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index 573780c..ffbe259 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -137,7 +137,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
>  	ima_putc(m, &namelen, sizeof namelen);
>  
>  	/* 4th:  template name */
> -	ima_putc(m, e->template_name, namelen);
> +	ima_putc(m, (void *)e->template_name, namelen);
>  
>  	/* 5th:  template specific data */
>  	ima_template_show(m, (struct ima_template_data *)&e->template,
> diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
> index cf227db..0b0bb8c 100644
> --- a/security/integrity/ima/ima_init.c
> +++ b/security/integrity/ima/ima_init.c
> @@ -20,7 +20,7 @@
>  #include "ima.h"
>  
>  /* name for boot aggregate entry */
> -static char *boot_aggregate_name = "boot_aggregate";
> +static const char *boot_aggregate_name = "boot_aggregate";
>  int ima_used_chip;
>  
>  /* Add the boot aggregate to the IMA measurement list and extend
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 23810e0..b5291ad 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -12,7 +12,6 @@
>   */
>  #include <linux/module.h>
>  #include <linux/list.h>
> -#include <linux/audit.h>
>  #include <linux/security.h>
>  #include <linux/magic.h>
>  #include <linux/parser.h>
> @@ -239,8 +238,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
>  	char *p;
>  	int result = 0;
>  
> -	ab = audit_log_start(current->audit_context, GFP_KERNEL,
> -			     AUDIT_INTEGRITY_STATUS);
> +	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
>  
>  	entry->action = -1;
>  	while ((p = strsep(&rule, " \n")) != NULL) {
> @@ -345,15 +343,14 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
>  						   AUDIT_SUBJ_TYPE);
>  			break;
>  		case Opt_err:
> -			printk(KERN_INFO "%s: unknown token: %s\n",
> -			       __FUNCTION__, p);
> +			audit_log_format(ab, "UNKNOWN=%s ", p);
>  			break;
>  		}
>  	}
>  	if (entry->action == UNKNOWN)
>  		result = -EINVAL;
>  
> -	audit_log_format(ab, "res=%d", result);
> +	audit_log_format(ab, "res=%d", !result ? 0 : 1);
>  	audit_log_end(ab);
>  	return result;
>  }
> @@ -367,7 +364,7 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
>   */
>  int ima_parse_add_rule(char *rule)
>  {
> -	const char *op = "add_rule";
> +	const char *op = "update_policy";
>  	struct ima_measure_rule_entry *entry;
>  	int result = 0;
>  	int audit_info = 0;
> @@ -394,8 +391,12 @@ int ima_parse_add_rule(char *rule)
>  		mutex_lock(&ima_measure_mutex);
>  		list_add_tail(&entry->list, &measure_policy_rules);
>  		mutex_unlock(&ima_measure_mutex);
> -	} else
> +	} else {
>  		kfree(entry);
> +		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> +				    NULL, op, "invalid policy", result,
> +				    audit_info);
> +	}
>  	return result;
>  }
>  
> -- 
> 1.5.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
