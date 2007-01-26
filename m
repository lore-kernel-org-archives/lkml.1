Return-Path: <linux-kernel-owner+w=401wt.eu-S1030766AbXAZGAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030766AbXAZGAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030768AbXAZGAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:00:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030766AbXAZGAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:00:43 -0500
Date: Thu, 25 Jan 2007 22:00:29 -0800
From: Andrew Morton <akpm@osdl.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       matthew.e.tolentino@intel.com, anil.s.keshavamurthy@intel.com
Subject: Re: [PATCH] Fix race in efi variable delete code
Message-Id: <20070125220029.f658af79.akpm@osdl.org>
In-Reply-To: <20070125222055.GA7237@lists.us.dell.com>
References: <20070122152209.29717.52473.sendpatchset@prarit.boston.redhat.com>
	<20070125203456.GB16521@lists.us.dell.com>
	<20070125222055.GA7237@lists.us.dell.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 16:20:56 -0600
Matt Domsch <Matt_Domsch@dell.com> wrote:

> Fix race when deleting an EFI variable and issuing another EFI command on the
> same variable.  The removal of the variable from the efivars_list should be
> done in efivar_delete and not delayed until the kobject release.
> 
> Furthermore, remove the item from the list at module unload time, and
> use list_for_each_entry_safe() rather than list_for_each_safe() for readability.
> 

Does it actually need to use the _safe variant?  That's only needed if the
body of the loop can do list_del() and afaict that doesn't happen here.

>  static void __exit
>  efivars_exit(void)
>  {
> -	struct list_head *pos, *n;
> +	struct efivar_entry *entry, *n;
>  
> -	list_for_each_safe(pos, n, &efivar_list)
> -		efivar_unregister(get_efivar_entry(pos));
> +	list_for_each_entry_safe(entry, n, &efivar_list, list) {
> +		spin_lock(&efivars_lock);
> +		list_del(&entry->list);
> +		spin_unlock(&efivars_lock);
> +		efivar_unregister(entry);
> +	}

That's not exactly a thing of beauty, sorry ;)

Given that the code is single-threaded here, there's nothing to race
against and I don't think we strictly need any locking at all.  But
consistency is OK.  Given the locking here I'm not sure that the code would
be safe against concurrent removes anyway.

A more idiomatic implementation would do:

	while (!list_empty(&efivar_list)) {
		struct efivar_entry *entry = list_entry(...);
		list_del(...)
	}

Anyway.  Stuff to think about on a rainy day...
