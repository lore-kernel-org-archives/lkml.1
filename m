Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbYF3Knb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbYF3Knb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYF3KnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:43:23 -0400
Received: from namei.org ([69.55.235.186]:36000 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752685AbYF3KnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:43:23 -0400
Date: Mon, 30 Jun 2008 20:43:20 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Reiner Sailer <sailer@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [RFC][PATCH 4/5] integrity: Linux Integrity Module(LIM)
In-Reply-To: <1214583780.28077.17.camel@new-host.home>
Message-ID: <Xine.LNX.4.64.0806302023240.23266@us.intercode.com.au>
References: <20080627131946.225566613@linux.vnet.ibm.com>
 <1214583780.28077.17.camel@new-host.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Mimi Zohar wrote:

> +const struct integrity_operations *integrity_ops = NULL;

This will be initialized to zero anyway.

> +
> +	if (!template_initialized++)
> +		INIT_LIST_HEAD(&integrity_templates);

Why not just intialize this at compile time with LIST_HEAD ?

> +	template_len = strlen(template_name);
> +	if (template_len > TEMPLATE_NAME_LEN_MAX)
> +		template_len = TEMPLATE_NAME_LEN_MAX;
> +	memcpy(entry->template_name, template_name, template_len);
> +	entry->template_name[template_len] = '\0';

Perhaps this would be simpler if you just bail with -EINVAL if the length 
is too great.  Then you can use strcpy and don't need to nul termiate the 
string for the caller.

> +	rc = integrity_find_template(template_name, &template_ops);
> +	if (rc == 0) {
> +		rc = template_ops->collect_measurement(data);
> +		rcu_read_unlock();
> +		return rc;
> +	}
> +	rcu_read_unlock();
> +	return -EINVAL;
> +}

If you give integrity_find_template() a standard form of returning 0 on 
success and -errno on failure, you can simplify the above quite a lot to 
have one unlock and one return.

> +	int rc;
> +
> +	rcu_read_lock();
> +	rc = integrity_find_template(template_name, &template_ops);
> +	if (rc == 0) {
> +		rc = template_ops->appraise_measurement(data);
> +		rcu_read_unlock();
> +		return rc;
> +	}
> +	rcu_read_unlock();
> +	return -EINVAL;
> +}

Ditto.

> +
> +EXPORT_SYMBOL_GPL(integrity_appraise_measurement);
> +
> +/**
> + * integrity_store_measurement - store template specific measurement
> + * @template_name: a pointer to a string containing the template name.
> + * @data: pointer to template specific data
> + *
> + * Store template specific integrity measurement.
> + */
> +void integrity_store_measurement(const char *template_name, void *data)
> +{
> +	const struct template_operations *template_ops;
> +	int rc;
> +
> +	rcu_read_lock();
> +	rc = integrity_find_template(template_name, &template_ops);
> +	if (rc == 0)
> +		template_ops->store_measurement(data);
> +	rcu_read_unlock();
> +	return;
> +}

So, the caller does not get an error if they supply an invalid template 
name?  That sounds like a bug which they need to know about.

> +/**
> + * integrity_must_measure - measure decision based on template policy
> + * @template_name: a pointer to a string containing the template name.
> + * @data: pointer to template specific data
> + *
> + * Returns 0 on success, an error code on failure.
> + */
> +int integrity_must_measure(const char *template_name, void *data)
> +{
> +	const struct template_operations *template_ops;
> +	int rc;
> +
> +	rcu_read_lock();
> +	rc = integrity_find_template(template_name, &template_ops);
> +	if (rc == 0) {
> +		rc = template_ops->must_measure(data);
> +		rcu_read_unlock();
> +		return rc;
> +	}
> +	rcu_read_unlock();
> +	return -EINVAL;
> +}

Do a single unlock and return.

> +/* Hook used to measure executable file integrity. */
> +int integrity_bprm_check(struct linux_binprm *bprm)
> +{
> +	int rc = 0;
> +
> +	if (integrity_ops && integrity_ops->bprm_check_integrity)
> +		rc = integrity_ops->bprm_check_integrity(bprm);
> +	return rc;
> +}

Have you considered using a set of dummy ops similar to LSM, so that 
integrity_ops->whatever will always point to something and can be 
unconditionally called?  (see security_fixup_ops()).



- James
-- 
James Morris
<jmorris@namei.org>
