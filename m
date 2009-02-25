Return-Path: <linux-kernel-owner+w=401wt.eu-S1762022AbZBYMFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbZBYMFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbZBYMFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:05:04 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44864 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbZBYMFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:05:01 -0500
Date: Wed, 25 Feb 2009 07:04:50 -0500
From: Andres Salomon <dilinger@queued.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>, tiwai@suse.de, katzj@redhat.com,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       perex@perex.cz, cjb@laptop.org, linux-geode@lists.infradead.org,
       jayakumar.alsa@gmail.com
Subject: Re: [PATCH 1/2] cs553x-gpio: add AMD CS5535/CS5536 GPIO driver
 support
Message-ID: <20090225070450.30be354b@ephemeral>
In-Reply-To: <20090225103830.4b416a1c@i1501.lan.towertech.it>
References: <20090220221202.667fbb79@ephemeral>
	<20090224120637.18073f93.akpm@linux-foundation.org>
	<20090224151937.6bf43943@ephemeral>
	<20090225103830.4b416a1c@i1501.lan.towertech.it>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 10:38:30 +0100
Alessandro Zummo <alessandro.zummo@towertech.it> wrote:

> On Tue, 24 Feb 2009 15:19:37 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > Not yet.  The MFGPT, DCON, and olpc stuff will use them; I'm
> > waiting to hear feedback on this patch before I write a generic
> > MFGPT driver (or skip to cleaning up and submitting the DCON
> > driver).
> > 
> 
>  why can't they use the generic gpio api?
> 

Because the DCON (for example) has this bit of code:

         * According to HiMax, when powering the DCON up we should hold
         * SMB_DATA high for 8 SMB_CLK cycles.  This will force the DCON
         * state machine to reset to a (sane) initial state.  Mitch Bradley
         * did some testing and discovered that holding for 16 SMB_CLK cycles
         * worked a lot more reliably, so that's what we do here.
         *
         * According to the cs5536 spec, to set GPIO14 to SMB_CLK we must
         * simultaneously set AUX1 IN/OUT to GPIO14; ditto for SMB_DATA and
         * GPIO15.
         */
        geode_gpio_set(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_VAL);
        geode_gpio_set(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_ENABLE);
        geode_gpio_clear(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX1);
        geode_gpio_clear(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX2);
        geode_gpio_clear(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_INPUT_AUX1);

        for (x = 0; x < 16; x++) {
                udelay(5);
                geode_gpio_clear(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
                udelay(5);
                geode_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
        }
        udelay(5);
        geode_gpio_set(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX1);
        geode_gpio_set(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_INPUT_AUX1);

The GPIO_OUTPUT_VALs can obviously use the generic GPIO API, but I have no
idea how you'd map the INPUT_AUX1/OUTPUT_AUX1/OUTPUT_AUX2 stuff.

There are plenty other examples of this sort of thing.
