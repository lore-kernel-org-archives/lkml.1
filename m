Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbYISP2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYISP2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYISP2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:28:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:7237 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYISP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OxmbcLqA1RTh77C3KERaAuwOx8SoGEo3KptUEEHu8/MGPLGlle5OHkB72HsGwuuAjb
         G+SNotsyQW2JCdNSvVTNc/6Cr6YotLYoZuHKFFXqZ131+iwhZxnt2RW3p4Y18vhN1USr
         cH6Ipu+NfrWnq9A+t6ifbYmqbJvjX67nbNMVo=
Message-ID: <f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com>
Date: Fri, 19 Sep 2008 08:28:45 -0700
From: "Russ Dill" <russ.dill@gmail.com>
To: "Eric Miao" <eric.y.miao@gmail.com>
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement ARRAY_SIZE().
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Ben Dooks" <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
In-Reply-To: <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080918132447.516309749@fluff.org.uk>
	 <20080918150624.GA3421@x200.localdomain>
	 <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com>
	 <20080919065426.GA7222@lenovo>
	 <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 12:22 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Fri, Sep 19, 2008 at 2:54 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> [Eric Miao - Fri, Sep 19, 2008 at 02:38:21AM +0800]
>> | On Thu, Sep 18, 2008 at 11:06 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> | > On Thu, Sep 18, 2008 at 02:24:47PM +0100, Ben Dooks wrote:
>> | >> Move the ARRAY_AND_SIZE() macro from arch/arm/mach-pxa/generic.h
>> | >> to a more useful position in include/linux/kernel.h. This macro
>> | >> is very useful to registration functions that take an array and
>> | >> the number of array elements in it as consecutive arguments.
>> | >>
>> | >> The macro also should ensure that mistakes where the wrong array
>> | >> is used to the ARRAY_SIZE() macro is passed. It also makes it
>> | >> easier to avoid wrapping registration function arguments.
>> | >
>> | >> --- linux-2.6.27-rc6-quilt4.orig/include/linux/kernel.h
>> | >> +++ linux-2.6.27-rc6-quilt4/include/linux/kernel.h
>> | >> @@ -43,6 +43,7 @@ extern const char linux_proc_banner[];
>> | >>  #define IS_ALIGNED(x, a)             (((x) & ((typeof(x))(a) - 1)) == 0)
>> | >>
>> | >>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>> | >> +#define ARRAY_AND_SIZE(arr) (arr), ARRAY_SIZE(arr)
>> | >
>> | > Just like ARRAY_SIZE, it is misnamed.
>> | >
>> |
>> | Any hint about the correct spelling?
>> |
>> | > And it isn't obvious to what it expands. Hopefully arm people will
>> | > remove it. :-)
>> |
>> | This is handy to use, saving several key strokes and making the line
>> | shorter. If it's not obvious to what it expands, there must be some
>> | fix for it?
>> |
>>
>> well, it seems it's not that good to use ARRAY_AND_SIZE at all.
>> Yes it's short but quite frankly - hiding number of args is not
>> that good.
>>
>> example
>>
>>        static void ssp_send_cmd(uint32_t *cmd, int num);
>>
>> called as
>>
>>        ssp_send_cmd(ARRAY_AND_SIZE(lcd_panel_on));
>>
>> thanks it's not that spreaded across kernel.
>> Someday it could lead to ARRAY_AND_SIZE_CHECK_IF_EXIST_AND_PANIC :)
>
> Probably that not gonna happen.
>
> without ARRAY_AND_SIZE:
>
>        ssp_send_cmd(lcd_panel_on, ARRAY_SIZE(lcd_panel_on));
>
> with:
>
>        ssp_send_cmd(ARRAY_AND_SIZE(lcd_panel_on));
>
> where you don't have to repeat the array name. I have to admit
> that a macro expanding to something like an argument list instead
> of a single variable or something  is not a good idea. But, we are
> using C, and there's no easy way just to pass the array itself,
> otherwise one may come up with:
>
>        ssp_send_cmd(lcd_panel_on);
>
> ssp_send_cmd(array a)
> {
>        int size = a.length();
>
> ........
> }
>
> I'm not trying to buy anyone anything, just illustrate this, and see
> if anyone else is interested in doing so.
>

My vote is for ARRAY_AND_SIZE to spread far and wide across the land.
ARRAY_SIZE is already very safe, as it has a __must_be_array macro
built in. So ARRAY_AND_SIZE is even safer, as it prevents you from
mixing up two different arrays. It also reduces line length and makes
driver and device (usually platform_device) registration code easier
to read.
