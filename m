Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbXKARlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbXKARlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXKARlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:41:37 -0400
Received: from gw.goop.org ([64.81.55.164]:51872 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXKARlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:41:37 -0400
Message-ID: <472A0FBF.6040907@goop.org>
Date: Thu, 01 Nov 2007 10:41:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       ak@suse.de, chrisw@sous-sol.org, tglx@linutronix.de,
       anthony@codemonkey.ws, akpm@linux-foundation.org,
       virtualization@lists.linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 3/16] read/write_crX, clts and wbinvd for 64-bit paravirt
References: <C34FAA4C.17CA9%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C34FAA4C.17CA9%Keir.Fraser@cl.cam.ac.uk>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> volatile prevents the asm from being 'moved significantly', according to the
> gcc manual. I take that to mean that reordering is not allowed.
>   

That phrase doesn't appear in the gcc manual; in fact, it specifically
says that reordering can happen:

    The `volatile' keyword indicates that the instruction has important
    side-effects.  GCC will not delete a volatile `asm' if it is reachable.
    (The instruction can still be deleted if GCC can prove that
    control-flow will never reach the location of the instruction.)  Note
    that even a volatile `asm' instruction can be moved relative to other
    code, including across jump instructions.  For example, on many targets
    there is a system register which can be set to control the rounding
    mode of floating point operations.  You might try setting it with a
    volatile `asm', like this PowerPC example:

                asm volatile("mtfsf 255,%0" : : "f" (fpenv));
                sum = x + y;

    This will not work reliably, as the compiler may move the addition back
    before the volatile `asm'.  To make it work you need to add an
    artificial dependency to the `asm' referencing a variable in the code
    you don't want moved, for example:

             asm volatile ("mtfsf 255,%1" : "=X"(sum): "f"(fpenv));
             sum = x + y;

I take from this that it is not a good idea to assume "asm volatile" has
any ordering effects at all.

    J
