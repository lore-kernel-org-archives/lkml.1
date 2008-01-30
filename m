Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbYA3OPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbYA3OPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762617AbYA3OOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:14:35 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:60565 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761756AbYA3OOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:14:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XXsDWT57Dw7s06hnJg8gEn1G67Bv54riHOL+w8X8vxh62EfBD0bRCOWQ7gjcI2B9k3KDr6HXFdVRvhJ6t7L4mMKDaNayGVxipLYuyY/xtqN0amKk6GfdYeEaP+UrACPSbQF5yTK2yaS5fm14eIBFWzkF+P70ceAcwCUK+2ur+ZY=
Message-ID: <8bd0f97a0801300614g3f7bce03p668fca354d49761@mail.gmail.com>
Date: Wed, 30 Jan 2008 09:14:30 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [PATCH 1/1] [MTD/MAPS] Blackfin BF5xx Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Cc: "Bryan Wu" <bryan.wu@analog.com>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <87a5b0800801300401o1b0b631dt55cefaeb31b2da22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201687364-32178-1-git-send-email-bryan.wu@analog.com>
	 <87a5b0800801300401o1b0b631dt55cefaeb31b2da22@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 7:01 AM, Will Newton <will.newton@gmail.com> wrote:
> On Jan 30, 2008 10:02 AM, Bryan Wu <bryan.wu@analog.com> wrote:
>
> switch_to_flash is calling SSYNC():
>
> > +static void switch_to_flash(struct flash_save *save)
> > +{
> > +       local_irq_save(save->flags);
> > +
> > +       gpio_set_value(enet_flash_pin, 0);
> > +       SSYNC();
> > +
> > +       save->ambctl0 = bfin_read_EBIU_AMBCTL0();
> > +       save->ambctl1 = bfin_read_EBIU_AMBCTL1();
> > +       bfin_write_EBIU_AMBCTL0(BFIN_FLASH_AMBCTL0VAL);
> > +       bfin_write_EBIU_AMBCTL1(BFIN_FLASH_AMBCTL1VAL);
> > +       SSYNC();
> > +}
> > +
> > +static void switch_back(struct flash_save *save)
> > +{
> > +       bfin_write_EBIU_AMBCTL0(save->ambctl0);
> > +       bfin_write_EBIU_AMBCTL1(save->ambctl1);
> > +       SSYNC();
> > +
> > +       gpio_set_value(enet_flash_pin, 1);
> > +
> > +       local_irq_restore(save->flags);
> > +}
> > +
> > +static map_word bf5xx_read(struct map_info *map, unsigned long ofs)
> > +{
> > +       int nValue = 0x0;
> > +       map_word test;
> > +       struct flash_save save;
> > +
> > +       switch_to_flash(&save);
> > +       SSYNC();
>
> Is it necessary to SSYNC() here as well?
>
> > +       nValue = readw(map->virt + ofs);
> > +       SSYNC();
> > +       switch_back(&save);
> > +
> > +       test.x[0] = (u16)nValue;
> > +       return test;
> > +}
> > +
> > +static void bf5xx_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
> > +{
> > +       unsigned long i;
> > +       map_word test;
> > +
> > +       if ((unsigned long)to & 0x1) {
> > +               for (i = 0; i < len / 2 * 2; i += 2) {
> > +                       test = bf5xx_read(map, from + i);
> > +                       put_unaligned(test.x[0], (__le16 *)(to + i));
> > +               }
> > +       } else {
> > +               for (i = 0; i < len / 2 * 2; i += 2) {
> > +                       test = bf5xx_read(map, from + i);
> > +                       *((u16*)(to + i)) = test.x[0];
> > +               }
> > +       }
> > +
> > +       if (len & 0x1) {
> > +               test = bf5xx_read(map, from + i);
> > +               *((u8*)(to + i)) = (u8)test.x[0];
> > +       }
> > +}
> > +
> > +static void bf5xx_write(struct map_info *map, map_word d1, unsigned long ofs)
> > +{
> > +       u16 d;
> > +       struct flash_save save;
> > +
> > +       d = (u16)d1.x[0];
> > +
> > +       switch_to_flash(&save);
> > +
> > +       SSYNC();
>
> Also here?
>
> > +       writew(d, map->virt + ofs);
> > +       SSYNC();
> > +
> > +       switch_back(&save);
> > +}

thanks ... it should be fixed now
http://blackfin.uclinux.org/gf/project/linux-kernel/scmsvn/?action=browse&path=/&view=rev&root=linux-kernel&revision=4173
-mike
