Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZIKJl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZIKJl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZIKJl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:41:28 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:37171 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZIKJl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A5fANbzku7dCANA9JVOSME8pe8pYroFEFvO79ttOjdtz78tgmD6moe9DXMWsJAkkzU
         +Ei+ZUaH4ZTL8LYiMmtVSbrXq0/jFPZMmTGj6xJ46hD+eKbt4Su0yqsWkkhp9uXhkrR1
         NVL4g4/srY/+WDE90gm3gg7Ze18QL6ynbnwmE=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0909111128250.31018@swampdragon.chaosbits.net>
References: <af3ea28a0909110211o559657e6hc62947708b4fc55d@mail.gmail.com>
	 <alpine.LNX.2.00.0909111128250.31018@swampdragon.chaosbits.net>
Date: Fri, 11 Sep 2009 17:41:30 +0800
Message-ID: <af3ea28a0909110241w664d260eye09ba32f75df8d1d@mail.gmail.com>
Subject: Re: [PATCH] remove variable length array tuner-xc2028
From: ye janboe <janboe.ye@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: dwmw2@infradead.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thank you for your comments, Jesper

I will update the patch later after I fix the issue gmail wrap my patch:-(

2009/9/11 Jesper Juhl <jj@chaosbits.net>:
> On Fri, 11 Sep 2009, ye janboe wrote:
>
>> hi
>>
>> using variable length array on kernel stack is not safe, so this patch
>> using kmalloc instead variable length array in tuner-xc2028
>>
>> Signed-off-by: janboe <janboe.ye@gmail.com>
>> ---
>>  drivers/media/common/tuners/tuner-xc2028.c |   26 ++++++++++++++++----------
>>  1 files changed, 16 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/common/tuners/tuner-xc2028.c
>> b/drivers/media/common/tuners/tuner-xc2028.c
>> index 1adce9f..96259c5 100644
>> --- a/drivers/media/common/tuners/tuner-xc2028.c
>> +++ b/drivers/media/common/tuners/tuner-xc2028.c
>> @@ -516,8 +516,8 @@ static int load_firmware(struct dvb_frontend *fe,
>> unsigned int type,
>>                        v4l2_std_id *id)
>>  {
>>       struct xc2028_data *priv = fe->tuner_priv;
>> -     int                pos, rc;
>> -     unsigned char      *p, *endp, buf[priv->ctrl.max_len];
>> +     int                pos, rc, ret = -EINVAL;
>> +     unsigned char      *p, *endp, *buf;
>>
>>       tuner_dbg("%s called\n", __func__);
>>
>> @@ -532,6 +532,7 @@ static int load_firmware(struct dvb_frontend *fe,
>> unsigned int type,
>>
>>       p = priv->firm[pos].ptr;
>>       endp = p + priv->firm[pos].size;
>> +     buf = kmalloc(priv->ctrl.max_len, GFP_KERNEL);
>>
>
> The call to kmalloc() could fail, so shouldn't we make this
>
>     buf = kmalloc(priv->ctrl.max_len, GFP_KERNEL);
>     if (!buf)
>       return -ENOMEM;
>
> or?
>
>
>>       while (p < endp) {
>>               __u16 size;
>> @@ -539,14 +540,16 @@ static int load_firmware(struct dvb_frontend
>> *fe, unsigned int type,
>>               /* Checks if there's enough bytes to read */
>>               if (p + sizeof(size) > endp) {
>>                       tuner_err("Firmware chunk size is wrong\n");
>> -                     return -EINVAL;
>> +                     goto fail;
>>               }
>>
>>               size = le16_to_cpu(*(__u16 *) p);
>>               p += sizeof(size);
>>
>> -             if (size == 0xffff)
>> -                     return 0;
>> +             if (size == 0xffff) {
>> +                     ret = 0;
>> +                     goto fail;
>> +             }
>>
>>               if (!size) {
>>                       /* Special callback command received */
>> @@ -554,7 +557,7 @@ static int load_firmware(struct dvb_frontend *fe,
>> unsigned int type,
>>                       if (rc < 0) {
>>                               tuner_err("Error at RESET code %d\n",
>>                                          (*p) & 0x7f);
>> -                             return -EINVAL;
>> +                             goto fail;
>>                       }
>>                       continue;
>>               }
>> @@ -565,13 +568,13 @@ static int load_firmware(struct dvb_frontend
>> *fe, unsigned int type,
>>                               if (rc < 0) {
>>                                       tuner_err("Error at RESET code %d\n",
>>                                                 (*p) & 0x7f);
>> -                                     return -EINVAL;
>> +                                     goto fail;
>>                               }
>>                               break;
>>                       default:
>>                               tuner_info("Invalid RESET code %d\n",
>>                                          size & 0x7f);
>> -                             return -EINVAL;
>> +                             goto fail;
>>
>>                       }
>>                       continue;
>> @@ -586,7 +589,7 @@ static int load_firmware(struct dvb_frontend *fe,
>> unsigned int type,
>>               if ((size + p > endp)) {
>>                       tuner_err("missing bytes: need %d, have %d\n",
>>                                  size, (int)(endp - p));
>> -                     return -EINVAL;
>> +                     goto fail;
>>               }
>>
>>               buf[0] = *p;
>> @@ -603,7 +606,7 @@ static int load_firmware(struct dvb_frontend *fe,
>> unsigned int type,
>>                       rc = i2c_send(priv, buf, len + 1);
>>                       if (rc < 0) {
>>                               tuner_err("%d returned from send\n", rc);
>> -                             return -EINVAL;
>> +                             goto fail;
>>                       }
>>
>>                       p += len;
>> @@ -611,6 +614,9 @@ static int load_firmware(struct dvb_frontend *fe,
>> unsigned int type,
>>               }
>>       }
>>       return 0;
>
> Why are we not freeing 'buf' here?
> Previously it was an array on the stack and would be gone now and I don't
> see what has changed so that it should live on after we return here.
>
>
>> +fail:
>> +     kfree(buf);
>> +     return ret;
>>  }
>>
>>  static int load_scode(struct dvb_frontend *fe, unsigned int type,
>
>
> --
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
>
>
