Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbXJYUi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbXJYUi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXJYUis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:38:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:56778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbXJYUir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:38:47 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [2.6 patch] acpi/ec.c: fix use-after-free
Date: Thu, 25 Oct 2007 16:38:24 -0400
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071024162600.GD30533@stusta.de> <20071024172604.GD30533@stusta.de> <471F812B.2020005@suse.de>
In-Reply-To: <471F812B.2020005@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251638.24282.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len


On Wednesday 24 October 2007 13:30, Alexey Starikovskiy wrote:
> Adrian Bunk wrote:
> > On Wed, Oct 24, 2007 at 09:15:18PM +0400, Alexey Starikovskiy wrote:
> >> Adrian,
> >>
> >> commit 30c08574da0ead1a47797ce028218ce5b2de61c7 can not introduce use-after-free.
> >>
> >> Please check...
> > 
> > 
> > Commit 30c08574da0ead1a47797ce028218ce5b2de61c7 did:
> > 
> > <--  snip  -->
> > 
> >  	list_for_each_entry(handler, &ec->list, node) {
> >                 if (query_bit == handler->query_bit) {
> >                         list_del(&handler->node);
> >                         kfree(handler);
> > -                       break;
> >                 }
> > 	}
> > 
> > <--  snip  -->
> > 
> > 
> > If you look at the definition of list_for_each_entry() in 
> > include/linux/list.h:
> > 
> > <--  snip  -->
> > 
> > #define list_for_each_entry(pos, head, member)                          \
> >         for (pos = list_entry((head)->next, typeof(*pos), member);      \
> >              prefetch(pos->member.next), &pos->member != (head);        \
> >              pos = list_entry(pos->member.next, typeof(*pos), member))
> >                               ^^^^^^^^^^^^^^^^
> > 
> > <--  snip  -->
> > 
> > 
> > Without the "break", "handler" is being dereferenced after it was freed.
> Yes, found it minute before :( 
> Acked, thanks.
> > 
> > 
> >> Regards,
> >> Alex.
> >> Adrian Bunk wrote:
> >>> This patch fixes a use-after-free introduced by
> >>> commit 30c08574da0ead1a47797ce028218ce5b2de61c7.
> >>>
> >>> Spotted by the Coverity checker.
> >>>
> >>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >>>
> >>> ---
> >>> --- linux-2.6/drivers/acpi/ec.c.old	2007-10-23 19:39:47.000000000 +0200
> >>> +++ linux-2.6/drivers/acpi/ec.c	2007-10-23 19:34:55.000000000 +0200
> >>> @@ -434,11 +442,11 @@
> >>>  EXPORT_SYMBOL_GPL(acpi_ec_add_query_handler);
> >>>  
> >>>  void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
> >>>  {
> >>> -	struct acpi_ec_query_handler *handler;
> >>> +	struct acpi_ec_query_handler *handler, *tmp;
> >>>  	mutex_lock(&ec->lock);
> >>> -	list_for_each_entry(handler, &ec->list, node) {
> >>> +	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
> >>>  		if (query_bit == handler->query_bit) {
> >>>  			list_del(&handler->node);
> >>>  			kfree(handler);
> >>>  		}
> >>>
> > 
> > 
> > cu
> > Adrian
> > 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
