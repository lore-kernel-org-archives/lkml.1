Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0CDJcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:32:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:64619 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0CDJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:32:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=s3IXpCrwnq884SW9UUtXTdXtZY9kKwPYPUn4VALgb7M1wx8r1AKClYp0bV9Ezp4/Am
         LMilmoMqlqGiZgMeqM4vDHj1ABQagtpyUndOV33el4NeWj+v814TmEanyzM3EsJ8n/69
         Efb3bLuwq5azd9DTyK0Mkt2+6dkFNJFhhd4CI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003040047310.1741@localhost.localdomain>
References: <201002272140.36891.rjw@sisk.pl>
	 <alpine.LFD.2.00.1003031644410.1044@localhost.localdomain>
	 <201003040152.58437.rjw@sisk.pl>
	 <alpine.LFD.2.00.1003040047310.1741@localhost.localdomain>
Date: Thu, 4 Mar 2010 09:32:03 +0000
Message-ID: <9b2b86521003040132v168399ct9241f3ad9ff8c4c7@mail.gmail.com>
Subject: Re: [Resend][PATCH] ACPI / EC: Remove race between EC driver and 
	suspend process (rev. 3)
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/10, Len Brown <lenb@kernel.org> wrote:
> Isn't the problem at hand that the boot-kernel stops
> in mid-transaction, and the resumed hibernate image
> then blunders forward with its first transaction
> only to find the EC in an intermediate state?
>
> If yes, I then making the transaction atomic WRT
> the boot kernel stopping should fix the problem.
>
> The patch sets a FROZEN bit, and subsequent
> requests for EC transactions simply fail.
> How do we know that we set the bit at the right time?
> What transactions or parts of transactions will fail,
> and what are the consequences of those failures?

The problem transactions on my machine were probably started by
ec_check_sci().  I.e. QUERY transactions which read the value of an
event raised by the EC.  (I triggered the problem by pressing ACPI
hotkeys, although I haven't been able to reproduce it since).

That might explain why the transactions can be asynchronous with the
s2disk task - because these transactions are run in the ACPI
workqueue.  Perhaps the workqueue needs to be flushed after the EC GPE
is disabled?

Alan
