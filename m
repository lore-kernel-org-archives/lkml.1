Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbYDYJgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbYDYJgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbYDYJgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:36:43 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:44512 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbYDYJgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:36:39 -0400
Date: Fri, 25 Apr 2008 03:36:38 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Dmitry <dbaryshkov@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, David Brownell <david-b@pacbell.net>,
       hiroshi.DOYU@nokia.com
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
In-Reply-To: <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com>
References: <20080420082925.GA32739@doriath.ww600.siemens.net>  <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com> <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry, 

On Mon, 21 Apr 2008, Dmitry wrote:

> 2008/4/21, Paul Walmsley <paul@pwsan.com>:
> >
> >   If the latter, your patchset will presumably
> >   need a higher standard of review, since once it is integrated, any
> >   changes will affect several architectures, rather than simply one.
> [...]
> I've reviewed the code for most linux/clk.h implementations in the
> kernel. The OMAP code was... a bit scary for me. I don't have any deep
> knowledge of this platform, and there were lots of structures, lots of
> structs embedding struct clk, etc.
> Tell me please, what do you need, that can't be done with this framework?

I wouldn't pretend to have a comprehensive list at this point.  But from a 
brief look, your clk_round_rate() and clk_set_rate() implementations will 
not work for the present OMAP clock tree.  In OMAP, many parent clocks do 
not have the same rate as their children.

But that is not really the main issue.  Ultimately, as long as your 
implementation remains completely optional, and any public interfaces 
(like debugfs/sysfs interfaces) are coordinated with other clock interface 
implementors, I personally have no issues with your code going into the 
tree somewhere.  With the possible exception of the clk_functions code, 
clocklib looks pretty clean to me, and a good exemplar of a clock 
interface implementation.

However: if the ultimate goal is to make your implementation normative, 
then I concur with Russell, and I would recommend against merging.  
Assumptions that you make in clocklib may not work well for future chips.  
Changing clocklib will affect many architectures.  For example, perhaps 
someone may wish to implement clocks as an actual in-memory tree rather 
than a list.  Or perhaps someone may need to handle clock usecounting 
differently, for situations when multiple clocks might share the same 
enable/disable code, but with different parents.
 
I am concerned that having any implementation as an implicit standard in 
the tree would increase the risk that, over time, internal implementation 
assumptions will be considered normative.  This could easily cause more 
pain in the future for maintainers than it would be worth. 

> This was already discussed. It was suggested to use struct embedding and 
> container_of, instead of pointers. If you do really need a pointer, you 
> can writes 
> struct my_clk {
>       void *data;
>       struct clk clk;
> };

OK.

> >  - I don't think that I understand the clk_functions part of your code.
> >   Is this a shorthand to construct aliases to other struct clks?
> 
> Yes, that's one of usages for it. E.g. current AT91 code has same 
> functionality named at91_clock_associate.  Also onece we get to multiple 
> chips providers/users, we'll see, that the clock simply can't have just 
> one record in the clocks tree. It's provided by some pin (provider_name) 
> and then consumed by several devices (several consumer_name + 
> consumer_device pairs). That is it.

Perhaps you might consider renaming these functions, perhaps "dynamic" 
clocks or "alias" clocks or something similar?  The word "function" has 
some other strong associations which I found confusing when I read the 
code.


regards,

- Paul
