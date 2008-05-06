Return-Path: <linux-kernel-owner+w=401wt.eu-S1765534AbYEFRQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765534AbYEFRQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760432AbYEFRP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:15:57 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:39252 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500AbYEFRP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:15:56 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH 1/3] PNP: cleanup pnp_fixup_device()
Date: Tue, 6 May 2008 11:15:56 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <481FAF79.2030407@keyaccess.nl>
In-Reply-To: <481FAF79.2030407@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805061115.56737.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008 07:08:09 pm Rene Herman wrote:

[It's easier to comment if the patch is inline rather than attached.]

> PNP: cleanup pnp_fixup_device()
>    
>     Signed-off-by: Rene Herman <rene.herman@gmail.com>
>
> diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> index 3f2d34a..10b1295 100644
> --- a/drivers/pnp/quirks.c
> +++ b/drivers/pnp/quirks.c
> @@ -209,20 +209,12 @@ static struct pnp_fixup pnp_fixups[] = {
>  
>  void pnp_fixup_device(struct pnp_dev *dev)
>  {
> -       int i = 0;
> -       void (*quirk)(struct pnp_dev *);
> -
> -       while (*pnp_fixups[i].id) {
> -               if (compare_pnp_id(dev->id, pnp_fixups[i].id)) {
> -                       quirk = pnp_fixups[i].quirk_function;
> -
> -#ifdef DEBUG
> -                       dev_dbg(&dev->dev, "calling quirk 0x%p", quirk);
> -                       print_fn_descriptor_symbol(": %s()\n",
> -                               (unsigned long) *quirk); 
> -#endif
> -                       (*quirk)(dev);
> -               }
> -               i++;
> +       int i;
> +
> +       for (i = 0; *pnp_fixups[i].id; i++) {
> +               if (!compare_pnp_id(dev->id, pnp_fixups[i].id))
> +                       continue;
> +               dev_dbg(&dev->dev, "calling quirk for %s\n", pnp_fixups[i].id);
> +               pnp_fixups[i].quirk_function(dev);
>         }
>  }

I'm sort of attached to keeping this similar to pci_do_fixups()
and keeping the symbol, even though the #ifdef is ugly.  I do
like getting rid of the "0x%p" and adding the PNP ID.

