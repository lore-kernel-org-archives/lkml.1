Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbZDWO4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbZDWO4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbZDWO4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:56:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43112 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZDWO4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:56:32 -0400
Date: Thu, 23 Apr 2009 15:56:31 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] TWL4030: Make sure the regulator is active after
	calling twl4030reg_enable
Message-ID: <20090423145631.GU30105@sirena.org.uk>
References: <1240492089-14410-1-git-send-email-peter.de-schrijver@nokia.com> <1240492089-14410-2-git-send-email-peter.de-schrijver@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240492089-14410-2-git-send-email-peter.de-schrijver@nokia.com>
X-Cookie: My vaseline is RUNNING...
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:08:09PM +0300, Peter 'p2' De Schrijver wrote:
> This patch makes sure a regulator is active when enabled. After a warm reboot, only adding
> a regulator to a power group is not enough to activate it.

> Signed-off-by: Peter 'p2' De Schrijver <peter.de-schrijver@nokia.com>

CCing people in again.

> ---
>  drivers/regulator/twl4030-regulator.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
> index df9a94b..80a4e10 100644
> --- a/drivers/regulator/twl4030-regulator.c
> +++ b/drivers/regulator/twl4030-regulator.c
> @@ -177,14 +177,21 @@ static int twl4030reg_is_enabled(struct regulator_dev *rdev)
>  static int twl4030reg_enable(struct regulator_dev *rdev)
>  {
>  	struct twlreg_info	*info = rdev_get_drvdata(rdev);
> -	int			grp;
> +	int			grp, status;
> +	unsigned 		message;
>  
>  	grp = twl4030reg_read(info, VREG_GRP);
>  	if (grp < 0)
>  		return grp;
>  
>  	grp |= P1_GRP;
> -	return twl4030reg_write(info, VREG_GRP, grp);
> +	status =  twl4030reg_write(info, VREG_GRP, grp);
> +	if (status < 0)
> +		return status;
> +
> +	message = MSG_SINGULAR(DEV_GRP_P1, info->id, RES_STATE_ACTIVE);
> +
> +	return twl4030_send_pb_msg(message);
>  }
>  
>  static int twl4030reg_disable(struct regulator_dev *rdev)
> -- 
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."
