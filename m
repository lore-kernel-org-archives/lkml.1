Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYLZPx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYLZPx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 10:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYLZPxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 10:53:18 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:29127 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752084AbYLZPxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 10:53:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kLR/M5VJSoBADXGVkSBAhhr0hbtAXWIg6pkp8P6gsUJXeLWvzEJSO6laPdzCJqGpXkwaNseV7s4LQSz8/ZW2J8gEQyg/t8b/cUgF3qzkinUXRGXElkXKacsxZa5dG6IC6aUslYuXi1AhIZYvUqnD/1VTzCtAqI6fYtNaQ+Hm4HM=  ;
X-YMail-OSG: ZT3AKmoVM1lMv5YGnm_NWyTvy12ZffHv47LovPFCK2PJ6qQKPEr9tIRaf6pVXlXc3uqMja.hPdHHF8MogzrILfkxkzGfRL_cNQU9WsrvZblam44uShaeR94vpn0RspoPVyWu4wbj37fx6YkYcOw4AvVgAkg9j7E60AwjKEiJO_2F.sg_RblstJ5f4N6w.uRU3j5uEKQLNgjeOAQo.jByJTe61L7b9b40vPUcMwcTSpd0
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] gpiolib: request fixes
Date: Fri, 26 Dec 2008 07:53:14 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       akpm@linux-foundation.org
References: <20081226052121.6472.22847.sendpatchset@rx1.opensource.se>
In-Reply-To: <20081226052121.6472.22847.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812260753.14981.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 December 2008, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Fix request related issues in gpiolib such as:
>  - fix request-already-requested handling in gpio_request()
>  - clear FLAG_REQUESTED on request error in gpio_direction_input()
>  - clear FLAG_REQUESTED on request error in gpio_direction_output()
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  drivers/gpio/gpiolib.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- 0001/drivers/gpio/gpiolib.c
> +++ work/drivers/gpio/gpiolib.c	2008-12-26 13:09:50.000000000 +0900
> @@ -789,6 +789,7 @@ int gpio_request(unsigned gpio, const ch
>  	} else {
>  		status = -EBUSY;
>  		module_put(chip->owner);
> +		goto done;

Right, good catch.


>  	}
>  
>  	if (chip->request) {
> @@ -924,6 +925,7 @@ int gpio_direction_input(unsigned gpio)
>  			/* and it's not available to anyone else ...
>  			 * gpio_request() is the fully clean solution.
>  			 */
> +			clear_bit(FLAG_REQUESTED, &desc->flags);

NAK, this is insufficient ... it would need to drop the module
refcount and null the label too.  Plus this invalidates the
comment.  (Same below.)

However a basic premise is that drivers should now be avoiding
this legacy autorequest stuff, using gpio_request() instead.

Hence the comments here, below, and at ensure_requested() to
note the lack of cleanup if these legacy paths lose:  small
incentives to "do the right thing".  I'd rather see the work
go into making callers stop using autorequest; not making
that mechanism work better.

It may be time to make ensure_requested() use WARN(), which
will create a lot more noise than the current message ... a
larger incentive. :)


>  			goto lose;
>  		}
>  	}
> @@ -977,6 +979,7 @@ int gpio_direction_output(unsigned gpio,
>  			/* and it's not available to anyone else ...
>  			 * gpio_request() is the fully clean solution.
>  			 */
> +			clear_bit(FLAG_REQUESTED, &desc->flags);
>  			goto lose;
>  		}
>  	}
> 
> 


