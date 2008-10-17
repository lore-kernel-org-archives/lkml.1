Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYJQThH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYJQThH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbYJQTg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:36:57 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:5872 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbYJQTg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:36:56 -0400
X-IronPort-AV: E=Sophos;i="4.33,434,1220227200"; 
   d="scan'208";a="96416155"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com>
	<20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com>
	<20081017191202.GA5396@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 17 Oct 2008 12:36:54 -0700
In-Reply-To: <20081017191202.GA5396@elte.hu> (Ingo Molnar's message of "Fri,
	17 Oct 2008 21:12:02 +0200")
Message-ID: <adaiqrrrp2h.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Oct 2008 19:36:54.0894 (UTC) FILETIME=[B603F8E0:01C9308F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > the drivers/net/mlx4/mcg.c commit you pointed out is one of the very few 
 > borderline cases: the code gets neither better, nor worse.

Yes, I agree exactly.  As long as there are not too many such cases
(since every commit has some cost just from causing churn) then we are
OK, I think.

 > If you look at the totality of fixes they are not common at all. (and
 > almost by definition the 100-200 unfixed warnings that we have piled
 > up in -git are the _problematic_ cases - clear-cut cases tend to be
 > fixed.)

Yes, and I think that merging such changes makes the most sense as part
of a project such as yours that wants to kill all warnings.  I looked at
the mcg.c warning and found the same workaround, but in the context of
my maintenance work, I just reported the gcc bug and lived with the
warning when using gcc 4.3.

By the way, just out of curiousity, how are you dealing with warnings
about "format not a string literal and no format arguments" caused by
code like arch/x86/kernel/dumpstack_64.c:

static void print_trace_address(void *data, unsigned long addr, int reliable)
{
	touch_nmi_watchdog();
	printk(data);
	printk_address(addr, reliable);
}

and also cases like:

	char *name;

	//...

	kobject_set_name(obj, name);

(I get these with gcc "(Ubuntu 4.3.2-1ubuntu10) 4.3.2")

 > i certainly have a found a couple of such cases, see tip/warnings/ugly - 
 > for example see the one below where gcc is not able to see through type 
 > width.

Yes, the uninitialized variable warnings are obnoxious too.  By the way,
I think this:

@@ -72,7 +72,7 @@ static __always_inline void *__constant_memcpy(void *to, const void *from,
 		return to;
 	case 5:
 		*(int *)to = *(int *)from;
-		*((char *)to + 4) = *((char *)from + 4);
+		*((short *)to + 3) = *((short *)from + 3);
 		return to;
 	case 6:
 		*(int *)to = *(int *)from;

is actually *wrong*, because the cast operator binds tighter than
addition -- so

+		*((short *)to + 3) = *((short *)from + 3);

actually copies bytes at offset 6 and 7; I think what you intended was:

+		*((short *)(to + 3)) = *((short *)(from + 3));

which illustrates the risks in fixing warnings.

 - R.
