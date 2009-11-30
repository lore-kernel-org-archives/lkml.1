Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZK3IQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZK3IQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZK3IQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:16:54 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:57269 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbZK3IQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:16:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UUGF56bXQV9RCYk9B79b7fAWc5S6DXwBsbs81tlQhtsYRk8uCcld2jHE3TnnVIaAew
         lyrtdiuw3oHQ8N1HhthsUWoJlTsFTWQ/T+ie4pyJ2WruS8sDPLlvdbAa5cVi7CspFhdl
         ulv2GSEFOIAT5KD0kisStwsun45CFu9wcilRY=
MIME-Version: 1.0
In-Reply-To: <20091130091007.7a5fd554@hina.wild-wind.fr.eu.org>
References: <20091130131627.8ccc6033.sfr@canb.auug.org.au> 
	<f17812d70911291917y2aeebbberbf31775491f0df4f@mail.gmail.com> 
	<20091130091007.7a5fd554@hina.wild-wind.fr.eu.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 30 Nov 2009 16:16:38 +0800
Message-ID: <f17812d70911300016q1e729569k8c72deb704e3a658@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pcmcia tree with the pxa tree
To: Marc Zyngier <maz@misterjones.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 4:10 PM, Marc Zyngier <maz@misterjones.org> wrote:
> On Mon, 30 Nov 2009 11:17:08 +0800
> Eric Miao <eric.y.miao@gmail.com> wrote:
>
> Hi Eric,
>
>> Could you take a look into this, I wonder you may need to rebase
>> against Russell's PCMCIA generalization stuffs. Let me know if you
>> want me to drop this patch.
>
> Patch looks good. I'm more worried about creating dependencies between
> trees:
>
> - Stephen fix depends on Russell's changes, which are in Dominik's tree,
> - My patch depends on Zeus support, which is in your tree,
> - Rebasing Zeus PCMCIA support against Dominik's tree is just another
>  dependency between the two trees.
>
> Should we drop my PCMCIA changes until both Russell's changes and main
> Zeus support are merged?
>

I'd propose to postpone your patches until dependency is resolved, will
send a second git pull til then. Sounds OK to you?

> I'm opened to any suggestion.
>
>        M.
>
>>
>> On Mon, Nov 30, 2009 at 10:16 AM, Stephen Rothwell
>> <sfr@canb.auug.org.au> wrote:
>> > Hi Dominik,
>> >
>> > Today's linux-next merge of the pcmcia tree got a conflict in
>> > drivers/pcmcia/pxa2xx_viper.c between commit
>> > c9b74a4489db7e6fe03fbee11f406b9641baae55 ("[ARM] pxa/zeus: make
>> > Viper pcmcia support more generic to support Zeus") from the pxa
>> > tree and commit 66024db57d5b9011e274b314affad68f370c0d6f ("PCMCIA:
>> > stop duplicating pci_irq in soc_pcmcia_socket") from the pcmcia
>> > tree.
>> >
>> > I fixed it up (see below) and can carry the fix as necessary.
>> > --
>> > Cheers,
>> > Stephen Rothwell                    sfr@canb.auug.org.au
>> >
>> > diff --cc drivers/pcmcia/pxa2xx_viper.c
>> > index 7a16ae9,27be2e1..0000000
>> > --- a/drivers/pcmcia/pxa2xx_viper.c
>> > +++ b/drivers/pcmcia/pxa2xx_viper.c
>> > @@@ -30,35 -32,23 +30,35 @@@
>> >  #include "soc_common.h"
>> >  #include "pxa2xx_base.h"
>> >
>> >  +static struct platform_device *arcom_pcmcia_dev;
>> >  +
>> >  static struct pcmcia_irqs irqs[] = {
>> >  -      { 0, gpio_to_irq(VIPER_CF_CD_GPIO),  "PCMCIA_CD" }
>> >  +      {
>> >  +              .sock   = 0,
>> >  +              .str    = "PCMCIA_CD",
>> >  +      },
>> >  };
>> >
>> >  +static inline struct arcom_pcmcia_pdata *viper_get_pdata(void)
>> >  +{
>> >  +      return arcom_pcmcia_dev->dev.platform_data;
>> >  +}
>> >  +
>> >  static int viper_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
>> >  {
>> >  +      struct arcom_pcmcia_pdata *pdata = viper_get_pdata();
>> >        unsigned long flags;
>> >
>> > -       skt->irq = gpio_to_irq(pdata->rdy_gpio);
>> >  -      skt->socket.pci_irq = gpio_to_irq(VIPER_CF_RDY_GPIO);
>> > ++      skt->socket.pci_irq = gpio_to_irq(pdata->rdy_gpio);
>> >  +      irqs[0].irq = gpio_to_irq(pdata->cd_gpio);
>> >
>> >  -      if (gpio_request(VIPER_CF_CD_GPIO, "CF detect"))
>> >  +      if (gpio_request(pdata->cd_gpio, "CF detect"))
>> >                goto err_request_cd;
>> >
>> >  -      if (gpio_request(VIPER_CF_RDY_GPIO, "CF ready"))
>> >  +      if (gpio_request(pdata->rdy_gpio, "CF ready"))
>> >                goto err_request_rdy;
>> >
>> >  -      if (gpio_request(VIPER_CF_POWER_GPIO, "CF power"))
>> >  +      if (gpio_request(pdata->pwr_gpio, "CF power"))
>> >                goto err_request_pwr;
>> >
>> >        local_irq_save(flags);
>> >
>>
>
>
> --
> And if you don't know where you're going, any road will take you
> there...
>
