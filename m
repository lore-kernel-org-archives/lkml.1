Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZECJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZECJBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZECJBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:01:14 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64938 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZECJBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ET6EHXB/kAibRhL08NJDI3TeiI6ab/hFdu6jzLCDxnUcKlB7LuuTm0GVWfLsb7DfSQ
         p8NkyMhQvhFBnX/G+syoLy4F5Kg3m7pYuehZn/SVEAdyq8IMR58YNk4QgikyvOM9kalp
         bNDbR/e9EQN9FkcLI8x1kJeWsKsRUJZAGRMes=
Date: Sun, 3 May 2009 13:01:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
	uv_system_init
Message-ID: <20090503090109.GA4615@lenovo>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu> <20090501200937.GD4633@lenovo> <20090501202511.GE4633@lenovo> <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503084847.GA20394@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, May 03, 2009 at 10:48:47AM +0200]
| 
| * Jack Steiner <steiner@sgi.com> wrote:
| 
| > >  arch/x86/kernel/apic/x2apic_uv_x.c |    3 +++
| > >  1 file changed, 3 insertions(+)
| > > 
| > > Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
| > > =====================================================================
| > > --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
| > > +++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
| > > @@ -584,15 +584,18 @@ void __init uv_system_init(void)
| > >  
| > >  	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
| > >  	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
| > > +	BUG_ON(!uv_blade_info);
| > >  
| > >  	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
| > >  
| > >  	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
| > >  	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
| > > +	BUG_ON(!uv_node_to_blade);
| > >  	memset(uv_node_to_blade, 255, bytes);
| > >  
| > >  	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
| > >  	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
| > > +	BUG_ON(!uv_cpu_to_blade);
| > >  	memset(uv_cpu_to_blade, 255, bytes);
| 
| Hm, would be nice if we had a __GFP_PANIC variant in kmalloc that 
| would just panic straight in the allocator, when allocation failure 
| is not acceptable. (Andrew Cc:-ed)
| 
| It does not increase the priority of the allocation nor does it 
| trigger any 'dont fail' logic - it is simply the central expression 
| of 'this should not have failed, panic'.
| 
| Thus we'd avoid all these duplicated BUG_ON() places.
| 
| 	Ingo
| 

Yes, we have SLAB_PANIC, the similar (in behaviour) could be
done for kmalloc. (Pekka and Rik CC'ed as well)

	-- Cyrill
