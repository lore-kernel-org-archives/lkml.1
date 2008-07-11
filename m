Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYGKDCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYGKDCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 23:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYGKDCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 23:02:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44147 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYGKDCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 23:02:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>
	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>
	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>
	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>
	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>
	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>
	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org>
	<m1prpl4pmh.fsf@frodo.ebiederm.org> <48764C21.4020601@zytor.com>
	<m1fxqhzhcu.fsf@frodo.ebiederm.org> <4876608B.10408@sgi.com>
	<m1zloptrwt.fsf@frodo.ebiederm.org> <4876B9CD.6080802@sgi.com>
Date: Thu, 10 Jul 2008 19:57:22 -0700
In-Reply-To: <4876B9CD.6080802@sgi.com> (Mike Travis's message of "Thu, 10 Jul
	2008 18:39:25 -0700")
Message-ID: <m1hcaxcelp.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3826]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> If you could dig that up, that would be great.  Another engr here at SGI
> took that task off my hands and he's been able to do a few things to reduce
> the "# irqs" but irq_desc is still one of the bigger static arrays (>256k).

So the part I had completed which turns takes the NR_IRQS array out of kernel_stat
I posted.  Here are my mental notes on how to handle the rest.

Also if you will notice on x86_64 everything that is per irq is in irq_cfg.
Which explains why irq_cfg grows.  We have those crazy bitmaps almost useless
bitmaps of which cpu we want to direct irqs to.  In the irq configuration so that
doesn't help.

The array sized by NR_IRQS irqs are in:

drivers/char/random.c:static struct timer_rand_state *irq_timer_state[NR_IRQS];
  looks like it should go in irq_desc (it's a generic feature).

drivers/pcmcia/pcmcia_resource.c:static u8 pcmcia_used_irq[NR_IRQS];
  That number should be 16 possibly 32 for sanity not NR_IRQS.

drivers/net/hamradio/scc.c:static struct irqflags { unsigned char used : 1; } Ivec[NR_IRQS];
drivers/serial/68328serial.c:struct m68k_serial *IRQ_ports[NR_IRQS];
drivers/serial/8250.c:static struct irq_info irq_lists[NR_IRQS];
drivers/serial/m32r_sio.c:static struct irq_info irq_lists[NR_IRQS];
  The are all drivers and should allocate a proper per irq structure like every other driver.

drivers/xen/events.c:static struct packed_irq irq_info[NR_IRQS];
drivers/xen/events.c:static int irq_bindcount[NR_IRQS];
  For all intents and purposes this is another architecture, that should be fixed up
  at some point.


The interfaces from include/linux/interrupt.h that take irq interfaces
that take an irq number are slow path.

So it is just a matter of writing an irq_descp(irq) that returns
an irq_desc and returns an irq.  The definition would go something
like:

#ifndef CONFIG_DYNAMIC_NR_IRQ
#define irq_descp(irq) (irq >= 0 && irq < NR_IRQS)? (irq_desc + irq) : NULL
#else
struct irq_desc *irq_descp(int irq)
{
        struct irq_desc *desc;
        rcu_read_lock();
        list_for_each_entry_rcu(desc, &irq_list, list) {
        	if (desc->irq == irq)
                	return desc;
        }
        rcu_read_unlock();
        return NULL;
}
#endif

Then the generic irq code just needs to use irq_descp through out.
And the arch code needs to allocate/free irq_descs and add them to the
list.  With say:
int add_irq_desc(int irq, struct irq_desc *desc)
{
        struct irq_desc *old;
        int error = -EINVAL;
	spin_lock(&irq_list_lock);
        old = irq_descp(irq);
        if (old)
        	goto out;
	list_add_rcu(&desc.list, &irc_list);
        error = 0;
        return error;    
}
With architecture picking the irq number so it can be stable and have meaning
to users.

Starting from that direction it isn't too hard and it should yield timely results.

Eric

