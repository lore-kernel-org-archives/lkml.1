Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbZGIVL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbZGIVL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZGIVLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:11:21 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:26557 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZGIVLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:11:21 -0400
MIME-Version: 1.0
Message-ID: <c0e57d57-3f36-4405-b3f1-1a8c48089394@default>
Date: Thu, 9 Jul 2009 14:09:30 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
In-Reply-To: <4A5545CC.9030909@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A565CC4.0022:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have trouble mapping this to a VMM capable of overcommit 
> without just 
> > coming back to CMM2.
> 
> Same for me.  CMM2 has a more complex mechanism, but way
> easier policy than anything else out there.

Although tmem and CMS have similar conceptual objectives,
let me try to describe what I see as a fundamental
difference in approach.

The primary objective of both is to utilize RAM more
efficiently.  Both are ideally complemented with some
longer term "memory shaping" mechanism such as automatic
ballooning or hotplug.

CMM2's focus is on increasing the number of VM's that
can run on top of the hypervisor.  To do this, it
depends on hints provided by Linux to surreptitiously
steal memory away from Linux.  The stolen memory still
"belongs" to Linux and if Linux goes to use it but the
hypervisor has already given it to another Linux, the
hypervisor must jump through hoops to give it back.
If it guesses wrong and overcommits too aggressively,
the hypervisor must swap some memory to a "hypervisor
swap disk" (which btw has some policy challenges).
IMHO this is more of a "mainframe" model.

Tmem's focus is on helping Linux to aggressively manage
the amount of memory it uses (and thus reduce the amount
of memory it would get "billed" for using).  To do this, it
provides two "safety valve" services, one to reduce the
cost of "refaults" (Rik's term) and the other to reduce
the cost of swapping.  Both services are almost
always available, but if the memory of the physical
machine get overcommitted, the most aggressive Linux
guests must fall back to using their disks (because the
hypervisor does not have a "hypervisor swap disk").  But
when physical memory is undercommitted, it is still being
used usefully without compromising "memory liquidity".
(I like this term Jeremy!) IMHO this is more of a "cloud"
model.

In other words, CMM2, despite its name, is more of a
"subservient" memory management system (Linux is
subservient to the hypervisor) and tmem is more
collaborative (Linux and the hypervisor share the
responsibilities and the benefits/costs).

I'm not saying either one is bad or good -- and I'm sure
each can be adapted to approximately deliver the value
of the other -- they are just approaching the same problem
from different perspectives.
