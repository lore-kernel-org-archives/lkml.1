Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbYGBABW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbYGBABW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 20:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbYGBABC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 20:01:02 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:59234 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760263AbYGBAA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 20:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=O9A9cMWJYru39kotavEubs5m9CYXUewz5HBfuGeeZBW9a6JeuaX8hn6+Dk1GTcpV+2
         WRuoEynMllSiqs7nQr+nrY7rv5xbMa7jB0RvLRJkVz7JICeKAKT3ITwvytCGYEUrliX/
         ryshIvIJGpshoc9cmA3BcI4lcNbG7fA84PREA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 14/23] make section names compatible with -ffunction-sections -fdata-sections: parisc
Date: Wed, 2 Jul 2008 02:00:49 +0200
User-Agent: KMail/1.8.2
Cc: linux-arch@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
References: <200807020239.11410.vda.linux@googlemail.com> <1214955660.3316.31.camel@localhost.localdomain>
In-Reply-To: <1214955660.3316.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020200.49518.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008 01:41, James Bottomley wrote:
> On Wed, 2008-07-02 at 02:39 +0200, Denys Vlasenko wrote:
> > The purpose of this patch is to make kernel buildable
> > with "gcc -ffunction-sections -fdata-sections".
> > This patch fixes parisc architecture.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> Um ... if you look at the Makefile you'll see we already build parisc
> with -ffunction-sections; we have to: our relative jumps are too small
> to guarantee finding the stubs in large files.
> 
> Since our text is -ffunction-sections compatible already, I question the
> need for transformations like this:
> 
> > -               *(.text.do_softirq)
> > -               *(.text.sys_exit)
> > -               *(.text.do_sigaltstack)
> > -               *(.text.do_fork)
> > +               *(.do_softirq.text)
> > +               *(.sys_exit.text)
> > +               *(.do_sigaltstack.text)
> > +               *(.do_fork.text)

arch/parisc/kernel/vmlinux.lds.S contains these lines:

               TEXT_TEXT
               SCHED_TEXT
               LOCK_TEXT
               *(.text.do_softirq)
               *(.text.sys_exit)
               *(.text.do_sigaltstack)
               *(.text.do_fork)

which suggested to me that for parisc it is important to have
these sections in that place (after LOCK_TEXT) and order.

If you use -ffunction-sections, any function with the name
do_fork (say, a static function somewhere) will end up in
.text.do_fork function, and will be "mixed up" with
global do_fork(). For parisc it is maybe not a problem
(I am not an expert) but in other places/arches people
clearly would not want this kind of things to happen.

In order to handle these situations uniformly, in these patches
I decided to _never_ use .text.XXXX names for sections,
effectively leaving them "reserved for gcc's use".

Did I understand you right that in this chunk I need to
leave .text.FUNC_NAME as it was before?

> And thus by the same token the data transformations.

It would be easiest for me if you will reply to the parisc patch
and indicate all parts where I should NOT do name change.

Thanks!
--
vda
