Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZFRTRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZFRTRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZFRTRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:17:34 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48193 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZFRTRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:17:33 -0400
Subject: Re: [PATCH] clocksource: save mult_orig in clocksource_disable()
From: john stultz <johnstul@us.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, lethal@linux-sh.org,
       tglx@linutronix.de, akpm@linux-foundation.org
In-Reply-To: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
References: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 12:17:12 -0700
Message-Id: <1245352632.7508.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 00:24 +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Save clocksource mult_orig in clocksource_disable().
> 
> To fix the common case where ->enable() does not setup
> mult, make sure mult_orig is saved in mult on disable.
> 
> Also add comments to explain why we do this.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Acked-by: John Stultz <johnstul@us.ibm.com>

Thomas, Andrew, please push this for 2.6.31.

thanks
-john


> ---
> 
>  include/linux/clocksource.h |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> --- 0001/include/linux/clocksource.h
> +++ work/include/linux/clocksource.h	2009-06-19 00:12:16.000000000 +0900
> @@ -293,7 +293,11 @@ static inline int clocksource_enable(str
>  	if (cs->enable)
>  		ret = cs->enable(cs);
> 
> -	/* save mult_orig on enable */
> +	/* The frequency may have changed while the clocksource
> +	 * was disabled. If so the code in ->enable() must update
> +	 * the mult value to reflect the new frequency. Make sure
> +	 * mult_orig follows this change.
> +	 */
>  	cs->mult_orig = cs->mult;
> 
>  	return ret;
> @@ -309,6 +313,12 @@ static inline int clocksource_enable(str
>   */
>  static inline void clocksource_disable(struct clocksource *cs)
>  {
> +	/* Save mult_orig in mult so clocksource_enable() can
> +	 * restore the value regardless if ->enable() updates
> +	 * the value of mult or not.
> +	 */
> +	cs->mult = cs->mult_orig;
> +
>  	if (cs->disable)
>  		cs->disable(cs);
>  }

