Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZDYWMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZDYWMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZDYWMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:12:05 -0400
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:39352 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752852AbZDYWME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:12:04 -0400
X-Yahoo-Newman-Id: 851672.12365.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=POTOjnNUP62ZXG4Mc/SAw/eXsMZib3G1QcoWHmjVu/R6izyOcxhNreWALeIFX52NHfUzfcYoYMjCiXwHwj1bmVp5107IwK/gx83+auTX3vv/E5eklCM39SQLd2LN88KmXR4GiDUTfZi04vy4eCTup2n3hUvBEMvB3T0YA1LdbMs=  ;
X-YMail-OSG: lhbXNCoVM1lN4qgM.jMmNwYc5kF8VS_yurCge6eNzQkucUGrK9jmCXve0YoXNDrSEkFzBC8KdVuNUtRAElvsQbXTWfHfMCXwCqGwmu51PCBfuVzNxYcXRDk6iiGRB5eQ9IqTYlOms1cXHOvWh7AsTRrhCVO5_5_MgMgcVEU4P0cTeP4PE04pek0SSkeFBdZ6y9AICg3M7f7H.t7_i3OmVyvfcIrE6sIDbpYsam0DsfcV07DVnq7togJPu6pKfYvs3a13EE6GIUWLWQsQxKIz7qwz1IUNJoMPP7KIDkVsylA52bLuk7BPU8YGwXPdvbs.pvWOpt0pE2P25bGtSwOKSg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator core: fix double-free in regulator_register() error path
Date: Sat, 25 Apr 2009 15:11:56 -0700
User-Agent: KMail/1.9.10
Cc: Paul Walmsley <paul@pwsan.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904251511.57390.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 April 2009, Paul Walmsley wrote:
> 
> During regulator registration, any error after device_register() will 
> cause a double-free on the struct regulator_dev 'rdev'.  The bug is in 
> drivers/regulator/core.c:regulator_register():
> 
> ...
> scrub:
> 	device_unregister(&rdev->dev);
> clean:
> 	kfree(rdev);                           <---
> 	rdev = ERR_PTR(ret);
> 	goto out;
> ...
> 
> device_unregister() calls regulator_dev_release() which frees rdev.  The 
> subsequent kfree corrupts memory and causes some OMAP3 systems to oops on 
> boot in regulator_get().
> 
> Applies against 2.6.30-rc3.
> 
> Signed-off-by: Paul Walmsley <paul@pwsan.com>

This looks like it would address the oopsing I mentioned a
while back, since affects cleanup paths after errors during
driver probe().


> ---
>  drivers/regulator/core.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 01f7702..fabd2e0 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2080,6 +2080,10 @@ out:
>  
>  scrub:
>  	device_unregister(&rdev->dev);
> +	/* device core frees rdev */
> +	rdev = ERR_PTR(ret);
> +	goto out;
> +
>  clean:
>  	kfree(rdev);
>  	rdev = ERR_PTR(ret);
> -- 
> 1.6.3.rc1.51.gea0b7
> 
> 



