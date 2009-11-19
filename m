Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbZKSNRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbZKSNRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZKSNRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:17:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55957 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZKSNRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:17:16 -0500
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
From: Peter Zijlstra <peterz@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091119130526.23a69b85@hyperion.delvare>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>
	 <20091107210147.3e754278@hyperion.delvare>
	 <4AF7148C.9090706@thebigcorporation.com>
	 <20091112211255.09cd884a@hyperion.delvare>
	 <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
	 <20091116155606.GC29479@sirena.org.uk>
	 <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>
	 <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>
	 <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>
	 <20091118175202.490989d8@hyperion.delvare>
	 <alpine.LFD.2.00.0911182127040.24119@localhost.localdomain>
	 <20091119130526.23a69b85@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Nov 2009 14:18:40 +0100
Message-ID: <1258636720.4372.350.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 13:05 +0100, Jean Delvare wrote:
> 
> Was yield() turned into NOOP by design, or was it a bug?

Design.

yield() for SCHED_OTHER is not specified, so everything goes.

There's two possible 'sane' options for yield for (CFS's) SCHED_OTHER:

 - place the task behind all other tasks of the same nice level

   This is however an O(n) operation for CFS since we don't separate
   things out based on nice level, hence we don't do that.

 - service the task that is most starved of service

   That fits nicely into the fairness thing, and is what we default to.
   The thing is, that's current in 99% of the cases, otherwise we would
   already be running another task.

   So its not strictly a NOP, but in practice it is.


There is also another option, place the task behind _all_ other tasks,
but that also surprises people and causes regressions, because they
don't expect yield() to wait _that_ long.


And all this is irrespective of the question of whether yield() is ever
a sane thing to do (I say not).
