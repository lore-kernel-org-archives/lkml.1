Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZLCTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZLCTj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZLCTj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:39:27 -0500
Received: from hypnotoad.manicmethod.com.2.126.204.in-addr.arpa ([204.126.2.47]:2202
	"EHLO manicmethod.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZLCTjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:39:25 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 14:39:24 EST
Message-ID: <4B181228.6080600@manicmethod.com>
Date: Thu, 03 Dec 2009 14:31:52 -0500
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Postbox 1.1.0 (Windows/20091201)
MIME-Version: 1.0
To: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org, selinux@tycho.nsa.gov,
       "George S. Coker, II" <gscoker@alpha.ncsc.mil>,
       Eamon Walsh <ewalsh@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] Dynamic port labeling V2
References: <1259616460.2444.9.camel@moss-stripedbass.epoch.ncsc.mil>
In-Reply-To: <1259616460.2444.9.camel@moss-stripedbass.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Nuzzi wrote:
> Second version of the dynamic port labeling patch.  Changed the name of
> the selinuxfs interface to portcon and changed the interface to only
> allow five arguments instead of the variable four or five.
>
> Added a mechanism to add/delete/update port labels with an interface in
> the selinuxfs filesystem.  This will give administrators the ability to
> update port labels faster than reloading the entire policy with
> semanage.  The administrator will also need less privilege since they
> don't have to be authorized to reload the full policy.
>
> A listing of all port labels will be output if the file /selinux/portcon
> is read.  Labels could be added or deleted with the following commands
>
> echo -n "del system_u:object_r:ssh_port_t:s0 6 22 22">  /selinux/portcon
> echo -n "add system_u:object_r:telnetd_port_t:s0 6 22 22">  /selinux/portcon
>

Aside from the conversation Dave and Casey are having I still think this 
isn't quite right. First, while you can atomically change a single port 
label with the add command above you can't atomically change multiple 
entries, which I think is completely necessary (you don't want to have 
strange labeling states when changing a set of ports to a new label.

Also, if you are dealing with ranges you need to essentially pop off all 
the specific ports, change the range and push all the specific ports 
back on. With the current interface I don't see how that is possible at 
all.

Also, while having a text parser in the kernel makes it easier to use 
with echo I think it is alot of code in the kernel for no good reason. 
There is no reason not to make a userspace tool that converts the 
textual representation into a serialized struct and feed it to the 
kernel. We typically tell users not to mess around in /selinux anyway, 
since we have a libselinux interface to do that.

We also need to be able to get that information back out somehow, and we 
need to be able to keep the on-disk policy consistent with the changes 
we are making at runtime. setsebool -P does this, but it rebuilds the 
policy, which you are trying to avoid. How do you make these portcon 
changes persist across reboots? I don't imagine very many scenarios 
where you only want to temporarily change portcons.

It seems like you'd need to manage an on-disk file of all the ports and 
load them right after loading the policy (which is still racy but the 
default port sid should prevent any traffic on the ports.

