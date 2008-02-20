Return-Path: <linux-kernel-owner+w=401wt.eu-S1763637AbYBTE6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763637AbYBTE6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 23:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYBTE6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 23:58:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46395 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYBTE6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 23:58:23 -0500
Date: Tue, 19 Feb 2008 21:02:36 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       akpm@osdl.org, "Andrew G. Morgan" <morgan@kernel.org>,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #6)
Message-ID: <20080220050236.GA20181@kroah.com>
References: <47B4ED1B.6070206@ak.jp.nec.com> <47B4F1C5.9010408@cn.fujitsu.com> <47B4FFE0.3000702@ak.jp.nec.com> <20080215183802.GA3925@sergelap.austin.ibm.com> <20080215185003.GA7495@kroah.com> <47B92FF5.1080301@ak.jp.nec.com> <20080218074056.GA19915@kroah.com> <47B945BA.2060107@ak.jp.nec.com> <20080219161610.GA3344@kroah.com> <47BBAEE3.6040301@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BBAEE3.6040301@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:38:59PM +0900, Kohei KaiGai wrote:
> >> If we can have a private member in kobj_attribute, we can found the 
> content
> >> to be returned in a single step.
> >
> > Ok, again, just send me a patch that adds this functionality and we will
> > be very glad to consider it.
>
> [1/2] Add a private data field within kobj_attribute structure.
>
> This patch add a private data field, declared as void *, within 
> kobj_attribute
> structure. Anyone wants to use sysfs can store their private data to refer 
> at
> _show() and _store() method.
> It enables to share a single method function with several similar entries,
> like ones to export the list of capabilities the running kernel supported.

But your patch 2/2 doesn't use this interface, why not?

>  include/linux/kobject.h |    1 +
>  include/linux/sysfs.h   |    7 +++++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index caa3f41..57d5bf1 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -130,6 +130,7 @@ struct kobj_attribute {
>  			char *buf);
>  	ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
>  			 const char *buf, size_t count);
> +	void *data;	/* a private field */

Hm, can you really use this?

>  extern struct sysfs_ops kobj_sysfs_ops;
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 8027104..6f40ff9 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -50,6 +50,13 @@ struct attribute_group {
>  	.store	= _store,					\
>  }
>
> +#define __ATTR_DATA(_name,_mode,_show,_store,_data) {		\
> +	.attr = {.name = __stringify(_name), .mode = _mode },   \
> +	.show	= _show,					\
> +	.store	= _store,					\
> +	.data	= (void *)(_data),				\
> +}

I don't see how this would be any different from the original?  You are
always passed a kobject, which can be embedded in anything else.

Could you also modify the documentation and the sample code to use this
new field, showing how it is to be used, and testing that it works
properly at the same time?

thanks,

greg k-h
