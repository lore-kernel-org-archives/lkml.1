Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZJVWJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZJVWJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbZJVWI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:08:59 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:64454 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbZJVWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:08:58 -0400
Message-ID: <4AE0D72A.4090607@nortel.com>
Date: Thu, 22 Oct 2009 16:05:30 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: Irq architecture for multi-core network driver.
References: <4AE0D14B.1070307@caviumnetworks.com>
In-Reply-To: <4AE0D14B.1070307@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2009 22:08:32.0133 (UTC) FILETIME=[313BFB50:01CA5364]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2009 03:40 PM, David Daney wrote:

> The main problem I have encountered is how to fit the interrupt
> management into the kernel framework.  Currently the interrupt source
> is connected to a single irq number.  I request_irq, and then manage
> the masking and unmasking on a per cpu basis by directly manipulating
> the interrupt controller's affinity/routing registers.  This goes
> behind the back of all the kernel's standard interrupt management
> routines.  I am looking for a better approach.
> 
> One thing that comes to mind is that I could assign a different
> interrupt number per cpu to the interrupt signal.  So instead of
> having one irq I would have 32 of them.  The driver would then do
> request_irq for all 32 irqs, and could call enable_irq and disable_irq
> to enable and disable them.  The problem with this is that there isn't
> really a single packets-ready signal, but instead 16 of them.  So If I
> go this route I would have 16(lines) x 32(cpus) = 512 interrupt
> numbers just for the networking hardware, which seems a bit excessive.

Does your hardware do flow-based queues?  In this model you have
multiple rx queues and the hardware hashes incoming packets to a single
queue based on the addresses, ports, etc. This ensures that all the
packets of a single connection always get processed in the order they
arrived at the net device.

Typically in this model you have as many interrupts as queues
(presumably 16 in your case).  Each queue is assigned an interrupt and
that interrupt is affined to a single core.

The intel igb driver is an example of one that uses this sort of design.

Chris

