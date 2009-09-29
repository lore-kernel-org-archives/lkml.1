Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZI2VV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZI2VV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZI2VV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:21:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbZI2VV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:21:58 -0400
Date: Tue, 29 Sep 2009 14:19:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, michael.hennerich@analog.com,
       cooloney@kernel.org
Subject: Re: [PATCH v2] mfd: ADP5520 Multifunction LCD Backlight and Keypad
 Input Device Driver
Message-Id: <20090929141939.b051fe74.akpm@linux-foundation.org>
In-Reply-To: <1253682664-27040-1-git-send-email-vapier@gentoo.org>
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org>
	<1253682664-27040-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 01:11:04 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> +static void adp5520_irq_work(struct work_struct *work)
> +{
> +	struct adp5520_chip *chip =
> +		container_of(work, struct adp5520_chip, irq_work);
> +	unsigned int events;
> +	uint8_t reg_val;
> +	int ret;
> +
> +	ret = __adp5520_read(chip->client, MODE_STATUS, &reg_val);
> +	if (ret)
> +		goto out;
> +
> +	events =  reg_val & (OVP_INT | CMPR_INT | GPI_INT | KR_INT | KP_INT);
> +
> +	blocking_notifier_call_chain(&chip->notifier_list, events, NULL);
> +	/* ACK, Sticky bits are W1C */
> +	__adp5520_ack_bits(chip->client, MODE_STATUS, events);
> +
> +out:
> +	enable_irq(chip->client->irq);
> +}
> +
> +static irqreturn_t adp5520_irq_handler(int irq, void *data)
> +{
> +	struct adp5520_chip *chip = data;
> +
> +	disable_irq_nosync(irq);
> +	schedule_work(&chip->irq_work);
> +
> +	return IRQ_HANDLED;
> +}

Disabling interrutps for an arbitrarily long period of time is pretty
nasty.  Especially if some poor innocent device is trying to share that
irq (can this happen?).

Is there no other way?
