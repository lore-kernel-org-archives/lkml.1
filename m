Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbZCOUgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbZCOUgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZCOUf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:35:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbZCOUfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:35:55 -0400
Date: Sun, 15 Mar 2009 13:32:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49BD4B2D.7000501@krogh.cc>
Message-ID: <alpine.LFD.2.00.0903151323260.3131@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc> 
 <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49AD90E2.7050209@krogh.cc>
  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc>
 <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Mar 2009, Jesper Krogh wrote:
> 
> I went on to trying Thomas Gleixners patch (which seems to do excactly the
> same .. ), I'll write a reply in to that message in a few minutes.

Side note: no, Thomas' patch doesn't do at all exactly the same. It does 
something similar, in that it looks at the time differences between calls 
to the whole "wait for the PIT MSB to change" function, but those 
differences _could_ in theory be very small, even if the error is very 
big.

That's especially true if the PIT read ends up serializing with the PIT, 
so that the "wait for MSB" essentially always takes exactly the same 
amount of cycles (giving a zero error estimation in Thomas' version), but 
the reads themselves can still be quite slow (giving a non-zero error term 
in the end result).

IOW, Thomas' patch is good at finding variability in the reads - which 
could be the result of SMM interaction, while my patch literally measures 
how long it takes to read the MSB change.

Now in practice I suspect the variability in the MSB reads _probably_ 
correlate reasonably well with how long a single PIT read will take (ie 
rather than finding variability due to SMM interaction, it will find 
variability due to the "quanitization" effect of the reads taking a 
reasonably long time), so I suspect that in many cases Thomas' patch will 
error out for the same cases mine does.

But the two patches are rather fundamentally different.

		Linus
