Return-Path: <linux-kernel-owner+w=401wt.eu-S1762379AbZDJBGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762379AbZDJBGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZDJBGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:06:21 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:61407 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbZDJBGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H16+KqjuEsCyD0VkX+SnOhIkffkEUpIe+o7uIYFPU0MqY+gHmplfxmFAypWyIWfsNT
         NvqKXt1Nn+agZA1BrU6uxTYIYGrmlb3cFdvccd9SyTgvFsRWEtteOlJIjgtfu3NYKhd4
         6a+v7A0NMcpsDDh86FiI0ibmniwg9eGn4DACg=
MIME-Version: 1.0
In-Reply-To: <9c9fda240904090959w6b72d08fm9347fd8b0a30eafc@mail.gmail.com>
References: <90b950fc0904090059l39229aa9hd3399782a15e1bf9@mail.gmail.com>
	 <9c9fda240904090959w6b72d08fm9347fd8b0a30eafc@mail.gmail.com>
Date: Fri, 10 Apr 2009 10:06:18 +0900
Message-ID: <90b950fc0904091806r106d9f75k50b738574b20aaf5@mail.gmail.com>
Subject: Re: It has added ARGB1888 and ARGB4888 features to Samsung SoC 
	Framebuffer driver.
From: InKi Dae <daeinki@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: ben-linux@fluff.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Kyungmin,

Signed-off-by: InKi Dae <daeinki@gmail.com, inki.dae@samsung.com>

2009/4/10 Kyungmin Park <kmpark@infradead.org>:
> Hi,
>
> On Thu, Apr 9, 2009 at 12:59 AM, InKi Dae <daeinki@gmail.com> wrote:
>> This patch supports ARGB1888 and ARGB4888 for Samsung SoC Framebuffer
>> driver. (s3c-fb.c)
>> I tested and is working fine.
>>
>> If this patch has any problem, please let me know.
>> I'll look forward to applying to mainline.
>>
>> Thank you,
>> InKi Dae.
>
> Please give you signed-off-by here and more descriptions
>
>>
>> ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
>> index e0e7899..55d2298 100644
>> --- a/drivers/video/s3c-fb.c
>> +++ b/drivers/video/s3c-fb.c
>> @@ -358,9 +358,16 @@ static int s3c_fb_set_par(struct fb_info *info)
>>  writel(data, regs + VIDOSD_B(win_no));
>>
>>  data = var->xres * var->yres;
>> +
>> + u32 osdc_data = 0;
>> +
>> + osdc_data = VIDISD14C_ALPHA1_R(0xf) |
>> +  VIDISD14C_ALPHA1_G(0xf) |
>> +  VIDISD14C_ALPHA1_B(0xf);
>> +
>>  if (s3c_fb_has_osd_d(win_no)) {
>>   writel(data, regs + VIDOSD_D(win_no));
>> -  writel(0, regs + VIDOSD_C(win_no));
>> +  writel(osdc_data, regs + VIDOSD_C(win_no));
>>  } else
>>   writel(data, regs + VIDOSD_C(win_no));
>>
>> @@ -409,8 +416,12 @@ static int s3c_fb_set_par(struct fb_info *info)
>>     data |= WINCON1_BPPMODE_19BPP_A1666;
>>    else
>>     data |= WINCON1_BPPMODE_18BPP_666;
>> -  } else if (var->transp.length != 0)
>> -   data |= WINCON1_BPPMODE_25BPP_A1888;
>> +  } else if (var->transp.length == 1)
>> +   data |= WINCON1_BPPMODE_25BPP_A1888
>> +    | WINCON1_BLD_PIX;
>> +  else if (var->transp.length == 4)
>> +   data |= WINCON1_BPPMODE_28BPP_A4888
>> +    | WINCON1_BLD_PIX | WINCON1_ALPHA_SEL;
>>   else
>>    data |= WINCON0_BPPMODE_24BPP_888;
>>
>> @@ -418,6 +429,20 @@ static int s3c_fb_set_par(struct fb_info *info)
>>   break;
>>  }
>>
>> + /* It has no color key control register for window0 */
>> + if (win_no > 0) {
>> +  u32 keycon0_data = 0, keycon1_data = 0;
>> +
>> +  keycon0_data = ~(WxKEYCON0_KEYBL_EN |
>> +    WxKEYCON0_KEYEN_F |
>> +    WxKEYCON0_DIRCON) | WxKEYCON0_COMPKEY(0);
>> +
>> +  keycon1_data = WxKEYCON1_COLVAL(0xffffff);
>> +
>> +  writel(keycon0_data, regs + WxKEYCONy(win_no-1, 0));
>> +  writel(keycon1_data, regs + WxKEYCONy(win_no-1, 1));
>> + }
>> +
>>  writel(data, regs + WINCON(win_no));
>>  writel(0x0, regs + WINxMAP(win_no));
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
