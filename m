Return-Path: <linux-kernel-owner+w=401wt.eu-S1946178AbXECPP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946178AbXECPP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162119AbXECPP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:15:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:29034 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162115AbXECPP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WnQFkwoGMS51yTCUIxgMBFcYLS+smDIIMWksv4q+DlmBrVhJNTRnl0tP2z8p3ros8+Rl6gm/MgJBwc+Lu83ZkKAPOBKmWOMVUtvrnvpp1JqE3+37n6Nhns2pVzU7BR0Zl8i5nJIILdZBFM0grIPWVDp7izB07vUvT1B9JVclAa4=
Message-ID: <4639FC94.9050203@gmail.com>
Date: Thu, 03 May 2007 19:15:32 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Trent Piepho <xyzzy@speakeasy.org>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (..	was:	Critical
 points about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	 <1178031333.3958.63.camel@localhost>	 <Pine.LNX.4.58.0705011606070.309@shell2.speakeasy.net>	 <1178071431.11109.62.camel@localhost>	 <Pine.LNX.4.58.0705020348080.309@shell2.speakeasy.net> <1178200976.12651.104.camel@localhost>
In-Reply-To: <1178200976.12651.104.camel@localhost>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Em Qua, 2007-05-02 às 04:10 -0700, Trent Piepho escreveu:
>> On Tue, 1 May 2007, Mauro Carvalho Chehab wrote:
> 
>>> However, when dst is selected, I got those errors:
>> When I made this patch I was basing it off a patch I made around 9 months
>> ago.  I thought since that one was ok, this would be ok too, and in my
>> hurry to get it done I've clearly put too little effort into checking it,
>> and I'm sorry to have wasted your time.
>>
>> I promise, this time it's right!
>> http://linuxtv.org/hg/~tap/dst-new
> 
> Confirmed. Now the patch is properly working. My tests were done with a
> board with DST. Those are the results:
> 
> 1) when DST is unselected, on a board with DST, it will print the errors
> indicating that the Kconfig items were not selected:
> 
> DVB: registering new adapter (bttv0).
> DVB: Unable to find symbol dst_attach()
> frontend_init: Could not find a Twinhan DST.
> dvb-bt8xx: A frontend driver was not found for device 109e/0878 subsystem fbfb/f800
> 
> The only issue is the wrong printk msg, stating that a "frontend driver"
> were not found. As this issue also happens with the current driver, due
> the usage of dvb_attach() macro, I don't see any regressions.
> 
> It would be nice, however, to have a patch making dvb_attach more
> generic, by e.g. having a variant that allows passing another message.
> 
> Trying to run dvb programs like scan and kaffeine will properly fail.
> 
> 2) With DST selected, the driver works properly. 
> 
> The changes also solved the issue of removing the dst drivers. Before
> the patch, sometimes it is required to force removal of dst module with
> the '-f' flag, since the module count were wrong.
> 
> ---
> 
> I'll risk to make a briefing of the technical points:
> 
> <SUMMARY>
> Current issues:
> 	1) allow deselecting DST/DST_CA support, since this is not needed by
> some supported boards;
> 	2) sometimes, module removal don't work with dst, since usage count
> becomes wrong;
> 	3) if dst or dst_ca is not properly loaded, the printk message wrongly
> indicates that "A frontend driver was not found"
> 
> The Trent's original patch were written on Aug, 2006 (*). The current
> version fixes (1) and (2). It doesn't touch on (3). There aren't any
> other patches properly fixing (1) and (2).
> 
> There's an argument against the prototype changes on dst_attach and
> dst_ca_attach since they aren't frontend.
> </SUMMARY>
> 
> (*) Notice: I can't remember why the patches were not applied on that
> time. I think somebody nacked they, although I didn't found any record
> about the patch on my mailbox.
> 
> About the usage of frontend support for a non-frontend module, I really
> can't see any issues at the current implementation, since even before
> the patch, all DST initialization are done by a routine called
> "frontend_init()". 

*Wrong*.  Frontend Init sends a command to the whole system to
initialize the frontend, Not initialize the DST
Whatever frontend naming conventions are in there are a relic from
Andrew's FE_REFACTORING changesets.

Even dst not being a frontend, the initialization
> gets the result of the attachment process, using it as a "frontend":
> 
> 	state = kmalloc(sizeof (struct dst_state), GFP_KERNEL);
> 
>         state->config = &dst_config;
>         state->i2c = card->i2c_adapter;
>         state->bt = card->bt;
>         state->dst_ca = NULL;
> 
>         dvb_attach(dst_attach, state, &card->dvb_adapter);
> 
>         card->fe = &state->frontend;
> 
> 	(comments and error checks removed to make code cleaner)
> 
> The patch basically moved state initialization to dst_attach. The above
> code, after the patch is:
> 	
> 	card->fe = dvb_attach(dst_attach, &dst_config, card->bt, card->i2c_adapter);
> 
> So, I didn't noticed any regressions by running the modified driver nor
> I couldn't identify any regressions by inspecting the source code. 
> 
> The end result seems also cleaner and easier to understand, preserving
> all characteristics of the original code. Also, it uses dvb_attach the
> same way as the other dvb helper modules.
> 
> If later any changes will be needed to allow using DST on different
> configurations, future patches probably will need to move dst
> initialization to other places, and use different callbacks for it,
> altering the above initialization. I can't see why those changes would
> possibly avoid any further changes at the driver.
> 
> That's said, I intend to commit the two patches, fixing the current
> issues, at this weekend.
> 

I did explain my stand in a previous mail.

NACK

