Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYBCVk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYBCVk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYBCVkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:40:17 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:45216 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYBCVkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:40:14 -0500
Date: Sun, 3 Feb 2008 23:40:11 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH v2] x86: Add a list for custom page fault handlers.
Message-ID: <20080203234011.5f18ad21@daedalus.pq.iki.fi>
In-Reply-To: <20080203070321.GA8293@elte.hu>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2008 08:03:21 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> i dont think this second problem is a practical one: i've test-merged 
> mmiotrace two days ago into x86.git and it's holding up very well in my 
> testing (it has not caused a single hickup so far). It's nice optional 
> debug functionality and i dont see any reason why not to merge it.

Good to hear!

I've made some fixes since my last mmiotrace patch (v2). Rewritten things
to use lookup_address(), added EXPORT_SYMBOL(lookup_address) into
pageattr.c to make it work (this hopefully fixed the undefined symbol
'init_mm' on x86-32), and fixed relay-buffer-full flags on SMP.

> a few cleanup requests:
> 
> - please make the pagefault callbacks explicit as Arjan has asked

What does this mean in practice? It should be able to call into a module,
so the only thing I can come up with is a single settable function
pointer. Just like I proposed in patch v2, but a function pointer instead
of a list. Is this what you and Arjan suggest?
We are talking about the hook in do_page_fault(), right?

> - any reason why it lives in arch/x86/kernel/mmiotrace/? It should be a
>   prime-time member of arch/x86/mm/ i think.

I was waiting for someone to comment on that, I didn't know what was the
proper place. I'll move it into there.

> - please make it build-in-able, not modules-only.

Then I need a way to clear the relay buffers at some point. Currently
they get cleared only on module unload. Maybe preferably also allocate
and deallocate them dynamically. I've no idea how to do this yet, any
pointers to examples?

Hmm, I guess relay buffers could be allocated on the first intercepted
call to ioremap, but then the userspace could not be started before
hand, and at that point it is too late.

Making it build-in-able will take so much time that I'd prefer to aim
it for 2.6.26.

> - [ longer-term: think about integrating pf_in.c with the x86
>     emulator/disassembler of KVM. ]

Yikes. Like I replied to Arjan, it looks daunting.


Thanks, I'll do what I can. When do you need the final (as for 2.6.25)
mmiotrace patch, or is it going in as v2 and then we fix it in RCs?

-- 
Pekka Paalanen
http://www.iki.fi/pq/
