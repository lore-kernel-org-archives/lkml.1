Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbZLAPjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbZLAPjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZLAPjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:39:41 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:32811 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZLAPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:39:41 -0500
Subject: Re: [PATCH] Dynamic port labeling V2
From: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, jmorris@namei.org,
       selinux@tycho.nsa.gov, "George S. Coker, II" <gscoker@alpha.ncsc.mil>,
       Eamon Walsh <ewalsh@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <1259679974.2365.29.camel@moss-terrapins.epoch.ncsc.mil>
References: <1259616460.2444.9.camel@moss-stripedbass.epoch.ncsc.mil>
	 <4B14A111.2000703@schaufler-ca.com>
	 <1259679974.2365.29.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain
Date: Tue, 01 Dec 2009 10:29:10 -0500
Message-Id: <1259681350.2444.20.camel@moss-stripedbass.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave brought up some good questions. A pseudo file-system based on ports
seems like a good idea but I think there is going be scaling issues.
SELinux also supports multiple labels for ports. Port 22 can be labeled
as ssh_port and if the label is removed, reverts to reserved_port. Do
you know of a way xattrs can handle this? 


On Tue, 2009-12-01 at 10:06 -0500, David P. Quigley wrote:
> I have several questions about this.
> 
> 1) Where is it located?
> 2) Is your proposal to implement it as a new fs with a name something
> like portfs?
> 3) How does it get populated initially? Do you have a file for each port
> right off the bat? Do you only have files for ports with policy or whose
> permissions differ from the default?
> 4) How do I assign a label to the port? You have an issue here that
> these files are objects themselves. You can't just label the file with
> what you want the port labeled because now you can't mediate access to
> these file objects outside of the label on the port itself.
> 
> On Mon, 2009-11-30 at 20:52 -0800, Casey Schaufler wrote:
> > Paul Nuzzi wrote:
> > > Second version of the dynamic port labeling patch.
> > 
> > So I've looked through both versions of this patch and I can't
> > help but think that you'd get better mileage out of a file system
> > interface than this SELinux specific implementation. If you had
> > something like
> > 
> >     /port/22
> > 
> > with default owner root and mode rw-------
> > 
> >     /port/3306
> > 
> > with default owner root and mode rw-rw-rw-
> > 
> > you could address a bunch of the complaints about port ownership that
> > you hear every day. Further, if the port filesystem supported xattrs
> > you could tie in SELinux as easily as you are doing it below and get
> > Smack for an extra $1.98, not to mention saving every other LSM the
> > grief of defining Yet Another way to define port accesses.
> > 
> > It bothers me that there is a perfectly reasonable way to provide the
> > specific behavior you're looking for (SELinux label on a port) that
> > generalizes so cleanly and that it's not being proposed.
> > 
> > 
> > >   Changed the name of
> > > the selinuxfs interface to portcon and changed the interface to only
> > > allow five arguments instead of the variable four or five.   
> > >
> > > Added a mechanism to add/delete/update port labels with an interface in 
> > > the selinuxfs filesystem.  This will give administrators the ability to
> > > update port labels faster than reloading the entire policy with
> > > semanage.  The administrator will also need less privilege since they
> > > don't have to be authorized to reload the full policy.
> > >
> > > A listing of all port labels will be output if the file /selinux/portcon
> > > is read.  Labels could be added or deleted with the following commands 
> > >
> > > echo -n "del system_u:object_r:ssh_port_t:s0 6 22 22" > /selinux/portcon
> > > echo -n "add system_u:object_r:telnetd_port_t:s0 6 22 22" > /selinux/portcon
> > >
> > > Labels can be atomically changed with the add command.  
> > >
> > >
> > > Signed-off-by: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>
> > >


