Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbYHUNhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbYHUNhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYHUNhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:37:47 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:33030 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752995AbYHUNhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:37:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BAneB4MsU6Q+b03zQR/sZ17pvld4wcuU23wHKf3rDU4vxqlJ+cLyeqgzfksMRULk8JBwyhxdIidsNtd6Ac66JyVjSis0ApP89aayM0JjOMuKXOxTGAzMGe1ndDdK8Z3vYqkJJ5RB+FRixqJxBzYOQRGJ5ER7dKX2VW5oezhZD+8=  ;
X-YMail-OSG: JYD87c0VM1mZMD1mpH8BMU.vrhpFArn1A41yyzaKXt0TKRH8dhednp31oRJePaBCOq86WBu.q3a5F6pKSOnz033jeG5CYWFB6y73xq8FRE6gV51HnCeiLvypFKuLS0hNNfG5fsSDVpQMMHg3nLEykuD.
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: jmerkey@wolfmountaingroup.com
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  =?iso-8859-1?q?2=2E6=2E27-rc4=09released?=
Date: Thu, 21 Aug 2008 23:37:38 +1000
User-Agent: KMail/1.9.5
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, paulmck@linux.vnet.ibm.com,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Howells" <dhowells@redhat.com>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <48AD5A21.7020801@s5r6.in-berlin.de> <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212337.38626.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:

> I used the smp_wmb() functions.  I noted a couple of things.  a) some of
> these macros just emit __asm__ __volatile__ into the code so why not just
> say "volatile" to begin with

It is not the same as volatile type. What it does is tell the compiler
to clobber all registers or temporaries. This something pretty well
defined and hard to get wrong compared to volatile type.


> b) smp_wmb() in some cases worked and in 
> other cases jut optimized away the global reference.

Linux barriers aren't going to force a load to be emitted, if it can be
optimized away. If it optimized away a store, then I'd like to see a
test case.


> c) I can go back and 
> break the code again by inserting them and building broken assembler d) I
> ave been doing hardware and software design since the early 1980;s, I
> invented SMP affinity scheduling, and yes, I understand barriers and this
> concept of instruction score-boarding and optimization very well -- its
> not an excuse for a busted C compiler.

The point is not whether it is possible to work with volatile types, but
that we tend not to use them in Linux to deal with concurrency.

Also, barriers seem to work fine for everybody else, so I think it is
likely you either aren't using them correctly, or have other bugs in the
code.


> It did not break all the places in the code, but broke enough for SMP to
> lock up and fail,  It turned global variables into local variables.  If
> you want me to reproduce this I can but it will have to wait til this
> evening
> because I have some product releases to get out the door at Omega 8 today.
>
> It's simple to reproduce.  Take away the volatile declaration for the
> rlock_t structure in mdb-ia32.c (rlock_t debug_lock) in all code
> references and watch the thing lock up in SMP with multiple processors in
> the debugger each stuck with their own local copy of debug_lock.

You should disable preempt before getting the processor id. Can't see any
other possible bugs, but you should be able to see from the disassembly
pretty easily.
