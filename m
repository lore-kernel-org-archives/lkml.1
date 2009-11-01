Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbZKANFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbZKANFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 08:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZKANFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 08:05:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:52575 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZKANFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 08:05:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Lb/bxIlEPUxS2GctbNEsIHoXDa6BprPdOHWfwqsERcFfU6qrJuhaX4yQbD+cyE8UmQ
         147qtFNTNgqeUY671Uo83a2afYrqsf2Cl5xxBX95zV+VokHhd1j+Cntsel+l7epbMEtS
         BV7S6DDB/IIV5vbtE/ggrFPnf7UpLmcCdOJVI=
MIME-Version: 1.0
Date: Sun, 1 Nov 2009 14:05:44 +0100
Message-ID: <f861ec6f0911010505l641d07fbh4608ee4f180fbebd@mail.gmail.com>
Subject: threaded irq handler thread doesn't run
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I noticed that the thread of a threaded irq doesn't run if the interrupt
is disabled:  I have a semi-broken system with 2 carddetect interrupts,
both are supposed to be edge-triggered, but due to broken PLD they
continue screaming as long as their trigger condition is met.  To work
around this, the triggering one is disabled while the other gets enabled;
disabling occurs in the "fast" handler, enabling in the threaded handler:

static irqreturn_t threadfn(irq, ctx)
{
    ...
      enable_irq(irq == cd1int ? cd2int : cd1int);
    ...
}

static irqreturn_t fastint(irq, ctx)
{
  disable_irq_nosync(irq);
  return IRQ_WAKE_THREAD;
}
...
request_threaded_irq(cd1int, fastint, threadfn, 0, "insert", ctx);
request_threaded_irq(cd2int, fastint, threadfn, 0, "eject", ctx);

In kernel/irq/manage.c::irq_thread(), the thread func isn't run
if the irq has been disabled; is there a way around this?
(removing that restriction completely solves it for me, but I
doubt this is acceptable for others).

Thanks!
     Manuel Lauss
