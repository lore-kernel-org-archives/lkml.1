Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYHKTGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYHKTGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYHKTFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:05:55 -0400
Received: from web82102.mail.mud.yahoo.com ([209.191.84.215]:43829 "HELO
	web82102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751918AbYHKTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:05:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=dnSm3yPwzFY3BG0D+REpwSbeh2WOPj1vKqpgnCFNFmFNVwpfTilLEIDR77ediTYj92U6Cwxnoxb7RLKPtVX+CmXnLQQmbyx/m0KLnvLpfb7qtK4++mX7dioRBn5IR5IUrM1f5ltN0BWr6lXtpA0XwH49V8nWQEYn2PBFLPCQClY=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Mon, 11 Aug 2008 12:05:53 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <714971.85255.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> > Just to recap (not sure if you saw the earlier posts in the thread, going
> > back to Monday a week ago):
> >
> > - kernel 2.6.25 worked for me without error
> 
> does hpet work at 2.6.25? or it is not enabled by default for the
> famous chipset?

Yes, 2.6.25 works perfectly.

I first discovered the problem (about 10 days ago) when compiling
my first 2.6.26 kernel, after Debian uploaded their first 2.6.26 kernel
sources (about 14 days ago).  My method is to begin with my previous 
working .config, and update it using 'make oldconfig'.  The output of 

  egrep "HPET|RCU|PREEMPT" .config

for several kernels, including my custom 2.6.25 and custom 2.6.26 kernels,
was posted in a message cc'd to you on Saturday, but you can see it here
if you no longer have it:
 
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0808.1/0720.html


Your commit changes that produced my troubles were to e820_64.c and 
setup_64.c (in arch/x86/kernel).  These mostly had to do with adding
calls to insert_resource() where there had been none.

On one of my machines, this change causes no problem.  (That is also
true on your own machines, and the machines of everyone else on LKML.)
On my two machines which lock up because of the commit, the kernel dies
in inet_init().  The chain of calls is:

  inet_init() -->  inet_register_protosw() --> synchronize_net()
  --> synchronize_rcu()

Since inet_register_protosw() touches RCU features, like list_add_rcu(),
before calling synchronize_net(), I first guessed that the problem was
here.  Gut none of this seems to have any direct connection to the 
insert_resource() calls, or to HPET.

[Of course, since I am not a kernel programmer, I should not even be
guessing in the first place....  I really wish I could give more help.]


Thanks,
Dave W.
