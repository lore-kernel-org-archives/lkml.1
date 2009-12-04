Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZLDOmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZLDOmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZLDOmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:42:42 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:63287 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZLDOml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:42:41 -0500
Subject: Re: [PATCH] Dynamic port labeling V2
From: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>
To: Joshua Brindle <method@manicmethod.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org, selinux@tycho.nsa.gov,
       "George S. Coker, II" <gscoker@alpha.ncsc.mil>,
       Eamon Walsh <ewalsh@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <4B181228.6080600@manicmethod.com>
References: <1259616460.2444.9.camel@moss-stripedbass.epoch.ncsc.mil>
	 <4B181228.6080600@manicmethod.com>
Content-Type: text/plain
Date: Fri, 04 Dec 2009 09:30:21 -0500
Message-Id: <1259937021.2444.16.camel@moss-stripedbass.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 14:31 -0500, Joshua Brindle wrote: 
> Paul Nuzzi wrote:
> > Second version of the dynamic port labeling patch.  Changed the name of
> > the selinuxfs interface to portcon and changed the interface to only
> > allow five arguments instead of the variable four or five.
> >
> > Added a mechanism to add/delete/update port labels with an interface in
> > the selinuxfs filesystem.  This will give administrators the ability to
> > update port labels faster than reloading the entire policy with
> > semanage.  The administrator will also need less privilege since they
> > don't have to be authorized to reload the full policy.
> >
> > A listing of all port labels will be output if the file /selinux/portcon
> > is read.  Labels could be added or deleted with the following commands
> >
> > echo -n "del system_u:object_r:ssh_port_t:s0 6 22 22">  /selinux/portcon
> > echo -n "add system_u:object_r:telnetd_port_t:s0 6 22 22">  /selinux/portcon
> >
> 
> Aside from the conversation Dave and Casey are having I still think this 
> isn't quite right. First, while you can atomically change a single port 
> label with the add command above you can't atomically change multiple 
> entries, which I think is completely necessary (you don't want to have 
> strange labeling states when changing a set of ports to a new label.

Can you think of a situation where we would need to atomically change
multiple entries?  I envisioned a sys admin stopping their application
or server, relabeling the ports and then restarting them.  Maybe there
is a specific case you know about that I've overlooked?

> Also, if you are dealing with ranges you need to essentially pop off all 
> the specific ports, change the range and push all the specific ports 
> back on. With the current interface I don't see how that is possible at 
> all.

If you want to change the label on a range you can do it with the atomic
add operation.  The only time you would need to pop all the ports and
push them back is resizing a range.

> Also, while having a text parser in the kernel makes it easier to use 
> with echo I think it is alot of code in the kernel for no good reason. 
> There is no reason not to make a userspace tool that converts the 
> textual representation into a serialized struct and feed it to the 
> kernel. We typically tell users not to mess around in /selinux anyway, 
> since we have a libselinux interface to do that.
> 
> We also need to be able to get that information back out somehow, and we 
> need to be able to keep the on-disk policy consistent with the changes 
> we are making at runtime. setsebool -P does this, but it rebuilds the 
> policy, which you are trying to avoid. How do you make these portcon 
> changes persist across reboots? I don't imagine very many scenarios 
> where you only want to temporarily change portcons.
> 
> It seems like you'd need to manage an on-disk file of all the ports and 
> load them right after loading the policy (which is still racy but the 
> default port sid should prevent any traffic on the ports.

There is no question that a userspace tool like setsebool will have to
be written to save the modified policy.  I used a text parsing interface
to stay consistent with the current selinuxfs interfaces where you can
echo numbers into files to modify functionality.  Would adding a
structure ingesting write interface break consistency?

> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.

