Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZJVC1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZJVC1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 22:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZJVC1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 22:27:21 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:52370 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZJVC1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 22:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AynoODxiu6DfrBpPMgIBjDQrp3sVL/KKLoknYkjZp9Lj2MAz78SQkl229/5yABq9mB
         S/6B4T0DVDY73n/SviOD2hfJ2IrXd1TNrux62HuKsEISd/7C3yI2Knqw99Imz9gW/14N
         Fu9ITJfFnHC2Cf/Vch8a8W6X4t4sGgQ6Cid1Y=
MIME-Version: 1.0
In-Reply-To: <4ADF35CA.5020207@imap.cc>
References: <4ADB93C4.4090607@imap.cc>
	 <7b6bb4a50910182227y1281b40bj3fcc082d32cf4496@mail.gmail.com>
	 <4ADF35CA.5020207@imap.cc>
Date: Thu, 22 Oct 2009 10:27:25 +0800
Message-ID: <7b6bb4a50910211927k7371aeax1973b295c6f729c@mail.gmail.com>
Subject: Re: possible circular locking dependency in ISDN PPP
From: Xiaotian Feng <xtfeng@gmail.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: LKML <linux-kernel@vger.kernel.org>,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       Netdev <netdev@vger.kernel.org>, Karsten Keil <isdn@linux-pingi.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 12:24 AM, Tilman Schmidt <tilman@imap.cc> wrote:
> Thanks for your analysis. The patch you propose does indeed prevent the
> "circular locking dependency" message, with no noticeable ill effect.
>
> I cannot say why xmit_lock was taken around isdn_net_lp_busy() in the
> first place. The ISDN4Linux people would be the ones to comment on that.
> If none of them objects, I propose you add a Signed-off-by line to your
> patch and submit it to Karsten Keil, the ISDN maintainer, for inclusion.
> You can also add a "Tested-by: Tilman Schmidt <tilman@imap.cc>" line.
>

Sure, I'll prepare a patch and send to Karsten later, Thanks.

> Thanks,
> Tilman
>
> Am 19.10.2009 07:27 schrieb Xiaotian Feng:
>> So there's a circular locking dependency.. Looking into isdn_net_get_locked_lp()
> [...]
>> Why do we need to hold xmit_lock while using
>> isdn_net_lp_busy(nd->queue) ? Can following patch fix this bug?
>>
>> ---
>> diff --git a/drivers/isdn/i4l/isdn_net.h b/drivers/isdn/i4l/isdn_net.h
>> index 74032d0..7511f08 100644
>> --- a/drivers/isdn/i4l/isdn_net.h
>> +++ b/drivers/isdn/i4l/isdn_net.h
>> @@ -83,19 +83,19 @@ static __inline__ isdn_net_local *
>> isdn_net_get_locked_lp(isdn_net_dev *nd)
>>
>>         spin_lock_irqsave(&nd->queue_lock, flags);
>>         lp = nd->queue;         /* get lp on top of queue */
>> -       spin_lock(&nd->queue->xmit_lock);
>>         while (isdn_net_lp_busy(nd->queue)) {
>> -               spin_unlock(&nd->queue->xmit_lock);
>>                 nd->queue = nd->queue->next;
>>                 if (nd->queue == lp) { /* not found -- should never happen */
>>                         lp = NULL;
>>                         goto errout;
>>                 }
>> -               spin_lock(&nd->queue->xmit_lock);
>>         }
>>         lp = nd->queue;
>>         nd->queue = nd->queue->next;
>> +       spin_unlock_irqrestore(&nd->queue_lock, flags);
>> +       spin_lock(&lp->xmit_lock);
>>         local_bh_disable();
>> +       return lp;
>>  errout:
>>         spin_unlock_irqrestore(&nd->queue_lock, flags);
>>         return lp;
>>
>
> --
> Tilman Schmidt                    E-Mail: tilman@imap.cc
> Bonn, Germany
> Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
> Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
>
>
