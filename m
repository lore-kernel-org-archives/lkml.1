Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXJXQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXJXQBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXJXQBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:01:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39177 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXJXQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:01:06 -0400
Date: Wed, 24 Oct 2007 10:01:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Takashi Iwai <tiwai@suse.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 3/4] sound: Use stringbuf
Message-ID: <20071024160105.GB27248@parisc-linux.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx> <1193173966-3550-2-git-send-email-matthew@wil.cx> <1193173966-3550-3-git-send-email-matthew@wil.cx> <s5h3aw0d29r.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3aw0d29r.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 04:18:40PM +0200, Takashi Iwai wrote:
> At Tue, 23 Oct 2007 17:12:45 -0400,
> Matthew Wilcox wrote:
> > 
> > sound/ had its own snd_info_buffer for doing proc reads, which can be
> > profitably replaced with stringbuf.  It actually finds a bug since ->read
> > and ->write now have a different signature.
> 
> Do you mean the assignment of snd_ca0106_proc_reg_write?
> I also found it out today coindentally :)

I was referring to this hunk, so yes:

@@ -448,10 +448,9 @@ int __devinit snd_ca0106_proc_init(struct snd_ca0106 * emu)
 //             entry->private_data = emu;
        }
        if(! snd_card_proc_new(emu->card, "ca0106_i2c", &entry)) {
-               snd_info_set_text_ops(entry, emu, snd_ca0106_proc_i2c_write);
+               entry->private_data = emu;
                entry->c.text.write = snd_ca0106_proc_i2c_write;
                entry->mode |= S_IWUSR;
-//             entry->private_data = emu;
        }
        if(! snd_card_proc_new(emu->card, "ca0106_regs2", &entry)) 
                snd_info_set_text_ops(entry, emu, snd_ca0106_proc_reg_read2);


> Any other bugs I missed?

Let me try to find them ... there was this warning fix:

diff --git a/sound/isa/ad1848/ad1848_lib.c b/sound/isa/ad1848/ad1848_lib.c
index a901cd1..9a64035 100644
--- a/sound/isa/ad1848/ad1848_lib.c
+++ b/sound/isa/ad1848/ad1848_lib.c
@@ -213,7 +213,7 @@ static void snd_ad1848_mce_down(struct snd_ad1848 *chip)
        for (timeout = 12000; timeout > 0 && (inb(AD1848P(chip, REGSEL)) & AD184
8_INIT); timeout--)
                udelay(100);
 
-       snd_printdd("(1) timeout = %d\n", timeout);
+       snd_printdd("(1) timeout = %ld\n", timeout);
 
 #ifdef CONFIG_SND_DEBUG
        if (inb(AD1848P(chip, REGSEL)) & AD1848_INIT)

but I think that's the only one.

> > -static void snd_ac97_proc_regs_write(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
> > +static void snd_ac97_proc_regs_write(struct snd_info_entry *entry, struct stringbuf *buffer)
> 
> This shouldn't be changed.

Quite right, sorry about that, will omit it from the next round.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
