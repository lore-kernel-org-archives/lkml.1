Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbZDSVMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbZDSVMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 17:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZDSVMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 17:12:10 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:38625 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZDSVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 17:12:09 -0400
X-IronPort-AV: E=Sophos;i="4.40,213,1238976000"; 
   d="scan'208";a="173709331"
From: Roland Dreier <rdreier@cisco.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 19 Apr 2009 14:12:07 -0700
In-Reply-To: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
	(Robert P. J. Day's message of "Sun, 19 Apr 2009 15:45:02 -0400
	(EDT)")
Message-ID: <adaab6c1h7c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Apr 2009 21:12:07.0832 (UTC) FILETIME=[7F332180:01C9C133]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > from arch/x86/Kconfig:
 > 	...
 >         select HAVE_READQ
 >         select HAVE_WRITEQ
 > 	...
 > 
 > yet there are no such defined Kconfig vars anywhere.  thoughts?

git blame shows that this came in from 2c5643b1 ("x86: provide
readq()/writeq() on 32-bit too").  And that commit looks very dubious
indeed to me -- it defines readq() and writeq() in a way that is not
atomic and probably won't generate single 64-bit bus cycles.

Now, many drivers do "#ifndef readq <define my own implementation> #endif"
but exactly what is required is very hardware-dependent, and accessing
32-bit halves in the wrong order may lead to very subtle bugs.  For
example, the changelog for e23a59e1 ("niu: Fix readq implementation when
architecture does not provide one.") says:

    In particular one of the issues is whether the top 32-bits
    or the bottom 32-bits of the 64-bit register should be read
    first.  There could be side effects, and in fact that is
    exactly the problem here.

By coincidence, the 32-bit x86 implementation is actually OK for niu,
but I didn't audit every similar driver, and I don't think any
implementation of readq()/writeq() that generates multiple bus cycles is
suitable in general -- it doesn't meet the requirements of the API.

So I would strongly suggest reverting 2c5643b1 since as far as I can
tell it just sets a trap for subtle bugs that only show up on 32-bit
x86 -- any portable driver still needs to provide readq()/writeq() for
other 32-bit architectures, so it doesn't really help anyone.

 - R.
