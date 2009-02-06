Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZBFIAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZBFIAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZBFIAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:00:32 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:24222 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbZBFIAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:00:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eUMjFX0dJtDh7ccpqLaf9JPTVvfHV9J9TWc7g71rYXHAola6dFHZ95jYM6KD2ezF5O
         GtV+r1NoXh+Vkuqw3ODA4t03UVSEmZRbZ2gKrfvRqnYWFBG6yOc80Q6LLJvkkhcO+PZk
         BVsylf9xXD8IBKmrOJb5ps86YAE6bqv1o22j4=
MIME-Version: 1.0
In-Reply-To: <386072610902052347m5754262bif18339809a00cb9f@mail.gmail.com>
References: <1233819002-6912-1-git-send-email-cooloney@kernel.org>
	 <1233846195.3028.14.camel@localhost>
	 <386072610902052347m5754262bif18339809a00cb9f@mail.gmail.com>
Date: Fri, 6 Feb 2009 16:00:28 +0800
X-Google-Sender-Auth: 001832ded916aae5
Message-ID: <386072610902060000s2e150e4cla19aca70f38b0474@mail.gmail.com>
Subject: Re: [PATCH] wireless: introduce POWEROF2_BLOCKSIZE_ONLY option
From: Bryan Wu <cooloney@kernel.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 3:47 PM, Bryan Wu <cooloney@kernel.org> wrote:
> On Thu, Feb 5, 2009 at 11:03 PM, Dan Williams <dcbw@redhat.com> wrote:
>> On Thu, 2009-02-05 at 15:30 +0800, Bryan Wu wrote:
>>> From: Cliff Cai <cliff.cai@analog.com>
>>>
>>> Introduce POWEROF2_BLOCKSIZE_ONLY option for those SD/SDIO host
>>> which only support transferring block with size of power-of-2
>>
>> Is the point here to avoid copying in the controller code?  As with the
>> other patches on libertas-dev, I really dislike adding code to *every
>> SDIO driver* just because the host has certain restrictions.  I'd much
>> rather that the host/controller code became aware of it's own
>> restrictions, and exposed those generically to drivers above it.
>> Without a KConfig option.
>>
>> Seriously.  The host knows what it needs.  The code to handle that
>> should go in the host.
>>
>
> I agree here.
>
>> How about adding a method like "sdio_align_size" that takes the
>> controller's constraints into account?  That seems a lot cleaner than
>> adding #define/KConfig junk to every SDIO driver in the kernel.  One
>> less codepath to test, makes your life and all our lives easier.
>>
>
> So we plan to add method ".sdio_align_size" to SDIO stack.
> And Blackfin host driver will implement this method while others will
> implement this as a dummy function.
>

sdio_align_size is already in SDIO stack, so we just need to add our
constraints to this function.

Thanks
-Bryan

>
>>> [ Bryan Wu <cooloney@kernel.org>:
>>>  - remove some useless coding style cleanup
>>>  - using roundup() function as upstream does
>>> ]
>>>
>>> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
>>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>>> ---
>>>  drivers/net/wireless/Kconfig            |    6 ++++++
>>>  drivers/net/wireless/libertas/if_sdio.c |   16 ++++++++++++++++
>>>  2 files changed, 22 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
>>> index e4f9f74..a2685fa 100644
>>> --- a/drivers/net/wireless/Kconfig
>>> +++ b/drivers/net/wireless/Kconfig
>>> @@ -151,6 +151,12 @@ config LIBERTAS_SDIO
>>>       ---help---
>>>         A driver for Marvell Libertas 8385 and 8686 SDIO devices.
>>>
>>> +config POWEROF2_BLOCKSIZE_ONLY
>>> +     bool "Support transferring block with size of power-of-2 only"
>>> +     depends on LIBERTAS_SDIO
>>> +     ---help---
>>> +       For SD/SDIO host which only supports transferring block with size of power-of-2.
>>> +
>>>  config LIBERTAS_DEBUG
>>>       bool "Enable full debugging output in the Libertas module."
>>>       depends on LIBERTAS
>>> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
>>> index 4519d73..5efc056 100644
>>> --- a/drivers/net/wireless/libertas/if_sdio.c
>>> +++ b/drivers/net/wireless/libertas/if_sdio.c
>>> @@ -272,6 +272,11 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
>>>        */
>>>       chunk = sdio_align_size(card->func, size);
>>>
>>> +/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
>>> +#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
>>> +     chunk = (chunk + card->func->cur_blksize - 1) /
>>> +                     card->func->cur_blksize * card->func->cur_blksize;
>>> +#endif
>>>       ret = sdio_readsb(card->func, card->buffer, card->ioport, chunk);
>>>       if (ret)
>>>               goto out;
>>> @@ -581,8 +586,14 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
>>>                       lbs_deb_sdio("sending %d bytes (%d bytes) chunk\n",
>>>                               chunk_size, (chunk_size + 31) / 32 * 32);
>>>  */
>>> +/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
>>> +#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
>>> +                     ret = sdio_writesb(card->func, card->ioport,
>>> +                             chunk_buffer, roundup(chunk_size, 256);
>>> +#else
>>>                       ret = sdio_writesb(card->func, card->ioport,
>>>                               chunk_buffer, roundup(chunk_size, 32));
>>> +#endif
>>>                       if (ret)
>>>                               goto release;
>>>
>>> @@ -699,6 +710,11 @@ static int if_sdio_host_to_card(struct lbs_private *priv,
>>>        */
>>>       size = sdio_align_size(card->func, nb + 4);
>>>
>>> +/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
>>> +#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
>>> +     size = (size + card->func->cur_blksize - 1) /
>>> +                     card->func->cur_blksize * card->func->cur_blksize;
>>> +#endif
>>>       packet = kzalloc(sizeof(struct if_sdio_packet) + size,
>>>                       GFP_ATOMIC);
>>>       if (!packet) {
>>
>>
>
