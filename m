Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYCYPOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYCYPOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYCYPO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:14:27 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:46632 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbYCYPO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:14:26 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [BUG] unsolicited IRQ disabling at the IO-APIC leading to eth0 freezes
Date: Tue, 25 Mar 2008 17:15:18 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803251715.18694.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WAS: net: tx timeouts with skge, 8139too, dmfe drivers/NICs

Hi all,

I am observing rare freezes(blocking) of eth0 with:

NETDEV WATCHDOG: eth0: transmit timed out

in dmesg output.

The problem has been already described in a previous message:

http://lkml.org/lkml/2008/2/25/312

with some additional observations, as described in:

http://lkml.org/lkml/2008/3/12/96

Recently I found that the IRQ# used by the driver/NIC has been
somehow disabled/masked  at the IO-APIC, blocking the interrupts to
the driver irq_handler, so the messages: NETDEV WATCHDOG....

Pitting:

disable_irq(_nosync)(irq#);
enable_irq(irq#);

in the dev->tx_timeout() method restores the working state of eth0,
(at least for skge), so the interface now works posting (sometimes)

NETDEV WATCHDOG: eth0: transmit timed out

messages in the log.

If I EXPORT_SYMBOL(irq_desc) (from kernel/irq/handle.c)
I am able to restore the working state of the eth0 interface with

(irq_desc + irq#)->chip->enable(irq#)

or

(irq_desc + irq#)->chip->unmask(irq#)

(properly locked),  instead of disable/enable_irq(irq#), 

Just for info the driver irq_handler always return IRQ_HANDLED and never 
(verified) IRQ_NONE, so the irq# is not disabled due to unhandled irqs - 
yes the driver declares IRQF_SHARED, but is the only one on this irq# 
(as viewed in /proc/interrupts).

The system is runing kernel-2.6.14.3-SMP (AMD64 X2) on Asus A7V Deluxe

Am I observing IRQ locking/rice condition OUT of net driver?

All suggestions for further investigation are wellcome.

Marin Mitov


