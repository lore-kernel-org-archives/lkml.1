Return-Path: <linux-kernel-owner+w=401wt.eu-S967710AbXEHD0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967710AbXEHD0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 23:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967653AbXEHD0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 23:26:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:47212 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967704AbXEHD0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 23:26:11 -0400
Subject: Incorrect atomic usage in cx88-alsa driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ricardo Cerqueira <v4l@cerqueira.org>,
       Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 13:25:06 +1000
Message-Id: <1178594706.14928.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi !

So I see this construct:

	if (test_and_set_bit(0, &chip->opened))
		return -EBUSY;

	.../...

	return 0;
_error:
	dprintk(1,"Error opening PCM!\n");
	clear_bit(0, &chip->opened);
	smp_mb__after_clear_bit();
	return err;

So that's basically an attempt at doing a spinlock. The problem is your
barrier is wrong at the end. Better would be:

done:
	smp_mb__before_clear_bit();
	clear_bit(0, &chip->opened);

Though it's still less optimal that doing:

	if (!spin_trylock(...))
		goto bail;

	.../...

done:
	spin_unlock(...)

If you really want to stick to bitops, then you may want to look at
Nick's upcoming patches adding some bitops with appropriate lock
semantics.


Cheers,
Ben.


