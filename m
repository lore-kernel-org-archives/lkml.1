Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0CCOoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:44:37 -0500
Received: from mail-qy0-f198.google.com ([209.85.221.198]:58558 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0CCOog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:44:36 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 09:44:35 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DL3wZL/liwBVF2UkM7ej2dut2MATQGucwXTSG8VPcI/sqP+NMJ/9Pr7Svj+IYMYrTW
         F5IECk/nHrlnwJxZI4lZfIPifFJ6BiWG+aS78R/HJkPB0Nq2Cw4/F0dZJZ7YUAwc6xdK
         4fzyhOrixHJbk0EJhYM7o/wnNRYo1hOrbMPcs=
MIME-Version: 1.0
In-Reply-To: <4B8E4B06.6060405@garzik.org>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
	 <20100302182939.GI3445@oksana.dev.rtsoft.ru>
	 <4B8D80C3.1050006@ru.mvista.com> <4B8D9CED.7040603@garzik.org>
	 <4B8E3CB1.10902@ru.mvista.com> <4B8E4B06.6060405@garzik.org>
Date: Wed, 3 Mar 2010 09:38:46 -0500
Message-ID: <87f94c371003030638x4f8a4e13l4145829cb81db33f@mail.gmail.com>
Subject: Re: [PATCH 09/12] ahci: Introduce ahci_set_em_messages()
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 6:41 AM, Jeff Garzik <jeff@garzik.org> wrote:
> On 03/03/2010 05:40 AM, Sergei Shtylyov wrote:
>>
>> Hello.
>>
>> Jeff Garzik wrote:
>>
>>>>> Factor out some ahci_em_messages handling code from ahci_init_one().
>>>>> We would like to reuse it for non-PCI devices.
>>>>>
>>>>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>>>>> ---
>>>>> drivers/ata/ahci.c | 41 ++++++++++++++++++++++++-----------------
>>>>> 1 files changed, 24 insertions(+), 17 deletions(-)
>>>>>
>>>>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>>>>> index 18443e9..6694b17 100644
>>>>> --- a/drivers/ata/ahci.c
>>>>> +++ b/drivers/ata/ahci.c
>>>>> @@ -3040,6 +3040,29 @@ static inline void
>>>>> ahci_gtf_filter_workaround(struct ata_host *host)
>>>>> {}
>>>>> #endif
>>>>>
>>>>> +static void ahci_set_em_messages(struct ahci_host_priv *hpriv,
>>>>> + struct ata_port_info *pi)
>>>>> +{
>>>>> + u8 messages;
>>>>> + void __iomem *mmio = hpriv->mmio;
>>>>> + u32 em_loc = readl(mmio + HOST_EM_LOC);
>>>>> + u32 em_ctl = readl(mmio + HOST_EM_CTL);
>>>>> +
>>>>> + if (!ahci_em_messages || !(hpriv->cap & HOST_CAP_EMS))
>>>>> + return;
>>>>> +
>>>>> + messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
>>>>> +
>>>>> + /* we only support LED message type right now */
>>>>> + if ((messages & 0x01) && (ahci_em_messages == 1)) {
>>>>> + /* store em_loc */
>>>>> + hpriv->em_loc = ((em_loc >> 16) * 4);
>>>>
>>>> Could drop unneeded parens, while at it...
>>>
>>> While not strictly necessary, parens often help with readability. I
>>> think the above code looks fine as-is. If the reader has to waste a
>>> few seconds recalling C's operator precedence, that detracts from the
>>> easy reading of the code. Not everyone is like me and has worked on a
>>> C compiler, you know ;-)
>>
>> Come on, parens around the right arg of = are pretty counter-intuitive
>> and so don't add to the readability. :-)
>
> <shrug>  I respectfully disagree.  It is wasteful but does not detract from
> readability at all, IMO.
>
>        Jeff


Re:      hpriv->em_loc = ((em_loc >> 16) * 4);

I think the way it is leaves the reader wondering what used to be
there.  ie. It makes me think there used to be a function call that
was removed, but the parens left in place.

I agree with Sergei that it is a readability issue because it sends
the readers brain off into tangents.

Greg
