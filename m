Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZFVXm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZFVXm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZFVXmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:42:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:47608 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZFVXmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:42:15 -0400
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Alex Chiang <achiang@hp.com>,
       jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>
In-Reply-To: <20090622183056.GY19977@parisc-linux.org>
References: <20090622140807.25509.54448.stgit@bob.kio>
	 <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org>
	 <20090622183056.GY19977@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 09:40:08 +1000
Message-Id: <1245714008.4017.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 12:30 -0600, Matthew Wilcox wrote:
> 
> That would be correct.  I'm guessing your out-of-tree code sets
> pcibios_scan_all_fns()?
> 
> Now, there are various options.  One is that you could remap config
> space accesses -- domain:bus:dev.fn in the guest don't have to match
> domain:bus:dev.fn in the host.  That's a certain amount of overhead in
> every config space access, but it doesn't have to be a large one.
> 
That's tricky. Some devices have internal registers that -do- depend on
what function they are on. In fact, I remember seeing that in
multifunction devices that are meant to be virtualized but still need to
have some registers be accessed differently depending on the function
(ugh) though don't ask me who that was ...

> Another would be that you could create dummy devices in the guest at
> function 0, and then the guest would scan all the functions.  A little
> ugly, perhaps.

But less ugly than the above.

> A third would be for guests to not do this scanning at all.  You could
> present the devices through something like the openfirmware tree, and
> create them insteaqd of scanning for them.  If you care about startup
> time, this is probably the way to go.

Which is what we do on powerpc nowadays. In fact, this code is currently
inside arch/powerpc and arch/sparc (2 copies slightly diverged) but I
had plans to make it common at move it over to either drivers/of or
drivers/pci (most probably the later).

> There's probably other ways I haven't thought of ...

Well, making up the devices without actual config space probing is nice
and fast but I don't think we want to see too many occurences of such
code in the kernel. We already had breakage once in powerpc land iirc
due to changes in drivers/pci/probe.c that we didn't reflect properly. I
think the normal and OF methods should be enough.

At this stage, it does look to me like a trivial tweak like
pcibios_scan_all_fns() but maybe done a bit nicely, would still be the
simplest solution in term of amount of code involved etc...

Maybe something like

pcibios_get_slot_fn_mask() which returns a bitmask of functions to be
scanned, whose default implementation (weak) would basically check
the header type for function 0 ? As I said, I don't -need- that right
now on powerpc "server" platforms but heh... 

Cheers,
Ben.

