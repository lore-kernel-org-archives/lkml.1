Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbZEKW4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbZEKW4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759575AbZEKW42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:56:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbZEKW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:56:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=isQ5WtXMXWe1B3tpzSScS3NTs3KpyS1sW2RTu8DpGfFIzawwArFjplUV4GM1j9dCD
	VCH7+EV17HGYU7HJFP3fA==
Date: Mon, 11 May 2009 15:56:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jack Steiner <steiner@sgi.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
In-Reply-To: <20090511213354.GD553@sgi.com>
Message-ID: <alpine.DEB.2.00.0905111550070.5979@chino.kir.corp.google.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <20090511213354.GD553@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Jack Steiner wrote:

> Cpus also belong to nodes. The cpu_to_node_map[] provides the mapping.
> I have not tried it, but I wonder what happens if you offline all of the
> memory of a node (probably not possible so this may be hypothetical for now).
> Should offlining all node memory change the node that a cpu on the node
> are associated with? That does not seem right.
> 

No, it would simply become a memoryless node and NODE_DATA() should 
probably be freed or just represent spanned_pages of 0.

Memoryless node support has already been merged (and needs to be fixed), 
but the same toplogies could be represented with memory-only nodes which 
may have been a better approach considering your point about memory 
offline and our lack of node hot-remove.

> Agree. FWIW, it works ok in 2.6.27. I need to bisect to find where the regression
> occurred.
> 

I'm not so sure it will help to identify which patch caused the issue, it 
depends on whether we want to support memoryless nodes or not and then 
address the issues as they arise when there is no memory attached, which 
you've done in this case.

We can fix your particular issue by deciding how node_online_map and its 
superset, node_possible_map, are handled for memoryless nodes.  Such users 
need to iterate over N_NORMAL_MEMORY instead.
