Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbXFKPqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbXFKPqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbXFKPpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:45:50 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:51111 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbXFKPpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:45:49 -0400
Date: Tue, 12 Jun 2007 00:44:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mm: memory/cpu hotplug section mismatch.
Message-ID: <20070611154428.GA27644@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070611043543.GA22910@linux-sh.org> <20070611140145.05726c0f.kamezawa.hiroyu@jp.fujitsu.com> <20070611050955.GA23215@linux-sh.org> <20070611082732.70018522.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611082732.70018522.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 08:27:32AM -0700, Randy Dunlap wrote:
> On Mon, 11 Jun 2007 14:09:55 +0900 Paul Mundt wrote:
> > On Mon, Jun 11, 2007 at 02:01:45PM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Mon, 11 Jun 2007 13:35:43 +0900
> > > Paul Mundt <lethal@linux-sh.org> wrote:
> > > > This happens because CONFIG_HOTPLUG_CPU=n sets __cpuinit to __init, but
> > > > CONFIG_MEMORY_HOTPLUG=y unsets __meminit.
> > > 
> > > It seems this zone_batchsize() is called by cpu-hotplug and
> > > memory-hotplug.  So, __init_refok doesn't look good, here.
> > > 
> > > maybe we can use __devinit here. (Because HOTPLUG_CPU and
> > > MEMORY_HOTPLUG are depend on CONFIG_HOTPLUG.)
> > > 
> > Yes, that's probably a more reasonable way to go. The __devinit name is a
> > bit misleading, though..
> 
> __meminit does not fit/work here?
> 
No, for the reasons already noted.

If CONFIG_MEMORY_HOTPLUG=n __meminit == __init, and if
CONFIG_HOTPLUG_CPU=n __cpuinit == __init. However, with one set and the
other disabled, you end up with a reference between __init and a regular
non-init function.

CONFIG_HOTPLUG is the only thing that they both have in common, so only
__devinit will gaurantee the proper behaviour. __init_refok is the
opposite of the behaviour that is desired, as Kamezawa-san was quick to
point out.

Simply switching to __meminit will cause zone_batchlist() to emit a
section mismatch on CONFIG_HOTPLUG_CPU=y and CONFIG_MEMORY_HOTPLUG=n
configurations instead of the other way around.
