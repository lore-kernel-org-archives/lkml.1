Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0CDTSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:18:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab0CDTR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:17:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: Re: [Resend][PATCH] ACPI / EC: Remove race between EC driver and suspend process (rev. 3)
Date: Thu, 4 Mar 2010 20:20:54 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
References: <201002272140.36891.rjw@sisk.pl> <alpine.LFD.2.00.1003040047310.1741@localhost.localdomain> <9b2b86521003040132v168399ct9241f3ad9ff8c4c7@mail.gmail.com>
In-Reply-To: <9b2b86521003040132v168399ct9241f3ad9ff8c4c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003042020.54715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 March 2010, Alan Jenkins wrote:
> On 3/4/10, Len Brown <lenb@kernel.org> wrote:
> > Isn't the problem at hand that the boot-kernel stops
> > in mid-transaction, and the resumed hibernate image
> > then blunders forward with its first transaction
> > only to find the EC in an intermediate state?
> >
> > If yes, I then making the transaction atomic WRT
> > the boot kernel stopping should fix the problem.
> >
> > The patch sets a FROZEN bit, and subsequent
> > requests for EC transactions simply fail.
> > How do we know that we set the bit at the right time?

Well, setting it later simply doesn't make sense and setting it earlier might
disturb things.

> > What transactions or parts of transactions will fail,
> > and what are the consequences of those failures?
> 
> The problem transactions on my machine were probably started by
> ec_check_sci().  I.e. QUERY transactions which read the value of an
> event raised by the EC.  (I triggered the problem by pressing ACPI
> hotkeys, although I haven't been able to reproduce it since).
> 
> That might explain why the transactions can be asynchronous with the
> s2disk task - because these transactions are run in the ACPI
> workqueue.  Perhaps the workqueue needs to be flushed after the EC GPE
> is disabled?

Yes, and that's what the patch does.  It calls acpi_os_wait_events_complete()
to flush the workqueue (actually, two of them) and _then_ sets the FROZEN
bit.

Dropping stuff on the floor after the FROZEN bit has been set doesn't change
things too much, because we're going to turn interrupts off shortly after that.
However, the FROZEN bit is set under the EC mutex, which automatically makes
us wait if any transaction is in progress while we're trying to set the FROZEN
bit.

Rafael
