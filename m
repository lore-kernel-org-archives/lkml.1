Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZEKT2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZEKT2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbZEKT1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:27:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31363 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbZEKT1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:27:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=HOkg1W5fzHpR2K9UFN5rC/wmStn/2KmKSt2Nd4SDmlZKwszH8ARhSzxQrdAiFR/m5
	9pfoTbzgK8ExJBPY8Oa0A==
Date: Mon, 11 May 2009 12:27:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jack Steiner <steiner@sgi.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
In-Reply-To: <20090511175312.GA27905@sgi.com>
Message-ID: <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Jack Steiner wrote:

> Do we have a clear and unambiguous definition of what a node really is?
> In this case, is a board (socket) with cpus, a unique PXM but no memory
> considered a node. Even though it has no memory, it is a node (depending on the
> definition of "node") for purposes such as scheduling. The memoryless node also
> has local IO buses that want to direct interrupts to node-local cpus.
> 

In your example of two cpus (0-1) that are remote to the system's only 
memory and two cpus (2-3) that have affinity to that memory, it appears as 
though the kernel is considering cpus 2-3 and the memory to be a node and 
cpus 0-1 to be a memoryless node.

That's a pretty useless scenario for memoryless node support, actually, 
unless there's a third node with memory that cpus 0-1 have a different 
distance to.  cpus 0-1 have no memory that is local, so the "remote" 
memory should be considered local to them.

I don't know who has been pushing the memoryless node support, but it 
appears as though it hasn't been fully tested yet.  The NULL pglist_data 
here for node 0 seems appropriate since you don't need it unless you're 
describing memory, but the kernel implies that if a bit is set in 
node_online_map or node_possible_map that it has this associated data.

Added Andi Kleen to the cc list.
