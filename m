Return-Path: <linux-kernel-owner+w=401wt.eu-S935525AbZLGRce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935525AbZLGRce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935460AbZLGRcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:32:32 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:54061 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935445AbZLGRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:32:31 -0500
Subject: Re: [PATCH] Dynamic port labeling V2
From: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>
To: Joshua Brindle <method@manicmethod.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org, selinux@tycho.nsa.gov,
       "George S. Coker, II" <gscoker@alpha.ncsc.mil>,
       Eamon Walsh <ewalsh@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <4B1932EB.9020303@manicmethod.com>
References: <1259616460.2444.9.camel@moss-stripedbass.epoch.ncsc.mil>
	 <4B181228.6080600@manicmethod.com>
	 <1259937021.2444.16.camel@moss-stripedbass.epoch.ncsc.mil>
	 <4B1932EB.9020303@manicmethod.com>
Content-Type: text/plain
Date: Mon, 07 Dec 2009 12:21:51 -0500
Message-Id: <1260206511.2630.10.camel@moss-stripedbass.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 11:03 -0500, Joshua Brindle wrote:
> Paul Nuzzi wrote:
> > On Thu, 2009-12-03 at 14:31 -0500, Joshua Brindle wrote:
> >> Paul Nuzzi wrote:
> >>> Second version of the dynamic port labeling patch.  Changed the name of
> >>> the selinuxfs interface to portcon and changed the interface to only
> >>> allow five arguments instead of the variable four or five.
> >>>
> >>> Added a mechanism to add/delete/update port labels with an interface in
> >>> the selinuxfs filesystem.  This will give administrators the ability to
> >>> update port labels faster than reloading the entire policy with
> >>> semanage.  The administrator will also need less privilege since they
> >>> don't have to be authorized to reload the full policy.
> >>>
> >>> A listing of all port labels will be output if the file /selinux/portcon
> >>> is read.  Labels could be added or deleted with the following commands
> >>>
> >>> echo -n "del system_u:object_r:ssh_port_t:s0 6 22 22">   /selinux/portcon
> >>> echo -n "add system_u:object_r:telnetd_port_t:s0 6 22 22">   /selinux/portcon
> >>>
> >> Aside from the conversation Dave and Casey are having I still think this
> >> isn't quite right. First, while you can atomically change a single port
> >> label with the add command above you can't atomically change multiple
> >> entries, which I think is completely necessary (you don't want to have
> >> strange labeling states when changing a set of ports to a new label.
> >
> > Can you think of a situation where we would need to atomically change
> > multiple entries?  I envisioned a sys admin stopping their application
> > or server, relabeling the ports and then restarting them.  Maybe there
> > is a specific case you know about that I've overlooked?
> >
> 
> Maybe not, and it isn't like labeling filesystems is atomic so maybe I'm 
> out in left field here.
> 
> >> Also, if you are dealing with ranges you need to essentially pop off all
> >> the specific ports, change the range and push all the specific ports
> >> back on. With the current interface I don't see how that is possible at
> >> all.
> >
> > If you want to change the label on a range you can do it with the atomic
> > add operation.  The only time you would need to pop all the ports and
> > push them back is resizing a range.
> >
> 
> I actually was thinking about resizing a range. You just put the system 
> in a strange state by having to remove alot of labels and then readd 
> them. It seems most reliable to add the entire set of portcons every 
> time (using some file on disk and a text parser to parse them in to an 
> ocontext like struct then feeding it in), that way the ordering is 
> always exactly like it is in the file and there is a persistent file on 
> disk that can be loaded at policy load time.
> 
> Users could literally do a setportcon -e to pop up an editor with all 
> the portcons and reorder, modify, re-range, etc and it would all take 
> effect at once.
> 
> I don't know though, I may be overthinking this. Right now isn't ideal, 
> portcons have to be stored in a libsemanage "database" and they get 
> added to the policydb at policy build time. You could generate out a 
> portcon file that sits next to the policy.24 and gets fed in at load 
> time but making modifications to that and keeping them in sync would be 
> a pain, unless libsemanage made the change and regenerated the file (it 
> would be cheaper than rebuilding the entire policy) but that would also 
> mean you'd have to modify libsemanage which I typically don't wish on 
> anyone.
> 

Sounds like your idea would present some a few problems.  To implement
this functionality user-space would have to take out a policy lock in
the kernel for an indefinite amount of time.  That brings up some issues
on scalability.  Typically atomic operations are small and fast.  This
also sounds like a toolchain issue.  The proposed functionality can be
done in the front end of semanage or setportcon.  

> I guess one issue I'm having is that in SELinux there are about 3 ways 
> to do any 1 think in the typical case (sometimes there are 5 or more). 
> And this adds a completely orthogonal and not integrated with the rest 
> way of changing port labels, which isn't ideal. We already have trouble 
> telling people how to choose one over the other in many cases.
> 
> >> Also, while having a text parser in the kernel makes it easier to use
> >> with echo I think it is alot of code in the kernel for no good reason.
> >> There is no reason not to make a userspace tool that converts the
> >> textual representation into a serialized struct and feed it to the
> >> kernel. We typically tell users not to mess around in /selinux anyway,
> >> since we have a libselinux interface to do that.
> >>
> >> We also need to be able to get that information back out somehow, and we
> >> need to be able to keep the on-disk policy consistent with the changes
> >> we are making at runtime. setsebool -P does this, but it rebuilds the
> >> policy, which you are trying to avoid. How do you make these portcon
> >> changes persist across reboots? I don't imagine very many scenarios
> >> where you only want to temporarily change portcons.
> >>
> >> It seems like you'd need to manage an on-disk file of all the ports and
> >> load them right after loading the policy (which is still racy but the
> >> default port sid should prevent any traffic on the ports.
> >
> > There is no question that a userspace tool like setsebool will have to
> > be written to save the modified policy.  I used a text parsing interface
> > to stay consistent with the current selinuxfs interfaces where you can
> > echo numbers into files to modify functionality.  Would adding a
> > structure ingesting write interface break consistency?
> >
> 
> Sort of. In some cases you can echo numbers in like booleans and enforce 
> and others you can't like load, all the compute functions, etc. We don't 
> have to do text parsing yet and that adds a bunch of stuff to the kernel 
> that isn't completely necessary. I'll defer to the kernel guys on this 
> one though, since it isn't my area of expertise.
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.

