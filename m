Return-Path: <linux-kernel-owner+w=401wt.eu-S935777AbZLQSV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935777AbZLQSV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935356AbZLQSVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:21:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45526 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935554AbZLQSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:21:49 -0500
Date: Thu, 17 Dec 2009 18:17:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Guenther <richard.guenther@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091217181718.GA4440@n2100.arm.linux.org.uk>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 06:17:11PM +0100, Richard Guenther wrote:
> On Thu, Dec 17, 2009 at 6:09 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> > Jamie Lokier wrote:
> >>
> >> Uwe Kleine-König wrote:
> >>>
> >>> Use the new unreachable() macro instead of for(;;);
> >>>        *(int *)0 = 0;
> >>>          /* Avoid "noreturn function does return" */
> >>> -       for (;;);
> >>> +       unreachable();
> >>
> >> Will GCC-4.5 remove ("optimise away") the *(int *)0 = 0 because it
> >> knows the branch of the code leading to unreachable can never be reached?
> >>
> >
> > I don't know the definitive answer, so I am sending to gcc@...
> >
> > FYI: #define unreachable() __builtin_unreachable()
> 
> It shouldn't as *(int *)0 = 0; might trap.  But if you want to be sure
> use
>    __builtin_trap ();
> instead for the whole sequence (the unreachable is implied then).
> GCC choses a size-optimal trap representation for your target then.

How is "size-optimal trap" defined?  The point of "*(int *)0 = 0;" is
to cause a NULL pointer dereference which is trapped by the kernel to
produce a full post mortem and backtrace which is easily recognised
as a result of this code.

Having gcc decide on, maybe, an undefined instruction instead would be
confusing.

Let me put it another way: I want this function to terminate with an
explicit NULL pointer dereference in every case.
