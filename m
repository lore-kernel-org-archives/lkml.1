Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab0COKph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:45:37 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49746 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab0COKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=F7R8GzaDcyi6G+6gZOOSn3lP7Oj1Z0W9tXM6CFm341dS6JyHsFm2UTTmF0O73Lhe8e
         LtPtw9KkAE+/xJopSY+mZiI68KKI073fdjpBCcTRz/shcBCPa/kcmzPjgqz9TEMRH4Ma
         O+wBqIcz8OQ7ijbxzn+THrXqbQ434IUaDa07o=
Date: Mon, 15 Mar 2010 13:45:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: bug list: range checking issues 2.6.34-rc1
Message-ID: <20100315101146.GL18181@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <201003151002.18928.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201003151002.18928.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 10:02:18AM +0100, Toralf Förster wrote:
> Hello,
> 
> I'm wondering about these entries :
> 

No problem, I'm happy to explain.

> drivers/infiniband/core/user_mad.c +646 ib_umad_reg_agent() 'umm' 4 <= 6
   641                          u32 *umm = (u32 *) ureq.method_mask;
   642                          int i;
   643  
   644                          for (i = 0; i < BITS_TO_LONGS(IB_MGMT_MAX_METHODS); ++i)
   645                                  req.method_mask[i] =
   646                                          umm[i * 2] | ((u64) umm[i * 2 + 1] << 32);
"umm" points to a array with 4 elements.
i can be 0 to 3, so "i * 2" goes up to 6
And 4 <= 6 so it's a problem.
Smatch also complained about "i * 2 + 1" but I didn't include that. 

> drivers/media/dvb/frontends/cx24110.c +210 cx24110_set_fec() 'rate' 7 <= 8
   184          static const int rate[]={-1,1,2,3,5,7,-1};
	[snip]
   192          if (fec>FEC_AUTO)
   193                  fec=FEC_AUTO;
   194  
   195          if (fec==FEC_AUTO) { /* (re-)establish AutoAcq behaviour */
	[snip]
   207          } else {
   208                  cx24110_writereg(state,0x37,cx24110_readreg(state,0x37)|0x20);
   209                  /* set AcqVitDis bit */
   210                  if(rate[fec]>0) {
"rate" has 7 elements.  FEC_AUTO - 1 is 8.  7 <= 8.

> drivers/video/cyber2000fb.c +330 cyber2000fb_setcolreg() 'cfb->palette' 256 <= 504
   316                  if (var->green.length == 6 && regno < 64) {
   317                          cfb->palette[regno << 2].green = green;
	[snip]
   330                          green = cfb->palette[regno << 3].green;
"cfb->palette" is an array with 256 elements.  "regno" can be 63.  
63 << 3 is 504.

> sound/drivers/opl3/opl3_midi.c +652 snd_opl3_kill_voice() 'opl3->voices' 18 <= 20
   626          if (snd_BUG_ON(voice >= MAX_OPL3_VOICES))
   627                  return;
	[snip]
   651          if (vp->state == SNDRV_OPL3_ST_ON_4OP) {
   652                  vp2 = &opl3->voices[voice + 3];
"opl3->voices" has 18 elements.  "voice" can be 17.  17 + 3 is 20.

> sound/i2c/other/ak4113.c +94 snd_ak4113_create() 'pgm' 5 <= 6
    93          for (reg = 0; reg < AK4113_WRITABLE_REGS ; reg++)
    94                  chip->regmap[reg] = pgm[reg];
"pgm" has 5 elements.  AK4113_WRITABLE_REGS is 7.

> sound/soc/codecs/wm8994.c +1703 wm8994_write() 'wm8994->reg_cache' 1570 <=  12799
  1700          BUG_ON(reg > WM8994_MAX_REGISTER);
  1701  
  1702          if (!wm8994_volatile(reg))
  1703                  wm8994->reg_cache[reg] = value;
"wm8994->reg_cache" has 1570 elements.  WM8994_MAX_REGISTER is 12799.

Obviously that last one is not the most serious bug in the world...

regards,
dan carpenter

> 
> b/c the range end shouldn't be reached, or ?
> 
> -- 
> MfG/Sincerely
> Toralf Förster
> 
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
