Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYKHTi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYKHTi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYKHTiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:38:19 -0500
Received: from colo.lackof.org ([198.49.126.79]:42917 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYKHTiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:38:18 -0500
Date: Sat, 8 Nov 2008 12:38:04 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Alex Chiang <achiang@hp.com>, Anil kumar <anils_r@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-pci <linux-pci@vger.kernel.org>
Subject: Re: MSI-X msix_entry.vector population
Message-ID: <20081108193804.GD28039@colo.lackof.org>
References: <886149.56834.qm@web32407.mail.mud.yahoo.com> <20081017182855.GD2137@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017182855.GD2137@ldl.fc.hp.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 12:28:55PM -0600, Alex Chiang wrote:
> 
> cc'ing linux-pci
> 
> * Anil kumar <anils_r@yahoo.com>:
> > Hi,
> > 
> > In the driver, during interrupt registration for MSIX we get
> > the vector numbers assigned from the kernel and we associate
> > the entry and interrupt handlers with this vector.
> > 
> > I want to achieve the following logic in the driver: 
> > In the queuecommand I assign MSIX vector for each command
> > before sending it down. The reason why I want to do this is I
> > want to get the response back in that particular MSIX vector
> > entry interrupt handler only. For example If I am sending two
> > commands down, command1 will have MSIX_vector_1 and command2
> > will have MSIX_vector_2. The interrupt handlers registered are
> > MSIX_vector_1_Int1 and MSIX_vector_2_Int2. When command is
> > complete the response should come back in the respective
> > interrupt handlers registered for MSIX_vector_1 and
> > MSIX_vector_2 only. 
> > 
> > To achieve this, I will take msix_entries.[1].vector and assign
> > it to command1 in queuecommand and msix_entries.[2].vector and
> > assign it to command2.

I never saw any follow up discussion on this.
Has anyone made another proposal?

There was a bit of discussion but a simple method to query NUMA topology
is still missing:
    http://marc.info/?l=linux-pci&m=122223549110218&w=2

e.g. how to define what a "domain" should be for a driver (CPU socket? 
Cell board (collection of Sockets on a board)?)
and how to express those domains to user space so irqbalanced can DTRT.

> > Question:
> > Now if I have a Dual core CPU, CORE1 and CORE2 each with
> > vectors 0 to 4 on them. When I shoot a command with
> > msix_entries[1].vector will the completion for this command
> > come from CORE1 core vector1 or it can come from CORE2 vector1.
> > Is it okay if we get response(triggered interrupt handler) back
> > from CORE2. Will I have any routing issues here?

I don't think so. Setting the /proc/irq/XX/smp_affinity for each MSI
to a different CPU will just target interrupts at the intended CPU.
Harder is to figure out how to know which command queue to use when starting
an IO...still would want to reverse map of "I'm on Core0, therefore use
command2" assuming command2 MSI is targeting Core0.

hth,
grant

> > 
> > -or- 
> > 
> > Is there a way wherein I can call some function to make sure
> > that let the kernel assign MSIX.vector for my command in proper
> > distributed way in my queuecommand.
> > 
> > with regards, Anil
> > 
> >  
> > 
> > 
> >       
> > -- To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to
> > majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html Please read the FAQ
> > at  http://www.tux.org/lkml/
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
