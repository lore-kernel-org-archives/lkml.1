Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXFGRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXFGRTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXFGRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:19:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:44517 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888AbXFGRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lXFBCbWYIN/ikaixqu+/sHeXk/9P+ZQaKH84pKrV5vIpt+2xUV8XL9xX5+Ww3YSjajeK8azPKGVVWPpvirtCVpkj7HLhqCpKOejWoRLKN/4V6zRrPe8mfUPpN5FDdsxZSkX54ndO27IwLKTpDcY7+dw7wyzI4GpFZh8c95v7ZQs=
Message-ID: <a781481a0706071018t26e75c84jba5314dde3fc6019@mail.gmail.com>
Date: Thu, 7 Jun 2007 22:48:10 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
Cc: "Jan Glauber" <jan.glauber@de.ibm.com>,
       "David Miller" <davem@davemloft.net>, akpm@osdl.org, mingo@elte.hu,
       ak@suse.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>, "Avi Kivity" <avi@qumranet.com>
In-Reply-To: <a781481a0706070954l636d752am82ef7ca9703788aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070208203210.GB9798@osiris.ibm.com>
	 <20070208.124328.88477956.davem@davemloft.net>
	 <20070209084221.GA8259@osiris.boeblingen.de.ibm.com>
	 <1171025838.5349.14.camel@localhost.localdomain>
	 <a781481a0706070707j301ba886h10f4607fd6a6e8de@mail.gmail.com>
	 <20070607162743.GA9433@osiris.ibm.com>
	 <a781481a0706070954l636d752am82ef7ca9703788aa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 6/7/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> [...]
> > Avi Kivity has already a patch which introduces an on_cpu() function which
> > looks quite like on_each_cpu(). That way you don't have to open code this
> > stuff over and over again:
> >
> > preempt_disable();
> > if (cpu == smp_processor_id())
> >         func();
> > else
> >         smp_call_function_single(...);
> > preempt_enable();
> >
> > There are already quite a few of these around.
>
> Indeed -- this was doubly problematic because the un-safeness
> was because of smp_processor_id() as well as the (eventual)
> access of cpu_online_map (via smp_call_function() ->
> num_online_cpus()) ... thanks for letting me know about this.

Oh wait, the on_one_cpu() patch proposes on UP:

+static inline int on_one_cpu(int cpu, void (*func)(void *info), void *info,
+			     int retry, int wait)
+{

/* this needs a if (cpu == 0) check here, IMO */

+	local_irq_disable();
+	func(info);
+	local_irq_enable();
+	return 0;

/* else WARN and return -EINVAL; */

+}

which is broken without the suggested additions, IMHO
(this is what got me into this in the first place). There
_is_ a difference between on_each_cpu() and the
smp_call_function* semantics (as discussed on the other
thread -- gargh! my mistake for opening this discussion up
on so many threads), and in its current form on_one_cpu()
has quite confused semantics, trying to mix the two. I guess
on_one_cpu() would be better off simply being just an
atomic wrapper over smp_processor_id() and
smp_call_function_single() (which is the *real* issue that
needs solving in the first place), and do it well.

Satyam
