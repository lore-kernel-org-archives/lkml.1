Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbZFIShQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbZFIShQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbZFIShB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:37:01 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54513 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758981AbZFIShA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:37:00 -0400
Date: Tue, 9 Jun 2009 11:36:56 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13116] Can't boot with nosmp
Message-ID: <20090609113656.46ed6335@nehalam>
In-Reply-To: <4A2EAA53.7060006@redhat.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	<D9VoutSOyXP.A.xm.Vb7KKB@chimera>
	<20090608091544.53a94235@nehalam>
	<e9c3a7c20906080929l1a4ec739t7585f6bba54bf684@mail.gmail.com>
	<20090608170437.1c2386a5@nehalam>
	<e9c3a7c20906091020m19abf3b5wbbb7f5364b2d4905@mail.gmail.com>
	<4A2EAA53.7060006@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Jun 2009 21:30:43 +0300
Avi Kivity <avi@redhat.com> wrote:

> Dan Williams wrote:
> > On Mon, Jun 8, 2009 at 5:04 PM, Stephen Hemminger<shemminger@vyatta.com> wrote:
> >   
> >> I did some more debugging, and the problem appears to be that
> >> booting with nosmp still leaves all the CPU's present in the cpu
> >> possible mask. So code like dma engine (or loopback device), that
> >> use alloc_percpu get broken.
> >>
> >> Not sure why all the cpu's are still showing up in the possible mask.
> >> Rusty? do you have an answer.
> >>     
> >
> > Would this recent commit also fix this issue?
> >
> > commit a4c0364be3f43d3e17fe19270f8b3d64881606e6
> > Author: Avi Kivity <avi@redhat.com>
> > Date:   Sat Jun 6 12:34:39 2009 +0300
> >
> >     KVM: Explicity initialize cpus_hardware_enabled
> >
> >     Under CONFIG_MAXSMP, cpus_hardware_enabled is allocated from the heap and
> >     not statically initialized.  This causes a crash on reboot when kvm thinks
> >     vmx is enabled on random nonexistent cpus and accesses nonexistent percpu
> >     lists.
> >
> >     Fix by explicitly clearing the variable.
> >
> >     Cc: stable@kernel.org
> >     Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
> >     Signed-off-by: Avi Kivity <avi@redhat.com>
> >   
> 
> This only affects reboots.  But yes, the cpumask code has bugs.  Does 
> the .config involved select MAXSMP?
> 

Patch does not fix the problem. Not sure if it is KVM only problem.
Look like possible cpumask always equals what ACPI / SMP tables report.
So currently looking into alloc_percpu which may not handle the possible
but never used cpus.

It is x86-64 config and does not have MAXSMP set. It does have NR_CPUS set.

-- 
