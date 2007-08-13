Return-Path: <linux-kernel-owner+w=401wt.eu-S971297AbXHMUtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971297AbXHMUtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970570AbXHMUsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:48:22 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:63522 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970333AbXHMUsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:48:20 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=bRGjGbOpriNylbgwWgFXHsZDNEnzOc0uWZ0B+xjPA1qivTmyP7dvS7HoC5qSZnIIx8rhe7uZJkstnkhAJBbKsAf1hegN3U8R/3zH1yzHlgLYOvOPOb52SPqLefO65j8b;
X-IronPort-AV: E=Sophos;i="4.19,256,1183352400"; 
   d="scan'208";a="339251094"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: EHCI Regression in 2.6.23-rc2
Date: Mon, 13 Aug 2007 15:48:04 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9B18E4E@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <200708101508.21389.webmaster@dragonslave.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: EHCI Regression in 2.6.23-rc2
Thread-Index: AcfbT48NL2d4TtczQBO+xf9FlU6XXACmyZUA
References: <200708101045.57166.dex@dragonslave.de> <Pine.LNX.4.64.0708101125120.3948@twin.jikos.cz> <200708101508.21389.webmaster@dragonslave.de>
From: <Stuart_Hayes@Dell.com>
To: <webmaster@dragonslave.de>, <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>,
       <david-b@pacbell.net>, <jikos@jikos.cz>
X-OriginalArrivalTime: 13 Aug 2007 20:48:10.0107 (UTC) FILETIME=[423374B0:01C7DDEB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Exner wrote:
> Jiri Kosina wrote:
>> On Fri, 10 Aug 2007, Daniel Exner wrote:
>>> Please CC me, as I'm currently not subscribed to this list, thx.
>> 
>> Please also don't forget to CC relevant people/lists when reporting
>> bugs, thanks.
> Guess its ok, now? Thanks anyway :)
> 
>>> After some serious hangs with 2.6.23-rc2 I did some bisects and
>>> this was the result: 196705c9bbc03540429b0f7cf9ee35c2f928a534 is
>>> first bad commit commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
>>> Author: Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
>>> Date:   Thu May 3 08:58:49 2007 -0700
>> 
>> I guess that the patch attached to bug 8535 in kernel.org bugzilla --
>> http://bugzilla.kernel.org/attachment.cgi?id=12228&action=view --
>> solves your issues, right?
> Nope, this does _not_ fix my issue.
> 
> Anything else I could try, or some files you need?
> I tried finding some clue in my logs, but without any results so far.
> 
> Greetings
> Daniel Exner


It appears that the VIA controllers just ignore the "inactivate" bit
completely.

Normally, when I set the "inactivate" bit in the QH and then watch the
QH & overlay, I eventually see the controller clear the "active" bit in
the overlay token, and, of course, it doesn't do the transaction.

With the VIA controller I have, after I set the "inactivate" bit, I
eventually see the controller set bit 1 in the overlay token
(SplitXstate), indicating that it's running the transaction, and, a
couple microframes later, it clears that bit again.  The transaction is
not inactivated.

The problem occurs if a transaction completes when the "inactivate" bit
is set... qh_completions will ignore the transaction until the
"inactivate" bit is cleared, and then, when the transaction should be
re-activated, my patch will set the "active" bit back to 1 in the
overlay & qtd token, even though the transaction was already completed
by the controller...

To work around this, I'd have to re-write my patch so that it didn't
depend on the "inactivate" bit at all... I suppose it could possibly be
done just by directly manipulating the "active" bit in the overlay
token, since already the code doesn't mess with the overlay if there's
any chance that the transaction is alrady cached or in progress, but
that would be tricky.

Perhaps for now the best thing would just be to bypass the EHCI CPU
frequency notifier code (i.e., my patch) for VIA EHCI controllers, since
they are broken.  Would a hard-coded blacklist (just an "if
(manufacturer==VIA)..." type thing) be OK?

I've also acquired a card with an NEC EHCI controller on it, which I'm
going to look at while I'm into it...

Thanks
Stuart
