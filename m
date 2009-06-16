Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZFPOqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZFPOqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZFPOqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:46:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbZFPOqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:46:37 -0400
Date: Tue, 16 Jun 2009 17:46:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based
	notifier interface
Message-ID: <20090616144618.GB18196@redhat.com>
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37AEF7.7070203@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37AEF7.7070203@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 10:40:55AM -0400, Gregory Haskins wrote:
> > This is ugly, isn't it? With CONFIG_PREEMPT=no preemptible() is always false.
> >
> > Further, to do useful things it might not be enough that you can sleep:
> > with iofd you also want to access current task with e.g. copy from user.
> >   
> 
> Something else to consider:  For iosignalfd, we can assume we will
> always be called from vcpu process context so we might not really need
> official affirmation from the system.  For irqfd, we cannot predict who
> may be injecting the interrupt (for instance, it might be a
> PCI-passthrough hard-irq context).  I am not sure if this knowledge
> actually helps to simplify the problem space, but I thought I should
> mention it.
> 
> -Greg
> 
> 

The way this is addressed with eventfd_signal_task proposal is:
- user calls eventfd_signal_task
  we look at current->mm and figure out whether this is the right
  context or we need a context switch
- everyone else calls eventfd_signal
  we know that we need a context switch


