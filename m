Return-Path: <linux-kernel-owner+w=401wt.eu-S1761812AbXFBPFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761812AbXFBPFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 11:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbXFBPFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 11:05:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:57136 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbXFBPFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 11:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=poAhDqwG5rKeRcrwgP6J6N9fm9lSGg7qjiTUDRksc4Jo1jL8JQItjXrsIMzIoukdNNlfEzw1HkaZWUgCMJUkkmAC7PJDjf3NHzByHieW6YsK+iDCk076w0Iu6CEDv/QRc9pRSb8+1fpZ4MbXBae9bDCpmoi2TzOcqmj4/jngI/w=
Message-ID: <a781481a0706020805y3065ca91rc5755f2403e93f60@mail.gmail.com>
Date: Sat, 2 Jun 2007 20:35:06 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Matthew Fredrickson" <creslin@digium.com>
Subject: Re: Device Driver Etiquette
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <a714c0e137cf5cf814e790e3fdef23c8@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a714c0e137cf5cf814e790e3fdef23c8@digium.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On 6/1/07, Matthew Fredrickson <creslin@digium.com> wrote:
> Greetings,
>
> I maintain a device driver that has been bitten by the transition to 4K
> stacks.  It is a T1/E1 line interface PCI card driver that is
> maintained outside of the kernel, although is used by a significant
> number of people.  The card has a part for doing echo cancellation, but
> it is accessed through a vendor API which (when we received it) was
> quite stack heavy.  It used the stack for a number of large data
> structures, although I have moved a great deal of them (particularly
> the larger ones) onto the heap instead of the stack.  Although this has
> reduced stack usage to the point where it is usable within 4K stacks,
> on some code paths, it can still use quite a bit of stack space (though
> under 4K) for local variables and a handful of small data structures.
> The problem is that in order to initialize and use the echo canceler,
> there is a firmware load portion which takes a noticeable period of
> time (~5-10 seconds).  That is done through this stack heavy portion of
> the code.

As Peter suggested earlier, the best strategy would be to
cleanup the code and make it stack-light in the first place ...

> My question is this: is there a way to either work around the problem I
> am seeing with the stack without recompiling the kernel with 8K stack
> size or without disabling irqs for such a long period of time (which I
> think is not a nice thing to do either)

There are standard mechanisms to push off long duration or
sleep-capable work from interrupts-disabled contexts to user
contexts. But those contexts can also, obviously, be interrupted,
so if you're stack-heavy and suffer a concurrent interrupt (which
you most definitely will in any codepath this long), there's always
the possibility of stack overflowing. I don't really see a better
solution to this than using bigger stacks or reducing your usage
of the same, but of course, better suggestions would be difficult
to give without looking at the code in question.

> OR is it acceptable (although
> not nice) to simply fix it this way, by disabling irqs while it loads
> the firmware?

IMHO, *not*. You could try this, in any case, and learn it the
hard way :-)

Satyam
