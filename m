Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYHGCNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYHGCNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 22:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYHGCNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 22:13:06 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:37977 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753281AbYHGCNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 22:13:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=E2R5wpfL+G0+4ADa/yNc4rOfCpHP4/BAThlMZtmkpzXseKDsQkAofgw1zohdddz8IND1aHhixcvn2QdcZNgEc5TVqlebevHr5wpqWWfDalntmax6e1WL6lXXFVCoMsV/AKt/J4YIyVlSvWfkvQM6JLYk3wGLS2zbI5G9YEpUSxo=  ;
X-YMail-OSG: 8kFR8PYVM1mbhZ_._G9Atzn7GXDYaPl.ngbcce9fjtesrHuiwwGymU1pB3iX5CbshR9qsOLdSu6stWnDX_a9Irno8t9MDITxvc.lPkVBRgvfEXdDWqo0JGnhJlGTy7qSZMU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in VFS or block layer
Date: Thu, 7 Aug 2008 12:12:58 +1000
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       ospite@studenti.unina.it, Matthew Wilcox <matthew@wil.cx>
References: <Pine.LNX.4.44L0.0808061628280.2145-100000@iolanthe.rowland.org> <20080806142805.9db6f52f.akpm@linux-foundation.org>
In-Reply-To: <20080806142805.9db6f52f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808071212.58506.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 August 2008 07:28, Andrew Morton wrote:
[...]

I'll have a go at reproducing it if I can.


> Aside: why does this code in do_generic_file_read() return -EIO when it
> got a signal?
>
>
> page_not_up_to_date:
>                 /* Get exclusive access to the page ... */
>                 if (lock_page_killable(page))
>                         goto readpage_eio;

I wondered about that too, but the error never gets back to userspace, so
we just want something that is going to return quickly.


> One possible problem is here:
>
> readpage:
> 		/* Start the actual read. The read will unlock the page. */
> 		error = mapping->a_ops->readpage(filp, page);
>
> 		if (unlikely(error)) {
> 			if (error == AOP_TRUNCATED_PAGE) {
> 				page_cache_release(page);
> 				goto find_page;
> 			}
> 			goto readpage_error;
> 		}
>
> the VFS layer assumes that if ->readpage() returned a synchronous error
> then the page was already unlocked within ->readpage().  Usually this
> means that the driver layer had to run the BIO completion callback to
> do that unlocking.  It is possible that the USB code forgot to do this.
> This would explain what you're seeing.
>
> So...  would you be able to verify that the USB, layer is correctly
> calling bio->bi_end_io() for the offending requests?

That seems likely.


> Aside2: why does this code:
>
> readpage:
> 		/* Start the actual read. The read will unlock the page. */
> 		error = mapping->a_ops->readpage(filp, page);
>
> 		if (unlikely(error)) {
> 			if (error == AOP_TRUNCATED_PAGE) {
> 				page_cache_release(page);
> 				goto find_page;
> 			}
> 			goto readpage_error;
> 		}
>
> 		if (!PageUptodate(page)) {
> 			if (lock_page_killable(page))
> 				goto readpage_eio;
>
> return EIO if lock_page_killable() saw a signal?

Same as above.
