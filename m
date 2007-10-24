Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbXJXRZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbXJXRZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXJXRZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:25:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60875 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755253AbXJXRZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:25:36 -0400
Date: Wed, 24 Oct 2007 19:26:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/ec.c: fix use-after-free
Message-ID: <20071024172604.GD30533@stusta.de>
References: <20071024162600.GD30533@stusta.de> <471F7DA6.2060907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <471F7DA6.2060907@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:15:18PM +0400, Alexey Starikovskiy wrote:
> Adrian,
> 
> commit 30c08574da0ead1a47797ce028218ce5b2de61c7 can not introduce use-after-free.
> 
> Please check...


Commit 30c08574da0ead1a47797ce028218ce5b2de61c7 did:

<--  snip  -->

 	list_for_each_entry(handler, &ec->list, node) {
                if (query_bit == handler->query_bit) {
                        list_del(&handler->node);
                        kfree(handler);
-                       break;
                }
	}

<--  snip  -->


If you look at the definition of list_for_each_entry() in 
include/linux/list.h:

<--  snip  -->

#define list_for_each_entry(pos, head, member)                          \
        for (pos = list_entry((head)->next, typeof(*pos), member);      \
             prefetch(pos->member.next), &pos->member != (head);        \
             pos = list_entry(pos->member.next, typeof(*pos), member))
                              ^^^^^^^^^^^^^^^^

<--  snip  -->


Without the "break", "handler" is being dereferenced after it was freed.


> Regards,
> Alex.
> Adrian Bunk wrote:
> > This patch fixes a use-after-free introduced by
> > commit 30c08574da0ead1a47797ce028218ce5b2de61c7.
> > 
> > Spotted by the Coverity checker.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > --- linux-2.6/drivers/acpi/ec.c.old	2007-10-23 19:39:47.000000000 +0200
> > +++ linux-2.6/drivers/acpi/ec.c	2007-10-23 19:34:55.000000000 +0200
> > @@ -434,11 +442,11 @@
> >  EXPORT_SYMBOL_GPL(acpi_ec_add_query_handler);
> >  
> >  void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
> >  {
> > -	struct acpi_ec_query_handler *handler;
> > +	struct acpi_ec_query_handler *handler, *tmp;
> >  	mutex_lock(&ec->lock);
> > -	list_for_each_entry(handler, &ec->list, node) {
> > +	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
> >  		if (query_bit == handler->query_bit) {
> >  			list_del(&handler->node);
> >  			kfree(handler);
> >  		}
> > 


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

