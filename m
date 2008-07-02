Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbYGBKyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbYGBKyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYGBKyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:54:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbYGBKyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:54:36 -0400
Date: Wed, 2 Jul 2008 11:54:34 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/6] drivers/md: remove null pointer dereference
Message-ID: <20080702105434.GF22522@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0805121537100.3694@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805121537100.3694@ask.diku.dk>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 03:37:31PM +0200, Julia Lawall wrote:
> If pgpath->pg->ps.type is NULL, it is not possible to access its name
> field.  So I have simply modified the error message to drop the printing of
> the name field.
> 
> This problem was found using the following semantic match
> (http://www.emn.fr/x-info/coccinelle/)
 
> --- a/drivers/md/dm-mpath.c	2008-04-16 13:27:57.000000000 +0200
> +++ b/drivers/md/dm-mpath.c	2008-05-12 09:19:35.000000000 +0200
> @@ -884,8 +884,7 @@ static int reinstate_path(struct pgpath 
>  		goto out;
>  
>  	if (!pgpath->pg->ps.type) {
> -		DMWARN("Reinstate path not supported by path selector %s",
> -		       pgpath->pg->ps.type->name);
> +		DMWARN("Reinstate path not supported by path selector");
>  		r = -EINVAL;
>  		goto out;
>  	}
 
Thanks for reporting this.

A more-sophisticated checker might discover that the test can never fail
- see parse_path_selector() - and so the real problem here is that it is
the wrong test.

The next line is:
	r = pgpath->pg->ps.type->reinstate_path(&pgpath->pg->ps, &pgpath->path);
and the error message makes it clear that the intent was to ensure that
the reinstate_path method exists before attempting to use it.

IOW
	if (!pgpath->pg->ps.type->reinstate_path) {

Alasdair
-- 
agk@redhat.com
