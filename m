Return-Path: <linux-kernel-owner+w=401wt.eu-S932831AbXHJNKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbXHJNKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbXHJNKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:10:31 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1475 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbXHJNKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:10:30 -0400
Message-ID: <46BC6384.8080504@shadowen.org>
Date: Fri, 10 Aug 2007 14:09:24 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@wp.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       drfickle@us.ibm.com, mel@csn.ul.ie
Subject: Re: 2.6.23-rc2-mm1 -- PPC G5 kernel compile failure (patch)
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>	<20070809130449.GB3091@shadowen.org> <20070809162006.00197118.krzysztof.h1@wp.pl>
In-Reply-To: <20070809162006.00197118.krzysztof.h1@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Helt wrote:
> On Thu, 9 Aug 2007 14:04:49 +0100
> Andy Whitcroft <apw@shadowen.org> wrote:
> 
>> Seeing the following compile error on a G5 mac:
>>
>>   drivers/video/tdfxfb.c: In function 'tdfxfb_setup':
>>   drivers/video/tdfxfb.c:1341: error: 'opt' undeclared (first use in this
>>                                                                  function)
>>   drivers/video/tdfxfb.c:1341: error: (Each undeclared identifier is
>>                                                         reported only once
>>   drivers/video/tdfxfb.c:1341: error: for each function it appears in.)
>>
>> This seems to be the following fragment from tdfxfb-hardware-cursor:
>>
>> +               } else if (!strcmp(this_opt, "hwcursor")) {
>> +                       hwcursor = simple_strtoul(opt + 9, NULL, 0);
>>
>> I guess the nieve fix would be s/opt/this_opt, but I am also
>> suspicious of the +9 here as hwcursor is only 8 long?  Now this
>> seems to take a numeric value and I assume that is via hwcursor=N,
>> if so then the +9 would make sense _if_ the strcmp was against
>> "hwcursor=".
>>
> 
> The patch below fixes all issues you have pointed out. It also fixes
> the description of the nomtrr option.
> 
> ---
> 
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> This patch fixes compilation with setup options bug and corrects
> description of the nomtrr option.
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> ---
> 
> --- linux-2.6.22.new/drivers/video/tdfxfb.c	2007-08-09 16:11:23.870028259 +0200
> +++ linux-2.6.23/drivers/video/tdfxfb.c	2007-08-09 16:15:07.654781024 +0200
> @@ -1337,8 +1337,8 @@ static void tdfxfb_setup(char *options)
>  			nopan = 1;
>  		} else if (!strcmp(this_opt, "nowrap")) {
>  			nowrap = 1;
> -		} else if (!strcmp(this_opt, "hwcursor")) {
> -			hwcursor = simple_strtoul(opt + 9, NULL, 0);
> +		} else if (!strncmp(this_opt, "hwcursor=", 9)) {
> +			hwcursor = simple_strtoul(this_opt + 9, NULL, 0);
>  #ifdef CONFIG_MTRR
>  		} else if (!strncmp(this_opt, "nomtrr", 6)) {
>  			nomtrr = 1;
> @@ -1409,7 +1409,7 @@ MODULE_PARM_DESC(hwcursor, "Enable hardw
>  			"(1=enable, 0=disable, default=1)");
>  #ifdef CONFIG_MTRR
>  module_param(nomtrr, bool, 0);
> -MODULE_PARM_DESC(nomtrr, "Disable MTRR support (0 or 1=disabled) (default=0)");
> +MODULE_PARM_DESC(nomtrr, "Disable MTRR support (default: enabled)");
>  #endif
>  
>  module_init(tdfxfb_init);

Confirmed that this gets my kernel compiled and the result boots.

Tested-by: Andy Whitcroft <apw@shadowen.org>

-apw
