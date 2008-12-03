Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbYLCSZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbYLCSZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYLCSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:25:29 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:53947 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYLCSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:25:28 -0500
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1228328102.2821.25.camel@localhost.localdomain>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>
	 <1228257819.2971.197.camel@nimitz>
	 <1228328102.2821.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 10:25:16 -0800
Message-Id: <1228328716.26913.10.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 13:15 -0500, Mimi Zohar wrote:
> > > +int register_integrity(const struct integrity_operations *ops)
> > > +{
> > > +	if (integrity_ops != NULL)
> > > +		return -EAGAIN;
> > > +	integrity_ops = ops;
> > > +	return 0;
> > > +}
> > 
> > Is there some locking to keep this from racing and two integrity modules
> > both thinking they succeeded?  Does it matter?
> 
> Wouldn't this be a Kconfig issue.

If it is a Kconfig issue, then we don't really need all the function
pointers and ops things.  Just pick which integrity infrastructure you
want at compile time.  You also wouldn't need that integrity_ops
function at all.

> > > +int integrity_register_template(const char *template_name,
> > > +				const struct template_operations *template_ops)
> > > +{
...
> > > +	mutex_lock(&integrity_templates_mutex);
> > > +	list_add_rcu(&entry->template, &integrity_templates);
> > > +	mutex_unlock(&integrity_templates_mutex);
> > > +	synchronize_rcu();
> > 
> > What's the synchronize_rcu() for here?
> 
> good question.

So, you'll go investigate this, fix it up in a future patch and if you
decide it needs to be kept, it will be commented, right?

> > > +int integrity_unregister_template(const char *template_name)
> > > +{
> > > +	struct template_list_entry *entry;
> > > +
> > > +	mutex_lock(&integrity_templates_mutex);
> > > +	list_for_each_entry(entry, &integrity_templates, template) {
> > > +		if (strncmp(entry->template_name, template_name,
> > > +			    strlen(entry->template_name)) == 0) {
> > > +			list_del_rcu(&entry->template);
> > > +			mutex_unlock(&integrity_templates_mutex);
> > > +			synchronize_rcu();
> > > +			kref_put(&entry->refcount, template_release);
> > > +			return 0;
> > > +		}
> > > +	}
> > > +	mutex_unlock(&integrity_templates_mutex);
> > > +	return -EINVAL;
> > > +}
> > > +EXPORT_SYMBOL_GPL(integrity_unregister_template);
> > 
> > Is this frequently called?  If so, it might be better to use
> > call_rcu(). 
> 
> I don't expect that Templates would be added/removed frequently,
> but I could be wrong.  Only time will tell.

synchronize_rcu() is an "expensive" operation in wall clock time.  It
won't cost you a lot of CPU or anything, but it could cause this code to
block for a bit of time.

What you've said there is:

1. delete the template from the list
2. sleep until no one can possibly see the template any more
3. delete template

Call RCU would, instead, queue the template (and the kref_put()) in a
list.  That list gets called in a batched manner once a grace period has
elapsed.  The batching speeds things up, and it also doesn't block in
the caller.

I do see some other use like this in the kernel, but I have a suspicion
that there's a better way to do it.  Could you have Paul McKenney take a
quick look?  Dipankar or Josh Triplett seem to also love to look at
RCU. :)

-- Dave

