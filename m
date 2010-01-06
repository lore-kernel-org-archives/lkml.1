Return-Path: <linux-kernel-owner+w=401wt.eu-S932530Ab0AFXA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab0AFXA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932976Ab0AFXAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:00:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51032 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab0AFXAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:00:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=gvJDExKqjtRr3TGPcL3yw2efKuX/P6UDd7gFqupgFfCRNFual6GupaUxGbdJ53svC
	p33xl4m7ZzFLr7w6GqFAA==
Date: Wed, 6 Jan 2010 15:00:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
In-Reply-To: <201001061706.26845.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.1001061454580.11653@chino.kir.corp.google.com>
References: <20100106045509.245662398@samba.org> <20100106045509.245662398@samba.org>> <20100106045525.476396870@samba.org>> <201001061706.26845.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Rusty Russell wrote:

> > pcibus_to_node can return -1 if we cannot determine which node a pci bus
> > is on. If passed -1, cpumask_of_node will negatively index the lookup array
> > and pull in random data:
> 
> If you grep for the callers, you'll see those which do this (now-obsolete)
> check.  One more patch :)
> 

Do we really want to do this?  A nid of -1 is undefined, so the result of 
cpumask_of_node(-1) should be undefined; there's no formal definition that 
a nid of -1 follows the semantics that we use for x86 pci buses, for 
example, where it implies no NUMA locality in all cases.

I think a better fix would be to define -1 where appropriate to either be 
an invalid node, cpu_all_mask, or whatever in the caller:

	mask = (nid != -1) ? cpumask_of_node(nid) : cpu_all_mask;
