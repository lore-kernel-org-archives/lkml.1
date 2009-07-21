Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZGULhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZGULhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZGULhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:37:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:32866 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZGULhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:37:20 -0400
Date: Tue, 21 Jul 2009 12:36:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Trilok Soni <soni.trilok@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090721113642.GC13286@sirena.org.uk>
References: <20090714100634.GA4054@elf.ucw.cz> <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090721105924.GK4133@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721105924.GK4133@elf.ucw.cz>
X-Cookie: Store in a cool place.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:59:25PM +0200, Pavel Machek wrote:

This looks like an unrelated (but useful) change:

>   *
> + * http://www.synaptics.com/sites/default/files/511_000099_01F.pdf
>   */

This too:

>  static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
>  {
> +/* 
> + * This sensor sends two 6-byte absolute finger reports, an optional
> + * 2-byte relative report followed by a status byte. This function
> + * reads the two finger reports and transforms the coordinates

Worth splitting them out?

> +static irqreturn_t synaptics_ts_hardirq(int irq, void *dev_id)
> +{
> +	disable_irq_nosync(irq);
> +	return IRQ_WAKE_THREAD;

Are you sure that this is going to work?  The IRQ thread code will not
call the thread function if the IRQ is marked as disabled so the thread
won't actually get called and the interrupt will just stay disabled (see
irq_thread() in kernel/irq/manage.c).  As far as I can see the threaded
IRQ support can't be used for devices on interrupt driven buses that
can't interact with the hardware in hardirq context but I might be
missing something here.
