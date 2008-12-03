Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYLCSPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYLCSPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYLCSPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:15:07 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51378 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbYLCSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:15:06 -0500
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1228257819.2971.197.camel@nimitz>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>
	 <1228257819.2971.197.camel@nimitz>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 13:15:02 -0500
Message-Id: <1228328102.2821.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 14:43 -0800, Dave Hansen wrote: 
> On Tue, 2008-12-02 at 16:47 -0500, Mimi Zohar wrote:
> > +#endif
> > +#endif
> 
> Personally, I love to see comments on these suckers after a long header
> file.  My memory sucks.

ok

> > +int register_integrity(const struct integrity_operations *ops)
> > +{
> > +	if (integrity_ops != NULL)
> > +		return -EAGAIN;
> > +	integrity_ops = ops;
> > +	return 0;
> > +}
> 
> Is there some locking to keep this from racing and two integrity modules
> both thinking they succeeded?  Does it matter?

Wouldn't this be a Kconfig issue.

> > +/**
> > + * integrity_register_template - registers an integrity template with the kernel
> > + * @template_name: a pointer to a string containing the template name.
> > + * @template_ops: a pointer to the template functions
> > + *
> > + * Register a set of functions to collect, appraise, store, and display
> > + * a template measurement, and a means to decide whether to do them.
> > + * Unlike integrity modules, any number of templates may be registered.
> > + *
> > + * Returns 0 on success, an error code on failure.
> > + */
> > +int integrity_register_template(const char *template_name,
> > +				const struct template_operations *template_ops)
> > +{
> > +	int template_len;
> > +	struct template_list_entry *entry;
> > +
> > +	template_len = strlen(template_name);
> > +	if (template_len > TEMPLATE_NAME_LEN_MAX)
> > +		return -EINVAL;
> > +
> > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > +	if (!entry)
> > +		return -ENOMEM;
> > +	INIT_LIST_HEAD(&entry->template);
> > +
> > +	kref_set(&entry->refcount, 1);
> > +	strcpy(entry->template_name, template_name);
> > +	entry->template_ops = template_ops;
> > +
> > +	mutex_lock(&integrity_templates_mutex);
> > +	list_add_rcu(&entry->template, &integrity_templates);
> > +	mutex_unlock(&integrity_templates_mutex);
> > +	synchronize_rcu();
> 
> What's the synchronize_rcu() for here?

good question.

> > +int integrity_unregister_template(const char *template_name)
> > +{
> > +	struct template_list_entry *entry;
> > +
> > +	mutex_lock(&integrity_templates_mutex);
> > +	list_for_each_entry(entry, &integrity_templates, template) {
> > +		if (strncmp(entry->template_name, template_name,
> > +			    strlen(entry->template_name)) == 0) {
> > +			list_del_rcu(&entry->template);
> > +			mutex_unlock(&integrity_templates_mutex);
> > +			synchronize_rcu();
> > +			kref_put(&entry->refcount, template_release);
> > +			return 0;
> > +		}
> > +	}
> > +	mutex_unlock(&integrity_templates_mutex);
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL_GPL(integrity_unregister_template);
> 
> Is this frequently called?  If so, it might be better to use
> call_rcu(). 

I don't expect that Templates would be added/removed frequently,
but I could be wrong.  Only time will tell.

> > +/**
> > + * integrity_find_get_template - search the integrity_templates list
> > + * @template_name: a pointer to a string containing the template name.
> > + *
> > + * Returns a pointer to an entry in the template list on success, NULL
> > + * on failure.
> > + */
> > +struct template_list_entry *integrity_find_get_template(const char
> > +							*template_name)
> > +{
> > +	struct template_list_entry *entry, *template_entry = NULL;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(entry, &integrity_templates, template) {
> > +		if (strncmp(entry->template_name, template_name,
> > +			    strlen(entry->template_name)) == 0) {
> > +			template_entry = entry;
> > +			break;
> > +		}
> > +	}
> > +	if (template_entry)
> > +		kref_get(&template_entry->refcount);
> > +	rcu_read_unlock();
> > +	return template_entry;
> > +}
> 
> Is there a reason not to do the kref_get() inside the loop?  Would save
> a line of code.

none, will do. 

> > +int integrity_collect_measurement(const char *template_name, void *data)
> > +{
> > +	struct template_list_entry *template_entry;
> > +	int rc = -EINVAL;
> > +
> > +	template_entry = integrity_find_get_template(template_name);
> > +	if (template_entry) {
> > +		rc = template_entry->template_ops->collect_measurement(data);
> > +		kref_put(&template_entry->refcount, template_release);
> > +	}
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(integrity_collect_measurement);
> > +
> 
> It's kinda a shame to see 5 or 6 functions which are such carbon copies
> of each other.  Could you do one of these, and just pass in the ops
> function as well as 'data'?  
> 
> You would have one of these:
> 
> +int integrity_generic_template(const char *template_name,
> +			      void (*func)(void *data), void *data)
> +{
> +       struct template_list_entry *template_entry;
> +       int rc = -EINVAL;
> +
> +       template_entry = integrity_find_get_template(template_name);
> +       if (template_entry) {
> +               rc = func(data);
> +               kref_put(&template_entry->refcount, template_release);
> +       }
> +       return rc;
> +}
> 
> And each measurement function could be something silly like:
> 
> int integrity_collect_measurement(const char *template_name, void *data)
> {
> 	return integrity_generic_template(template_name,
> 		 template_entry->template_ops->collect_measurement,
> 		 data);
> }
> 
> -- Dave

Yes, will re-factor the code. Thanks!

Mimi

