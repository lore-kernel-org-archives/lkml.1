Return-Path: <linux-kernel-owner+w=401wt.eu-S1423025AbXBHPPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423025AbXBHPPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423044AbXBHPPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:15:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:42244 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423025AbXBHPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:15:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RgJ2J2oZx5BQoiVw01cQid3F19zjxy/J98/CKIEiphmrfNyWOPmrAMR6vEAxaP2R3zdWQH5U3heWQWY+gv8/8NIoPzfQ3wclqRQ1RK1DyRhqC8NxV59uZSlw+lOPxNiA5c4pjgDdhMuJW8b9f9RAy8UDl+EQPFZMzl0P/ivg8rE=
Message-ID: <d120d5000702080715u2902bc81oda4b9250892a1bf2@mail.gmail.com>
Date: Thu, 8 Feb 2007 10:15:16 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: frank.salomon@wincor-nixdorf.com
Subject: Re: EV_MSC / driver/input/input.c (Input Handler)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CAE5A1.80409@wincor-nixdorf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45CAE5A1.80409@wincor-nixdorf.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Frank Salomon <frank.salomon@wincor-nixdorf.com> wrote:
> Hi All,
>
> I had written an additional input_handler :
>
>      static struct input_device_id pcraw_ids[] = {
>             {
>                      .flags = INPUT_DEVICE_ID_MATCH_EVBIT,
>                      .evbit = { BIT(EV_MSC) },
>              },
>             { },    /* Terminating entry */
>      };
>
> to get MSC_RAW events from the atkeyboard :
>
>      input_event (&atkbd->dev, EV_MSC, MSC_RAW, code)
>
> But I only get these events :
>
>      input_event(&atkbd->dev, EV_MSC, MSC_SCAN, code);
>

That is because by default atkbd uses software-emulated raw mode.
bootk with atkbd.softraw=0 or switch it off after boot through sysfs
attribute to get EV_MSC/MSC_RAW passed through).

> I know the reason is in driver/input/input.c :
>
>      case EV_MSC:
>           if (code > MSC_MAX || !test_bit(code, dev->mscbit))
>                return;
>
>           if (dev->event) dev->event(dev, type, code, value);
>           break;
>
> because of (driver/input/keyboard/atkbd.c):
>
>      atkbd->dev.mscbit[0] = atkbd->softraw ? BIT(MSC_SCAN) :
>           BIT(MSC_RAW) | BIT(MSC_SCAN);
>
> I would like to change driver/input/input.c like this :
>
>      case EV_MSC:
>           if (code > MSC_MAX)
>                return;
>
>           if (test_bit(code, dev->mscbit))
>                if (dev->event) dev->event(dev, type, code, value);
>           break;
>
> Any comments ? Maybe I misunderstand the concept of the input events. In
> that case, please give me a short description or let me know were I can
> find any documentation.
>

No, input core should not pass any events device did not claim to support.

What are you trying to do though? Why are you interested in raw atkbd
events? What will your handler do with events from other input devices
that might emit raw events?

-- 
Dmitry
