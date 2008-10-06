Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYJFBZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYJFBZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 21:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYJFBZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 21:25:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:8383 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYJFBZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 21:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=JRySUgSXrmaDPqtuhDJenw6gB+sMFgi0hntVSapCMgAmE8qZx21kVfVZX318giYjJ8
         twChZ1NJsGgBVipPgwLNmh3qvv5r8Bx76D84q6Xkpr5DP18qfAAwhRChL0bMCodCeEuR
         cttjJAbkUM6ZErdv3c1DOddenXPMk17CGlBSU=
Message-ID: <919fe2b30810051825l4f0907d1ucc9ffe9f201ddc4f@mail.gmail.com>
Date: Sun, 5 Oct 2008 21:25:06 -0400
From: "M. Asselstine" <asselsm@mcmaster.ca>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 2/2] drivers/s390/cio/chsc_sch.c: Correct use of ! and &
Cc: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0810042205090.19286@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810042205090.19286@ask.diku.dk>
X-Google-Sender-Auth: bb233e02e72c6bd0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 4:05 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
> involved converting !x & y to !(x & y).  The code below shows the same
> pattern, and thus should perhaps be fixed in the same way.  In particular,
> the result of !scsw_stctl(&request->irb.scsw) & SCSW_STCTL_STATUS_PEND is
> always just !scsw_stctl(&request->irb.scsw).
>
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@ expression E; constant C; @@
> (
>  !E & !C
> |
> - !E & C
> + !(E & C)
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Mark Asselstine <mark.asselstine@windriver.com>

>
> ---
>  drivers/s390/cio/chsc_sch.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -u -p a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
> --- a/drivers/s390/cio/chsc_sch.c
> +++ b/drivers/s390/cio/chsc_sch.c
> @@ -261,7 +261,7 @@ static int chsc_examine_irb(struct chsc_
>  {
>        int backed_up;
>
> -       if (!scsw_stctl(&request->irb.scsw) & SCSW_STCTL_STATUS_PEND)
> +       if (!(scsw_stctl(&request->irb.scsw) & SCSW_STCTL_STATUS_PEND))
>                return -EIO;
>        backed_up = scsw_cstat(&request->irb.scsw) & SCHN_STAT_CHAIN_CHECK;
>        request->irb.scsw.cmd.cstat &= ~SCHN_STAT_CHAIN_CHECK;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
