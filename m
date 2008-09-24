Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYIXVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYIXVQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYIXVQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:16:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:43497 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYIXVQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:16:29 -0400
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
	hardirq preemption
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Milton Miller <miltonm@bga.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Christoph Raisch <RAISCH@de.ibm.com>, linuxppc-dev@ozlabs.org,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Sebastien Dugue <sebastien.dugue@bull.net>
In-Reply-To: <f30d1d832fd4ad096afccf198c14a7bb@bga.com>
References: <200809231743.23828.ossthema@de.ibm.com>
	 , <20080915100406.342e027a@bull.net>
	 <200809240958.m8O9wM7k010996@sullivan.realtime.net>
	 <1222251467.8277.73.camel@pasglop>
	 <f30d1d832fd4ad096afccf198c14a7bb@bga.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 07:14:07 +1000
Message-Id: <1222290847.8277.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> There may be some implicit assumption in that we expect the cpu 
> priority to be returned to normal by the EOI, but there is nothing in 
> the hardware that requires the EOI to come from the same cpu as 
> accepted the interrupt for processing, with the exception of the IPI 
> which is per-cpu (and the only interrupt that is per-cpu).

Well, there is one fundamental one: The XIRR register we access is
per-CPU, so if we are to return the right processor priority, we must
make sure we write the right XIRR.

Same with Cell, MPIC, actually and a few others. In general I'd say most
fast_eoi type PICs have this requirement.

> It would probably mean adding the concept of the current cpu priority 
> vs interrupts and making sure we write it to hardware at irq_exit() 
> time when deferring the actual irq handlers.

I think we need something like a special -rt variant of the fast_eoi
handler that masks & eoi's in ack() before the thread is spun off, and
unmasks instead of eoi() when the irq processing is complete.

Ben.


