Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651Ab0AKIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab0AKIh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205Ab0AKIh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:37:27 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51967 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0AKIh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:37:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=uJYxyJWpBp53PhOIVyRD8fbKPd01MDKtGt4S0sc5D3bThNu9MHFFQBsqPkZ5FDlNHB
         mTd3g4/QdHhS248UnXBVmNzRXOiWGOyOOFXQaCr8ch36Aab1g1aQDSHK+IrJxxBq9WnX
         T/VO7TFFOlNCDJFTz9HTaBNMsfAOnmrCK0TAU=
Message-ID: <4b4ae343.09a8100a.3b72.ffffda1b@mx.google.com>
Date: Mon, 11 Jan 2010 10:36:31 +0200
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, yinghai@kernel.org, travis@sgi.com, tglx@linutronix.de,
       peterz@infradead.org
Subject: kernel/irq: __setup_irq/__free_irq disable-depth asymmetry?
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For discussion simplicity, lets assume our IRQ is not IRQF_SHARED, also
IRQ_NOAUTOEN is not set.

Normally, when the system is initialized, the initial value of
irq_desc[i].depth is 1, representing disable-depth of 1, as the line is
indeed initially disabeled.

When __setup_irq is called (as a result of request_irq call), the line gets
enabled via desc->chip->startup(irq), and desc->depth is set to 0
(meaning: there's no disable-depth).

When __free_irq is called (assuming last handler unregistering), the line
gets masked by desc->chip->shutdown(irq), however the desc->depth is not
modified.
In that case, desc->depth is still 0 ("no disable-depth") but the line is
actually disabled.

Now suppose someone calls disable_irq() and then enable_irq().
The overall result will be the line getting enabled by the latter call,
although there's no registered ISR.
(disable_irq increments depth to 1, enabled_irq decrements it to 0 and
thus calls desc->chip->enable).

Yes, I agree, calling disable_irq/enable_irq when there's no registered ISR
is bizzare... however bizzare things might happen to you too ;)

What bothers me is that the overall result is not identical when running
the following sequence: system initlialization, disable_irq, enable_irq
(without any __setup_irq/__free_irq calls).
In that case, the overall result is that the line is kept masked.
(upon initialization depth is 1, disable_irq increments it to 2, enable_irq
decrements it to back 1. no desc->chip->xxx calls whatsoever).

The cause for this behaviour is the assymetrical treatment to the 'depth' field
in __free_irq; it should have reverted what was done in __setup_irq.

So, I suggest resetting desc->depth to 1 within __free_irq (at the same place
desc->chip->shutdown is called).

Your thoughts appreciated.

-- 
Shmulik Ladkani
