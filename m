Return-Path: <linux-kernel-owner+w=401wt.eu-S1760331AbXJMF7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbXJMF7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 01:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbXJMF7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 01:59:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbXJMF7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 01:59:40 -0400
Date: Sat, 13 Oct 2007 07:59:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rok Markovic <kernel@kanardia.eu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.23-rt1 lockup after loading HAL deamon
Message-ID: <20071013055922.GB26370@elte.hu>
References: <470F27DA.9020307@kanardia.eu> <20071012083551.GA17937@elte.hu> <470FB4F4.60707@kanardia.eu> <20071012175831.GA27420@elte.hu> <470FD96A.8040505@kanardia.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470FD96A.8040505@kanardia.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rok Markovic <kernel@kanardia.eu> wrote:

> I enabled netconsole but I am affraid that it won't help. In 
> attachment I am sending complete log over netconsole. While I was 
> trying to make everything, I got a lockup on linux-2.6.23-rc8, but I 
> am not sure into this. But all lockups happend in VGA console mode. 
> Any ideas.

hm:

[  104.224904] oprofile: using NMI interrupt.

could you disable CONFIG_OPROFILE? Maybe it interferes with the NMI 
watchdog?

how does /proc/interrupts look like shortly after bootup? Does a simple 
"intentional lockup" piece of code, which provokes a hard lockup from 
user-space, get properly zapped by the NMI watchdog (within a minute or 
so):

# cat > lockup.c

int main(void)
{
	iopl(3);
	for (;;)
		asm("cli");
}
Ctrl-D
# make lockup
# ./lockup
<hard hang>

the NMI watchdog should produce a console message similar to:

 BUG: NMI Watchdog detected LOCKUP on CPU0, eip bff12345, registers:
 ...

( if you test ./lockup and get the message properly then i'd suggest a 
  new reboot - i think we inhibit further console output after an NMI 
  printout. )

	Ingo
