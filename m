Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZLBM2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZLBM2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZLBM2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:28:31 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:50918 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLBM2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:28:30 -0500
Message-ID: <4B165D71.5010408@ladisch.de>
Date: Wed, 02 Dec 2009 13:28:33 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: markh@compro.net
CC: Mai Daftedar <mai.daftedar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Signal from kernel space to user space
References: <2cd4ff050912010307h5570a376xc220a95947775eae@mail.gmail.com> <4B151A86.1060505@ladisch.de> <4B1533B0.1030007@compro.net>
In-Reply-To: <4B1533B0.1030007@compro.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Clemens Ladisch wrote:
> > kill_pid_(info) is to be preferred over send_sig_info because it ensures
> > that the destination process has the same identity (a plain pid number
> > might have wrappend around and be in use by another process).
> 
> Does that mean I can't assume my process pid will unique for the life of the process?

The pid _does_ uniquely identify your process.  However, after the
process has died, it could be used for some new process, and
send_sig_info would happily kill the new process.

> > However, why are you using a signal? What information are you trying to
> > send, and why wouldn't eventfd or a plain device thaz becomes readable
> > be a better solution?
> 
> If no "information" is required, which of these are the fastest, say
> from an interrupt handler?

If there really is no information, doing nothing would be fastest.  ;-)

If you want to tell userland that some event has happened, the various
mechanisms are not much different as far as the kernel is concerned,
as long as you don't have many thousands of events per seconds; the
biggest problems for event delivery are scheduling the userland process
for execution and handling of the event.

Signals handlers interrupt any other userland code and therefore are
not allowed to do much; therefore, I would strongly prefer to use
some file handle that can be waited on with poll().  Furthermore,
poll() allows to wait for multiple handles, and does not have the
complexities of signal delivery and blocking.  I would use signals only
if the handler must interrupt any other running code, and if the signal
can be handled completely without running into reentrancy problems.

It is possible to handle signals with poll() by using signalfd, but
when designing a new interface, one could just use eventfd instead.


Best regards,
Clemens
