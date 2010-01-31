Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485Ab0AaJKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab0AaJKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 04:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907Ab0AaJKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 04:10:46 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:50145 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0AaJKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 04:10:45 -0500
Subject: SUMMARY: KVM+nf_conntrack_htable_size
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Sun, 31 Jan 2010 04:10:33 -0500
Message-Id: <1264929033.7499.22.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Thanks to everyone who helped me poke a little at the netfilter code.
Since I'm not usually a network guy and haven't really kept up with
things like the namespace code, this was fun. I have some results.

The problem (as Eric hinted) is that we have a global
nf_conntrack_htable_size, which is manipulated every time we create a
new hashtable. This used to happen only once, but now that we have
multiple network namespaces, it will happen every time we create a new
namespace due to the code registering with register_pernet_subsys. At
this time, the value of the hashtable may be changed underneath code
that is currently using it for another hashtable instance. Additionally,
the "resize" code (via module parameter or via sysctl) only changes the
root netns hashtable, then changes this value, also busticating stuff.
Finally, the very fact that this variable is exported directly is
*asking* for trouble and random corruption to happen later on.

So, there are a great many issues with how the conntrack hashtables are
managed (looks literally as it it used to be fine then namespace code
came along and broke assumptions that had been there since the start),
and they should not be considered safe for use with multiple namespaces
in my opinion. The solution would seem to be to remove this as a global
and make it per namespace, or even per hashtable (there is usually a 1:1
mapping, but the expect code uses this variable too).

Can someone give me some advice on which solution you prefer of these?
Or if you have an alternative preference. I think for now I'll hack up
something involving per-namespace hashtable sizes.

Jon.


