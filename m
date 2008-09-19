Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYISHdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYISHdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYISHc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:32:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:61160 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYISHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BF8TUNxg/lQKdlIkEoZ8fSduiZRss23IrA4StYCJ4oH0LpjvTDJTEJwbLr+oYIPlrg
         vF9OMTI/yhV10wiki9jkXqPt5IPB24N+ptLN/E7CA819weFHtF14j52p2QZdGfFrlOX1
         4UXRML7+jAo/8YtHbDesWp3PE56akHPW3Dw4M=
Date: Fri, 19 Sep 2008 11:32:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement
	ARRAY_SIZE().
Message-ID: <20080919073254.GB7222@lenovo>
References: <20080918132447.516309749@fluff.org.uk> <20080918150624.GA3421@x200.localdomain> <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com> <20080919065426.GA7222@lenovo> <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric Miao - Fri, Sep 19, 2008 at 03:22:13PM +0800]
| On Fri, Sep 19, 2008 at 2:54 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > [Eric Miao - Fri, Sep 19, 2008 at 02:38:21AM +0800]
| > | On Thu, Sep 18, 2008 at 11:06 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
| > | > On Thu, Sep 18, 2008 at 02:24:47PM +0100, Ben Dooks wrote:
| > | >> Move the ARRAY_AND_SIZE() macro from arch/arm/mach-pxa/generic.h
| > | >> to a more useful position in include/linux/kernel.h. This macro
| > | >> is very useful to registration functions that take an array and
| > | >> the number of array elements in it as consecutive arguments.
| > | >>
| > | >> The macro also should ensure that mistakes where the wrong array
| > | >> is used to the ARRAY_SIZE() macro is passed. It also makes it
| > | >> easier to avoid wrapping registration function arguments.
| > | >
| > | >> --- linux-2.6.27-rc6-quilt4.orig/include/linux/kernel.h
| > | >> +++ linux-2.6.27-rc6-quilt4/include/linux/kernel.h
| > | >> @@ -43,6 +43,7 @@ extern const char linux_proc_banner[];
| > | >>  #define IS_ALIGNED(x, a)             (((x) & ((typeof(x))(a) - 1)) == 0)
| > | >>
| > | >>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
| > | >> +#define ARRAY_AND_SIZE(arr) (arr), ARRAY_SIZE(arr)
| > | >
| > | > Just like ARRAY_SIZE, it is misnamed.
| > | >
| > |
| > | Any hint about the correct spelling?
| > |
| > | > And it isn't obvious to what it expands. Hopefully arm people will
| > | > remove it. :-)
| > |
| > | This is handy to use, saving several key strokes and making the line
| > | shorter. If it's not obvious to what it expands, there must be some
| > | fix for it?
| > |
| >
| > well, it seems it's not that good to use ARRAY_AND_SIZE at all.
| > Yes it's short but quite frankly - hiding number of args is not
| > that good.
| >
| > example
| >
| >        static void ssp_send_cmd(uint32_t *cmd, int num);
| >
| > called as
| >
| >        ssp_send_cmd(ARRAY_AND_SIZE(lcd_panel_on));
| >
| > thanks it's not that spreaded across kernel.
| > Someday it could lead to ARRAY_AND_SIZE_CHECK_IF_EXIST_AND_PANIC :)
| 
| Probably that not gonna happen.
| 
| without ARRAY_AND_SIZE:
| 
|         ssp_send_cmd(lcd_panel_on, ARRAY_SIZE(lcd_panel_on));
| 
| with:
| 
|         ssp_send_cmd(ARRAY_AND_SIZE(lcd_panel_on));
| 
| where you don't have to repeat the array name. I have to admit
| that a macro expanding to something like an argument list instead
| of a single variable or something  is not a good idea. But, we are
| using C, and there's no easy way just to pass the array itself,
| otherwise one may come up with:
| 
|         ssp_send_cmd(lcd_panel_on);
| 
| ssp_send_cmd(array a)
| {
|         int size = a.length();
| 
| ........
| }
| 
| I'm not trying to buy anyone anything, just illustrate this, and see
| if anyone else is interested in doing so.
| 

Absolutely agreed with this (ie pass _one_ array name). Would
be a good cleanup.

		- Cyrill -
