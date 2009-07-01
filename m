Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZGAWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZGAWcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZGAWcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:32:33 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:30160 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750981AbZGAWcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:32:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EAZNQusMkBuFNgylCcRoopYosqwVhIDaFc6GPrfQa5TDOVoQwZhK9Tpv2gsMBd7KO2UCqsSPdstjk13mA7nVXp5/lc8D+avoSIYCPVcuRI5op1ypZSbLvgJlNmI2MomFB7UZvBcWfoQnwzYhQy75m+DkipxMlbNoHupw7N9llHo=  ;
X-YMail-OSG: XA1RsM4VM1kqhA.HdjVJlk6Hw8aT35NWerfj8UXLSOA7vT44R8_A_l0u5ijLwbVKpb.wa6zoIIIslbq0zSAz6Ij3S2U0QdXmuMJyGYiwy.d_6CtYZmOebl.LVEYzWty.zxsNf8TuMa3B1G7MQXsy.c3PMhGCedf.D4ofgdNvYpLsJhpR9_WaoVgbogMEnF3zfqDm1GVbVvJXziPPBOK7u0yLiOPDAYimA5Uew_9uzNtepGJ2e3ban5u.UB00u5DNVqLUrjgUVEu_kLUjcSg1.Wz84nSAAcHTDE3LEJ0hYzJImp_4hYHc
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andres Salomon <dilinger@collabora.co.uk>, Tobias_Mueller@twam.info
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver   support
Date: Wed, 1 Jul 2009 15:32:34 -0700
User-Agent: KMail/1.9.10
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       deepak@laptop.org, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       jordan@cosmicpenguin.net, cjb@laptop.org
References: <20090610001033.27b7f69f@mycelium.queued.net> <17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com> <20090611172850.6c418b1d@mycelium.queued.net>
In-Reply-To: <20090611172850.6c418b1d@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011532.34677.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Andres Salomon wrote:
> 
> > I mentioned this in an ealier mail too. When I request the GPIO from
> > userspace the direction file always contains "in", so I thought
> > this is the standard direction after resetting as I should be in a
> > defined state after requesting. But I didn't found anything
> > about this in GPIO lib documentation, so I would be fine to change
> > this if there is any common default behavoir.
> 
> To be honest, I'd have to play around with it a bit before I
> knew whether it actually breaks anything or not. I'm not sure if
> it would break anything on OLPC, and I don't have any other geode
> machines that do anything interesting w/ GPIOs.
> 
> Maybe David can clear up whether this behavior is correct from the
> userspace GPIO usage standpoint..

Correct-but-annoying ... and maybe worth changing.  The
direction *displayed* may not reflect the actual hardware
until after that GPIO signal is initialized.  Boot firmware
may well have set the direction; Linux shouldn't change it
without explicit instructions to do so.

The issue is that when it first comes up, nobody has tod
Linux that direction ... so instead of defining an "unknown"
state, that code applies a heuristic.  In gpiochip_add():

                for (id = base; id < base + chip->ngpio; id++) {
                        gpio_desc[id].chip = chip;

                        /* REVISIT:  most hardware initializes GPIOs as
                         * inputs (often with pullups enabled) so power
                         * usage is minimized.  Linux code should set the
                         * gpio direction first thing; but until it does,
                         * we may expose the wrong direction in sysfs.
                         */
                        gpio_desc[id].flags = !chip->direction_input
                                ? (1 << FLAG_IS_OUT)
                                : 0;
                }

Now, as far as heuristics go that one seems to cover most
of the common cases.  But like all heuristics, the result
produced may be wrong.

So it would be nice to remove the heuristic.  The best
way would be to add a new method to query gpio direction.
Then that when it's available, instead of the heuristic.

- Dave

