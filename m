Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0BEU3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:29:52 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:57149 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab0BEU3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:29:51 -0500
MIME-Version: 1.0
In-Reply-To: <4B6C5271.9080802@cs.ucr.edu>
References: <4B6762CE.1050001@cs.ucr.edu> <fa686aa41002031501q14e8ab54s6713edc58d0fddc1@mail.gmail.com> 
	<4B6C5271.9080802@cs.ucr.edu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 5 Feb 2010 12:29:31 -0800
X-Google-Sender-Auth: 9a19cb6c45fe0738
Message-ID: <fa686aa41002051229y3c19ebfj9ae6d52811199668@mail.gmail.com>
Subject: Re: PATCH: Add non-Virtex 5 support for LL TEMAC driver
To: John Tyner <jtyner@cs.ucr.edu>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 9:16 AM, John Tyner <jtyner@cs.ucr.edu> wrote:
>
>
> Grant Likely wrote:
>>
>> On Mon, Feb 1, 2010 at 4:25 PM, John Tyner <jtyner@cs.ucr.edu> wrote:
>>>
>>> This patch adds support for using the LL TEMAC Ethernet driver on
>>> non-Virtex
>>> 5 platforms by adding support for accessing the Soft DMA registers as if
>>> they were memory mapped instead of solely through the DCR's (available on
>>> the Virtex 5).
>>>
>>> Signed-off-by: John Tyner <jtyner@cs.ucr.edu>
>>
>> Hi John, thanks for doing this work.  A couple of comments below.
>>
>
> [snip]
>
>>>  * TODO:
>>> - * - Fix driver to work on more than just Virtex5.  Right now the driver
>>> - *   assumes that the locallink DMA registers are accessed via DCR
>>> - *   instructions.
>>>  * - Factor out locallink DMA code into separate driver
>>>  * - Fix multicast assignment.
>>>  * - Fix support for hardware checksumming.
>>> @@ -117,12 +114,20 @@
>>>
>>>  static u32 temac_dma_in32(struct temac_local *lp, int reg)
>>>  {
>>> -       return dcr_read(lp->sdma_dcrs, reg);
>>> +       if (lp->sdma_regs) {
>>> +               return __raw_readl(lp->sdma_regs + reg);
>>> +       } else {
>>> +               return dcr_read(lp->sdma_dcrs, reg);
>>> +       }
>>
>> Rather than taking the ugliness an if/else block on every register
>> access, why not create an ops structure and populate it with the
>> correct access routines at runtime?
>
> As you can see from the comments in the TODO section, someone thinks (and I
> would tend to agree) that it would be a good idea to separate the DMA code
> from the Ethernet driver entirely. I also agree with your suggestion of
> avoiding the ugliness of the if/else block, but it seems like a job better
> left to be done when that refactoring takes place.
>
> This patch is only about 20 lines worth of changes, and to add a bunch of
> complexity doesn't seem worthwhile to me at this time.

I wrote that comment, so that someone would happen to be me.  :-)

Breaking the register access functions out into callbacks or an ops
callbacks structure is unrelated to the DMA refactoring task.  Doing
callbacks is pretty trivial to implement and it makes things simpler,
not more complex.

>
>>> @@ -895,7 +904,7 @@
>>>
>>>        lp->phy_node = of_parse_phandle(op->node, "phy-handle", 0);
>>>        if (lp->phy_node)
>>> -               dev_dbg(lp->dev, "using PHY node %s (%p)\n",
>>> np->full_name, np);
>>> +               dev_dbg(lp->dev, "using PHY node %s (%p)\n",
>>> lp->phy_node->full_name, lp->phy_node);
>>
>> This looks like an unrelated bug fix.  Please put into a separate
>> patch and post separately.
>
> It is an unrelated bug fix. If it's really a big deal, I can submit a
> separate patch, but it seems like it would be easier for someone to manually
> make this change than for me to go back and generate a new patch (since I'm
> not working on anything related to this anymore).
>
> I apologize for being kind of a dick about this stuff, but as I said, I'm
> not doing anything related to this stuff anymore. The change is really
> small, but adds support for something that currently doesn't work, so I'm
> hoping somebody else is willing to take up the cause in my stead. :)

Fair enough.  Thanks for posting what you have.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
