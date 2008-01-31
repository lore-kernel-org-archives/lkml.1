Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbYAaVaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbYAaVaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYAaV34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:29:56 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:13986 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYAaV3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XzZbKGM/TFd97MCEXk3wqNaFTu4QRENNP0LjG+GjPxqq8wul2LWoF0iQjjzcgFieyeFaE+AivvgQAgm6WZiGLc23XpsZ/gS8tj7y8cOBxTG73wWrPzHV3obwP+XftZhBkESY43cnvHUIi+7P76Q9GYW+Bsm1u2zVdtG7fUK63uY=
Message-ID: <86802c440801311329h67a79139xa33994e2cc116781@mail.gmail.com>
Date: Thu, 31 Jan 2008 13:29:52 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Brice Goglin" <Brice.Goglin@inria.fr>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Purpose of numa_node?
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Chris Snook" <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47A1D03A.3020508@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A11ACD.1090400@redhat.com> <20080131074045.GA13788@linux-sh.org>
	 <47A1D03A.3020508@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 5:42 AM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> Paul Mundt wrote:
> > On Wed, Jan 30, 2008 at 07:48:13PM -0500, Chris Snook wrote:
> >
> >> While pondering ways to optimize I/O and swapping on large NUMA machines, I
> >> noticed that the numa_node field in struct device isn't actually used
> >> anywhere. We just have a couple dozen lines of code to conditionally
> >>  create a sysfs file that will always return -1.  Is anyone even working on
> >> code to actually use this field?  I think it's a good piece of information
> >> to keep track of, so I'm not suggesting we remove it, but I want to make
> >> sure I'm not stepping on toes or duplicating effort if I try to make it
> >> useful.
> >>
> > It's manipulated with accessors. If you look at the users of
> > dev_to_node()/set_dev_node() you can see where it's being used. It's
> > primarily used in allocation paths for node locality, and the existing
> > set_dev_node() callsites are places where node locality information
> > already exists (ie, which node a given controller sits on). You can see
> > this in places like PCI (pcibus_to_node()) and USB, with node allocation
> > hints used in places like the dmapool and skb alloc paths.
> >
> > The in-kernel use looks perfectly sane in that regard, though I'm not
> > sure what the point of exporting this as a RO attribute to userspace is.
> > Presumably someone has a tool somewhere that cares about this.
> >
>
> I added the numa_node sysfs attribute in the beginning to make it easier
> to bind processes near some devices. So yes I have some user-space tool
> using it. It is much easier to use than the local_cpus field on large
> machines, especially when you use the libnuma interface to bind things,
> since you don't have to translate numa_node from/to cpumasks.
>
> It works fine on regular machines such as dual opterons. However, I
> noticed recently that it was wrong on some quad-opteron machines (see
> http://marc.info/?l=linux-pci&m=119072400008538&w=2) because something
> is not initialized in the right order. But I haven't tested 2.6.24 on
> this hardware yet, and I don't know if things have changed regarding this.

that will depend if you dsdt have _PXM for your pci root bus.
otherwise you will get all -1

I have a patchset locally that it call bus_numa, can get that from pci
conf space for AMD64 based machine.
so you can use that for AMD64 system without _PXM for pci root bus or
even with acpi=off.

let me know if you want test it.

YH
