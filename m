Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZHGLbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZHGLbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbZHGLbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:31:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZHGLbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:31:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH][RFC] net/bridge: add basic VEPA support
Date: Fri, 7 Aug 2009 13:29:44 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "Fischer, Anna" <anna.fischer@hp.com>,
       "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "kaber@trash.net" <kaber@trash.net>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>,
       Or Gerlitz <ogerlitz@voltaire.com>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net> <20090806210002.75beb7c6@nehalam>
In-Reply-To: <20090806210002.75beb7c6@nehalam>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908071329.44437.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Zda0kEeFPzMjbv0mtGtuQF1WAJeFHqokL4pW
 OhB+fTMEhx8YZYfY4YF3NS5r9c6KoMW3nzYoMV3Et4nTghb/Fp
 OSyDzp4KKUetY7W46TXrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Stephen Hemminger wrote:
> So instead of adding more stuff to existing bridge code, why not
> have a new driver for just VEPA. You could
> do it with a simple version of macvlan type driver.

The current macvlan driver already does the downstream side of
VEPA and only needs a connection to KVM et al, either using
Or's qemu packet socket interface, or using the macvtap driver
I posted.

Now Anna's patch also addresses the upstream side of VEPA, by
making it possible for the bridge code to send frames back
in the bridge code that they were received from, if that port
is marked as a hairpin mode port.

Is your suggestion to do that part also with a macvlan type driver?
I've thought about this before, and I guess that would mean
basically the same as the macvlan driver, except hashing the
source MAC address instead of the destination MAC address for
inbound frames. That way you should be able to do something
like:

            Host A                             Host B

      /- nalvcam0 -\                   /- macvlan0 - 192.168.1.1
br0 -|              |- ethA === ethB -|
      \- nalvcam1 -/                   \- macvlan1 - 192.168.1.2
  
Now assuming that macvlan0 and macvlan1 are in different
network namespaces or belong to different KVM guests, these
guests would be able to communicate with each other through
the bridge on host A, which can set the policy (using ebtables)
for this communication and get interface statistics on its
nalvcam interfaces. Also, instead of having the br0, Host A could
assign an IP addresses to the two nalvcam interfaces that host
B has, and use IP forwarding between the guests of host B.

	Arnd <><
