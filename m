Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbYIGGCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbYIGGCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 02:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYIGGCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 02:02:10 -0400
Received: from 1wt.eu ([62.212.114.60]:3380 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYIGGCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 02:02:09 -0400
Date: Sun, 7 Sep 2008 08:01:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alok Kataria <akataria@vmware.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080907060146.GB2244@1wt.eu>
References: <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org> <20080904204305.GA29065@elte.hu> <1220653095.14401.72.camel@alok-dev1> <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061347120.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062253030.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061406150.3117@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809061406150.3117@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 02:10:32PM -0700, Linus Torvalds wrote:

> The fact is, the code that Ingo added was totally bogus. The real bug was 
> that he did a totally bogus "--expect" in the argument to that last call. 

BTW, I hate to see state-changing instructions inside an if condition.
I've been bitten several times while debugging. You try to temporarily
comment out the if statement for a test and you end up with different
code. Same for printf. Examples of dangerous usages :

      i = 0;
      for (x = 0; x < 100; x++) {
         update_var(&i);
         if (debug && i--)
             printf("Hey I'm here\n");
      }
      return i;

You can bet that the if will go away before production. Variant with
similar effects :

      i = 0;
      for (x = 0; x < 100; x++) {
         update_var(&i);
         printf("Hey I'm here : %d\n", --i);
      }
      return i;

Since it costs nothing (except one tab and one LF) to put the instruction
out of the condition, I prefer to see them extracted :

      i = 0;
      for (x = 0; x < 100; x++) {
         update_var(&i);
         i--;
         if (debug)
             printf("Hey I'm here\n");
      }
      return i;
> 

Willy

