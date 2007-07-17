Return-Path: <linux-kernel-owner+w=401wt.eu-S935936AbXGQVRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935936AbXGQVRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXGQVR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:17:27 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1505 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbXGQVR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:17:26 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Ian Kent" <raven@themaw.net>
Cc: "Chuck Ebbert" <cebbert@redhat.com>, "Bill Davidsen" <davidsen@tmr.com>
Subject: RE: [patch] CFS scheduler, -v19
Date: Tue, 17 Jul 2007 14:16:39 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEBPFGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070717074537.GA13539@elte.hu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 17 Jul 2007 14:17:04 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 17 Jul 2007 14:17:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> * Ian Kent <raven@themaw.net> wrote:
>
> > Yes it does and I have two reported bugs so far.
> >
> > In several places I have code similar to:
> >
> > wait.tv_sec = time(NULL) + 1;
> > wait.tv_nsec = 0;
> >
> > signaled = 0;
> > while (!signaled) {
> >         status = pthread_cond_timedwait(&cond, &mutex, &wait);
> >        if (status) {
> >              if (status == ETIMEDOUT)
> >                   break;
> >              fatal(status);
> >       }
> > }
>
> ah! It passes in a low-res time source into a high-res time interface
> (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to
> time(NULL) + 2, or change it to:
>
> 	gettimeofday(&wait, NULL);
> 	wait.tv_sec++;
>
> does this solve the spinning?
>
> i'm wondering how widespread this is. If automount is the only app doing
> this then _maybe_ we could get away with it by changing automount?

This code is horribly broken. Don't change the kernel because this code is
broken.

First it adds a second, but then it subtracts up to a second. Just before
the second boundary, this code can burn CPU like crazy, with each wait being
just a few nanoseconds.

What is the intent of this code? Is it to wait "up to a second, possibly for
no time at all" or is to wait "for at least a second"? If so, why are you
zeroing the nanosecond count?

DS


