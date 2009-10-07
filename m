Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbZJGLab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbZJGLab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbZJGLab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:30:31 -0400
Received: from ns.penguin.cz ([84.21.108.25]:47444 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759048AbZJGLaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:30:30 -0400
Subject: Re: spitz: add gpio button support (AK_INT and remote control
 description)
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20091007085806.GB28807@elf.ucw.cz>
References: <20091006074635.GA2775@ucw.cz>
	 <1254829732.3546.35.camel@utx.utx.cz>  <20091007085806.GB28807@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Wed, 07 Oct 2009 13:29:51 +0200
Message-Id: <1254914991.4213.80.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2009-10-06 13:48:52, Stanislav Brabec wrote:
> > Pavel Machek wrote:
> > > I'm not sure what AK_INT is, nor what event it should
> > > generate.
> > 
> > AK_INT: remote control detect
> 
> Thanks. So for now I'll do:
> 
>         /* This is for remote control support. Zaurus supports wired                  
>            remote on headphones. */
>         {
>                 .type   = EV_KEY,
>                 .code   = KEY_F13,
>                 .gpio   = SPITZ_GPIO_AK_INT,
>                 .desc   = "Wired remote (AK_INT)",
>         },
> 
> ..and leave it for proper driver to support nicely.

I think that AK_INT should not generate key press event. Permanently
pressed key could confuse many programs.

But we may want to use switch events. I propose to create new switch
event for it: SW_REMOTE_INSERT. But mapping of AK_INT to
SW_REMOTE_INSERT cannot be straightforward.

That is why I propose to ignore AK_INT for now.

Following implementation may be used later (with future resistor matrix
keyboard driver):

Map SPITZ_GPIO_HP_IN to SW_JACK_PHYSICAL_INSERT (after debouncing).

Generate SW_REMOTE_INSERT if:
- SW_JACK_PHYSICAL_INSERT is on AK_INT is active and remote pin has full
  voltage
or
- SW_JACK_PHYSICAL_INSERT is on and remote driver shows valid value

SW_REMOTE_INSERT should be recognized by the Jack abstraction layer
(sound/core/jack.c).

Well, I am thinking about defining extra values for resistors, that can
make stuff even more useful at cost of need of non-standard wiring on
fourth ring of the audio jack. It can generate SW_MICROPHONE_INSERT,
SW_LINEOUT_INSERT, and not yet defined SW_HEADESET_INSERT and
SW_LINEIN_INSERT (which would require hardware mod inside Zaurus for
stereo line-in).

The default may be SW_HEADPHONE_INSERT (short connection between remote
pin and ground).

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

