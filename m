Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbZLRFdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbZLRFdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbZLRFdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:33:45 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:42295 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZLRFdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:33:44 -0500
MIME-Version: 1.0
In-Reply-To: <4B1932EB.9020303@manicmethod.com>
References: <1259616460.2444.9.camel@moss-stripedbass.epoch.ncsc.mil> 
	<4B181228.6080600@manicmethod.com> <1259937021.2444.16.camel@moss-stripedbass.epoch.ncsc.mil> 
	<4B1932EB.9020303@manicmethod.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 18 Dec 2009 00:33:24 -0500
Message-ID: <f73f7ab80912172133m4237eba3h706e624d8bd58b99@mail.gmail.com>
Subject: Re: [PATCH] Dynamic port labeling V2
To: Joshua Brindle <method@manicmethod.com>
Cc: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, jmorris@namei.org,
       selinux@tycho.nsa.gov, "George S. Coker, II" <gscoker@alpha.ncsc.mil>,
       Eamon Walsh <ewalsh@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>,
       John Livingston <jlivings@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 11:03, Joshua Brindle <method@manicmethod.com> wrote:
> Paul Nuzzi wrote:
>> On Thu, 2009-12-03 at 14:31 -0500, Joshua Brindle wrote:
>>> Paul Nuzzi wrote:
>>>> Added a mechanism to add/delete/update port labels with an interface in
>>>> the selinuxfs filesystem.  This will give administrators the ability to
>>>> update port labels faster than reloading the entire policy with
>>>> semanage.  The administrator will also need less privilege since they
>>>> don't have to be authorized to reload the full policy.
>>>>
>>>> A listing of all port labels will be output if the file /selinux/portcon
>>>> is read.  Labels could be added or deleted with the following commands
>>>>
>>>> echo -n "del system_u:object_r:ssh_port_t:s0 6 22 22"> /selinux/portcon
>>>> echo -n "add system_u:object_r:telnetd_port_t:s0 6 22 22"> /selinux/portcon
>>>>
>>> Aside from the conversation Dave and Casey are having I still think this
>>> isn't quite right. First, while you can atomically change a single port
>>> label with the add command above you can't atomically change multiple
>>> entries, which I think is completely necessary (you don't want to have
>>> strange labeling states when changing a set of ports to a new label.
>>
>> Can you think of a situation where we would need to atomically change
>> multiple entries?  I envisioned a sys admin stopping their application
>> or server, relabeling the ports and then restarting them.  Maybe there
>> is a specific case you know about that I've overlooked?
>>
>
> Maybe not, and it isn't like labeling filesystems is atomic so maybe I'm out
> in left field here.
>
> [...]
>
> I actually was thinking about resizing a range. You just put the system in a
> strange state by having to remove alot of labels and then readd them. It
> seems most reliable to add the entire set of portcons every time (using some
> file on disk and a text parser to parse them in to an ocontext like struct
> then feeding it in), that way the ordering is always exactly like it is in
> the file and there is a persistent file on disk that can be loaded at policy
> load time.
>
> Users could literally do a setportcon -e to pop up an editor with all the
> portcons and reorder, modify, re-range, etc and it would all take effect at
> once.

Hrm, wow.... this seems like a whole lot of re-engineering of work
that has already been done and works well, specifically iptables.

The iptables code already allows almost any combination of access
rules, with conditionals, nested filters, ranges, etc... and it has a
design that allows atomic replacement of the entire firewall ruleset.

Furthermore, using tools like Shorewall (http://shorewall.net), I can
customize exactly what my filtering and forwarding rules are using
simple human-readable configuration files.  Shorewall even generates
an iptables restore file so I either get the old set of firewall rules
or the new set, nothing halfway in-between.

I know that SELinux labeling is already partially supported through
the security table... can't we figure out some way to extend that to
this port-based labeling as well?  Another thing that would be nice is
to be able to apply some amount of discrete access control to firewall
rule updates, so that a "network admin" could adjust most firewall
rules, while the "security admin" would be responsible for packet and
network interface labeling.

I have to say... looking at IPsec+iptables solutions for robust and
secure packet labeling to IP port-based security labels seems a big
step backwards to me.

Putting my various admin hats on, what I would *LOVE* to have from a
security standpoint would be something along the lines of
setroubleshoot, but designed to handle audits from many computer
systems and to allow communication between people with different
security roles.  Here's an example use-case:

So say a web developer is preparing to roll out a big application
install, and needs to add a new HTTP listen port (say, 8083).  She
tells apache to listen on that port and gets a "permission denied",
along with a notification of some kind that her action has triggered a
security warning.  As a result, she goes ahead and fills out a
"network security" change request form, and then puts the ticket
number into the SETroubleshoot interface tagged to the security
warning.

A few minutes later, the network security guy sits down and opens up
his audit window and sees the warning that his friendly web developer
triggered.  He checks the trouble ticket and updates the HTTP
type-enforcement rules to allow that port as well, then sends off a
notice to the web developer that everything is OK.

The web developer then works with his users to beta-test the web
application and discovers that his software is unable to talk to one
of its database backends on another server because that database has
"sensitive financial" data and requires labelled IPsec connections to
access it.  Those audit messages (even from the same server) then go
to a separate "data security" person, who must himself add the new
labelling rules to allow that software access to some financial data.

I could almost build this system today with a bunch of custom
userspace firewall management and audit-log filtering software... but
I have no real way of actually restricting my "data security" person
from fiddling with the HTTP port labelling, nor can I prevent my basic
network security guy from changing my fancy labelled IPsec rules.

Cheers,
Kyle Moffett
