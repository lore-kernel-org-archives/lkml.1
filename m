Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYIKH1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYIKH1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYIKH1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:27:22 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:45241 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYIKH1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:27:21 -0400
Date: Thu, 11 Sep 2008 09:27:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney@avtrex.com>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch 2/6] MIPS: Add HARDWARE_WATCHPOINTS definitions and
 support code.
In-Reply-To: <48C8B2C3.4050002@avtrex.com>
Message-ID: <Pine.LNX.4.64.0809110922090.29543@anakin>
References: <48C8ADEF.9020305@avtrex.com> <48C8B2C3.4050002@avtrex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008, David Daney wrote:

Given

> +	case 4:
> +		write_c0_watchlo3(watches->watchlo[3]);
> +		/* Write 1 to the I, R, and W bits to clear them, and
> +		   1 to G so all ASIDs are trapped. */
> +		write_c0_watchhi3(0x40000007 | watches->watchhi[3]);
> +	case 3:
> +		write_c0_watchlo2(watches->watchlo[2]);
> +		write_c0_watchhi2(0x40000007 | watches->watchhi[2]);
> +	case 2:
> +		write_c0_watchlo1(watches->watchlo[1]);
> +		write_c0_watchhi1(0x40000007 | watches->watchhi[1]);
> +	case 1:
> +		write_c0_watchlo0(watches->watchlo[0]);
> +		write_c0_watchhi0(0x40000007 | watches->watchhi[0]);

and

> +	case 4:
> +		watches->watchhi[3] = (read_c0_watchhi3() & 0x0fff);
> +	case 3:
> +		watches->watchhi[2] = (read_c0_watchhi2() & 0x0fff);
> +	case 2:
> +		watches->watchhi[1] = (read_c0_watchhi1() & 0x0fff);
> +	case 1:
> +		watches->watchhi[0] = (read_c0_watchhi0() & 0x0fff);

and

> +	case 8:
> +		write_c0_watchlo7(0);
> +	case 7:
> +		write_c0_watchlo6(0);
> +	case 6:
> +		write_c0_watchlo5(0);
> +	case 5:
> +		write_c0_watchlo4(0);
> +	case 4:
> +		write_c0_watchlo3(0);
> +	case 3:
> +		write_c0_watchlo2(0);
> +	case 2:
> +		write_c0_watchlo1(0);
> +	case 1:
> +		write_c0_watchlo0(0);

do the same for each registers, perhaps it makes sense to create
read_c0_watchhi(), write_c0_watchlo(), and write_c0_watchhi() macros
that take the watchdog register index as a parameter? Then the above can
be turned in simple loops.

> +	write_c0_watchlo0(7);
> +	t = read_c0_watchlo0();
> +	write_c0_watchlo0(0);
> +	c->watch_reg_masks[0] = t & 7;
> +
> +	/* Write the mask bits and read them back to determine which
> +	 * can be used. */
> +	c->watch_reg_count = 1;
> +	c->watch_reg_use_cnt = 1;
> +	t = read_c0_watchhi0();
> +	write_c0_watchhi0(t | 0xff8);
> +	t = read_c0_watchhi0();
> +	c->watch_reg_masks[0] |= (t & 0xff8);
> +	if ((t & 0x80000000) == 0)
> +		return;
> +
> +	write_c0_watchlo1(7);
> +	t = read_c0_watchlo1();
> +	write_c0_watchlo1(0);
> +	c->watch_reg_masks[1] = t & 7;
> +
> +	c->watch_reg_count = 2;
> +	c->watch_reg_use_cnt = 2;
> +	t = read_c0_watchhi1();
> +	write_c0_watchhi1(t | 0xff8);
> +	t = read_c0_watchhi1();
> +	c->watch_reg_masks[1] |= (t & 0xff8);
> +	if ((t & 0x80000000) == 0)
> +		return;
> +
> +	write_c0_watchlo2(7);
> +	t = read_c0_watchlo2();
> +	write_c0_watchlo2(0);
> +	c->watch_reg_masks[2] = t & 7;
> +
> +	c->watch_reg_count = 3;
> +	c->watch_reg_use_cnt = 3;
> +	t = read_c0_watchhi2();
> +	write_c0_watchhi2(t | 0xff8);
> +	t = read_c0_watchhi2();
> +	c->watch_reg_masks[2] |= (t & 0xff8);
> +	if ((t & 0x80000000) == 0)
> +		return;
> +
> +	write_c0_watchlo3(7);
> +	t = read_c0_watchlo3();
> +	write_c0_watchlo3(0);
> +	c->watch_reg_masks[3] = t & 7;
> +
> +	c->watch_reg_count = 4;
> +	c->watch_reg_use_cnt = 4;
> +	t = read_c0_watchhi3();
> +	write_c0_watchhi3(t | 0xff8);
> +	t = read_c0_watchhi3();
> +	c->watch_reg_masks[3] |= (t & 0xff8);
> +	if ((t & 0x80000000) == 0)
> +		return;

Same here

> +	/* We use at most 4, but probe and report up to 8. */
> +	c->watch_reg_count = 5;
> +	t = read_c0_watchhi4();
> +	if ((t & 0x80000000) == 0)
> +		return;
> +
> +	c->watch_reg_count = 6;
> +	t = read_c0_watchhi5();
> +	if ((t & 0x80000000) == 0)
> +		return;
> +
> +	c->watch_reg_count = 7;
> +	t = read_c0_watchhi6();
> +	if ((t & 0x80000000) == 0)
> +		return;
> +
> +	c->watch_reg_count = 8;

and here

BTW, no check for read_c0_watchhi7()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
