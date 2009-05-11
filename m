Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZEKTZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZEKTZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZEKTZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:25:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46783 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZEKTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:24:59 -0400
Subject: Re: PowerPC page faults
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <4A08663D.1010703@codemonkey.ws>
References: <20090505132005.19891.78436.stgit@dev.haskins.net>
	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>
	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>
	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>
	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>
	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>
	 <4A0570B1.30401@novell.com>  <4A071F1A.1090702@codemonkey.ws>
	 <1242060260.29194.19.camel@slate.austin.ibm.com>
	 <4A08663D.1010703@codemonkey.ws>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 11 May 2009 14:24:58 -0500
Message-Id: <1242069898.29194.99.camel@slate.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 12:54 -0500, Anthony Liguori wrote:
> For future ppcemb's, do you know if there is an equivalent of a PF exit 
> type?  Does the hardware squirrel away the faulting address somewhere 
> and set PC to the start of the instruction?  If so, no guest memory load 
> should be required.

Ahhh... you're saying that the address itself (or offset within a page)
is the hypercall token, totally separate from IO emulation, and so we
could ignore the access size. I guess it looks like this:

page fault vector:
        if (faulting_address & PAGE_MASK) == vcpu->hcall_page
                handle_hcall(faulting_address & ~PAGE_MASK)
        else
                if (faulting_address is IO)
                        emulate_io(faulting_address)
                else
                        handle_pagefault(faulting_address)

Testing for hypercalls in the page fault handler path would add some
overhead, and on processors with software-managed TLBs, the page fault
path is *very* hot. Implementing the above pseudocode wouldn't be ideal,
especially because Power processors with hardware virtualization support
have a separate vector for hypercalls. However, I suspect it wouldn't be
a show-stopper from a performance point of view.

Note that other Power virtualization solutions (hypervisors from IBM,
Sony, and Toshiba) use the dedicated hypercall instruction and interrupt
vector, which after all is how the hardware was designed. To my
knowledge, they also don't do IO emulation, so they avoid both
conditionals in the above psuedocode.

-- 
Hollis Blanchard
IBM Linux Technology Center

