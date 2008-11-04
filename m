Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYKDUCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYKDUCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYKDUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:02:22 -0500
Received: from gw.goop.org ([64.81.55.164]:39447 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbYKDUCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:02:22 -0500
Message-ID: <4910AA46.909@goop.org>
Date: Tue, 04 Nov 2008 12:02:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu>
In-Reply-To: <20081104124242.GA6795@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> .. which we were able to avoid before. A couple of segment register 
> accesses, shifts, etc to calculate the vector - each of which can be 
> quite costly (especially the segment register access - this is a 
> relatively rare instruction pattern).
>
> I'm not unconvicable, but we need to be conservative here: could you 
> try to measure the full before/after cost of IRQ entry, to the cycle 
> level? I'm curious what the performance impact is.
>
> Also, this makes life probably a bit harder for Xen, which assumes 
> that the GDT of the guest OS is small-ish. (Jeremy Cc:-ed)
>   

It doesn't increase the GDT to more than one page, so there's no issue 
there.  The only reason the GDT uses a whole page is because of Xen's 
requirements anyway, so if we can make good use of the rest of the 
entries, so much the better.

The other possible concern with Xen is whether Xen will properly load an 
arbitrary %cs on exception entry, or if it always loads KERNEL_CS; looks 
like it will load any %cs, so we should be fine there.

Overall the patch looks good.  Saving a segment register should be much 
faster than loading it, so I don't think the %cs read on entry should 
cost too much, but reloading %cs with KERNEL_CS might be a bit more of a 
cost (or does it run the whole exception with the new %cs?).

    J
