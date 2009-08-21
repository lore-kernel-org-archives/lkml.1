Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZHUQt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZHUQt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbZHUQt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:49:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:48282 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbZHUQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A/trEX2upJmm/JeYbKAQdhRdiozzotOExtZAewspjba6+kg1CpnRcT//OT5ikFJO5y
         jZbC14+vTKtdDA96DF3ver3nSViCm3obb+BqC2QRKzhX00CC7PIiEmBVgUzHy48LLy+L
         x3nm3f0G0jg5ajBQU/IIyb5hNVdtStmfv+32o=
Date: Fri, 21 Aug 2009 20:49:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: smp_scan_config - use signed long as scan
	area size
Message-ID: <20090821164957.GC5373@lenovo>
References: <20090820173427.GA8517@lenovo> <20090821160426.GA17731@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821160426.GA17731@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Aug 21, 2009 at 06:04:26PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| 
| > Unsigned value potentially could be overlapped
| > if length parameter is that: length % 16 != 0.
| > 
| > This is not a problem at moment since all values
| > we pass now are 16 divisible (0x400 and 0x10000).
| > 
| > Though there is no need unsigned value anyway.
| > Max range pointed out by MP specification is
| > in kilobytes so plain "signed long" is enough.
| > 
| > This allow us to be on a safe side.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > ---
| > 
...
| 
| Hm, does a BUILD_BUG_ON((length & 15) != 0) line catch incorrectly 
| aligned length parameters?
| 
| 	Ingo
| 

For my gcc it doesn't (gcc (Ubuntu 4.3.3-5ubuntu4) 4.3.3). Perhaps
some clever future gcc version would be able to note that constant is passed as argument
and catch it. But at moment it doesn't. (Or maybe there is some cmd option
which force compiler to inspect calls more precisely?)

We could use BUG_ON as well here but I think it doesn't worth it.
0xefffffff is enough to scan 1G of physical memory which we hard
to believe ever do (note 16 byte step size here). And code is not
getting bigger.

Ingo, current situation is not a problem since we know which
values we're passing so I thought about possible (if ever) errors
only.

Also we could introduce inline helper to check the size alignment
(in this case gcc will recognize constants I believe and catch
 nits on build time). But I really doubt it is worth thing to do.

	-- Cyrill
