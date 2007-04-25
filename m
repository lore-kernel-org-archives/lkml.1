Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXDYMwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXDYMwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965620AbXDYMwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:52:38 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:47290 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965583AbXDYMwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:52:37 -0400
Subject: Re: [PATCH 10/10] Use safe_apic_wait_icr_idle in
	__send_IPI_dest_field - x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, horms@verge.net.au,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@in.ibm.com, mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
In-Reply-To: <200704251433.40302.ak@suse.de>
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
	 <1177501872.17974.56.camel@sebastian.intellilink.co.jp>
	 <200704251433.40302.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 21:52:36 +0900
Message-Id: <1177505556.19745.16.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 14:33 +0200, Andi Kleen wrote:
> On Wednesday 25 April 2007 13:51:12 Fernando Luis Vázquez Cao wrote:
> > Use safe_apic_wait_icr_idle to check ICR idle bit if the vector is
> > NMI_VECTOR to avoid potential hangups in the event of crash when kdump
> > tries to stop the other CPUs.
> 
> But what happens then when this fails? Won't this give another hang?
> Have you tested this?
In kdump the crashing CPU (i.e. the CPU that called crash_kexec) is the
one in charge of rebooting into and executing the dump capture kernel.
But before doing this it attempts to stop the other CPUs sending a IPI
using NMI_VECTOR as the vector. The problem is that sometimes delivery
seems to fail and the crashing CPU gets stuck waiting for the ICR status
bit to be cleared, which will never happen. 

With this patch, when safe_apic_wait_icr_idle times out the CPU will
continue executing and try to hand over control to the dump capture
kernel as usual. After applying this patch I have not seen hangs in the
reboot path to second kernel showing the symptoms mentioned before, but
perhaps I am just being lucky and there is something else going on.

