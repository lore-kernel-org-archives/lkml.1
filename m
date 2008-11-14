Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYKNWQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYKNWQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYKNWQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:16:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbYKNWQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:16:17 -0500
Date: Fri, 14 Nov 2008 14:15:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, jmorris@namei.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
Message-Id: <20081114141510.6f04404d.akpm@linux-foundation.org>
In-Reply-To: <9395c0a4110469d19100084664900789c34ebd42.1226547084.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
	<9395c0a4110469d19100084664900789c34ebd42.1226547084.git.zohar@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 22:47:12 -0500
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> This version resolves the merge issues resulting from the removal
> of the nameidata parameter to inode_permission(), by moving the
> integrity_inode_permission() call from inode_permission() to
> may_open(), and renaming the hook to integrity_nameidata_check().
> The nameidata is needed in order to open and read the file, so
> that the file can be hashed(a cryptographically strong checksum.)
> 
> This patch also fixes the template locking, preventing the template
> from being freed while being used.
> 
> This patch is a redesign of the integrity framework, which address a
> number of issues, including
>    - generalizing the measurement API beyond just inode measurements.
>    - separation of the measurement into distinct collection, appraisal,
>      and commitment phases, for greater flexibility.
> 
> Extended Verification Module(EVM) and the Integrity Measurement
> Architecture(IMA) were originally implemented as an LSM module.  Based
> on discussions on the LSM mailing list, a decision was made that the
> LSM hooks should only be used to enforce mandatory access control
> decisions and a new set of hooks should be defined specifically for
> integrity.
> 
> EVM/IMA was limited to verifying and measuring a file's (i.e. an inode)
> integrity and the metadata associated with it.  Current research is
> looking into other types of integrity measurements. (i.e. "Linux kernel
> integrity measurement using contextual inspection",  by Peter A. Loscocco,
> Perry W. Wilson, J. Aaron Pendergrass, C. Durward McDonell,
> http://doi.acm.org/10.1145/1314354.1314362). As a result, a requirement
> of the new integrity framework is support for different types of integrity
> measurements.
> This patch provides an integrity framework(api and hooks) and placement
> of the integrity hooks in the appropriate places in the fs directory.
> Collecting, appraising, and storing of file and other types of integrity
> data is supported.  Multiple integrity templates, which implement the
> integrity API, may register themselves.  For now, only a single integrity
> provider can register itself for the integrity hooks. (Support for multiple
> providers registering themselves for the integrity hooks would require
> some form of stacking.)
> 
> The six integrity hooks are:
>    nameidata_check_integrity, inode_alloc_integrity, inode_free_integrity,
>    bprm_check_integrity, file_free_integrity, file_mmap
> 
> The five integrity API calls provided are:
>    integrity_must_measure, integrity_collect_measurement,
>    integrity_appraise_measurement, integrity_store_measurement,
>    and integrity_display_template.
> 
> The type of integrity data being collected, appraised, stored, or
> displayed is template dependent.
> 
>
> ...
>
> +int integrity_register_template(const char *template_name,
> +				const struct template_operations *template_ops)
> +{
> +	int template_len;
> +	struct template_list_entry *entry;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;
> +	INIT_LIST_HEAD(&entry->template);
> +
> +	atomic_set(&entry->refcount, 1);
> +	template_len = strlen(template_name);
> +	if (template_len > TEMPLATE_NAME_LEN_MAX) {

It would be much neater to perform this check before running kzalloc().

> +		kfree(entry);
> +		return -EINVAL;
> +	}
> +	strcpy(entry->template_name, template_name);
> +	entry->template_ops = template_ops;
> +
> +	mutex_lock(&integrity_templates_mutex);
> +	list_add_rcu(&entry->template, &integrity_templates);
> +	mutex_unlock(&integrity_templates_mutex);
> +	synchronize_rcu();
> +
> +	return 0;
> +}
> +
> +EXPORT_SYMBOL_GPL(integrity_register_template);

someone forgot to run checkpatch.

>
> ...
>
> +static inline void tget(struct template_list_entry *entry)
> +{
> +	if (!entry)
> +		return;
> +	atomic_inc(&entry->refcount);
> +}
> +
> +static inline void tput(struct template_list_entry *entry)
> +{
> +	if (!entry)
> +		return;
> +	if (atomic_dec_and_test(&entry->refcount))
> +		kfree(entry);
> +}

Do these _really_ need to test for a NULL pointer?  It's an extra
test-n-branch in many fastpaths.  It would be better to avoid doing
this here, if poss.


