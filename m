Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYAOXOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYAOXOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYAOXOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:14:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862AbYAOXOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:14:39 -0500
Date: Tue, 15 Jan 2008 15:11:30 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jan Christoph Nordholz <hesso@pool.math.tu-berlin.de>
Cc: kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net_device refcnt bug when NFQUEUEing bridged packets
Message-ID: <20080115151130.6d26e364@deepthought>
In-Reply-To: <20080115230544.GA21214@pool.math.tu-berlin.de>
References: <20080115230544.GA21214@pool.math.tu-berlin.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 00:05:44 +0100
Jan Christoph Nordholz <hesso@pool.math.tu-berlin.de> wrote:

> Hi,
> 
> I came across the following bug a few weeks ago (which still applies to
> 2.6.24-rc7):
> 
> Packets that are to be sent out over a bridge device are skb_clone()d in
> br_loop() before traversing the appropriate (FORWARD/OUTPUT) NF chain. 
> The copies made by skb_clone() share their nf_bridge metadata with the
> original, which is no problem usually.
> If however one or more packets of a br_loop() run end up in a NFQUEUE,
> their shared nf_bridge metadata causes trouble when they are about to be
> reinjected: nf_reinject() decrements the net_device refcounts that were
> previously upped when queueing the packet in __nf_queue(), but as
> skb->nf_bridge->physoutdev points to the same device for all these
> packets, most (if not all) of them will affect the wrong refcnt.
> 
> (I originally encountered the bug on a Xen host because the hypervisor
> refused to shutdown a virtual device with non-zero refcount... but it is
> perfectly reproducible with a standard kernel, too, although it was a
> bit more tedious to create a test scenario, involving a couple of UMLs.)
> 
> I'd suggest to make a real copy of the nf_bridge member in br_loop() if
> CONFIG_BRIDGE_NETFILTER is defined - I've attached a patch that illus-
> trates how to fix the bug (and the machine I've found the bug on is
> running a kernel with this patch since weeks and has not had any
> refcount anomalies since), but I admit it is ugly, returning the reference
> acquired by __nf_copy() and then copying manually...
> 
> Please tell me where that logic should really go (skbuff.h? br_netfilter.c?)
> so I can wrap up a final and CodingStyle-conformant version, or feel free
> to simply apply a modified version.
> 
> 
> Regards,
> 
> Jan
> 
>

Please submit a bug to kernel bugzilla.  Not sure that the patch is the
proper way to fix this.

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
