Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbXGRF7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbXGRF7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXGRF7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:59:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53076 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbXGRF7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:59:12 -0400
X-Sasl-enc: a2pqPZy4+8ySQfJ9wpoKB+GWiGk0WqHMKDUn1OrkPIGD 1184738350
Subject: RE: [patch] CFS scheduler, -v19
From: Ian Kent <raven@themaw.net>
To: davids@webmaster.com
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, Bill Davidsen <davidsen@tmr.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEBPFGAC.davids@webmaster.com>
References: <MDEHLPKNGKAHNMBLJOLKKEBPFGAC.davids@webmaster.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 13:59:04 +0800
Message-Id: <1184738344.4178.18.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 14:16 -0700, David Schwartz wrote:
> > * Ian Kent <raven@themaw.net> wrote:
> >
> > > Yes it does and I have two reported bugs so far.
> > >
> > > In several places I have code similar to:
> > >
> > > wait.tv_sec = time(NULL) + 1;
> > > wait.tv_nsec = 0;
> > >
> > > signaled = 0;
> > > while (!signaled) {
> > >         status = pthread_cond_timedwait(&cond, &mutex, &wait);
> > >        if (status) {
> > >              if (status == ETIMEDOUT)
> > >                   break;
> > >              fatal(status);
> > >       }
> > > }
> >
> > ah! It passes in a low-res time source into a high-res time interface
> > (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to
> > time(NULL) + 2, or change it to:
> >
> > 	gettimeofday(&wait, NULL);
> > 	wait.tv_sec++;
> >
> > does this solve the spinning?

Yes, adding in the offset within the current second appears to resolve
the issue. Thanks Ingo.

> >
> > i'm wondering how widespread this is. If automount is the only app doing
> > this then _maybe_ we could get away with it by changing automount?

I don't think the change is unreasonable since I wasn't using an
accurate time in the condition wait, so that's a coding mistake on my
part which I will fix.

Ian


