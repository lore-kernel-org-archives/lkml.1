Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbZIHS6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbZIHS6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZIHS6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:58:34 -0400
Received: from claw.goop.org ([74.207.240.146]:33079 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbZIHS6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:58:34 -0400
Message-ID: <4AA6A95B.2030602@goop.org>
Date: Tue, 08 Sep 2009 11:58:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Miroslav Rezanina <mrezanin@redhat.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Gianluca Guida <gianluca.guida@citrix.com>
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
References: <1864241231.701071252327314933.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1864241231.701071252327314933.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/09 05:41, Miroslav Rezanina wrote:
> can you give me a practical example, where e820 map can have "hole" inside,
> i.e. there will be block of memory not listed in e820 map that have listed 
> memory before and after it?
> As I checked the source code, there is always removed memory from some point
> till end of map, not from one adress till another. And I can't image how would
> be such a case handled. Of course, there can be some special regions, as the PCI
> hole, but these are marked as "Reserved".
> There can be "reserved and returned" some inside memory, but this is already
> handled  by balloon driver. My patch returns memory that this driver can't use.
>   

PCI memory isn't typically reserved; there's just a hole in the address
space for it.  Its up to the BIOS/OS to set the BARs for the devices
into that hole.  Reserved E820 regions are just that - reserved by the
BIOS for its own purposes.

In a Xen domain, the E820 tables are purely synthesized by the kernel's
Xen code, and can have any content we like.  At the moment they tend to
be very simple with linear memory up to the domain's memory size.  For
domains with PCI access - either dom0 or with pcifront - we want to be
able to carve out regions from that memory to place devices.  We may
want to manipulate the E820 tables to reshape memory for other reasons
(like pre-ballooned memory, or memory hotplug).

What I'm looking for is a nice general purpose routine which will walk a
set of E820 entries and release back to Xen any memory which is in an
E820 hole (ie, in a gap between or after E820 entries).  That solves the
simple problem of trimming the end of the memory map, but also copes
with more complex cases that will arise.

    J
