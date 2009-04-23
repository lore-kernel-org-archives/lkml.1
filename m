Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbZDWVx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbZDWVx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZDWVxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:53:49 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:25084 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753174AbZDWVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:53:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WQxnc2/B5QRXKYgfhqL+aZ+696fbSeQdnArc+SZ+BTOLve5VMaPNcblBiox2p1XYZJKzRpyJZp0BW8XqYCu/fMWcKeUyN6lw+/NoIi9gxgQwUSSEBIkDQfFhYz6B5QwOt6rm8XWfMKSvOxMb7fhlZLPLMQrgSTYXmUvAKXMPNI0=  ;
X-YMail-OSG: xnGXKP8VM1kphdMcpmWhA6sIXeAWHknZbM_reyZN2VL7KLGuF774BbvqDUmSTDqSZYVe.aQYvxT.Z2MidM7YmK5dNGVmIQukXVOuQNg4Q1B5XYR.uio7qjIlxsQGBq4YzUG_DajlGqTQGi_O_KqkMgb0Mr7z2QOKpKEKIyK.AKDz5VS_MHtuP5uH7bErp9Y8_STfSjA3ANzhW3mtdIA.06Nv2IWWTOnUbEiaqfrgqMi9Ac1AaUOvo2em_7GdwiguRr1_ZeOA4j.4uBaqLV86mwpvwC0EcIOMvsiqrhIPsNamQU2XUw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Subject: Re: [PATCH 1/1] TWL4030: Activate VDD1, VDD2 and VPLL1 at startup
Date: Thu, 23 Apr 2009 14:53:47 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1240492208-14791-1-git-send-email-peter.de-schrijver@nokia.com> <1240492208-14791-2-git-send-email-peter.de-schrijver@nokia.com>
In-Reply-To: <1240492208-14791-2-git-send-email-peter.de-schrijver@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904231453.47223.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Peter 'p2' De Schrijver wrote:
> This patch activates VDD1, VDD2 and VPLL1 when booting. This is necessary
> because these resources are in warm reset state after a reboot.

Warm reset state?  I thought there were only ACTIVE, SLEEP, and OFF
states for individual resources.  Do you mean SLEEP?  And if so, is
this not something that should be dealt with by the power script
which runs inside the twl4030 when it handles the warm reset event?

I thought those regulators couldn't provide enough power from SLEEP
state to let the system boot.  So being able to run this code means
they're not in SLEEP state...

Please explain.  (Remembering that most of us haven't really looked
in much detail at this level of reset even handling!)


> This means 
> their voltage levels cannot be modified so DVFS and smartreflex don't work.

Three thoughts on this:

 - These three switching regulators are currently ignored by this
   driver, because I've expected them to be managed as part of the
   DVFS framework.  (Mostly via the hardware SmartReflex support.
   They don't seem particularly geared for software control.)

   It seems odd to add these hooks for regulators that are otherwise
   consciously ignored by this driver, and not software-controlled...

 - This *could* be done with the twl4030-power.c (nyet in mainline)
   resource_config hooks.  But those hooks are board-specific (and
   nyet in mainline), while these should "always" be done.

   Should we maybe have all those power resource init hooks done
   by the twl4030_core.c code?  So as to work even if regulator
   and power (script) drivers aren't present.

 - The policy you described is specific to OMAP3 ... so shouldn't
   these changes be conditionalized so they only kick in on OMAP3
   based platforms?  (Just as code-cleanliness for now; no other
   platform yet uses these PMIC solutions, that I've heard of.)

   And if they only matter for DVFS + SmartReflex ... should they
   maybe be conditionalized for those, too?  (Minor point at best;
   it "shouldn't" hurt to do this at other times too.)  Or maybe
   even put into a twl4030-smartreflex.c driver, if there'd be
   much for that to do.  Setting FLOOR and CEILING voltages and
   other stuff in section 5.5.1 of the tps65950 manual (step 4),
   for example.

Having this in twl4030-core.c would affect the patch you sent to
move the "send PowerBus message" logic to its own function; that
would need to be in twl4030_core too.

- Dave


> 
> Signed-off-by: Peter 'p2' De Schrijver <peter.de-schrijver@nokia.com>
> ---
>  drivers/regulator/twl4030-regulator.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
> index 80a4e10..ab2a726 100644
> --- a/drivers/regulator/twl4030-regulator.c
> +++ b/drivers/regulator/twl4030-regulator.c
> @@ -506,6 +506,22 @@ static int twl4030reg_probe(struct platform_device *pdev)
>  	}
>  	platform_set_drvdata(pdev, rdev);
>  
> +	/* VDD1, VDD2 and VPLL1 are left in warm reset state after a reboot.
> +	 * We need to put them back to active state for DVFS and smartreflex.
> +	 */
> +
> +	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VDD1,
> +		RES_STATE_ACTIVE)) < 0)
> +		pr_err("Unable to activate VDD1\n");
> +
> +	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VDD2,
> +		RES_STATE_ACTIVE)) < 0)
> +		pr_err("Unable to activate VDD2\n");
> +
> +	if (twl4030_send_pb_msg(MSG_SINGULAR(DEV_GRP_P1, RES_VPLL1,
> +		RES_STATE_ACTIVE)) < 0)
> +		pr_err("Unable to activate VPLL1\n");
> +
>  	/* NOTE:  many regulators support short-circuit IRQs (presentable
>  	 * as REGULATOR_OVER_CURRENT notifications?) configured via:
>  	 *  - SC_CONFIG
> -- 
> 1.5.6.3
> 
> 


