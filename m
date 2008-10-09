Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYJIGgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYJIGgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYJIGf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:35:59 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:20339 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754604AbYJIGf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:35:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AHcSk6rfEYBS5P2FjVzBzhjIMn2gWZmpSDUpxBAlvgmZ22OPZ2amRzgZzPbkymtv+zXC1H3uJixjnKffCoQpvg1GPp9pQJPj8sI6nl/rhWjCW1jG6hFdMuTYhhsszeGfxQAcTZKKdJ+JNB6r8ZHQWW5HverbEt7mopUslDYd5T0=  ;
X-YMail-OSG: X2S9yPwVM1moW6iVkr6JSB7u7E_cOrWRkoqTfpuvlvuzmySJGkmL4pq1HXkdoSy5SvF5iLzhSmGlsVC0BUZcG4VCuocVO6K8nDpkqU.Ms.MKCSkWsw11l1dy0Lqs6ITnlKZNRG0nYWI.w1Ex_joUjAnwhBuNbgLjrcDgrBMxLUonAwsZGxrU4Kqce21_
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] documentation: explain memory barriers
Date: Fri, 10 Oct 2008 04:35:47 +1100
User-Agent: KMail/1.9.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
References: <20080911101616.GA24064@agk.fab.redhat.com> <20081008181223.6954c7b2.randy.dunlap@oracle.com> <8119.1223517003@turing-police.cc.vt.edu>
In-Reply-To: <8119.1223517003@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810100435.48010.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008 12:50, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 08 Oct 2008 18:12:23 PDT, Randy Dunlap said:
> > +
> > +24: All memory barriers {e.g., barrier(), rmb(), wmb()} need a comment
> > in the +    source code that explains the logic of what they are doing
> > and why.
>
> "what they are doing" will almost always be "flush value to RAM" or
> similar.

Memory barriers don't flush anything anywhere. It's simple: you must
explain which operations you are ordering against which.


> How about this instead: 
>
> + 24: All memory barriers ({e.g., barrier(), rmb(), wmb()} need a comment
> in the +    source code that explains the race condition being prevented,
> and states +    the location of the other code or hardware feature that
> races with this. +
> +    An example comment:
> +
> + 	/*
> + 	 * If we don't do a wmb() here, the RBFROBNIZ register on the XU293
> + 	 * card will get confused and wedge the hardware...
> + 	 */
> +	wmb();

This comment is no good, because it doesn't tell you what the memory barrier
does. It tells you what might happen if you omit it.

 /*
  * If we don't do a wmb() here, the store to the RBFROBNIZ,
  * above, might reach the device before the store X, below.
  * 
  * If that happens, then the XU293  card will get confused
  * and wedge the hardware...
  */
  wmb();

If you don't comment like that, then how does the reader know that the wmb
is not *also* supposed to order the store with any other of the limitless
subsequent stores until the next memory ordering operation? Or any of the
previous stores since the last one?
