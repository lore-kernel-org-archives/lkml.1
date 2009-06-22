Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZFVSbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZFVSbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFVSa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:30:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53665 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZFVSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:30:57 -0400
Date: Mon, 22 Jun 2009 12:30:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
Message-ID: <20090622183056.GY19977@parisc-linux.org>
References: <20090622140807.25509.54448.stgit@bob.kio> <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FCB68.3030004@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:20:24AM -0700, Jeremy Fitzhardinge wrote:
> > I'd like to know what the KVM / Xen / ... people think about this.
> > I don't know if they rely on function 5 being able to show up out of
> > the blue.
> 
> We want to be able to export specific functions to a particular domain,
> so it might see a PCI device with only function 5.
> 
> It looks like we lose that ability with this patch, is that right?

That would be correct.  I'm guessing your out-of-tree code sets
pcibios_scan_all_fns()?

Now, there are various options.  One is that you could remap config
space accesses -- domain:bus:dev.fn in the guest don't have to match
domain:bus:dev.fn in the host.  That's a certain amount of overhead in
every config space access, but it doesn't have to be a large one.

Another would be that you could create dummy devices in the guest at
function 0, and then the guest would scan all the functions.  A little
ugly, perhaps.

A third would be for guests to not do this scanning at all.  You could
present the devices through something like the openfirmware tree, and
create them insteaqd of scanning for them.  If you care about startup
time, this is probably the way to go.

There's probably other ways I haven't thought of ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
