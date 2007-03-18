Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbXCRXqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbXCRXqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 19:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbXCRXqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 19:46:30 -0400
Received: from gw.goop.org ([64.81.55.164]:44188 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbXCRXq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 19:46:26 -0400
Message-ID: <45FDCF52.4000805@goop.org>
Date: Sun, 18 Mar 2007 16:46:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: David Miller <davem@davemloft.net>, rusty@rustcorp.com.au, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       torvalds@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org> <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net> <20070318120814.GA45869@muc.de> <45FD619D.6030402@goop.org> <20070318170414.GB45869@muc.de> <45FD76E6.4060907@goop.org> <20070318193030.GB71548@muc.de>
In-Reply-To: <20070318193030.GB71548@muc.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Yes. All inline assembly tells gcc what registers are clobbered
> and it fills in the tables. Hand clobbering in inline assembly cannot
> be expressed with the current toolchain, so we moved all those
> out of line.
>
> But again I'm not sure it will work anyways. For once you would
> need large padding around the calls anyways for inline replacement --
> how would you generate that? I expect you would need to put the calls
> into asm() again and with that a custom annotiation format looks reasonable.

Inlining is most important for very small code: sti, cli, pushf;pop eax,
etc (in many cases, no-ops).  We'd have at least 5 bytes to work in, and
maybe more if there are surrounding push/pops to be consumed.

For example, say we wanted to put a general call for sti into entry.S,
where its expected it won't touch any registers.  In that case, we'd
have a sequence like:

    push %eax
    push %ecx
    push %edx
    call paravirt_cli
    pop %edx
    pop %ecx
    pop %eax
      

If we parse the relocs, then we'd find the reference to paravirt_cli. 
If we look at the byte before and see 0xe8, then we can see if its a
call.  If we then work out in each direction and see matched push/pops,
then we know what registers can be trashed in the call.  This also
allows us to determine the callsite size, and therefore how much space
we need for inlining.

So in this case, we see that there are 5 bytes for the call and a
further 6 bytes of push/pops available for inlining.

Of course this is hand-written code anyway, so there's no particular
burden to having some extra metadata stashed away in another section. 
For compiler-generated code, we know that it's already expecting
standard C ABI calling conventions.  The downside, of course, is that
only the 5 byte call space is available for inline patching.

    J
