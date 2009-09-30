Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZI3VuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZI3VuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZI3VuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:50:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040AbZI3Vt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:49:59 -0400
Date: Wed, 30 Sep 2009 14:49:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: nils.carlson@ludd.ltu.se, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] edac: i5100 add scrubbing
Message-Id: <20090930144942.615ea092.akpm@linux-foundation.org>
In-Reply-To: <4abd45c5.eiiiPyYLP3Q0wh5h%dougthompson@xmission.com>
References: <4abd45c5.eiiiPyYLP3Q0wh5h%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 1/2] edac: i5100 add scrubbing

I received

	[patch 1/3]
	[patch 1/1]
	[patch 1/2]

which tricked me for a while, but I worked it out!

On Fri, 25 Sep 2009 16:35:49 -0600
dougthompson@xmission.com wrote:

> From: Nils Carlson <nils.carlson@ludd.ltu.se>
> 
> ls.carlson@ludd.ltu.seThis patch adds scrubbing to the i5100 chipset.
> The i5100 chipset only  supports one scrubbing rate, which is not constant
> but dependent on memory load. The rate returned by this driver is an
> estimate based on some experimentation, but is substantially closer to
> the truth than the speed supplied in the documentation.
> 
> Also, scrubbing is done once, and then a done-bit is set. This means that
> to accomplish continuous scrubbing a re-enabling mechanism must be used. I
> have created the simplest possible such mechanism in the form of a
> work-queue which will check every five minutes. This interval is quite
> arbitrary but should be sufficient for all sizes of system memory.

nits:

> Index: linux-2.6.31/drivers/edac/i5100_edac.c
> ===================================================================
> --- linux-2.6.31.orig/drivers/edac/i5100_edac.c
> +++ linux-2.6.31/drivers/edac/i5100_edac.c
> @@ -25,6 +25,8 @@
>  
>  /* device 16, func 1 */
>  #define I5100_MC		0x40	/* Memory Control Register */
> +#define 	I5100_MC_SCRBEN_MASK	(1 << 7)
> +#define 	I5100_MC_SCRBDONE_MASK	(1 << 4)
>  #define I5100_MS		0x44	/* Memory Status Register */

You used tabs, they used spaces.  Doesn't matter.  I prefer tabs.

>  #define I5100_SPDDATA		0x48	/* Serial Presence Detect Status Reg */
>  #define I5100_SPDCMD		0x4c	/* Serial Presence Detect Command Reg */


> @@ -72,11 +74,21 @@
>  
>  /* bit field accessors */
>  
> +static inline u32 i5100_mc_scrben(u32 mc)
> +{
> +	return mc >> 7 & 1;
> +}
> +
>  static inline u32 i5100_mc_errdeten(u32 mc)
>  {
>  	return mc >> 5 & 1;
>  }
>  
> +static inline u32 i5100_mc_scrbdone(u32 mc)
> +{
> +	return mc >> 4 & 1;
> +}

"scrb", "en", "err", "det".

The problem with these scruffy abbreviations is that it's difficult to
_remember_ them.  Which is why we'll so often spell out the full word
in kernel code.  That's easy to remember.

>  static inline u16 i5100_spddata_rdo(u16 a)
>  {
>  	return a >> 15 & 1;
> @@ -272,6 +284,7 @@ static inline u32 i5100_recmemb_ras(u32
>  #define I5100_MAX_DIMM_SLOTS_PER_CHAN	4
>  #define I5100_MAX_RANK_INTERLEAVE	4
>  #define I5100_MAX_DMIRS			5
> +#define I5100_SCRUB_REFRESH_RATE	(5 * 60 * HZ)
>  
>  struct i5100_priv {
>  	/* ranks on each dimm -- 0 maps to not present -- obtained via SPD */
> @@ -318,6 +331,9 @@ struct i5100_priv {
>  	struct pci_dev *mc;	/* device 16 func 1 */
>  	struct pci_dev *ch0mm;	/* device 21 func 0 */
>  	struct pci_dev *ch1mm;	/* device 22 func 0 */
> +
> +	struct delayed_work i5100_scrubbing;
> +	int scrub_enable;
>  };
>  
>  /* map a rank/chan to a slot number on the mainboard */
> @@ -534,6 +550,80 @@ static void i5100_check_error(struct mem
>  	}
>  }
>  
> +/* The i5100 chipset will scrub the entire memory once, then
> + * set a done bit. Continuous scrubbing is achieved by enqueing
> + * delayed work to a workqueue, checking every few minutes if
> + * the scrubbing has completed and if so reinitiating it.
> + */
> +
> +static void i5100_refresh_scrubbing(struct work_struct *work)
> +{
> +	struct delayed_work *i5100_scrubbing = container_of(work,
> +							    struct delayed_work,
> +							    work);
> +	struct i5100_priv *priv = container_of(i5100_scrubbing,
> +					       struct i5100_priv,
> +					       i5100_scrubbing);
> +	u32 dw;

Jumping through hoops to make it fit in 80-cols.  But there's a better way:

	struct delayed_work *i5100_scrubbing;
	struct i5100_priv *priv;
	u32 dw;

	i5100_scrubbing = container_of(work, struct delayed_work, work);
	priv = container_of(i5100_scrubbing, struct i5100_priv,
				i5100_scrubbing);

> +	pci_read_config_dword(priv->mc, I5100_MC, &dw);
> +
> +	if (priv->scrub_enable) {
> +
> +		pci_read_config_dword(priv->mc, I5100_MC, &dw);
> +
> +		if (i5100_mc_scrbdone(dw)) {
> +			dw |= I5100_MC_SCRBEN_MASK;
> +			pci_write_config_dword(priv->mc, I5100_MC, dw);
> +			pci_read_config_dword(priv->mc, I5100_MC, &dw);
> +		}
> +
> +		schedule_delayed_work(&(priv->i5100_scrubbing),

The parens around the `&' operand aren't needed (several instances).

> +				      I5100_SCRUB_REFRESH_RATE);
> +	}
> +}

